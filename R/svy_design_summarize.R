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

 if(is.null(exposure)) exposure <- 'None'
 if(is.null(group)) group <- 'None'

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
                  by_vars = by_vars)

   if(exposure != 'None')
    .out <- setnames(.out, old = exposure, new = 'exposure')
   else
    .out[, exposure := 'None']

   if(group != 'None')
    .out <- setnames(.out, old = group, new = 'group')
   else
    .out[, group := 'None']

   if(pool_svy_years)
    .out[[key$time_var]] <- 'None'

   if( !('level' %in% names(.out)) )
    .out$level <- NA_character_

   setcolorder(.out,
               neworder = c(key$time_var,
                            'outcome',
                            'level',
                            'exposure',
                            'group',
                            'statistic',
                            'estimate',
                            'std_error',
                            'ci_lower',
                            'ci_upper'))

   .out

  }

 )

}
