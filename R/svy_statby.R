#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param outcome
#' @param by_vars
#' @param design
#' @param svy_stat_fun
#' @param ...
svy_statby <- function(outcome, by_vars, design, svy_stat_fun, ...){

 svyby(formula = as_svy_formula(outcome),
       by = as_svy_formula(by_vars),
       design = design,
       FUN = svy_stat_fun,
       na.rm = TRUE,
       vartype = c('ci', 'se'),
       ...)

}
