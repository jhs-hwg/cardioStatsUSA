
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
jama_etable_1 <- tribble(
 ~svy_year,   ~group              , ~estimate, ~ci_lower, ~ci_upper,
 "1999-2000", "Overall"           ,  53.4    ,  49.0    ,  57.9    ,
 "2001-2002", "Overall"           ,  58.6    ,  56.0    ,  61.2    ,
 "2003-2004", "Overall"           ,  62.1    ,  57.9    ,  66.2    ,
 "2005-2006", "Overall"           ,  65.5    ,  62.0    ,  69.0    ,
 "2007-2008", "Overall"           ,  68.3    ,  65.9    ,  70.8    ,
 "2009-2010", "Overall"           ,  69.7    ,  67.4    ,  72.1    ,
 "2011-2012", "Overall"           ,  70.3    ,  66.8    ,  73.8    ,
 "2013-2014", "Overall"           ,  72.2    ,  68.6    ,  75.8    ,
 "2015-2016", "Overall"           ,  66.8    ,  63.0    ,  70.6    ,
 "2017-2018", "Overall"           ,  64.8    ,  61.3    ,  68.3    ,
 "1999-2000", "18 to 44"          ,  66.1    ,  54.7    ,  77.5    ,
 "2001-2002", "18 to 44"          ,  70.8    ,  60.4    ,  81.1    ,
 "2003-2004", "18 to 44"          ,  81.7    ,  73.2    ,  90.2    ,
 "2005-2006", "18 to 44"          ,  77.2    ,  67.1    ,  87.4    ,
 "2007-2008", "18 to 44"          ,  83.7    ,  78.6    ,  88.7    ,
 "2009-2010", "18 to 44"          ,  65.5    ,  56.0    ,  74.9    ,
 "2011-2012", "18 to 44"          ,  83.3    ,  74.2    ,  92.4    ,
 "2013-2014", "18 to 44"          ,  81.0    ,  76.0    ,  85.9    ,
 "2015-2016", "18 to 44"          ,  70.9    ,  63.2    ,  78.6    ,
 "2017-2018", "18 to 44"          ,  73.3    ,  60.5    ,  86.0    ,
 "1999-2000", "45 to 64"          ,  60.6    ,  55.1    ,  66.1    ,
 "2001-2002", "45 to 64"          ,  63.3    ,  58.6    ,  68.1    ,
 "2003-2004", "45 to 64"          ,  63.9    ,  58.6    ,  69.2    ,
 "2005-2006", "45 to 64"          ,  68.8    ,  63.1    ,  74.5    ,
 "2007-2008", "45 to 64"          ,  69.8    ,  65.5    ,  74.1    ,
 "2009-2010", "45 to 64"          ,  73.4    ,  69.6    ,  77.3    ,
 "2011-2012", "45 to 64"          ,  74.6    ,  70.6    ,  78.5    ,
 "2013-2014", "45 to 64"          ,  75.2    ,  69.7    ,  80.7    ,
 "2015-2016", "45 to 64"          ,  74.0    ,  68.1    ,  79.9    ,
 "2017-2018", "45 to 64"          ,  69.1    ,  64.6    ,  73.6    ,
 "1999-2000", "65 to 74"          ,  50.0    ,  43.2    ,  56.9    ,
 "2001-2002", "65 to 74"          ,  49.8    ,  43.1    ,  56.5    ,
 "2003-2004", "65 to 74"          ,  58.7    ,  51.9    ,  65.5    ,
 "2005-2006", "65 to 74"          ,  58.8    ,  53.7    ,  63.9    ,
 "2007-2008", "65 to 74"          ,  66.1    ,  62.2    ,  70.0    ,
 "2009-2010", "65 to 74"          ,  71.5    ,  67.5    ,  75.6    ,
 "2011-2012", "65 to 74"          ,  68.6    ,  62.0    ,  75.2    ,
 "2013-2014", "65 to 74"          ,  70.6    ,  66.4    ,  74.7    ,
 "2015-2016", "65 to 74"          ,  64.4    ,  56.7    ,  72.2    ,
 "2017-2018", "65 to 74"          ,  64.3    ,  56.9    ,  71.7    ,
 "1999-2000", "75+"               ,  28.1    ,  22.0    ,  34.3    ,
 "2001-2002", "75+"               ,  46.5    ,  36.9    ,  56.2    ,
 "2003-2004", "75+"               ,  44.1    ,  38.2    ,  50.1    ,
 "2005-2006", "75+"               ,  55.0    ,  48.3    ,  61.7    ,
 "2007-2008", "75+"               ,  53.9    ,  48.5    ,  59.2    ,
 "2009-2010", "75+"               ,  61.7    ,  55.8    ,  67.6    ,
 "2011-2012", "75+"               ,  49.9    ,  41.7    ,  58.1    ,
 "2013-2014", "75+"               ,  58.5    ,  50.4    ,  66.7    ,
 "2015-2016", "75+"               ,  47.7    ,  39.2    ,  56.2    ,
 "2017-2018", "75+"               ,  46.9    ,  39.9    ,  53.9    ,
 "1999-2000", "Women"             ,  49.6    ,  44.6    ,  54.5    ,
 "2001-2002", "Women"             ,  57.5    ,  53.8    ,  61.1    ,
 "2003-2004", "Women"             ,  59.4    ,  54.2    ,  64.6    ,
 "2005-2006", "Women"             ,  63.8    ,  60.0    ,  67.6    ,
 "2007-2008", "Women"             ,  67.5    ,  64.7    ,  70.3    ,
 "2009-2010", "Women"             ,  71.4    ,  68.7    ,  74.0    ,
 "2011-2012", "Women"             ,  70.2    ,  65.6    ,  74.7    ,
 "2013-2014", "Women"             ,  72.4    ,  68.1    ,  76.7    ,
 "2015-2016", "Women"             ,  67.9    ,  63.9    ,  71.9    ,
 "2017-2018", "Women"             ,  63.0    ,  59.1    ,  66.8    ,
 "1999-2000", "Men"               ,  59.2    ,  51.3    ,  67.1    ,
 "2001-2002", "Men"               ,  61.3    ,  55.8    ,  66.8    ,
 "2003-2004", "Men"               ,  65.5    ,  60.6    ,  70.3    ,
 "2005-2006", "Men"               ,  68.4    ,  62.7    ,  74.1    ,
 "2007-2008", "Men"               ,  69.4    ,  66.2    ,  72.6    ,
 "2009-2010", "Men"               ,  68.4    ,  64.5    ,  72.3    ,
 "2011-2012", "Men"               ,  71.1    ,  67.1    ,  75.1    ,
 "2013-2014", "Men"               ,  72.6    ,  67.5    ,  77.8    ,
 "2015-2016", "Men"               ,  66.5    ,  61.1    ,  71.8    ,
 "2017-2018", "Men"               ,  67.1    ,  62.5    ,  71.8    ,
 "1999-2000", "Non-Hispanic White",  57.3    ,  51.9    ,  62.8    ,
 "2001-2002", "Non-Hispanic White",  61.3    ,  57.2    ,  65.4    ,
 "2003-2004", "Non-Hispanic White",  65.1    ,  60.6    ,  69.6    ,
 "2005-2006", "Non-Hispanic White",  67.1    ,  62.9    ,  71.2    ,
 "2007-2008", "Non-Hispanic White",  71.0    ,  68.3    ,  73.7    ,
 "2009-2010", "Non-Hispanic White",  73.4    ,  70.7    ,  76.1    ,
 "2011-2012", "Non-Hispanic White",  72.3    ,  68.5    ,  76.2    ,
 "2013-2014", "Non-Hispanic White",  75.4    ,  70.4    ,  80.4    ,
 "2015-2016", "Non-Hispanic White",  70.4    ,  65.6    ,  75.2    ,
 "2017-2018", "Non-Hispanic White",  68.2    ,  63.5    ,  72.9    ,
 "1999-2000", "Non-Hispanic Black",  44.3    ,  37.1    ,  51.5    ,
 "2001-2002", "Non-Hispanic Black",  48.6    ,  45.7    ,  51.6    ,
 "2003-2004", "Non-Hispanic Black",  55.6    ,  49.0    ,  62.2    ,
 "2005-2006", "Non-Hispanic Black",  57.9    ,  51.9    ,  63.9    ,
 "2007-2008", "Non-Hispanic Black",  61.1    ,  56.7    ,  65.6    ,
 "2009-2010", "Non-Hispanic Black",  60.1    ,  56.0    ,  64.1    ,
 "2011-2012", "Non-Hispanic Black",  64.2    ,  58.9    ,  69.4    ,
 "2013-2014", "Non-Hispanic Black",  60.4    ,  54.4    ,  66.5    ,
 "2015-2016", "Non-Hispanic Black",  58.1    ,  53.0    ,  63.2    ,
 "2017-2018", "Non-Hispanic Black",  53.2    ,  47.5    ,  58.9    ,
 "1999-2000", "Hispanic"          ,  48.8    ,  39.3    ,  58.3    ,
 "2001-2002", "Hispanic"          ,  61.7    ,  51.0    ,  72.4    ,
 "2003-2004", "Hispanic"          ,  54.5    ,  40.9    ,  68.1    ,
 "2005-2006", "Hispanic"          ,  64.2    ,  57.1    ,  71.4    ,
 "2007-2008", "Hispanic"          ,  64.3    ,  57.7    ,  70.9    ,
 "2009-2010", "Hispanic"          ,  58.1    ,  52.3    ,  64.1    ,
 "2011-2012", "Hispanic"          ,  65.4    ,  59.5    ,  71.2    ,
 "2013-2014", "Hispanic"          ,  68.9    ,  61.8    ,  75.9    ,
 "2015-2016", "Hispanic"          ,  65.0    ,  58.8    ,  71.2    ,
 "2017-2018", "Hispanic"          ,  58.2    ,  48.7    ,  67.7    ,
 "2011-2012", "Non-Hispanic Asian",  72.5    ,  62.3    ,  82.6    ,
 "2013-2014", "Non-Hispanic Asian",  63.8    ,  57.2    ,  70.5    ,
 "2015-2016", "Non-Hispanic Asian",  54.1    ,  43.8    ,  64.4    ,
 "2017-2018", "Non-Hispanic Asian",  63.7    ,  58.9    ,  68.5    )

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

