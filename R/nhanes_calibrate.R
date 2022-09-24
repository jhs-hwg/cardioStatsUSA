

# nhanes full is the full nhanes data
# nhanes sub is a subset of nhanes full that we will calibrate weights in
# calib_by defines the groups we'll calibrate weights in

nhanes_calibrate <- function(nhanes_full,
                             nhanes_sub,
                             calib_by = c('svy_year',
                                          'demo_age_cat',
                                          'demo_gender')){


 # find total sum of weights across all combinations of the by groups
 # .full is for the full population, .sub is among the subpop
 .full <- nhanes_full[,.(total = sum(svy_weight_mec)), keyby = calib_by]
 .sub <- nhanes_sub[, .(partial = sum(svy_weight_mec)),  keyby = calib_by]

 # merge and compute the ratio that will be used to calibrate weights
 .calib <- merge(.full, .sub)[, ratio := total / partial] %>%
  # not needed, but drop the total and partial column
  .[, `:=`(total = NULL, partial = NULL)]

 # return nhanes_sub with calibrated weights
 nhanes_sub[.calib, on = calib_by] %>%
  .[, svy_weight_cal := svy_weight_mec * ratio]

#
#
#  # find total sum of weights across all combinations of the by groups
#  # .full is for the full population, .sub is among the subpop
#  .full <- nhanes_full[,.(total = sum(svy_weight_af, na.rm=TRUE)), keyby = calib_by]
#  .sub <- nhanes_sub[, .(partial = sum(svy_weight_af, na.rm=TRUE)),  keyby = calib_by]
#
#  # merge and compute the ratio that will be used to calibrate weights
#  .calib <- merge(.full, .sub)[, ratio := total / partial] %>%
#   # not needed, but drop the total and partial column
#   .[, `:=`(total = NULL, partial = NULL)]
#
#  # return nhanes_sub with calibrated weights
#  nhanes_sub[.calib, on = calib_by] %>%
#   .[, svy_weight_cal := svy_weight_af * ratio]


}


