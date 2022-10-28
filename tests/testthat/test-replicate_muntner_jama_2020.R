
# TODO: do you need to subset before standardize? should make an error if so.
suppressPackageStartupMessages({
 library(dplyr)
 library(data.table)
 library(tidyr)
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
#' In most cases, we use `nhanes_summarize()` or `nhanes_visualize` when
#' generating results with `cardioStatsUSA`. In this case, we find it's
#' easier to use the `nhanes_design` family of functions, which are the lower
#' level functions that support `nhanes_summarize` and `nhanes_visualize`.
#' Full details on this family can be found at the help page for
#' [nhanes_design]. For this analysis, we create three designs:
#'
#' - an initial design that encapsulates the two others:
#'
#+ echo = TRUE
ds_init <- nhanes_design(
 data = nhanes_data[svy_subpop_htn == 1],
 key = nhanes_key,
 outcome_variable = 'bp_control_jnc7'
)
#' - a design for non-pregnant adults with hypertension
#+ echo = TRUE
ds_all <- ds_init %>%
 nhanes_design_subset(
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
 filter(bp_control_jnc7=='Yes') %>%
 mutate(group = 'Overall')

shiny_answers_etable_1_by_age <- ds_meds %>%
 nhanes_design_update(group_variable = 'demo_age_cat') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 filter(bp_control_jnc7=='Yes') %>%
 mutate(group = as.character(demo_age_cat))

shiny_answers_etable_1_by_sex <- ds_meds %>%
 nhanes_design_update(group_variable = 'demo_gender') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 filter(bp_control_jnc7=='Yes') %>%
 mutate(group = as.character(demo_gender))

shiny_answers_etable_1_by_race <- ds_meds %>%
 nhanes_design_update(group_variable = 'demo_race') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 filter(bp_control_jnc7=='Yes') %>%
 mutate(group = as.character(demo_race)) %>%
 filter(group != 'Other')

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
#' match their answers. There isn't really an easy way to load these data
#' programmatically, so they are written manually into a data set here.
#+ echo = TRUE

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

#' ## Replicating Table 2

jama_table_2 <- cardioStatsUSA::muntner_jama_2020_table_2

shiny_answers_table_2 <- ds_all %>%
 nhanes_design_update(outcome_variable = 'bp_cat_meds_excluded') %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 mutate(
  group = recode(
   bp_cat_meds_excluded,
   "SBP <120 and DBP <80 mm Hg" = "lt_120_80",
   "SBP of 120 to <130 and DBP <80 mm Hg" = "gt_120_lt_80",
   "SBP of 130 to <140 or DBP 80 to <90 mm Hg" = "gt_130_80",
   "SBP of 140 to <160 or DBP 90 to <100 mm Hg" = "gt_140_90",
   "SBP 160+ or DBP 100+ mm Hg" = "gt_160_100"
  )
 ) %>%
 select(all_of(names(jama_table_2))) %>%
 mutate(across(.cols = c(estimate, ci_lower, ci_upper),
               .fns = round, digits = 1))

test_results <-
 dplyr::bind_rows(jama = jama_table_2,
                  shiny = shiny_answers_table_2,
                  .id = 'source') %>%
 filter(svy_year != '2017-2018',
        svy_year != '2017-2020') %>%
 pivot_wider(names_from = source,
             values_from = c(estimate, ci_lower, ci_upper))

test_that(
 desc = "shiny app matches Table 2 of JAMA paper",
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

if(interactive()){
 file.copy(from = 'tests/testthat/test-replicate_muntner_jama_2020.R',
           to = "vignettes/replicate_jama_2020.R")
}


