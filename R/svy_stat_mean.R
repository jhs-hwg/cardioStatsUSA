#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param x
#' @param design
#' @param ...
svy_stat_mean <- function(outcome, design, ...) {

  svymean(x = as_svy_formula(outcome),
          design = design,
          na.rm = TRUE) %>%
  attribute_add(.name = '..svy_stat_type..', .value = 'mean') %>%
  attribute_add(.name = '..svy_stat_fun..', .value = 'stat')

}
