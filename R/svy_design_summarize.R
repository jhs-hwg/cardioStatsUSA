
svy_design_summarize <- function(
  design,
  outcome,
  key,
  user_calls = c(),
  exposure = NULL,
  group = NULL,
  pool_svy_years = FALSE,
  simplify_bnry_output = TRUE,
  quantiles = c(0.25, 0.50, 0.75),
  age_standardize = FALSE,
  age_wts = c(0.155, 0.454, 0.215, 0.177)
){

 time_var <- ifelse(pool_svy_years, 'None', key$time_var)

 if(!is_used(exposure)) exposure <- 'None'
 if(!is_used(group)) group <- 'None'

 by_vars <- c(time_var,
              exposure,
              group) %>%
  setdiff('None')

 if(length(age_wts) != 4 || any(age_wts == 0)){
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

   .out <- do.call(what = svy_stat_fun,
                   args = list(outcome = outcome,
                               by_vars = by_vars,
                               design = design,
                               key = key,
                               quantiles = quantiles)) %>%
    svy_stat_tidy(outcome = outcome,
                  by_vars = by_vars) %>%
    .[, outcome := NULL]


   if(is_discrete(outcome, key) && 'level' %in% names(.out)){

    setnames(.out, old = 'level', new = outcome)

    lvls <- levels(design$variables[[outcome]])

    # if(is_empty(lvls) || is.null(lvls))
    #  lvls <- sort(unique(design$variables[[outcome]]))

    .out[, x := factor(x, levels = lvls), env = list(x = outcome)]

   }

   if(exposure != 'None'){

    lvls <- levels(design$variables[[exposure]])

    .out[, x := factor(x, levels = lvls), env = list(x = exposure)]

   }

   if(group != 'None'){

    lvls <- levels(design$variables[[group]])

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
