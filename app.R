
source("packages.R")

R.utils::sourceDirectory('R')

nhanes_data <- nhanes_shiny_load()

key_data <- fread('data/nhanes_key.csv')

key_list <- key_data %>%
 as_inline(tbl_variables = 'variable',
           tbl_values = setdiff(names(key_data), 'variable'))

key_svy_funs <-
 data.table(
  name = c('mean',
           'quantile',
           'count'),
  svy_stat_fun = list(svy_stat_mean,
                      svy_stat_quantile,
                      svy_stat_count),
  svy_statby_fun = list(svy_statby_mean,
                        svy_statby_quantile,
                        svy_statby_count)
 ) %>%
 split(by = 'name')

time_var <- key_data[type == 'time', variable]
time_lab <- key_list[[time_var]]$label



design <- svy_design_new(nhanes_data, years = c("1999-2000",
                                                "2001-2002",
                                                "2003-2004"))
# conditional input
quantiles <- c(0.25, 0.50, 0.75)

design %>%
 svy_design_summarize(
  outcome = 'bp_sys_mean',
  key_svy_calls = c('mean', 'quantile'),
  key_svy_funs,
  time_var,
  exposure,
  group)


  # else if(key_list[[outcome]]$type %in% c('bnry', 'catg', 'intg')){
  #
  #  out <- svy_table(x = c(outcome, by_vars), design = design) %>%
  #   .[, p := N / sum(N), by = by_vars]
  #
  #  if(key_list[[outcome]]$type == 'bnry' && simplify_bnry_output){
  #
  #   out <- out %>%
  #    .[y == 'Yes', env = list(y = outcome)] %>%
  #    .[, y := key_list[[outcome]]$label, env = list(y = outcome)]
  #
  #  }
  #
  # }

 # data.table printing is muted after modification by ref
 # a single call to print reverts that.

 # now return the output
 out


