
svy_statby_tidy_quantile <- function(x, outcome, by_vars, ...) {

 out_names <- names(x) %>%
  gsub(pattern = paste0("^", outcome),
       replacement = paste0('estimate.', outcome),
       x = .) %>%
  gsub(pattern = outcome,
       replacement = paste0('_z.z.z_.', outcome, '._z.z.z_'),
       x = .) %>%
  gsub(pattern = '^se\\.',
       replacement = 'std_error.',
       x = .) %>%
  gsub(pattern = '^ci_l\\.',
       replacement = 'ci_lower.',
       x = .) %>%
  gsub(pattern = '^ci_u\\.',
       replacement = 'ci_upper.',
       x = .)

 out <- as.data.table(x) %>%
  setnames(new = out_names) %>%
  melt(id.vars = by_vars) %>%
  .[, c('stat_type',
        'outcome',
        'quant') := tstrsplit(variable, split='._z.z.z_.', fixed=T)] %>%
  .[, variable := NULL] %>%
  .[, statistic := paste0('q', format(as.numeric(quant)*100, nsmall = 0))] %>%
  .[, quant := NULL] %>%
  dcast(formula = ... ~ stat_type, value.var = 'value') %>%
  setcolorder(neworder = c("outcome",
                           by_vars,
                           "statistic",
                           "estimate",
                           "std_error",
                           "ci_lower",
                           "ci_upper")) %>%
  setkey(NULL)

 out

}

