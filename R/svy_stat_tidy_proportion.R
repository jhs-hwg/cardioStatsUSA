#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param x
#' @param outcome
#' @param by_vars
#' @param ...
svy_stat_tidy_proportion <- function(x, outcome, by_vars, ...){

 svy_stat_tidy_count(x, outcome, by_vars) %>%
  .[, statistic := 'proportion'] %>%
  .[, ci_lower := pmax(ci_lower, 0)] %>%
  .[, ci_upper := pmin(ci_upper, 1)]

}
