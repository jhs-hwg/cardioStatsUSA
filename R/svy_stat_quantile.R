
svy_stat_quantile <- function(outcome, design, quantiles, ...) {

 svyquantile(x = as_svy_formula(outcome),
             design = design,
             quantiles = quantiles,
             na.rm = TRUE,
             ci = TRUE,
             se = TRUE) %>%
  svy_stat_adorn(stat_type = 'quantile',
                 stat_fun = 'stat')

}



svy_statby_quantile <- function(outcome, by_vars, design, quantiles, ...){

 svy_statby(outcome = outcome,
            by_vars = by_vars,
            design = design,
            svy_stat_fun = svyquantile,
            quantiles = quantiles) %>%
  svy_stat_adorn(stat_type = 'quantile',
                 stat_fun = 'statby')

}
