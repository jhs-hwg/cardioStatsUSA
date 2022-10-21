
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

svy_stat_percentage_kg <- function(outcome, design, ...){

 # ensure categorical inputs
 design$variables[[outcome]] %<>% as.factor()

 lvls <- levels(design$variables[[outcome]])

 glue::glue("I({outcome} == '{lvls}')") %>%
  set_names(lvls) %>%
  map(as_svy_formula) %>%
  map(svyciprop, design = design, method = 'beta') %>%
  svy_stat_adorn(stat_type = 'percentage_kg',
                 stat_fun = 'stat')

}



svy_statby_percentage_kg <- function(outcome, by_vars, design, ...){

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
  svy_stat_adorn(stat_type = 'percentage_kg',
                 stat_fun = 'statby')

}
