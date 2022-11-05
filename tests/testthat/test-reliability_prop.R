
smry <- nhanes_summarize(data = nhanes_data,
                         key = nhanes_key,
                         outcome_variable = 'bp_cat_meds_excluded',
                         time_values = 'most_recent',
                         subset_calls = list("demo_pregnant" = "Yes"))

reasons <-
 smry[unreliable_status==TRUE, unreliable_reason] %>%
 strsplit(split = '; ') %>%
 unlist() %>%
 unique()

expect_true(
 "Effective sample size < 30" %in% reasons
)

expect_true(
 "Relative CI width > 130%" %in% reasons
)
