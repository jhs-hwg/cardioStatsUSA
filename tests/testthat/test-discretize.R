

bp <- nhanes_data$bp_sys_mean

ctns_variables <- nhanes_key[type == 'ctns', variable]

for(v in ctns_variables){

 for(n_group in seq(2, 5)){

  freq <- discretize(nhanes_data[[v]], 'frequency', n_group = n_group)

  expect_equal(length(levels(freq)), n_group)

  expect_equal(
   which(is.na(nhanes_data[[v]])),
   which(is.na(freq))
  )

  # this is the max difference b/t the relative size of the groups
  max_diff <- diff(range(prop.table(table(freq))))

  expect_true(max_diff < 0.05)

  interval <- discretize(nhanes_data[[v]], 'interval', n_group = n_group)

  expect_equal(length(levels(interval)), n_group)

  expect_equal(
   which(is.na(nhanes_data[[v]])),
   which(is.na(interval))
  )

 }

}





