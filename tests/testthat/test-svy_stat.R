

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
 )

nhanes_key_test <- nhanes_key

exposure <- 'demo_age_cat'

design <- nhanes_bp_test %>%
 svy_design_new(
  exposure = exposure,
  n_exposure_group = as.numeric(character(0)),
  exposure_cut_type = 'interval',
  years = "2015-2016",
  pool = 'yes'
 ) %>%
 svy_design_subset(subset_calls = list(demo_pregnant = 'No'))

# up to 1/2% of a difference in prevalence estimate is acceptable
# (our cohorts aren't exactly the same)
diff_tolerance <- 0.5

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
                      key = nhanes_key_test,
                      user_calls = c('percentage'),
                      exposure = exposure) %>%
 dplyr::filter(htn_jnc7 == 'Yes') %>%
 dplyr::mutate(demo_gender = 'Overall')

shiny_answers_by_age_sex <- design %>%
 svy_design_summarize(outcome = 'htn_jnc7',
                      key = nhanes_key_test,
                      user_calls = c('percentage'),
                      exposure = exposure,
                      group = 'demo_gender') %>%
 dplyr::filter(htn_jnc7 == 'Yes')

shiny_answers <- shiny_answers_by_age %>%
 dplyr::bind_rows(shiny_answers_by_age_sex) %>%
 dplyr::transmute(demo_gender,
                  demo_age_cat,
                  shiny_estimate = round(estimate,1),
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



