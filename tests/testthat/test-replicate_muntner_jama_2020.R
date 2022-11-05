
# TODO: do you need to subset before standardize? should make an error if so.
suppressPackageStartupMessages({
 library(data.table)
 library(testthat)
})

# JAMA Trends in BP tests -------------------------------------------------

#' ## Who is included in this test
#'
#' For these tests, we include the same cohort as Muntner et al. Full details
#' on the inclusion criteria are given in the paper, but here all that
#' we need to do is subset the data to include rows where `svy_subpop_htn`
#' is equal to 1.

#+ echo = TRUE
nhanes_subpop_htn <- nhanes_data[svy_subpop_htn == 1]

#' after these exclusions,
{{nrow(nhanes_subpop_htn)}}
#' participants are included.
#'
#' ## Age adjustment
#'
#' We use direct standardization with the same standard weights as in Munter
#' et al.
#'
#+ echo = TRUE
standard_weights <- c(15.5, 45.4, 21.5, 17.7)
#'
#' ## NHANES design objects
#'
#' In most cases, we use `nhanes_summarize()` or `nhanes_visualize`
#' when generating results with `cardioStatsUSA`. Here, we use the
#' `nhanes_design` family of functions. NHANES design functions are
#' lower level functions that support `nhanes_summarize` and
#' `nhanes_visualize`. Full details on this family can be found at
#' the help page for [nhanes_design]. For this analysis, we
#' create three designs:
#'
#' - an initial design that encapsulates the two others:
#'
#+ echo = TRUE
ds_init <- nhanes_design(
 data = nhanes_subpop_htn,
 key = nhanes_key,
 outcome_variable = 'bp_control_140_90'
)
#' - a design for non-pregnant adults with hypertension
#+ echo = TRUE
ds_all <- ds_init %>%
 nhanes_design_subset(
  svy_subpop_htn == 1 &
  (demo_pregnant == 'No' | is.na(demo_pregnant)) &
   htn_jnc7 == 'Yes'
 ) %>%
 nhanes_design_standardize(standard_weights = standard_weights)
#' - a design for non-pregnant adults with hypertension who reported using antihypertensive medication
#+ echo = TRUE
ds_meds <- ds_init %>%
 nhanes_design_subset(
  (demo_pregnant == 'No' | is.na(demo_pregnant)) &
   htn_jnc7 == 'Yes' &
   bp_med_use == 'Yes'
 ) %>%
 nhanes_design_standardize(standard_weights = standard_weights)
#'
#' ## Replicating eTable 1
#'
#' To reproduce eTable 1 from Muntner et al, we use the `ds_meds` design
#' object to estimate the proportion of adults with BP control according to
#' the JNC7 BP guidelines.
#'
#+ echo = TRUE
shiny_answers_etable_1_overall <- ds_meds %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[bp_control_140_90=='Yes'] %>%
 .[, group := "Overall"]

shiny_answers_etable_1_by_age <- ds_meds %>%
 nhanes_design_update(group_variable = 'demo_age_cat') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[bp_control_140_90=='Yes'] %>%
 .[, group := as.character(demo_age_cat)]


shiny_answers_etable_1_by_sex <- ds_meds %>%
 nhanes_design_update(group_variable = 'demo_gender') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[bp_control_140_90=='Yes'] %>%
 .[, group := as.character(demo_gender)]


shiny_answers_etable_1_by_race <- ds_meds %>%
 nhanes_design_update(group_variable = 'demo_race') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[bp_control_140_90=='Yes'] %>%
 .[, group := as.character(demo_race)] %>%
 .[group != 'Other']

#' Now we can put all of our answers together
#+ echo = TRUE

# names of columns that contain model estimates
est_cols <- c('estimate', 'ci_lower', 'ci_upper')
# names of columns to include for comparison to Muntner et al
muntner_cols <- c('svy_year', 'group', 'estimate', 'ci_lower', 'ci_upper')

