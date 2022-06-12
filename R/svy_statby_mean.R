

svy_statby_mean <- function(outcome, by_vars, design, ...){

 svyby(formula = as_svy_formula(outcome),
       by = as_svy_formula(by_vars),
       design = design,
       FUN = svymean,
       na.rm = TRUE,
       vartype = c('ci', 'se')) %>%
  attribute_add(.name = '..svy_stat_type..', .value = 'mean') %>%
  attribute_add(.name = '..svy_stat_fun..', .value = 'statby')

}
