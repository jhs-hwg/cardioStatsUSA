

ds <- nhanes_design(data = nhanes_data,
                    key = nhanes_key,
                    outcome_variable = 'bp_sys_mean',
                    time_values = '2011-2012')

ds_standard <- nhanes_design_standardize(ds)

test_that(
 desc = 'design is modified as intended',
 code = {
  expect_true(is.null(ds$design$postStrata))
  expect_false(is.null(ds_standard$design$postStrata))
 }
)





