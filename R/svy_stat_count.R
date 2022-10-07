

design_prep_count <- function(design, outcome){

 # ensure categorical inputs
 design$variables[[outcome]] %<>% as.factor()

 # use calibrated weights if they are present
 if('svy_weight_cal' %in% names(design$variables)){
  design$variables$svy_weight <- design$variables$svy_weight_cal
  design$prob <- 1/design$variables$svy_weight
 }

 design

}

svy_stat_count <- function(outcome, design, ...) {

 design <- design_prep_count(design, outcome = outcome)

 svytotal(x = as_svy_formula(outcome),
          na.rm = TRUE,
          design = design) %>%
  svy_stat_adorn(stat_type = 'count',
                 stat_fun = 'stat')


}

svy_statby_count <- function(outcome, by_vars, design, ...){

 design <- design_prep_count(design, outcome = outcome)

 svy_statby(outcome = outcome,
            by_vars = by_vars,
            design = design,
            svy_stat_fun = svytotal) %>%
  svy_stat_adorn(stat_type = 'count',
                 stat_fun = 'statby')

}







