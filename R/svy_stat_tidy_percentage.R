
svy_stat_tidy_percentage <- function(x, outcome, by_vars, ...){

 svy_stat_tidy_count(x, outcome, by_vars) %>%
  .[, statistic := 'percentage'] %>%
  .[, estimate  := estimate * 100] %>%
  .[, std_error := std_error * 100] %>%
  .[, ci_lower  := pmax(ci_lower, 0) * 100] %>%
  .[, ci_upper  := pmin(ci_upper, 1) * 100]


}
