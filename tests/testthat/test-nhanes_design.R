
outcomes <- nhanes_key %>%
 .[module == 'htn'] %>%
 .[outcome == TRUE] %>%
 .[['variable']]


# input validation --------------------------------------------------------

#TODO

# continuous exposure -----------------------------------------------------

ctns_group_variables <- nhanes_key %>%
 .[module == 'htn'] %>%
 .[group == TRUE] %>%
 .[type == 'ctns'] %>%
 .[['variable']]

for(i in ctns_group_variables){

 for(j in outcomes){

  if(i != j){

   ds <- nhanes_design(data = nhanes_data,
                       key = nhanes_key,
                       outcome_variable = j,
                       group_variable = i,
                       time_values = '2011-2012',
                       group_cut_n = 2)

   test_that(
    desc = glue::glue("general expectations are met for {i}"),
    code = {
     expect_s3_class(ds, 'nhanes_design')
     expect_true('svy_weight_mec' %in% names(ds$design$variables))
     expect_equal(ds$group$type, 'ctns')
    }
   )

   test_that(
    desc = glue::glue('original data unmodified when {i} is grouped'),
    code = {
     expect_type(nhanes_data[[i]], 'double')
     expect_false('svy_weight' %in% names(nhanes_data))
    }
   )

   test_that(
    desc = glue::glue('design data have discrete {i}'),
    code = {
     expect_true(is.factor(ds$design$variables[[i]]))
    }
   )

   test_that(
    desc = glue::glue('discrete {i} has right no. of groups'),
    code = {
     expect_equal(length(levels(ds$design$variables[[i]])), 2)
    }
   )


  }

 }


}





