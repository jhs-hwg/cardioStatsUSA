


nhanes_rename <- function(data){

 # in case this function is called before nhanes_recode()
 names(data) <- tolower(names(data))

 # all variables need to be listed here, even if they aren't renamed.
 # if you want to change this, use the rename function instead of select,
 # but note that rename won't change the column order.
 select(

  data,

  # Survey  -----------------------------------------------------------------
  svy_id          = seqn,
  svy_weight      = newwt,
  svy_weight_mec  = wtmec2yr,  # uncalibrated
  svy_weight_af   = wtsaf2yr,  # uncalibrated
  svy_weight_htn  = newwt,     # used for the htn subpop
  svy_weight_chol = newwtldl,  # used for the chol subpop
  svy_psu         = sdmvpsu,
  svy_strata      = sdmvstra,
  svy_year        = surveyyr,
  svy_subpop_htn  = subpophtn,
  svy_subpop_chol = subpopldl,

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

  # Lipids ------------------------------------------------------------------

  chol_measured_never = cholmeas_never,
  chol_measured_last = time_cholmeas,
  chol_total = total_chol,
  chol_total_gteq_200 = total_c200pl,
  chol_total_gteq_240 = total_c240pl,
  chol_hdl = hdl_chol,
  chol_hdl_low = lowhdl,
  chol_trig = triglycerides,
  chol_trig_gteq_150 = tg150pl,
  chol_ldl = ldl_chol,
  chol_ldl_5cat = ldl_5cat,
  chol_ldl_lt_70 = ldl_lt70,
  chol_ldl_gteq_70 = ldl_gt70,
  chol_ldl_lt_100 = ldl_lt100,
  chol_ldl_gteq_100 = ldl_gt100,
  chol_ldl_gteq_190 = ldl_gt190,
  chol_ldl_persistent = persistent_ldl,
  chol_nonhdl = nonhdlc,
  chol_nonhdl_5cat = nonhdl_5cat,
  chol_nonhdl_lt_100 = nonh_lt100,
  chol_nonhdl_gteq_100 = nonh_gt100,
  chol_nonhdl_gteq_220 = nonh_gt220,

  chol_med_use = cholmeds,
  chol_med_use_sr = cholmeds_sr,
  chol_med_statin = statin,
  chol_med_ezetimibe = ezetimibe,
  chol_med_pcsk9i = pcsk9i,
  chol_med_bile = bile,
  chol_med_fibric_acid = fibric_acid,
  chol_med_atorvastatin = atorvastatin,
  chol_med_simvastatin = simvastatin,
  chol_med_rosuvastatin = rosuvastatin,
  chol_med_pravastatin = pravastatin,
  chol_med_pitavastatin = pitavastatin,
  chol_med_fluvastatin = fluvastatin,
  chol_med_lovastatin = lovastatin,
  chol_med_other = other_chol,
  chol_med_addon_use = addontherapy,
  chol_med_addon_recommended_ahaacc = recommended_ill,
  chol_med_statin_recommended_ahaacc = llt_rec_2018,
  chol_med_recommended_ever = toldcholmeds,


  # ASCVD risk --------------------------------------------------------------

  ascvd_risk_vh_ahaacc = vhr,

  # Co-morbid conditions ----------------------------------------------------
  cc_smoke      = nfc_smoker,
  cc_bmi        = bmicat,
  cc_diabetes   = diabetes,
  cc_ckd        = ckd,
  cc_n_highrisk = highriskcond,

  # cc_cvd, a sub-class of cc variables
  cc_cvd_mi       = hxmi,
  cc_cvd_chd      = hxchd,
  cc_cvd_stroke   = hxstroke,
  cc_cvd_ascvd    = hxascvd,
  cc_cvd_hf       = hxhf,
  cc_cvd_any      = hxcvd_hf

 )

}
