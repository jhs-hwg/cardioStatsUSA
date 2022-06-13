

svy_statby_quantile <- function(outcome, by_vars, design, quantiles, ...){


 svy_statby(outcome = outcome,
            by_vars = by_vars,
            design = design,
            svy_stat_fun = svyquantile,
            quantiles = quantiles) %>%
  svy_stat_adorn(stat_type = 'quantile',
                 stat_fun = 'statby')

}
