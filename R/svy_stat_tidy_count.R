#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param x
#' @param outcome
#' @param by_vars
svy_stat_tidy_count <- function(x, outcome, by_vars, ...){

 out <- as.data.table(x) %>%
  setnames(old = c(outcome, "N"), new = c('level', 'count')) %>%
  .[, outcome := outcome] %>%
  setcolorder(neworder = c('outcome', 'level', by_vars, 'count')) %>%
  .[, proportion := count / sum(count), by = by_vars] %>%
  melt(id.vars = c('outcome', 'level', by_vars),
       variable.name = 'statistic',
       value.name = 'estimate')

}
