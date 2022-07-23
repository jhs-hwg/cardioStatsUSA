


nhanes_rename <- function(data){

 # in case this function is called before nhanes_recode()
 names(data) <- tolower(names(data))

 # all variables need to be listed here, even if they aren't renamed.
 # if you want to change this, use the rename function instead of select,
 # but note that rename won't change the column order.
 select(

  data,

  # Survey  -----------------------------------------------------------------
  svy_id         = seqn,
  svy_weight     = newwt,
  svy_weight_mec = wtmec2yr,
  svy_psu        = sdmvpsu,
  svy_strata     = sdmvstra,
  svy_year       = surveyyr,
  svy_subpop     = subpophtn,

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

  bp_med_ace = ace,
  bp_med_aldo = aldo,
  bp_med_alpha = alpha,
  bp_med_angioten = angioten,
  bp_med_beta = beta,
  bp_med_central = central,
  bp_med_ccb = ccb,
  bp_med_diur_Ksparing = diur_ksparing,
  bp_med_diur_loop = diur_loop,
  bp_med_diur_thz = diur_thz,
  bp_med_renin_inhibitors = renin_inhibitors,
  bp_med_vasod = vasod,

  # bp_control, a sub-class of bp variables
  bp_control_jnc7           = jnc7_control,
  bp_control_accaha         = accaha_control,

  dplyr::any_of(c("bp_uncontrolled_jnc7",
                  "bp_uncontrolled_accaha")),

  # Hypertension ------------------------------------------------------------
  htn_jnc7             = jnc7htn,
  htn_accaha           = accahahtn,
  htn_aware,           # no need to rename this one

  # htn_resistant, a sub-class of htn variables
  htn_resistant_jnc7   = rht_jnc7,
  htn_resistant_accaha = rht_accaha,
  htn_resistant_jnc7_thz = rht_jnc7thz,
  htn_resistant_accaha_thz = rht_accahathz,




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