jama_table_2 <- tribble(
 ~svy_year,   ~group,        ~estimate , ~ci_lower, ~ci_upper,
 "1999-2000", "lt_120_80",    9.2      ,  7.4     ,  10.9    ,
 "2001-2002", "lt_120_80",    12.5     ,  10.0    ,  15.0    ,
 "2003-2004", "lt_120_80",    13.1     ,  11.2    ,  14.9    ,
 "2005-2006", "lt_120_80",    14.9     ,  12.8    ,  17.0    ,
 "2007-2008", "lt_120_80",    18.2     ,  15.8    ,  20.6    ,
 "2009-2010", "lt_120_80",    21.4     ,  19.4    ,  23.4    ,
 "2011-2012", "lt_120_80",    18.4     ,  14.7    ,  22.1    ,
 "2013-2014", "lt_120_80",    20.2     ,  16.8    ,  23.6    ,
 "2015-2016", "lt_120_80",    17.2     ,  13.5    ,  20.9    ,
 "2017-2018", "lt_120_80",    15.8     ,  12.9    ,  18.6    ,
 "1999-2000", "gt_120_lt_80", 6.5      ,  5.3     ,  7.6     ,
 "2001-2002", "gt_120_lt_80", 7.1      ,  5.7     ,  8.5     ,
 "2003-2004", "gt_120_lt_80", 9.6      ,  8.0     ,  11.3    ,
 "2005-2006", "gt_120_lt_80", 10.7     ,  8.5     ,  12.8    ,
 "2007-2008", "gt_120_lt_80", 12.3     ,  10.0    ,  14.5    ,
 "2009-2010", "gt_120_lt_80", 12.5     ,  10.9    ,  14.0    ,
 "2011-2012", "gt_120_lt_80", 15.8     ,  13.8    ,  17.8    ,
 "2013-2014", "gt_120_lt_80", 14.6     ,  12.5    ,  16.7    ,
 "2015-2016", "gt_120_lt_80", 14.3     ,  11.6    ,  16.9    ,
 "2017-2018", "gt_120_lt_80", 11.3     ,  9.4     ,  13.2    ,
 "1999-2000", "gt_130_80",    16.2     ,  12.4    ,  19.9    ,
 "2001-2002", "gt_130_80",    15.3     ,  13.0    ,  17.5    ,
 "2003-2004", "gt_130_80",    17.1     ,  14.6    ,  19.7    ,
 "2005-2006", "gt_130_80",    18.3     ,  14.8    ,  21.8    ,
 "2007-2008", "gt_130_80",    18.0     ,  15.5    ,  20.6    ,
 "2009-2010", "gt_130_80",    19.2     ,  17.3    ,  21.0    ,
 "2011-2012", "gt_130_80",    17.7     ,  16.4    ,  18.9    ,
 "2013-2014", "gt_130_80",    19.1     ,  15.3    ,  22.8    ,
 "2015-2016", "gt_130_80",    16.9     ,  14.0    ,  19.7    ,
 "2017-2018", "gt_130_80",    16.7     ,  15.0    ,  18.3    ,
 "1999-2000", "gt_140_90",    48.2     ,  44.3    ,  52.1    ,
 "2001-2002", "gt_140_90",    44.8     ,  41.8    ,  47.7    ,
 "2003-2004", "gt_140_90",    42.4     ,  38.2    ,  46.6    ,
 "2005-2006", "gt_140_90",    41.5     ,  38.8    ,  44.2    ,
 "2007-2008", "gt_140_90",    39.3     ,  36.3    ,  42.4    ,
 "2009-2010", "gt_140_90",    36.7     ,  33.3    ,  40.0    ,
 "2011-2012", "gt_140_90",    35.7     ,  31.7    ,  39.7    ,
 "2013-2014", "gt_140_90",    35.1     ,  31.0    ,  39.2    ,
 "2015-2016", "gt_140_90",    40.1     ,  36.8    ,  43.4    ,
 "2017-2018", "gt_140_90",    41.7     ,  38.6    ,  44.8    ,
 "1999-2000", "gt_160_100",   20.0     ,  16.5    ,  23.6    ,
 "2001-2002", "gt_160_100",   20.4     ,  17.2    ,  23.5    ,
 "2003-2004", "gt_160_100",   17.8     ,  15.4    ,  20.2    ,
 "2005-2006", "gt_160_100",   14.6     ,  12.4    ,  16.9    ,
 "2007-2008", "gt_160_100",   12.2     ,  10.7    ,  13.7    ,
 "2009-2010", "gt_160_100",   10.3     ,  8.7     ,  12.0    ,
 "2011-2012", "gt_160_100",   12.4     ,  9.6     ,  15.2    ,
 "2013-2014", "gt_160_100",   11.1     ,  9.3     ,  12.9    ,
 "2015-2016", "gt_160_100",   11.5     ,  9.9     ,  13.2    ,
 "2017-2018", "gt_160_100",   14.6     ,  11.7    ,  17.5
)

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

#
# testServer(
#  app = server, {
#   session$setInputs(do = 'data',
#                     years = c(
#                      "1999-2000",
#                      "2001-2002",
#                      "2003-2004",
#                      "2005-2006",
#                      "2007-2008",
#                      "2009-2010",
#                      "2011-2012",
#                      "2013-2014",
#                      "2015-2016",
#                      "2017-2020"
#                     ),
#                     pool = 'no')
#  }
#
# )

