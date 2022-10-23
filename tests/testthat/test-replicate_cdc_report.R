
# Test our app's answers for prevalence of hypertension  ---------------------
# Cohort: Non-pregnant adults aged 18 and over,
# By: sex and age
# Years: 2015-2016

nhanes_data_test <- nhanes_data %>%
 as.data.table() %>%
 dplyr::mutate(
  svy_weight = svy_weight_mec,
  demo_age_cat = cut(demo_age_years,
                     breaks = c(18, 39, 59, Inf),
                     labels = c("18-39", "40-59", "60+"),
                     include.lowest = TRUE)
 ) %>%
 dplyr::filter(
  demo_pregnant == 'No' | is.na(demo_pregnant),
  !(is.na(bp_dia_mean) & is.na(bp_sys_mean))
 )

exposure <- 'demo_age_cat'

ds <- nhanes_design(
 data = nhanes_data_test,
 key = nhanes_key,
 outcome_variable = 'htn_jnc7',
 group_variable = 'demo_age_cat',
 time_values = '2015-2016'
)

ds_standard <- ds %>%
 nhanes_design_standardize(
  standard_variable = 'demo_age_cat',
  standard_weights = c(0.420263, 0.357202, 0.222535)
 )

# cohort size should match the CDC brief cohort size
expect_equal(nrow(ds$design$variables), 5504)

# up to 0.15% of a difference in prevalence estimate is acceptable
# (because rounding can be done differently)
diff_tolerance <- 0
# up to 1/2 of a percentage is acceptable for CI differences
# the app uses svymean for CI's of percentages, which leads to
# slightly more narrow intervals (this is done for efficiency
# and also because the app's CIs are merely descriptive)
ci_diff_tolerance <- 0

# test results without age-adjustment -------------------------------------

# SOURCE: https://www.cdc.gov/nchs/data/databriefs/db289.pdf, Figure 1

test_data <- tibble::tribble(
 ~demo_gender, ~demo_age_cat, ~estimate, ~std_error,
 "Overall",       "18-39",       7.5,       1.0,
 "Men",           "18-39",       9.2,       1.4,
 "Women",         "18-39",       5.6,       1.1,
 "Overall",       "40-59",       33.2,      1.7,
 "Men",           "40-59",       37.2,      2.9,
 "Women",         "40-59",       29.4,      2.0,
 "Overall",       "60+",         63.1,      2.1,
 "Men",           "60+",         58.5,      2.2,
 "Women",         "60+",         66.8,      2.6
) %>%
 as.data.table()

shiny_answers_by_age <- ds %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[htn_jnc7 == 'Yes'] %>%
 .[, demo_gender := 'Overall']

shiny_answers_by_age_sex <- ds %>%
 nhanes_design_update(stratify_variable = 'demo_gender') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[htn_jnc7 == 'Yes']

shiny_answers <- list(shiny_answers_by_age,
                      shiny_answers_by_age_sex) %>%
 rbindlist(use.names = TRUE) %>%
 .[, .(demo_gender,
       demo_age_cat,
       shiny_estimate = round(estimate,1),
       shiny_std_error = round(std_error,1))]

test_results <-
 merge(test_data, shiny_answers, by = c("demo_gender", "demo_age_cat")) %>%
 .[, `:=`(estimate_diffs = abs(estimate - shiny_estimate),
          std_error_diffs = abs(std_error - shiny_std_error))]

for(i in seq(nrow(test_results))){
 expect_lte(test_results$estimate_diffs[i], diff_tolerance)
 expect_lte(test_results$std_error_diffs[i], diff_tolerance)
}

# test age-adjusted results -----------------------------------------------

test_data <- tibble::tribble(
 ~demo_race,          ~demo_gender, ~estimate, ~std_error,
 "Non-Hispanic White", "Total",      27.8,      1.4,
 "Non-Hispanic Black", "Total",      40.3,      2.0,
 "Non-Hispanic Asian", "Total",      25.0,      1.7,
 "Hispanic",           "Total",      27.8,      1.4,
 "Non-Hispanic White", "Men",        29.7,      2.1,
 "Non-Hispanic Black", "Men",        40.6,      2.2,
 "Non-Hispanic Asian", "Men",        28.7,      2.6,
 "Hispanic",           "Men",        27.3,      2.0,
 "Non-Hispanic White", "Women",      25.6,      1.4,
 "Non-Hispanic Black", "Women",      39.9,      2.1,
 "Non-Hispanic Asian", "Women",      21.9,      2.2,
 "Hispanic",           "Women",      28.0,      1.2
) %>%
 mutate(
  demo_race = factor(
   demo_race,
   levels = levels(nhanes_data$demo_race)
  )
 )

shiny_answers_total <- ds_standard %>%
 nhanes_design_update(group_variable = 'demo_race') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 mutate(demo_gender = 'Total')

shiny_answers_by_gender <- ds_standard %>%
 nhanes_design_update(group_variable = 'demo_race',
                      stratify_variable = 'demo_gender') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE)

shiny_answers <- shiny_answers_total %>%
 dplyr::bind_rows(shiny_answers_by_gender) %>%
 dplyr::filter(htn_jnc7 == 'Yes') %>%
 dplyr::transmute(demo_gender,
                  demo_race,
                  shiny_estimate  = round(estimate, 1),
                  shiny_std_error = round(std_error, 1))

test_results <-
 dplyr::left_join(test_data, shiny_answers,
                  by = c("demo_gender", "demo_race"))

test_that(
 desc = 'Shiny app matches CDC report, age standardized',
 code = {

  expect_equal(
   test_results$estimate, test_results$shiny_estimate
  )

  expect_equal(
   test_results$std_error, test_results$shiny_std_error
  )

 }
)
