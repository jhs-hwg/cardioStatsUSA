

svy_statby_quantile <- function(outcome, by_vars, design, quantiles, ...){

 svyby(formula = as_svy_formula(outcome),
       by = as_svy_formula(by_vars),
       design = design,
       FUN = svyquantile,
       na.rm = TRUE,
       quantiles = quantiles,
       vartype = c('ci', 'se')) %>%
  attribute_add(.name = '..svy_stat_type..', .value = 'quantile') %>%
  attribute_add(.name = '..svy_stat_fun..', .value = 'statby')

}
