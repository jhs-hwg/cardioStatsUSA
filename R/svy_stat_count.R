#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param x
#' @param design
#' @param ...
svy_stat_count <- function(x, design, ...) {

  svytable(formula = as_svy_formula(x), design = design) %>%
  attribute_add(.name = '..svy_stat_type..', .value = 'count') %>%
  attribute_add(.name = '..svy_stat_fun..', .value = 'stat')

}


