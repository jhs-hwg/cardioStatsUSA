
svy_stat_tidy_count <- function(x, outcome, by_vars, ...){

 x_ci <- confint(x)

 outcome_levels <- names(x) %>%
  gsub(pattern = paste0('^', outcome), replacement = "", x = .)

 data.table(outcome = outcome,
            level = outcome_levels,
            statistic = c('count'),
            estimate = as.numeric(x),
            std_error = as.numeric(sqrt(diag(attr(x, 'var')))),
            ci_lower = x_ci[, 1, drop=TRUE],
            ci_upper = x_ci[, 2, drop=TRUE])

}


