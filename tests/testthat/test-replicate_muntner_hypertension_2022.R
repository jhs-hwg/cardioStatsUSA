# TODO: PM's paper had N=11,007 w/JNC7 hypertension (figure S1)
# we have 10 more cases - see Issue 39 at
# https://github.com/jhs-hwg/cardioStatsUSA/issues/39
# nrow(ds$design$variables)

# Solution: it may be the calibrated BP
# - try using uncalibrated BP values when making the sample

# Hypertension Trends in BP tests --------------------------------------------

#' ## Who is included in this test
#'
#' For these tests, we include the same cohort as Muntner et al. Full details
#' on the inclusion criteria are given in the paper, but here all that
#' we need to do is subset the data to include rows where `svy_subpop_htn`
#' is equal to 1 and limit the survey cycles to those used in the paper.
#'
#+ echo = TRUE
nhanes_subpop_htn <- nhanes_data %>%
 .[svy_subpop_htn == 1] %>%
 .[svy_year %in% c("2009-2010",
                   "2011-2012",
                   "2013-2014",
                   "2015-2016",
                   "2017-2020")]

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
standard_weights <- c(13.5, 45.3, 23.3, 17.8)
#'
#' In most cases, we use `nhanes_summarize()` or `nhanes_visualize()`
#' when generating results with `cardioStatsUSA`. Here, we use the
#' `nhanes_design` family of functions. NHANES design functions are
#' lower level functions that support `nhanes_summarize` and
#' `nhanes_visualize`. Full details on this family can be found at
#' the help page for [nhanes_design].

ds <- nhanes_subpop_htn %>%
 nhanes_design(
  key = nhanes_key,
  outcome_variable = 'bp_control_140_90',
  time_values = c( "2009-2010",
                   "2011-2012",
                   "2013-2014",
                   "2015-2016",
                   "2017-2020")
 ) %>%
 nhanes_design_subset(
  (demo_pregnant == 'No' | is.na(demo_pregnant)) &
   htn_jnc7 == 'Yes'
 ) %>%
 nhanes_design_standardize(standard_weights = standard_weights)

#'
#' ## Replicating Table S2
#'
#' To reproduce Table S2 from Muntner et al, we use the `ds` design
#' object to estimate the proportion of adults with BP control according to
#' the JNC7 BP guidelines.
#'
#+ echo = TRUE
shiny_answers_table_s2_overall <- ds %>%
 nhanes_design_summarize(outcome_stats = 'percentage',
                         simplify_output = TRUE) %>%
 .[bp_control_140_90=='Yes'] %>%
 .[, group := "Overall"]

shiny_answers_table_s2_groups <- lapply(
 c('demo_age_cat', 'demo_gender'),
 function(.variable){
  ds %>%
   nhanes_design_update(group_variable = .variable) %>%
   nhanes_design_summarize(outcome_stats = 'percentage',
                           simplify_output = TRUE) %>%
   .[bp_control_140_90=='Yes'] %>%
   setnames(old = .variable, new = 'group')
 }
)

#' Now we can put all of our answers together
#+ echo = TRUE
est_cols <- c('estimate', 'ci_lower', 'ci_upper')

shiny_answers_table_s2 <- list(shiny_answers_table_s2_overall) %>%
 c(shiny_answers_table_s2_groups) %>%
 rbindlist(fill = TRUE) %>%
 as.data.table() %>%
 .[, .(svy_year, group, estimate, ci_lower, ci_upper)] %>%
 .[, (est_cols) := lapply(.SD, round, digits = 1), .SDcols = est_cols]

#' We also need to get the data from Muntner et al to make sure our answers
#' match their answers.
#+ echo = TRUE
table_s2 <- cardioStatsUSA::muntner_hypertension_2022_table_s2 %>%
 .[, variable := NULL]


#' Now put everything together and test that all of our answers match
#+ echo = TRUE
test_results <- list(
 hypertension = table_s2,
 shiny = shiny_answers_table_s2
) %>%
 rbindlist(idcol = 'source') %>%
 dcast(svy_year + group ~ source, value.var = est_cols)

#' take a look at the merged results, you can see estimate_shiny matches
#' estimate_hypertension in all cells shown.
#+ echo = TRUE
test_results

#' In some cases, we have minor differences due to rounding and/or
#' minor differences due to a small differences in the study cohorts.
#' To ensure all of these differences are small enough, we set a 1%
#' tolerance for differences in the Shiny app versus the paper.
#+ echo = TRUE
tolerance <- 0.01

test_that(
 desc = "shiny app matches Table S2 of Hypertension paper",
 code = {

  expect_equal(test_results$estimate_hypertension,
               test_results$estimate_shiny,
               tolerance = tolerance)

  expect_equal(test_results$ci_lower_hypertension,
               test_results$ci_lower_shiny,
               tolerance = tolerance)

  expect_equal(test_results$ci_upper_hypertension,
               test_results$ci_upper_shiny,
               tolerance = tolerance)

 }
)

