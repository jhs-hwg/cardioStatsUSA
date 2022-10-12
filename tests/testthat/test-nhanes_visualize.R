
# continuous outcome ----

test_that(
 desc = 'one group blots, continuous outcome mean',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean'),
                  cran = FALSE)

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   geom = 'point'),
                  cran = FALSE)

 }
)

test_that(
 desc = 'one group bar blots, continuous outcome quantile',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   outcome_quantiles = seq(1,10)/10,
                                   statistic_primary = 'quantile'),
                  cran = FALSE)
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   outcome_quantiles = seq(1,10)/10,
                                   statistic_primary = 'quantile',
                                   geom = 'point'),
                  cran = FALSE)
 }
)

test_that(
 desc = 'multiple group bar blots, continuous outcome mean',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   group_variable = 'demo_gender'),
                  cran = FALSE)
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   group_variable = 'demo_gender',
                                   geom = 'point'),
                  cran = FALSE)
 }
)

test_that(
 desc = 'multiple group plots, continuous outcome quantile',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   outcome_quantiles = seq(1,10)/10,
                                   statistic_primary = 'quantile',
                                   group_variable = 'demo_gender'),
                  cran = FALSE)
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   outcome_quantiles = seq(1,10)/10,
                                   statistic_primary = 'quantile',
                                   group_variable = 'demo_gender',
                                   geom = 'point'),
                  cran = FALSE)
 }
)

test_that(
 desc = 'stratified group plots, continuous outcome quantile',
 code = {

  plts_bar <- nhanes_visualize(outcome_variable = 'bp_sys_mean',
                               outcome_quantiles = seq(1,10)/10,
                               statistic_primary = 'quantile',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd')

  expect_snapshot(plts_bar[[1]])
  expect_snapshot(plts_bar[[2]])

  plts_pnt <- nhanes_visualize(outcome_variable = 'bp_sys_mean',
                               outcome_quantiles = seq(1,10)/10,
                               statistic_primary = 'quantile',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd',
                               geom = 'point')

  expect_snapshot(plts_pnt[[1]])
  expect_snapshot(plts_pnt[[2]])

 }
)

# binary outcome ----

test_that(
 desc = 'one group blots, binary outcome prevalence',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7'))

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   geom = 'point'))

 }
)

test_that(
 desc = 'one group bar blots, binary outcome count',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   statistic_primary = 'count'))

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   statistic_primary = 'count',
                                   geom = 'point'))
 }
)

test_that(
 desc = 'multiple group bar blots, binary outcome prevalence',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   group_variable = 'demo_gender'))

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   group_variable = 'demo_gender',
                                   geom = 'point'))
 }
)

test_that(
 desc = 'multiple group plots, binary outcome count',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   statistic_primary = 'count',
                                   group_variable = 'demo_gender'))

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   statistic_primary = 'count',
                                   group_variable = 'demo_gender',
                                   geom = 'point'))
 }
)

test_that(
 desc = 'stratified group plots, binary outcome count',
 code = {

  plts_bar <- nhanes_visualize(outcome_variable = 'htn_jnc7',
                               statistic_primary = 'count',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd')

  expect_snapshot(plts_bar[[1]])
  expect_snapshot(plts_bar[[2]])

  plts_pnt <- nhanes_visualize(outcome_variable = 'htn_jnc7',
                               statistic_primary = 'count',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd',
                               geom = 'point')

  expect_snapshot(plts_pnt[[1]])
  expect_snapshot(plts_pnt[[2]])

 }
)

# catg outcome ----

test_that(
 desc = 'one group blots, categorical outcome prevalence',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded'))

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   geom = 'point'))

 }
)

test_that(
 desc = 'one group bar blots, categorical outcome count',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   statistic_primary = 'count'))

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   statistic_primary = 'count',
                                   geom = 'point'))
 }
)

test_that(
 desc = 'multiple group bar blots, categorical outcome prevalence',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   group_variable = 'demo_gender'))

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   group_variable = 'demo_gender',
                                   geom = 'point'))
 }
)

test_that(
 desc = 'multiple group plots, categorical outcome count',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   statistic_primary = 'count',
                                   group_variable = 'demo_gender'))

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   statistic_primary = 'count',
                                   group_variable = 'demo_gender',
                                   geom = 'point'))
 }
)

test_that(
 desc = 'stratified group plots, categorical outcome count',
 code = {

  plts_bar <- nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                               statistic_primary = 'count',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd')

  expect_snapshot(plts_bar[[1]])
  expect_snapshot(plts_bar[[2]])

  plts_pnt <- nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                               statistic_primary = 'count',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd',
                               geom = 'point')

  expect_snapshot(plts_pnt[[1]])
  expect_snapshot(plts_pnt[[2]])

 }
)
