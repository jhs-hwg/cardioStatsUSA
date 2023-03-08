
# SOURCE: https://www.cdc.gov/nchs/data/databriefs/db289.pdf
# Cohort: Non-pregnant adults aged 18 and over,
# By: sex and age
# Years: 2015-2016

#' We modify our `demo_age_cat` variable so that it has the same
#' groups that are analyzed in the CDC report.
#'
#+ echo = TRUE

# Make a copy here so that we don't modify the NHANES data
# (doing so would break tests that are run after this one)
nhanes_data_test <- copy(nhanes_data)
# match the age groups of CDC report
nhanes_data_test[
 , demo_age_cat := cut(demo_age_years,
                       breaks = c(18, 39, 59, Inf),
                       labels = c("18-39", "40-59", "60+"),
                       include.lowest = TRUE)
]

#' ## Who is included in this test
#'
#' For these tests, we include the same cohort as the CDC report. Full details
#' on the inclusion criteria are given in the paper.
#'
#+ echo = TRUE

nhanes_data_test <- nhanes_data_test %>%
 # exclude pregnant women
 .[demo_pregnant == 'No' | is.na(demo_pregnant)] %>%
 # exclude participants missing both SBP and DBP
 .[!(is.na(bp_dia_mean) & is.na(bp_sys_mean))]

#' In most cases, we use `nhanes_summarize()` or `nhanes_visualize()`
#' when generating results with `cardioStatsUSA`. Here, we use the
#' `nhanes_design` family of functions. NHANES design functions are
#' lower level functions that support `nhanes_summarize` and
#' `nhanes_visualize`. Full details on this family can be found at
#' the help page for [nhanes_design].
#+ echo = TRUE

ds <- nhanes_data_test %>%
 nhanes_design(
  key = nhanes_key,
  outcome_variable = 'htn_jnc7',
  group_variable = 'demo_age_cat',
  time_values = '2015-2016'
 )

#' We create a separate NHANES design object that will use age adjustment via
#' direct standardization, copying the standard weights reported by the CDC
#+ echo = TRUE

ds_standard <- ds %>%
 nhanes_design_standardize(
  standard_variable = 'demo_age_cat',
  standard_weights = c(0.420263, 0.357202, 0.222535)
 )

#' Our first test: do we have the same sample size as the CDC report?
#+ echo = TRUE

expect_equal(
 5504, # this is the sample size reported by CDC
 nrow(ds$design$variables)
)


#' ## Test results without age adjustment
#'
#' This test compares our answers versus Figure 1 of the CDC report.
#' We begin by loading the data from Figure 1:
#+ echo = TRUE
test_data <- cdc_db289_figure_1 %>%
 setnames(old = c('estimate', 'std_error'),
          new = c('cdc_estimate', 'cdc_std_error'))

#' Now we summarize our design object (`ds`) with various updates
#' to create results by age group and by sex within age groups
#+ echo = TRUE

shiny_answers_by_age <- ds %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[htn_jnc7 == 'Yes'] %>%
 .[, demo_gender := 'Overall']

shiny_answers_by_age_sex <- ds %>%
 # this adds a stratify variable to the already existing group variable (age)
 # to make results stratified by age and sex groups.
 nhanes_design_update(stratify_variable = 'demo_gender') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[htn_jnc7 == 'Yes']

#' Putting all our answers together:
#+ echo = TRUE

shiny_answers <- list(shiny_answers_by_age,
                      shiny_answers_by_age_sex) %>%
 rbindlist(use.names = TRUE) %>%
 .[, .(demo_gender,
       demo_age_cat,
       shiny_estimate = round(estimate,1),
       shiny_std_error = round(std_error,1))]

#' Putting everything together:
#+ echo = TRUE

test_results <- test_data %>%
 merge(shiny_answers, by = c("demo_gender", "demo_age_cat"))

test_results

#' In the following tests, we will compare our application's estimates
#' to corresponding estimates reported by the CDC. To ensure all of
#' these differences are exactly 0, we set the tolerance values to 0
#+ echo = TRUE
est_diff_tolerance <- 0
se_diff_tolerance <- 0

#' Now we can formally check for equality:
#+ echo = TRUE
test_that(
 'cardioStatsUSA matches CDC report, Figure 1',
 code = {

  expect_equal(test_results$cdc_estimate,
               test_results$shiny_estimate,
               tolerance = est_diff_tolerance)

  expect_equal(test_results$cdc_std_error,
               test_results$shiny_std_error,
               tolerance = se_diff_tolerance)

 }
)

#' ## Test results with age adjustment
#'
#' This test compares our answers versus Figure 2 of the CDC report.
#' We begin by loading the data from Figure 2:
#+ echo = TRUE

test_data <- cdc_db289_figure_2 %>%
 # sync levels of the race variable
 .[, demo_race := factor(demo_race,
                         levels = levels(nhanes_data$demo_race))] %>%
 setnames(old = c('estimate', 'std_error'),
          new = c('cdc_estimate', 'cdc_std_error'))

#' using our standardized NHANES design, we create results in
#' subgroups defined by race and race by sex.
#+ echo = TRUE

shiny_answers_total <- ds_standard %>%
  nhanes_design_update(group_variable = 'demo_race') %>%
  nhanes_design_summarize(outcome_stats = 'percentage',
                          simplify_output = TRUE) %>%
  as.data.table() %>%
  .[, demo_gender := 'Total']

shiny_answers_by_gender <- ds_standard %>%
 nhanes_design_update(group_variable = 'demo_race',
                      stratify_variable = 'demo_gender') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE)

#' Putting all of our answers together:
#+ echo = TRUE

shiny_answers <-
 list(shiny_answers_total,
      shiny_answers_by_gender) %>%
 rbindlist(use.names = TRUE) %>%
 .[htn_jnc7 == 'Yes'] %>%
 .[, .(demo_gender,
       demo_race,
       shiny_estimate  = round(estimate, 1),
       shiny_std_error = round(std_error, 1))]

#' Merging our results with the CDC results:
#+ echo = TRUE

test_results <- test_data %>%
 merge(shiny_answers, by = c("demo_gender", "demo_race"))

#' Asserting equality between our results and the CDC results

test_that(
 desc = 'Shiny app matches CDC report Figure 2, age standardized',
 code = {

  expect_equal(
   test_results$cdc_estimate,
   test_results$shiny_estimate,
   tolerance = est_diff_tolerance
  )

  expect_equal(
   test_results$cdc_std_error,
   test_results$shiny_std_error,
   tolerance = se_diff_tolerance
  )

 }
)
