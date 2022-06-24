#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

variable_choices_load <- function() {

 list(

  "Demographics"  = c(
   "Age, years (categories)" = "demo_age_cat",
   "Race" = "demo_race",
   "Age, years (continuous)" = "demo_age_years",
   "Gender" = "demo_gender",
   "Pregnant" = "demo_pregnant"
  ),

  "Blood pressure" = c(
   "Systolic blood pressure" = "bp_sys_mean",
   "Diastolic blood pressure" = "bp_dia_mean",
   "Blood pressure category (meds excluded)" = "bp_cat_meds_excluded",
   "Blood pressure category (meds included)" = "bp_cat_meds_included",
   "Blood pressure control (JNC7)" = "bp_control_jnc7",
   "Blood pressure control (ACC/AHA)" = "bp_control_accaha"
  ),

  "Antihypertensive medication" = c(
   "Antihypertensive medication use" = "bp_med_use",
   "Antihypertensive medication recommended (JNC7)" = "bp_med_recommended_jnc7",
   "Antihypertensive medication recommended (ACC/AHA)" = "bp_med_recommended_accaha",
   "Number of antihypertensive medication classes" = "bp_med_n_class"
  ),

  "Hypertension" = c(
   "Hypertension (JNC7)" = "htn_jnc7",
   "Hypertension (ACC/AHA)" = "htn_accaha",
   "Hypertension awareness" = "htn_aware",
   "Resistant hypertension (JNC7)" = "htn_resistant_jnc7",
   "Resistant hypertension (ACC/AHA)" = "htn_resistant_accaha"
  ),

  "Comorbidities" = c(
   "Smoking" = "cc_smoke",
   "Body mass index" = "cc_bmi",
   "Diabetes" = "cc_diabetes",
   "Chronic kidney disease" = "cc_ckd",
   "History of myocardial infarction" = "cc_cvd_mi",
   "History of coronary heart disease" = "cc_cvd_chd",
   "History of stroke" = "cc_cvd_stroke",
   "History of ASCVD" = "cc_cvd_ascvd",
   "History of heart failure" = "cc_cvd_hf",
   "History of any CVD" = "cc_cvd_any"
  )

 )

}
