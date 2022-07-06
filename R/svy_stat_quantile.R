
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
