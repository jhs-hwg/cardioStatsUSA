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
  key_svy_calls,
  key_svy_funs,
  time_var = NULL,
  exposure = NULL,
  group = NULL,
  simplify_bnry_output = TRUE
){

 by_vars <- c(time_var, exposure, group)

 out <- list()

 svy_stat_fun_type <- ifelse(
  is_empty(by_vars),
  'svy_stat_fun',
  'svy_statby_fun'
 )

 map(

  .x = key_svy_calls,

  .f = ~ {

   # find the right function to call,
   # depends on stratification and stat to compute
   svy_stat_fun <- key_svy_funs %>%
    getElement(.x) %>%
    getElement(svy_stat_fun_type) %>%
    getElement(1)

   svy_stat_fun(outcome = outcome,
                by_vars = by_vars,
                design = design,
                quantiles = quantiles) %>%
    svy_stat_tidy(outcome = outcome,
                  by_vars = by_vars)

  }

 ) %>%
  rbindlist()

}
