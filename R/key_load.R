
key_load <- function() {

 key_data <- fread(file.path(here(), 'data-raw', 'nhanes_key.csv'))

 key_variables <- key_data %>%
  as_inline(tbl_variables = 'variable',
            tbl_values = setdiff(names(key_data), 'variable'))

 key_recoder <- key_data %>%
  select(variable, label) %>%
  deframe() %>%
  c("svy_year" = "NHANES cycle",
    "std_error" = "Standard error",
    "ci_lower" = "Lower 95% CI",
    "ci_upper" = "Upper 95% CI")

 key_fctrs <-
  readr::read_rds(file.path('data-raw', 'nhanes_bp_fctrs.rds'))

 key_minimum_value <- nhanes_bp %>%
  select(all_of(key_data$variable[key_data$type == 'ctns'])) %>%
  map(min, na.rm = TRUE) %>%
  map(floor) %>%
  map(as.integer)

 key_maximum_value <- nhanes_bp %>%
  select(all_of(key_data$variable[key_data$type == 'ctns'])) %>%
  map(max, na.rm = TRUE) %>%
  map(ceiling) %>%
  map(as.integer)

 key_svy_funs <-
  data.table(
   name = c('mean',
            'quantile',
            'count',
            'percentage'),
   svy_stat_fun = list('svy_stat_mean',
                       'svy_stat_quantile',
                       'svy_stat_count',
                       'svy_stat_percentage'),
   svy_statby_fun = list('svy_statby_mean',
                         'svy_statby_quantile',
                         'svy_statby_count',
                         'svy_statby_percentage')
  ) %>%
  split(by = 'name') %>%
  map(unlist)

 key_svy_calls <- list(
  'ctns' = c(Mean = 'mean',
             Quantiles = 'quantile'),
  'catg' = c(Percentage = 'percentage',
             Count = 'count'),
  'bnry' = c(Percentage = 'percentage',
             Count = 'count'),
  'intg' = c(Percentage = 'percentage',
             Count = 'count')
 )

 key_variable_choices <- map(
  .x = list(
   outcome = key_data[outcome == TRUE, .(class, label, variable)],
   exposure = key_data[exposure == TRUE, .(class, label, variable)],
   subset = key_data[subset == TRUE, .(class, label, variable)],
   group = key_data[group == TRUE, .(class, label, variable)]
  ),
  .f = ~ .x %>%
   split(by = 'class', keep.by = FALSE) %>%
   map(deframe)
 )


 list(
  data = key_data,
  variables = key_variables,
  variable_choices = key_variable_choices,
  minimum_values = key_minimum_value,
  maximum_values = key_maximum_value,
  recoder = key_recoder,
  fctrs = key_fctrs,
  svy_funs = key_svy_funs,
  svy_calls = key_svy_calls,
  time_var = key_data[type == 'time', variable]
 )

}
