


outcomes <- c('bp_sys_mean',          # continuous outcome
              'bp_cat_meds_included', # categorical outcome
              'chol_hdl_low')         # binary outcome

exposures <- c('demo_race',      # a categorical variable
               'demo_age_years', # a continuous variable
               'htn_jnc7')       # a binary variable

subset_variables <- list("demo_gender")
subset_values <- list("Women")
years <- 'last_5'

test_that(
 desc = "each outcome can be summarized overall and in exposure groups",
 code = {
  for(o in outcomes){

   expect_true(is.data.table(nhanes_summarize(o, pool = TRUE)))
   expect_true(is.data.table(nhanes_summarize(o, pool = FALSE)))

   for(e in setdiff(exposures, o)){

    expect_true(
     is.data.table(
      nhanes_summarize(
       outcome = o,
       exposure = e,
       years = years,
       subset_variables = subset_variables,
       subset_values = subset_values,
       pool = TRUE
      )
     )
    )
    expect_true(
     is.data.table(
      nhanes_summarize(
       outcome = o,
       exposure = e,
       years = years,
       subset_variables = subset_variables,
       subset_values = subset_values,
       pool = FALSE
      )
     )
    )

   }
  }
 }
)

