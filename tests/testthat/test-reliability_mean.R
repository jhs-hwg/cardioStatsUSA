
# A case where the number of observations is low

smry <- nhanes_summarize(
 data = nhanes_data,
 key = nhanes_key,
 outcome_variable = 'bp_sys_mean',
 outcome_stats = 'mean',
 subset_calls = list(bp_med_ace = "Yes",
                     bp_med_aldo = "Yes"),
 stratify_variable = "demo_race"
)

reasons <- smry[unreliable_status==TRUE, unreliable_reason]

expect_true(
 "Sample size < 30" %in% reasons
)
