

# Test our app's answers for prevalence of hypertension  ---------------------
# Cohort: non-pregnant adults aged 18 and over,
# By: sex and age
# Years: 2015-2016

nhanes_bp_test <- nhanes_bp %>%
 dplyr::mutate(
  demo_age_gteq_18 = dplyr::if_else(demo_age_years >= 18, 'Yes', 'No'),
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

design <- nhanes_bp_test %>%
 svy_design_new(
  exposure = exposure,
  n_exposure_group = as.numeric(character(0)),
  exposure_cut_type = 'interval',
  years = "2015-2016",
  pool = 'yes'
 )

# cohort size should match the CDC brief cohort size
expect_equal(nrow(design$variables), 5504)

# up to 0.15% of a difference in prevalence estimate is acceptable
# (because rounding can be done differently)
diff_tolerance <- 0.1


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
)

shiny_answers_by_age <- design %>%
 svy_design_summarize(outcome = 'htn_jnc7',
                      key = nhanes_key,
                      user_calls = c('percentage'),
                      exposure = exposure) %>%
 dplyr::filter(htn_jnc7 == 'Yes') %>%
 dplyr::mutate(demo_gender = 'Overall')

shiny_answers_by_age_sex <- design %>%
 svy_design_summarize(outcome = 'htn_jnc7',
                      key = nhanes_key,
                      user_calls = c('percentage'),
                      exposure = exposure,
                      group = 'demo_gender') %>%
 dplyr::filter(htn_jnc7 == 'Yes')

shiny_answers <- shiny_answers_by_age %>%
 dplyr::bind_rows(shiny_answers_by_age_sex) %>%
 dplyr::transmute(demo_gender,
                  demo_age_cat,
                  shiny_estimate = estimate,
                  shiny_std_error = std_error)

test_results <-
 dplyr::left_join(test_data, shiny_answers,
                  by = c("demo_gender", "demo_age_cat")) %>%
 mutate(estimate_diffs = abs(estimate - shiny_estimate),
        std_error_diffs = abs(std_error - shiny_std_error))


for(i in seq(nrow(test_results))){
 expect_lte(test_results$estimate_diffs[i], diff_tolerance)
 expect_lte(test_results$std_error_diffs[i], diff_tolerance)
}

# test age-adjusted results -----------------------------------------------

test_data <- tribble(
 ~demo_race,          ~demo_gender, ~estimate, ~std_error,
 "non-Hispanic White", "Total",      27.8,      1.4,
 "non-Hispanic Black", "Total",      40.3,      2.0,
 "non-Hispanic Asian", "Total",      25.0,      1.7,
 "Hispanic",           "Total",      27.8,      1.4,
 "non-Hispanic White", "Men",        29.7,      2.1,
 "non-Hispanic Black", "Men",        40.6,      2.2,
 "non-Hispanic Asian", "Men",        28.7,      2.6,
 "Hispanic",           "Men",        27.3,      2.0,
 "non-Hispanic White", "Women",      25.6,      1.4,
 "non-Hispanic Black", "Women",      39.9,      2.1,
 "non-Hispanic Asian", "Women",      21.9,      2.2,
 "Hispanic",           "Women",      28.0,      1.2
) %>%
 mutate(demo_race = factor(demo_race,
                           levels = levels(nhanes_bp$demo_race)))

design <- nhanes_bp_test %>%
 svy_design_new(
  exposure = exposure,
  n_exposure_group = as.numeric(character(0)),
  exposure_cut_type = 'interval',
  years = "2015-2016",
  pool = 'yes'
 )

shiny_answers_total <- design %>%
 svy_design_summarize(outcome = 'htn_jnc7',
                      key = nhanes_key,
                      user_calls = c('percentage'),
                      group = 'demo_race',
                      age_standardize = TRUE,
                      age_wts = c(0.420263, 0.357202, 0.222535)) %>%
 mutate(demo_gender = 'Total')

shiny_answers_by_gender <- design %>%
 svy_design_summarize(outcome = 'htn_jnc7',
                      key = nhanes_key,
                      user_calls = c('percentage'),
                      exposure = 'demo_gender',
                      group = 'demo_race',
                      age_standardize = TRUE,
                      age_wts = c(0.420263, 0.357202, 0.222535))

shiny_answers <- shiny_answers_total %>%
 dplyr::bind_rows(shiny_answers_by_gender) %>%
 dplyr::filter(htn_jnc7 == 'Yes') %>%
 dplyr::transmute(demo_gender,
                  demo_race,
                  shiny_estimate = estimate,
                  shiny_std_error = std_error)

test_results <-
 dplyr::left_join(test_data, shiny_answers,
                  by = c("demo_gender", "demo_race")) %>%
 mutate(estimate_diffs = abs(estimate - shiny_estimate),
        std_error_diffs = abs(std_error - shiny_std_error))

for(i in seq(nrow(test_results))){
 expect_lte(test_results$estimate_diffs[i], diff_tolerance)
 expect_lte(test_results$std_error_diffs[i], diff_tolerance)
}

# JAMA Trends in BP tests -------------------------------------------------

nhanes_jama <- nhanes_bp %>%
 filter(demo_pregnant == 'No' | is.na(demo_pregnant)) %>%
 filter(!is.na(bp_sys_mean), !is.na(bp_dia_mean)) %>%
 filter(!is.na(bp_med_use)) %>%
 filter(htn_jnc7 == 'Yes') %>%
 filter(bp_med_use == 'Yes')

design <- nhanes_jama %>%
 svy_design_new(
  exposure = exposure,
  n_exposure_group = as.numeric(character(0)),
  exposure_cut_type = 'interval',
  years = levels(nhanes_jama$svy_year),
  pool = 'no'
 )

shiny_answers_total <- design %>%
 svy_design_summarize(outcome = 'bp_control_jnc7',
                      key = nhanes_key,
                      user_calls = c('percentage'),
                      age_standardize = TRUE) %>%
 filter(bp_control_jnc7=='Yes')






