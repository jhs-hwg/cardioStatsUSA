
svy_stat_tidy_quantile <- function(x, ...){

 x_data <- getElement(x, 1)

 quant_names <- rownames(x_data) %>%
  as.numeric() %>%
  multiply_by(100) %>%
  paste("q", ., sep = '')

 data.table(outcome = names(x),
            statistic = quant_names,
            estimate = as.numeric(x_data[, 'quantile']),
            std_error = as.numeric(x_data[, 'se']),
            ci_lower = as.numeric(x_data[, 'ci.2.5']),
            ci_upper = as.numeric(x_data[, 'ci.97.5']))

}
