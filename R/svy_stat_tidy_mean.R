
svy_stat_tidy_mean <- function(x, ...){

 x_ci <- confint(x)

 data.table(outcome = names(x),
            statistic = c('mean'),
            estimate = as.numeric(x),
            std_error = as.numeric(sqrt(attr(x, 'var'))),
            ci_lower = x_ci[1],
            ci_upper = x_ci[2])

}
