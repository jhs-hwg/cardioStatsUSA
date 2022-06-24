#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param design
#' @param outcome
#' @param key_svy_funs
#' @param time_var
#' @param exposure
#' @param group
#' @param simplify_bnry_output
svy_design_summarize <- function(
  design,
  outcome,
  key,
  user_calls = c(),
  exposure = NULL,
  group = NULL,
  pool_svy_years = FALSE,
  simplify_bnry_output = TRUE,
  quantiles = c(0.25, 0.50, 0.75)
){

 time_var <- ifelse(pool_svy_years, 'None', key$time_var)

 if(is.null(exposure) || is_empty(exposure)) exposure <- 'None'
 if(is.null(group) || is_empty(group)) group <- 'None'

 by_vars <- c(time_var, exposure, group) %>%
  setdiff('None')

 svy_stat_fun_type <- ifelse(
  is_empty(by_vars),
  'svy_stat_fun',
  'svy_statby_fun'
 )

 key_svy_calls <- key$svy_calls[[key$variables[[outcome]]$type]]

 if(!is_empty(user_calls))
  key_svy_calls %<>% intersect(user_calls)

 map_dfr(

  .x = key_svy_calls,

  .f = ~ {

   # find the right function to call,
   # depends on stratification and stat to compute
   svy_stat_fun <- key$svy_funs %>%
    getElement(.x) %>%
    getElement(svy_stat_fun_type)

   .out <- svy_stat_fun(outcome = outcome,
                by_vars = by_vars,
                design = design,
                key = key,
                quantiles = quantiles) %>%
    svy_stat_tidy(outcome = outcome,
                  by_vars = by_vars) %>%
    .[, outcome := NULL]



   if(is_discrete(outcome, key)){

    setnames(.out, old = 'level', new = outcome)

    lvls <- key$fctrs[[outcome]]

    if(is_empty(lvls) || is.null(lvls))
     lvls <- sort(unique(nhanes_shiny[[outcome]]))

    .out[, x := factor(x, levels = lvls), env = list(x = outcome)]

   }

   if(exposure != 'None'){

    lvls <- key$fctrs[[exposure]]
    .out[, x := factor(x, levels = lvls), env = list(x = exposure)]

   }

   if(group != 'None'){

    lvls <- key$fctrs[[group]]
    .out[, x := factor(x, levels = lvls), env = list(x = group)]

   }

   neworder <- c(key$time_var,
                 exposure,
                 group,
                 outcome,
                 'statistic',
                 'estimate',
                 'std_error',
                 'ci_lower',
                 'ci_upper') %>%
    intersect(names(.out))

   setcolorder(.out, neworder = neworder)

   if(!is_empty(by_vars)) setorderv(.out, cols = by_vars)

   .out

  }

 )

}
