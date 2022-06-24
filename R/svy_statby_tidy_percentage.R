#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param x
#' @param outcome
#' @param by_vars
#' @param ...
svy_statby_tidy_percentage <- function(x, outcome, by_vars, ...) {

 out <- svy_statby_tidy_count(x, outcome, by_vars) %>%
  .[, statistic := 'percentage'] %>%
  .[, estimate := estimate * 100] %>%
  .[, std_error := std_error * 100] %>%
  .[, ci_lower := pmax(ci_lower, 0) * 100] %>%
  .[, ci_upper := pmin(ci_upper, 1) * 100]

 out

}

