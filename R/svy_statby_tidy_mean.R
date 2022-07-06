
svy_statby_tidy_mean <- function(x, outcome, by_vars, ...){

 as.data.table(x) %>%
  setnames(old = c(outcome, 'se', 'ci_l', 'ci_u'),
           new = c('estimate', 'std_error', 'ci_lower', 'ci_upper')) %>%
  .[, outcome := outcome] %>%
  .[, statistic := "mean"] %>%
  setcolorder(neworder = c('outcome',
                           by_vars,
                           'statistic',
                           'estimate',
                           'std_error',
                           'ci_lower',
                           'ci_upper'))

}

