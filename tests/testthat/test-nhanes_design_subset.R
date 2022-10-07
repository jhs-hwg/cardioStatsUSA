

# subsets -----------------------------------------------------------------

subset_variables <- nhanes_key %>%
 .[module == 'htn'] %>%
 .[subset==TRUE] %>%
 .[['variable']]

for(i in subset_variables){

 ds <- nhanes_design(data = nhanes_data,
                     key = nhanes_key,
                     outcome_variable = i,
                     time_values = '2013-2014')

 if(i == subset_variables[1]){
  test_that(
   desc = "object is unmodified if no subsets are requested",
   code = {expect_equal(ds, nhanes_design_subset(ds))}
  )
 }

 lvls <- levels(nhanes_data[[i]])

 for(j in lvls){

  sub_call <- rlang::parse_expr(glue::glue("{i} == \'{j}\'"))

  ds_sub <- nhanes_design_subset(ds, rlang::eval_bare(sub_call))

  ds_survey_pack <- subset(ds$design, rlang::eval_bare(sub_call))

  # different but safe to ignore
  ds_sub$design$call <- NULL
  ds_survey_pack$call <- NULL

  expect_equal(ds_sub$design, ds_survey_pack)

 }

}
