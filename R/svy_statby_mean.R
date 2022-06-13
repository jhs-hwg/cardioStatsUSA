

svy_statby_mean <- function(outcome, by_vars, design, ...){

 svy_statby(outcome = outcome,
            by_vars = by_vars,
            design = design,
            svy_stat_fun = svymean) %>%
  svy_stat_adorn(stat_type = 'mean',
                 stat_fun = 'statby')

}
