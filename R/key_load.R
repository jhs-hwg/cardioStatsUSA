#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

key_load <- function() {

 key_data <- fread(file.path(here(), 'data', 'nhanes_key.csv'))

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
  read_rds(file.path('data', 'nhanes_shiny_fctrs.rds'))


 key_svy_funs <-
  data.table(
   name = c('mean',
            'quantile',
            'count',
            'percentage'),
   svy_stat_fun = list(svy_stat_mean,
                       svy_stat_quantile,
                       svy_stat_count,
                       svy_stat_percentage),
   svy_statby_fun = list(svy_statby_mean,
                         svy_statby_quantile,
                         svy_statby_count,
                         svy_statby_percentage)
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
             Count = 'count',
             Quantiles = 'quantile')
 )


 list(
  data = key_data,
  variables = key_variables,
  recoder = key_recoder,
  fctrs = key_fctrs,
  svy_funs = key_svy_funs,
  svy_calls = key_svy_calls,
  time_var = key_data[type == 'time', variable]
 )

}
