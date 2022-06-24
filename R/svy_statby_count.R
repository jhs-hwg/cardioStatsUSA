

svy_statby_count <- function(outcome, by_vars, design, key, ...){

 if(key$variables[[outcome]]$type == 'intg'){

  design$variables[[outcome]] %<>% as.factor()

 }

 svy_statby(outcome = outcome,
            by_vars = by_vars,
            design = design,
            svy_stat_fun = svytotal) %>%
  svy_stat_adorn(stat_type = 'count',
                 stat_fun = 'statby')

}


