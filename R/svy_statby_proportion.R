#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param outcome
#' @param by_vars
#' @param design
#' @param ...
svy_statby_proportion <- function(outcome, by_vars, design, ...){

 if(is.integer(design$variables[[outcome]])){
  design$variables[[outcome]] <- as.factor(design$variables[[outcome]])
 }

 outcome_type <- key_list[[outcome]]$type

 svy_stat_fun <- switch(
  outcome_type,
  'bnry' = svyciprop,
  'intg' = svymean,
  'catg' = svymean
 )

 svy_statby(
  outcome = outcome,
  by_vars = by_vars,
  design = design,
  svy_stat_fun = svy_stat_fun
 ) %>%
  svy_stat_adorn(stat_type = paste('proportion', outcome_type, sep = '_'),
                 stat_fun = 'statby')

}


