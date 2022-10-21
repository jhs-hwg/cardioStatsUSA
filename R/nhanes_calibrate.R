

# nhanes full is the full nhanes data
# nhanes sub is a subset of nhanes full that we will calibrate weights in
# calib_by defines the groups we'll calibrate weights in



#' Calibration of NHANES weights
#'
#' When estimating the count of US adults using a subset of NHANES participants,
#'   it may be helpful to re-calibrate the survey weights in the subset so that
#'   the sum of the calibrated weights match the sum of the weights in the
#'   full NHANES data
#'
#' @param nhanes_sub \[data.table\]
#'
#' The subsetted NHANES data.
#'
#' @param nhanes_full \[data.table\]
#'
#' The full NHANES data
#'
#' @param calib_by \[character(1+)\]
#'
#' The variables that are used to create groups wherein calibration occurs.
#'   For example, the default calib_by = c('svy_year', 'demo_age_cat',
#'   'demo_gender', 'demo_race_black') means that weights within subgroups
#'   defined by NHANES cycle, age, sex, and race categories will be calibrated
#'   in the subsetted data to match the corresponding group's sum in the
#'   full data.
#'
#' @details the default for `calib_by` uses a race variable with fewer
#'   categories than `demo_race` (the variable used in analyses). This is
#'   done because some of the groups formed when `demo_race` is used
#'   are too small to ensure that the sum of the calirbated weights
#'   matches (or is very close to matching) the sum of the weights in
#'   the original NHANES data.
#'
#'
#' @return a data.table
#'
#' @export
#'
#' @examples
#'
#' # here we calibrate the hypertension sub-population
#'
#' nhanes_sub <- nhanes_data[svy_subpop_htn == 1]
#' nhanes_htn <- nhanes_calibrate(nhanes_full = nhanes_data,
#'                                nhanes_sub = nhanes_sub)
#'
#' # the un-calibrated weights do not match the size of the NHANES population
#' sum(nhanes_sub$svy_weight_mec)
#' # but the calibrated weights do
#' sum(nhanes_htn$svy_weight_cal)
#' sum(nhanes_data$svy_weight_mec)
#'
#'
nhanes_calibrate <- function(nhanes_sub,
                             nhanes_full,
                             calib_by = c('svy_year',
                                          'demo_age_cat',
                                          'demo_gender',
                                          'demo_race_black')){

 if(!is.data.table(nhanes_sub))
  nhanes_sub <- as.data.table(nhanes_sub)

 if(!is.data.table(nhanes_full))
  nhanes_full <- as.data.table(nhanes_full)

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


}


