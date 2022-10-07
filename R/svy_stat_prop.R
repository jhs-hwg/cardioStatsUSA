

svy_stat_proportion <- function(outcome, design, ...){

 # ensure categorical inputs
 design$variables[[outcome]] %<>% as.factor()

 lvls <- levels(design$variables[[outcome]])

 glue::glue("I({outcome} == '{lvls}')") %>%
  set_names(lvls) %>%
  map(as_svy_formula) %>%
  map(svyciprop, design = design, method = 'beta') %>%
  svy_stat_adorn(stat_type = 'proportion',
                 stat_fun = 'stat')

}



svy_statby_proportion <- function(outcome, by_vars, design, ...){

 # ensure categorical inputs
 design$variables[[outcome]] %<>% as.factor()

 lvls <- levels(design$variables[[outcome]])

 glue::glue("I({outcome} == '{lvls}')") %>%
  as.character() %>%
  set_names(lvls) %>%
  map(svy_statby,
      by_vars = by_vars,
      design = design,
      svy_stat_fun = svyciprop,
      method = 'beta') %>%
  svy_stat_adorn(stat_type = 'proportion',
                 stat_fun = 'statby')

}
