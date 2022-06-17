


nhanes_shiny <- nhanes_shiny_load()
key <- key_load()

test_inputs <- expand_grid(
 outcome = c('demo_age_years',
             'htn_jnc7',
             'bp_cat_meds_included',
             'bp_med_n_class'),
 exposure = c('none', 'demo_gender', 'cc_smoke'),
 group = c('none', 'demo_race'),
 pool_svy_years = c(TRUE, FALSE)
)

design <- svy_design_new(nhanes_shiny,
                         years = c("2001-2002",
                                   "2003-2004"))

test_output <- test_inputs %>%
 transmute(
  results = pmap(
   .l = list(outcome, exposure, group, pool_svy_years),
   .f = function(.outcome, .exposure, .group, .pool_svy_years){
    svy_design_summarize(
     design = design,
     outcome = .outcome,
     key = key,
     exposure = .exposure,
     group = .group,
     pool_svy_years = .pool_svy_years
    )
   }
  )
 )


