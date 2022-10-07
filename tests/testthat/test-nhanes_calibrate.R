
# benchmark the nhanes_calibrate function
# takes about ~30-35 milliseconds on average
# microbenchmark::microbenchmark(
#  bcj_calib = nhanes_calibrate(nhanes_full = nhanes_data,
#                               nhanes_sub = nhanes_data[svy_subpop_htn == 1])
# )

# validate calibration in subgroups defined by:
variables <- c('svy_year',
               'demo_age_cat',
               'demo_gender',
               'demo_race_black')

nhanes_htn <- nhanes_calibrate(nhanes_full = nhanes_data,
                               nhanes_sub = nhanes_data[svy_subpop_htn == 1])

test_that(
 desc = "sum of weights in the calibrated data matches the original",
 code = {

  # overall
  expect_equal(
   sum(nhanes_htn$svy_weight_cal),
   sum(nhanes_data$svy_weight_mec)
  )


  for(v in variables){
   for(i in levels(nhanes_data[[v]])){
    expect_equal(
     sum(nhanes_htn$svy_weight_cal[nhanes_htn[[v]]==i]),
     sum(nhanes_data$svy_weight_mec[nhanes_data[[v]]==i])
    )
   }
  }
 }
)

nhanes_chol <- nhanes_calibrate(nhanes_full = nhanes_data,
                                nhanes_sub = nhanes_data[svy_subpop_chol == 1])

test_that(
 desc = "sum of weights in the calibrated data matches the original",
 code = {

  # overall
  expect_equal(
   sum(nhanes_chol$svy_weight_cal),
   sum(nhanes_data$svy_weight_mec)
  )

  for(v in variables){
   for(i in levels(nhanes_data[[v]])){
    expect_equal(
     sum(nhanes_chol$svy_weight_cal[nhanes_chol[[v]]==i]),
     sum(nhanes_data$svy_weight_mec[nhanes_data[[v]]==i])
    )
   }
  }
 }
)

