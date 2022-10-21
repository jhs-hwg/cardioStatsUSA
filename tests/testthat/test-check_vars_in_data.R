
expect_invisible(
 check_vars_in_data(outcome_variable = 'bp_sys_mean',
                    group_variable = NULL,
                    data_names = names(nhanes_data),
                    data_label = 'nhanes_data')
)

expect_invisible(
 check_vars_in_data(outcome_variable = 'bp_sys_mean',
                    data_names = nhanes_key$variable,
                    data_label = 'nhanes_key')
)

expect_error(
 check_vars_in_data(outcome_variable = 'not_right',
                    data_names = nhanes_key$variable,
                    data_label = 'nhanes_key'),
 regexp = 'outcome_variable not_right'
)

expect_error(
 check_vars_in_data(outcome_variable = 'bp_sys_mean',
                    group_variable = 'not_right',
                    data_names = nhanes_key$variable,
                    data_label = 'nhanes_key'),
 regexp = 'group_variable not_right'
)

expect_error(
 check_vars_in_data(outcome_variable = 'bp_sys_mean',
                    stratify_variable = 'not_right',
                    data_names = names(nhanes_data),
                    data_label = 'nhanes_key'),
 regexp = 'stratify_variable not_right'
)

