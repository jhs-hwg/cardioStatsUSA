

smry <- nhanes_summarize(
 data = nhanes_data,
 key = nhanes_key,
 outcome_variable = 'bp_sys_mean',
 outcome_stats = 'mean',
 subset_calls = list(bp_med_ace = "Yes",
                     bp_med_aldo = "Yes"),
 stratify_variable = "demo_race"
)

smry[unreliable_status==TRUE]
