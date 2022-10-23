

ds <- nhanes_design(data = nhanes_data,
                    key = nhanes_key,
                    outcome_variable = 'bp_sys_mean')

smry <- ds %>%
 nhanes_design_summarize(outcome_stats = 'mean',
                         simplify_output = FALSE)

test_that(
 desc = 'results are stored as intended',
 code = {
  expect_false(is_empty(smry$results))
 }
)

