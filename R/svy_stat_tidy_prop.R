
svy_stat_tidy_prop <- function(x, outcome, cat, ...){

 x_ci <- confint(x)

 data.table(outcome = outcome,
            level = cat,
            statistic = c('proportion'),
            estimate = mean(x),
            ci_lower = x_ci[, 1],
            ci_upper = x_ci[, 2])

}

