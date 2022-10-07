
outcomes <- c('bp_sys_mean',          # continuous outcome
              'bp_cat_meds_included', # categorical outcome
              'bp_med_n_class',       # integer outcome
              'chol_hdl_low')         # binary outcome

exposures <- c('demo_race',      # a categorical variable
               'demo_age_years', # a continuous variable
               'htn_jnc7')       # a binary variable

subset_calls <- list("demo_gender" = "Women")
years <- 'most_recent'

test_that(
 desc = "each outcome can be summarized overall and in exposure groups",
 code = {
  for(o in outcomes){

   smry_overall <- nhanes_summarize(outcome_variable = o,
                                    pool = TRUE,
                                    simplify_output = TRUE)

   smry_by_cycle <- nhanes_summarize(outcome_variable = o,
                                     pool = FALSE,
                                     simplify_output = TRUE)


   expect_true(is.data.table(smry_overall))
   expect_true(is.data.table(smry_by_cycle))

   expect_true(
    all(names(smry_overall) %in% names(smry_by_cycle))
   )

   for(e in setdiff(exposures, o)){
    for (p in c(TRUE, FALSE)){
     expect_true(
      is.data.table(
       nhanes_summarize(
        outcome_variable = o,
        group_variable = e,
        time_values = years,
        subset_calls = subset_calls,
        pool = p
       )
      )
     )
    }
   }
  }
 }
)

