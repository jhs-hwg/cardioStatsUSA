

# variable renaming: NEW NAME = ORIGINAL NAME
nhanes_rename <- function(data){

 # in case this function is called before nhanes_recode()
 names(data) <- tolower(names(data))

 # all variables need to be listed here, even if they aren't renamed.
 # if you want to change this, use the rename function instead of select,
 # but note that rename won't change the column order.
 select(

  data,

  # Survey  -----------------------------------------------------------------
  svy_id     = seqn,
  svy_weight = newwt,
  svy_psu    = sdmvpsu,
  svy_strata = sdmvstra,
  svy_year   = surveyyr,

  # Demographics ------------------------------------------------------------
  demo_age_cat   = agecat4,
  demo_race      = race_wbaho,
  demo_age_years = ridageyr,
  demo_pregnant  = pregnant,
  demo_gender    = riagendr,

  # Blood pressure ----------------------------------------------------------
  bp_sys_mean               = avgsbp,
  bp_dia_mean               = avgdbp,
  bp_cat_meds_excluded      = bpcat,
  bp_cat_meds_included      = bpcatmed,

  # bp_med, a sub-class of bp variables
  bp_med_use                = htmeds,
  bp_med_recommended_jnc7   = jnc7tx,
  bp_med_recommended_accaha = newgdltx,
  bp_med_n_class            = num_htn_class,

  # bp_control, a sub-class of bp variables
  bp_control_jnc7           = jnc7_control,
  bp_control_accaha         = accaha_control,

  # Hypertension ------------------------------------------------------------
  htn_jnc7             = jnc7htn,
  htn_accaha           = accahahtn,
  htn_aware,           # no need to rename this one

  # htn_resistant, a sub-class of htn variables
  htn_resistant_jnc7   = rht_jnc7,
  htn_resistant_accaha = rht_accaha,

  # Co-morbid conditions ----------------------------------------------------
  cc_smoke    = nfc_smoker,
  cc_bmi      = bmicat,
  cc_diabetes = diabetes,
  cc_ckd      = ckd,

  # cc_cvd, a sub-class of cc variables
  cc_cvd_mi       = hxmi,
  cc_cvd_chd      = hxchd,
  cc_cvd_stroke   = hxstroke,
  cc_cvd_ascvd    = hxascvd,
  cc_cvd_hf       = hxhf,
  cc_cvd_any      = hxcvd_hf

 )

}
