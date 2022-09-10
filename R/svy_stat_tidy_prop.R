
svy_stat_tidy_proportion <- function(x, outcome, ...){

 map2_dfr(
  x,
  names(x),
  ~ {

   x_ci <- confint(.x)

   data.table(outcome = outcome,
              level = .y,
              statistic = c('proportion'),
              estimate = as.numeric(.x),
              ci_lower = x_ci[, 1],
              ci_upper = x_ci[, 2]) %>%
    .[, estimate := estimate * 100] %>%
    .[, std_error := std_error * 100] %>%
    .[, ci_lower := pmax(ci_lower, 0) * 100] %>%
    .[, ci_upper := pmin(ci_upper, 1) * 100]
  }
 )

}


svy_statby_tidy_proportion <- function(x, outcome, by_vars, ...){

 map2_dfr(
  x,
  names(x),
  ~ {

   outcome_expression <- as.character(glue("I({outcome} == \"{.y}\")"))
   se_expression <- paste0('se.as.numeric(', outcome_expression, ')')

   as.data.table(.x) %>%
    setnames(old = c(outcome_expression, se_expression, 'ci_l', 'ci_u'),
             new = c('estimate', 'std_error', 'ci_lower', 'ci_upper')) %>%
    .[, outcome := outcome] %>%
    .[, level := .y] %>%
    .[, statistic := "proportion"] %>%
    setcolorder(neworder = c('outcome',
                             'level',
                             by_vars,
                             'statistic',
                             'estimate',
                             'std_error',
                             'ci_lower',
                             'ci_upper')) %>%
    .[, estimate := estimate * 100] %>%
    .[, std_error := std_error * 100] %>%
    .[, ci_lower := pmax(ci_lower, 0) * 100] %>%
    .[, ci_upper := pmin(ci_upper, 1) * 100]

  }
 )



}
