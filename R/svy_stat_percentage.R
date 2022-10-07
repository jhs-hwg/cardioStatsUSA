
svy_stat_percentage <- function(outcome, design, ...) {

 # ensure categorical inputs
 design$variables[[outcome]] %<>% as.factor()

 svymean(x = as_svy_formula(outcome),
         design = design,
         na.rm = TRUE) %>%
  svy_stat_adorn(stat_type = 'percentage',
                 stat_fun = 'stat')

}


svy_statby_percentage <- function(outcome, by_vars, design, ...){

 svy_statby(
  outcome = outcome,
  by_vars = by_vars,
  design = design,
  svy_stat_fun = svymean
 ) %>%
  svy_stat_adorn(stat_type = 'percentage',
                 stat_fun = 'statby')

}
