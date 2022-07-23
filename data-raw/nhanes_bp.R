
# make the data used in shiny app
nhanes_bp <-
 nhanes_load(fname = "nhanes_bp-raw.sas7bdat",
             as = 'data.table') %>%
 nhanes_recode() %>%
 nhanes_rename()


# nhanes_bp <- nhanes_bp %>%
#  .[, demo_age_3cat := recode(demo_age_cat,
#                             '75+' = '65+',
#                             '65 to 74' = '65+')]
#
# nhanes_full <- nhanes_bp
# nhanes_sub <- nhanes_bp[svy_subpop == 1]
#
# nhanes_calibrate <- function(nhanes_full,
#                              nhanes_sub,
#                              calib_by = c('svy_year',
#                                           'demo_age_3cat',
#                                           'demo_gender',
#                                           'demo_race')){
#
#  .full <- nhanes_full[,.(total = sum(svy_weight_mec)), keyby = calib_by]
#  .sub <- nhanes_sub[, .(partial = sum(svy_weight_mec)),  keyby = calib_by]
#
#  .calib <- merge(.full, .sub)[, ratio := total / partial] %>%
#   .[, `:=`(total = NULL, partial = NULL)]
#
#  nhanes_sub[.calib, on = calib_by] %>%
#   .[, svy_weight_cal := svy_weight_mec * ratio]
#
# }
#
# tmp <- nhanes_bp %>%
#  nhanes_calibrate(nhanes_bp[svy_subpop == 1])
#
# nhanes_full$svy_weight_mec %>% sum()
# tmp$svy_weight_cal %>% sum()

usethis::use_data(nhanes_bp, overwrite = TRUE)