shiny_answers_etable_1 <- list(
 shiny_answers_etable_1_overall,
 shiny_answers_etable_1_by_age,
 shiny_answers_etable_1_by_sex,
 shiny_answers_etable_1_by_race
) %>%
 rbindlist(fill = TRUE) %>%
 .[, (est_cols) := lapply(.SD, round, digits = 1), .SDcols = est_cols] %>%
 .[, .SD, .SDcols = muntner_cols]

shiny_answers_etable_1

#' We also need to get the data from Muntner et al to make sure our answers
#' match their answers.

jama_etable_1 <- cardioStatsUSA::muntner_jama_2020_etable_1

#' Now put everything together and test that all of our answers match
#+ echo = TRUE
test_results <- list(
 jama = jama_etable_1,
 shiny = shiny_answers_etable_1
) %>%
 rbindlist(idcol = 'source') %>%
 .[!svy_year %in% c('2017-2018', '2017-2020')] %>%
 dcast(formula = svy_year + group ~ source, value.var = est_cols)

#' take a look at the merged results, you can see estimate_shiny matches
#' estimate_jama in all cells shown.
#+ echo = TRUE
test_results

#' In some cases, we have differences in CI estimates due to rounding and/or
#' minor differences in the way CI boundaries are computed in R versus stata.
#' To ensure all of these differences are small enough, we allow a 1%
#' difference in the CI boundaries for our test. I.e., |A-B|/ B < 0.01
#+ echo = TRUE
ci_diff_tolerance <- 0.01

test_that(
 desc = "shiny app matches eTable 1 of JAMA paper",
 code = {

  expect_equal(test_results$estimate_jama,
               test_results$estimate_shiny)

  expect_equal(test_results$ci_lower_jama,
               test_results$ci_lower_shiny,
               tolerance = ci_diff_tolerance)

  expect_equal(test_results$ci_upper_jama,
               test_results$ci_upper_shiny,
               tolerance = ci_diff_tolerance)

 }
)
#' success!
#'
#' ## Replicating Table 2
#'
#' The process for this table is similar. The values from Muntner et al's
#' Table 2 are saved in a data frame:
#+ echo = TRUE
jama_table_2 <- cardioStatsUSA::muntner_jama_2020_table_2
jama_table_2

#' Our answers are generated with the design object created earlier.
#+ echo = TRUE
shiny_answers_table_2 <- ds_all %>%
 nhanes_design_update(outcome_variable = 'bp_cat_meds_excluded') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 as.data.table() %>%
 .[,
   # just recoding this variable to match JAMA group variable
   group := factor(
    bp_cat_meds_excluded,
    labels = c(
     "lt_120_80",
     "gt_120_lt_80",
     "gt_130_80",
     "gt_140_90",
     "gt_160_100"
    )
   )] %>%
 # select the same names as JAMA table
 .[, .(svy_year, group, estimate, ci_lower, ci_upper)] %>%
 # round to 1 decimal place (matching rounding in JAMA table)
 .[, estimate := round(estimate, digits = 1)] %>%
 .[, ci_lower := round(ci_lower, digits = 1)] %>%
 .[, ci_upper := round(ci_upper, digits = 1)]

#' Now we merge the results from our code with the JAMA data:
#+ echo = TRUE
test_results <- list(jama = jama_table_2,
                     shiny = shiny_answers_table_2) %>%
 rbindlist(idcol = 'source') %>%
 .[svy_year != '2017-2018' &  svy_year != '2017-2020'] %>%
 dcast(svy_year + group ~ source, value.var = c('estimate',
                                                'ci_lower',
                                                'ci_upper'))

test_results

#' Last, we assert the expectation that all of our answers match
#' the corresponding value in the JAMA table.
#+ echo = TRUE
test_that(
 desc = "shiny app matches Table 2 of JAMA paper",
 code = {

  expect_equal(test_results$estimate_jama,
               test_results$estimate_shiny,
               tolerance = 0.01)

  expect_equal(test_results$ci_lower_jama,
               test_results$ci_lower_shiny,
               tolerance = ci_diff_tolerance)

  expect_equal(test_results$ci_upper_jama,
               test_results$ci_upper_shiny,
               tolerance = ci_diff_tolerance)

 }
)

