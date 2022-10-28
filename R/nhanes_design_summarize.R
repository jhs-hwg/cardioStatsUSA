
#' Summarize an NHANES design
#'
#' @param x \[nhanes_design\]
#'
#' `r document_nhanes_design()`
#'
#' @param outcome_stats \[character(1+)\]
#'
#' The statistics that should be computed.
#'   Multiple statistics may be requested.
#'   Valid options depend on the type of outcome to be summarized.
#' `r document_outcome_stat_options()`
#'
#' @param simplify_output \[logical(1)\]
#'
#' The type of output returned will be [nhanes_design] if `simplify_output`
#'   is `FALSE` and a `data.table` otherwise.
#'
#'
#' @return if `simplify_output` is `TRUE`, a `data.table`.
#'   Otherwise, an [nhanes_design] object is returned.
#'
#' @export
#'
nhanes_design_summarize <- function(x,
                                    outcome_stats = x$stats,
                                    simplify_output = FALSE){

 check_nobs(x)

 if(is_standardized(x) && 'count' %in% outcome_stats){

  stop("Direct standardization should not be applied when estimating counts",
       call. = FALSE)

 }

 # check_group_counts(x)

 counts <- NULL
 count_vars <- c(x$by_variables)

 if(x$outcome$type != 'ctns'){
  count_vars <- c(x$outcome$variable, count_vars)
 }

 if(!is_empty(count_vars)){

  count_vars_combn <- paste(count_vars, collapse = ', ')

  count_expr <- glue::glue(
   "x$design$variables[,data.table(table({count_vars_combn}))]"
  ) %>%
   rlang::parse_expr()

  counts <- rlang::eval_bare(count_expr)

  for(i in count_vars){
   counts[[i]] %<>% factor(levels = levels(x$design$variables[[i]]))
  }

  setnames(counts, old = 'N', new = 'n_obs')

  counts[['outcome']] <- x$outcome$variable

  if(x$outcome$type != 'ctns') setnames(counts,
                                        old = x$outcome$variable,
                                        new = 'level')

 }

 use_statby <- !is.null(x$by_variables)

 # browser()

 smry_output <- purrr::map_dfr(

  .x = x$stats[x$stats %in% outcome_stats],

  .f = ~ {

   stat_string <- if(use_statby) 'statby' else 'stat'

   svy_stat_fun <- paste("svy", stat_string, .x,  sep = '_')
   svy_suppress_fun <- paste('svy_stat_suppress', x$outcome$type, sep = '_')

   .out <- do.call(what = svy_stat_fun,
                   args = list(outcome = x$outcome$variable,
                               by_vars = x$by_variables,
                               design = x$design,
                               quantiles = x$outcome$quantiles)) %>%
    svy_stat_tidy(outcome = x$outcome$variable,
                  by_vars = x$by_variables)

   if(!is.null(counts)) .out %<>% merge(counts, sort = FALSE)

   .out <- .out %>%
    svy_stat_suppress(type = x$outcome$type,
                      stat = .x,
                      n_obs = get_obs_count(x$design),
                      n_psu = get_psu_count(x$design),
                      n_strata = get_strata_count(x$design))

    .out[, outcome := NULL]


   if(outcome_is_discrete(x) && 'level' %in% names(.out)){

    setnames(.out, old = 'level', new = x$outcome$variable)

    lvls <- levels(x$design$variables[[x$outcome$variable]])
    .out[[x$outcome$variable]] %<>% factor(levels = lvls)

   }

   if(has_group(x)){

    lvls <- levels(x$design$variables[[x$group$variable]])

    .out[[x$group$variable]] %<>% factor(levels = lvls)

   }

   if(has_stratify(x)){

    lvls <- levels(x$design$variables[[x$stratify$variable]])

    .out[[x$stratify$variable]] %<>% factor(levels = lvls)

   }


   neworder <- c(x$time$variable,
                 x$group$variable,
                 x$stratify$variable,
                 x$outcome$variable,
                 'statistic',
                 'estimate',
                 'std_error',
                 'ci_lower',
                 'ci_upper') %>%
    intersect(names(.out))

   setcolorder(.out, neworder = neworder)

   if(!is_empty(x$by_variables)) setorderv(.out, cols = x$by_variables)

   .out

  }

 )

 if(simplify_output) return(smry_output)

 x$results <- smry_output

 x

}
