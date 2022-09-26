


#' Summarize a survey design
#'
#' @param design an object created by [svy_design_new]
#' @param outcome (*character*) the outcome variable
#' @param key should always be `nhanes_key`
#' @param statistic (*character vector*) which statistics to compute
#' @param exposure (*character*) the exposure variable
#' @param group (*character*) the group variable
#' @param pool_svy_years (*logical*) `TRUE` in pool is 'yes', `FALSE` o.w.
#' @param simplify_bnry_output not currently used
#' @param quantiles (*numeric vector*) percentiles for stat summaries
#' @param age_standardize (*logical*) standardize by age groups?
#' @param age_wts (*numeric vector*) weights for age standardization.
#'
#' @return summaries
#'
#' @noRd
#'
svy_design_summarize <- function(
  design,
  outcome,
  exposure = NULL,
  statistic = NULL,
  group = NULL,
  simplify_bnry_output = TRUE,
  quantiles = c(0.25, 0.50, 0.75),
  age_standardize = FALSE,
  age_wts = c(0.155, 0.454, 0.215, 0.177)
){

 key <- cardioStats.USA::nhanes_key
 pool_svy_years = attr(design, 'pool') == 'yes'
 time_var <- ifelse(pool_svy_years, 'None', key$time_var)
 outcome_type <- key$variables[[outcome]]$type


 statistic %<>% input_infer(key$svy_calls[[outcome_type]])
 exposure  %<>% input_infer("None")
 group     %<>% input_infer("None")

 by_vars <- c(time_var, exposure, group) %>%
  setdiff('None')

 if(length(age_wts) != length(levels(design$variables$demo_age_cat)) ||
    any(age_wts == 0)){
  age_standardize <- FALSE
 }

 if(age_standardize){

  over <- by_vars %>%
   setdiff('demo_age_cat') %>%
   as_svy_formula()

  exclude_miss <- c(outcome, by_vars) %>%
   setdiff('demo_age_cat') %>%
   as_svy_formula()

  design <- svystandardize(by = ~ demo_age_cat,
                           over = over,
                           design = design,
                           population = age_wts,
                           excluding.missing = exclude_miss)


 }

 svy_stat_fun_type <- is_empty(by_vars) %>%
  ifelse('svy_stat_fun', 'svy_statby_fun')

 smry_output <- map_dfr(

  .x = statistic,

  .f = ~ {

   # find the right function to call,
   # depends on stratification and stat to compute
   svy_stat_fun <- key$svy_funs %>%
    getElement(.x) %>%
    getElement(svy_stat_fun_type)

   .out <- do.call(what = svy_stat_fun,
                   args = list(outcome = outcome,
                               by_vars = by_vars,
                               design = design,
                               key = key,
                               quantiles = quantiles)) %>%
    svy_stat_tidy(outcome = outcome,
                  by_vars = by_vars) %>%
    .[, outcome := NULL]


   if(is_discrete(outcome) && 'level' %in% names(.out)){

    setnames(.out, old = 'level', new = outcome)

    lvls <- levels(design$variables[[outcome]])

    # if(is_empty(lvls) || is.null(lvls))
    #  lvls <- sort(unique(design$variables[[outcome]]))

    .out[[outcome]] <- factor(.out[[outcome]], levels = lvls)

    # .out[, x := factor(x, levels = lvls), env = list(x = outcome)]

   }

   if(exposure != 'None'){

    lvls <- levels(design$variables[[exposure]])

    .out[[exposure]] <- factor(.out[[exposure]], levels = lvls)

    # .out[, x := factor(x, levels = lvls), env = list(x = exposure)]

   }

   if(group != 'None'){

    lvls <- levels(design$variables[[group]])

    .out[[group]] <- factor(.out[[group]], levels = lvls)

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

 attr(smry_output, "outcome") <- outcome
 attr(smry_output, "exposure") <- exposure
 attr(smry_output, "statistic") <- statistic
 attr(smry_output, "group") <- group

 smry_output

}




