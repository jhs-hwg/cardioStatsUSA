#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param x
#' @param design
#' @param ...
svy_stat_quantile <- function(outcome, design, quantiles, ...) {

 svyquantile(x = as_svy_formula(outcome),
             design = design,
             quantiles = quantiles,
             na.rm = TRUE,
             ci = TRUE,
             se = TRUE) %>%
  attribute_add(.name = '..svy_stat_type..', .value = 'quantile') %>%
  attribute_add(.name = '..svy_stat_fun..', .value = 'stat')

}
