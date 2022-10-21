
svy_stat_tidy_percentage <- function(x, outcome, by_vars, ...){

 svy_stat_tidy_count(x, outcome, by_vars) %>%
  .[, statistic := 'percentage'] %>%
  .[, estimate  := estimate * 100] %>%
  .[, std_error := std_error * 100] %>%
  .[, ci_lower  := pmax(ci_lower, 0) * 100] %>%
  .[, ci_upper  := pmin(ci_upper, 1) * 100]


}

svy_stat_tidy_percentage_kg <- function(x, outcome, ...){

 map2_dfr(
  x,
  names(x),
  ~ {

   x_ci <- confint(.x)

   data.table(outcome = outcome,
              level = .y,
              statistic = c('percentage_kg'),
              estimate = as.numeric(.x),
              ci_lower = x_ci[, 1],
              ci_upper = x_ci[, 2]) %>%
    .[, estimate := estimate * 100] %>%
    .[, std_error := as.numeric(survey::SE(.x)) * 100] %>%
    .[, ci_lower := pmax(ci_lower, 0) * 100] %>%
    .[, ci_upper := pmin(ci_upper, 1) * 100]
  }
 )

}


