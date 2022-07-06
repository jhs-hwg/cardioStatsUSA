
svy_statby <- function(outcome, by_vars, design, svy_stat_fun, ...){

 svyby(formula = as_svy_formula(outcome),
       by = as_svy_formula(by_vars),
       design = design,
       FUN = svy_stat_fun,
       na.rm = TRUE,
       vartype = c('ci', 'se'),
       ...)

}
