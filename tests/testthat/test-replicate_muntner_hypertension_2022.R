
wts <- c(13.5, 45.3, 23.3, 17.8)

ds <- nhanes_data %>%
 .[svy_subpop_htn == 1] %>%
 nhanes_design(
  key = nhanes_key,
  outcome_variable = 'bp_control_jnc7',
  time_values = c(
   "2009-2010",
   "2011-2012",
   "2013-2014",
   "2015-2016",
   "2017-2020"
  )
 ) %>%
 nhanes_design_subset(
  (demo_pregnant == 'No' | is.na(demo_pregnant)) &
   htn_jnc7 == 'Yes'
 ) %>%
 nhanes_design_standardize(standard_weights = wts)

# TODO: PM's paper had N=11,007 w/JNC7 hypertension (figure S1)
# we have 10 more cases - why? (appears to be issue w/bp_med_use)
nrow(ds$design$variables)

shiny_answers_table_s2_overall <- ds %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE)%>%
 filter(bp_control_jnc7=='Yes') %>%
 mutate(group = "Overall")

shiny_answers_table_s2_by_age <- ds %>%
 nhanes_design_update(group_variable = 'demo_age_cat') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 filter(bp_control_jnc7=='Yes') %>%
 mutate(group = demo_age_cat)

shiny_answers_table_s2_by_sex <- ds %>%
 nhanes_design_update(group_variable = 'demo_gender') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 filter(bp_control_jnc7=='Yes') %>%
 mutate(group = demo_gender)

shiny_answers_table_s2_by_race <- ds %>%
 nhanes_design_update(group_variable = 'demo_race') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 filter(bp_control_jnc7=='Yes') %>%
 mutate(group = recode(demo_race,
                       "Non-Hispanic White" = "Non_Hispanic_White",
                       "Non-Hispanic Black" = "Non_Hispanic_Black",
                       "Hispanic" = "Hispanic",
                       "Non-Hispanic Asian" = "Non_Hispanic_Asian")) %>%
 filter(group != 'Other')

shiny_answers_table_s2 <- list(
 shiny_answers_table_s2_overall,
 shiny_answers_table_s2_by_age,
 shiny_answers_table_s2_by_sex
) %>%
 purrr::map(select, svy_year, group, estimate, ci_lower, ci_upper) %>%
 dplyr::bind_rows() %>%
 dplyr::mutate(across(.cols = c(estimate, ci_lower, ci_upper),
                      .fns = round,
                      digits = 1)) %>%
 tibble::as_tibble()

table_s2 <- cardioStatsUSA::muntner_hypertension_2022_table_s2

test_results <-
 dplyr::bind_rows(hypertension = select(table_s2, -variable),
                  shiny = shiny_answers_table_s2,
                  .id = 'source') %>%
 pivot_wider(names_from = source,
             values_from = c(estimate, ci_lower, ci_upper))


# This is a relative tolerance, unless the differences are very small.
# I.e., A / B < 0.01, not A - B < 0.01

estimate_tolerance <- 0.02 # be lenient b/c samples don't quite match
ci_diff_tolerance <- 0.01

test_that(
 desc = "shiny app matches Table S2 of Hypertension paper",
 code = {

  expect_equal(test_results$estimate_hypertension,
               test_results$estimate_shiny,
               tolerance = estimate_tolerance)

  expect_equal(test_results$ci_lower_hypertension,
               test_results$ci_lower_shiny,
               tolerance = ci_diff_tolerance)

  expect_equal(test_results$ci_upper_hypertension,
               test_results$ci_upper_shiny,
               tolerance = ci_diff_tolerance)

 }
)

