#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param outcome
#' @param design
#' @param ...
svy_stat_proportion <- function(outcome, design, ...) {


 if(is.integer(design$variables[[outcome]])){
  design$variables[[outcome]] <- as.factor(design$variables[[outcome]])
 }

 svyciprop(formula = as_svy_formula(outcome),
           design = design,
           na.rm = TRUE) %>%
  svy_stat_adorn(stat_type = 'proportion',
                 stat_fun = 'stat')

}
