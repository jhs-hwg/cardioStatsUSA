
# continuous outcome ----

test_that(
 desc = 'one group plot, continuous outcome mean',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean')$fig_object,
                  cran = FALSE)

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   geom = 'point')$fig_object,
                  cran = FALSE)

 }
)

test_that(
 desc = 'one group bar plot, continuous outcome quantile',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   outcome_quantiles = seq(1,10)/10,
                                   statistic_primary = 'quantile')$fig_object,
                  cran = FALSE)
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   outcome_quantiles = seq(1,10)/10,
                                   statistic_primary = 'quantile',
                                   geom = 'point')$fig_object,
                  cran = FALSE)
 }
)

test_that(
 desc = 'multiple group bar plot, continuous outcome mean',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   group_variable = 'demo_gender')$fig_object,
                  cran = FALSE)
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   group_variable = 'demo_gender',
                                   geom = 'point')$fig_object,
                  cran = FALSE)
 }
)

test_that(
 desc = 'multiple group plots, continuous outcome quantile',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   outcome_quantiles = seq(1,10)/10,
                                   statistic_primary = 'quantile',
                                   group_variable = 'demo_gender')$fig_object,
                  cran = FALSE)
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_sys_mean',
                                   outcome_quantiles = seq(1,10)/10,
                                   statistic_primary = 'quantile',
                                   group_variable = 'demo_gender',
                                   geom = 'point')$fig_object,
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
                               stratify_variable = 'cc_ckd')$fig_object

  expect_snapshot(plts_bar[[1]])
  expect_snapshot(plts_bar[[2]])

  plts_pnt <- nhanes_visualize(outcome_variable = 'bp_sys_mean',
                               outcome_quantiles = seq(1,10)/10,
                               statistic_primary = 'quantile',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd',
                               geom = 'point')$fig_object

  expect_snapshot(plts_pnt[[1]])
  expect_snapshot(plts_pnt[[2]])

 }
)

# binary outcome ----

test_that(
 desc = 'one group plot, binary outcome prevalence',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7')$fig_object)

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   geom = 'point')$fig_object)

 }
)

test_that(
 desc = 'one group bar plot, binary outcome count',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   statistic_primary = 'count')$fig_object)

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   statistic_primary = 'count',
                                   geom = 'point')$fig_object)
 }
)

test_that(
 desc = 'multiple group bar plot, binary outcome prevalence',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   group_variable = 'demo_gender')$fig_object)

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   group_variable = 'demo_gender',
                                   geom = 'point')$fig_object)
 }
)

test_that(
 desc = 'multiple group plots, binary outcome count',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   statistic_primary = 'count',
                                   group_variable = 'demo_gender')$fig_object)

  expect_snapshot(nhanes_visualize(outcome_variable = 'htn_jnc7',
                                   statistic_primary = 'count',
                                   group_variable = 'demo_gender',
                                   geom = 'point')$fig_object)
 }
)

test_that(
 desc = 'stratified group plots, binary outcome count',
 code = {

  plts_bar <- nhanes_visualize(outcome_variable = 'htn_jnc7',
                               statistic_primary = 'count',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd')$fig_object

  expect_snapshot(plts_bar[[1]])
  expect_snapshot(plts_bar[[2]])

  plts_pnt <- nhanes_visualize(outcome_variable = 'htn_jnc7',
                               statistic_primary = 'count',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd',
                               geom = 'point')$fig_object

  expect_snapshot(plts_pnt[[1]])
  expect_snapshot(plts_pnt[[2]])

 }
)

# catg outcome ----

test_that(
 desc = 'one group plot, categorical outcome prevalence',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded')$fig_object)

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   geom = 'point')$fig_object)

 }
)

test_that(
 desc = 'one group bar plot, categorical outcome count',
 code = {
  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   statistic_primary = 'count')$fig_object)

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   statistic_primary = 'count',
                                   geom = 'point')$fig_object)
 }
)

test_that(
 desc = 'multiple group bar plot, categorical outcome prevalence',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   group_variable = 'demo_gender')$fig_object)

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   group_variable = 'demo_gender',
                                   geom = 'point')$fig_object)
 }
)

test_that(
 desc = 'multiple group plot, categorical outcome count',
 code = {

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   statistic_primary = 'count',
                                   group_variable = 'demo_gender')$fig_object)

  expect_snapshot(nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                                   statistic_primary = 'count',
                                   group_variable = 'demo_gender',
                                   geom = 'point')$fig_object)
 }
)

test_that(
 desc = 'stratified group plots, categorical outcome count',
 code = {

  plts_bar <- nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                               statistic_primary = 'count',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd')$fig_object

  expect_snapshot(plts_bar[[1]])
  expect_snapshot(plts_bar[[2]])

  plts_pnt <- nhanes_visualize(outcome_variable = 'bp_cat_meds_excluded',
                               statistic_primary = 'count',
                               group_variable = 'demo_gender',
                               stratify_variable = 'cc_ckd',
                               geom = 'point')$fig_object

  expect_snapshot(plts_pnt[[1]])
  expect_snapshot(plts_pnt[[2]])

 }
)
