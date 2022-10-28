

# variable data -------------------------------------------------------------


nhanes_variables <- data.table::data.table(


 # variable classes --------------------------------------------------------

 class = c(
  "Survey", # svy_id
  "Survey", # svy_psu
  "Survey", # svy_strata
  "Survey", # svy_weight_mec
  "Survey", # svy_weight_cal
  "Survey", # svy_subpop_htn
  "Survey", # svy_year
  "Demographics", # demo_age_cat
  "Demographics", # demo_race
  "Demographics", # demo_age_years
  "Demographics", # demo_pregnant
  "Demographics", # demo_gender
  "Blood pressure", # bp_sys_mean
  "Blood pressure", # bp_dia_mean
  "Blood pressure", # bp_cat_meds_excluded
  "Blood pressure", # bp_cat_meds_included
  "Blood pressure", # bp_control_jnc7
  "Blood pressure", # bp_control_accaha
  "Blood pressure", # bp_uncontrolled_jnc7
  "Blood pressure", # bp_uncontrolled_accaha
  "Antihypertensive medication", # bp_med_use
  "Antihypertensive medication", # bp_med_recommended_jnc7
  "Antihypertensive medication", # bp_med_recommended_accaha
  "Antihypertensive medication", # bp_med_n_class
  "Antihypertensive medication", # bp_med_ace
  "Antihypertensive medication", # bp_med_aldo
  "Antihypertensive medication", # bp_med_alpha
  "Antihypertensive medication", # bp_med_angioten
  "Antihypertensive medication", # bp_med_beta
  "Antihypertensive medication", # bp_med_central
  "Antihypertensive medication", # bp_med_ccb
  "Antihypertensive medication", # bp_med_diur_Ksparing
  "Antihypertensive medication", # bp_med_diur_loop
  "Antihypertensive medication", # bp_med_diur_thz
  "Antihypertensive medication", # bp_med_renin_inhibitors
  "Antihypertensive medication", # bp_med_vasod
  "Hypertension", # htn_jnc7
  "Hypertension", # htn_accaha
  "Hypertension", # htn_aware
  "Hypertension", # htn_resistant_jnc7
  "Hypertension", # htn_resistant_accaha
  "Hypertension", # htn_resistant_accaha_thz
  "Hypertension", # htn_resistant_jnc7_thz
  "Comorbidities", # cc_n_highrisk
  "Comorbidities", # cc_smoke
  "Comorbidities", # cc_bmi
  "Comorbidities", # cc_diabetes
  "Comorbidities", # cc_ckd
  "Comorbidities", # cc_cvd_mi
  "Comorbidities", # cc_cvd_chd
  "Comorbidities", # cc_cvd_stroke
  "Comorbidities", # cc_cvd_ascvd
  "Comorbidities", # cc_cvd_hf
  "Comorbidities", # cc_cvd_any
  "Survey", # svy_subpop_chol
  "Cholesterol", # chol_measured_never
  "Cholesterol", # chol_measured_last
  "Cholesterol", # chol_total
  "Cholesterol", # chol_total_gteq_200
  "Cholesterol", # chol_total_gteq_240
  "Cholesterol", # chol_trig
  "Cholesterol", # chol_trig_gteq_150
  "HDL Cholesterol", # chol_hdl
  "HDL Cholesterol", # chol_hdl_low
  "LDL Cholesterol", # chol_ldl
  "LDL Cholesterol", # chol_ldl_5cat
  "LDL Cholesterol", # chol_ldl_lt_70
  "LDL Cholesterol", # chol_ldl_gteq_70
  "LDL Cholesterol", # chol_ldl_lt_100
  "LDL Cholesterol", # chol_ldl_gteq_100
  "LDL Cholesterol", # chol_ldl_gteq_190
  "LDL Cholesterol", # chol_ldl_persistent
  "Non-HDL Cholesterol", # chol_nonhdl
  "Non-HDL Cholesterol", # chol_nonhdl_5cat
  "Non-HDL Cholesterol", # chol_nonhdl_lt_100
  "Non-HDL Cholesterol", # chol_nonhdl_gteq_100
  "Non-HDL Cholesterol", # chol_nonhdl_gteq_220
  "Cholesterol-lowering medication", # chol_med_use
  "Cholesterol-lowering medication", # chol_med_use_sr
  "Cholesterol-lowering medication", # chol_med_statin
  "Cholesterol-lowering medication", # chol_med_ezetimibe
  "Cholesterol-lowering medication", # chol_med_pcsk9i
  "Cholesterol-lowering medication", # chol_med_bile
  "Cholesterol-lowering medication", # chol_med_fibric_acid
  "Cholesterol-lowering medication", # chol_med_atorvastatin
  "Cholesterol-lowering medication", # chol_med_simvastatin
  "Cholesterol-lowering medication", # chol_med_rosuvastatin
  "Cholesterol-lowering medication", # chol_med_pravastatin
  "Cholesterol-lowering medication", # chol_med_pitavastatin
  "Cholesterol-lowering medication", # chol_med_fluvastatin
  "Cholesterol-lowering medication", # chol_med_lovastatin
  "Cholesterol-lowering medication", # chol_med_other
  "Cholesterol-lowering medication", # chol_med_addon_use
  "Cholesterol-lowering medication", # chol_med_addon_recommended_ahaacc
  "Cholesterol-lowering medication", # chol_med_statin_recommended_ahaacc
  "Cholesterol-lowering medication", # chol_med_recommended_ever
  "Atherosclerotic CVD risk" # ascvd_risk_vh_ahaacc
 ),


 # variable names ----------------------------------------------------------

 variable = c(
  "svy_id",
  "svy_psu",
  "svy_strata",
  "svy_weight_mec",
  "svy_weight_cal",
  "svy_subpop_htn",
  "svy_year",
  "demo_age_cat",
  "demo_race",
  "demo_age_years",
  "demo_pregnant",
  "demo_gender",
  "bp_sys_mean",
  "bp_dia_mean",
  "bp_cat_meds_excluded",
  "bp_cat_meds_included",
  "bp_control_jnc7",
  "bp_control_accaha",
  "bp_uncontrolled_jnc7",
  "bp_uncontrolled_accaha",
  "bp_med_use",
  "bp_med_recommended_jnc7",
  "bp_med_recommended_accaha",
  "bp_med_n_class",
  "bp_med_ace",
  "bp_med_aldo",
  "bp_med_alpha",
  "bp_med_angioten",
  "bp_med_beta",
  "bp_med_central",
  "bp_med_ccb",
  "bp_med_diur_Ksparing",
  "bp_med_diur_loop",
  "bp_med_diur_thz",
  "bp_med_renin_inhibitors",
  "bp_med_vasod",
  "htn_jnc7",
  "htn_accaha",
  "htn_aware",
  "htn_resistant_jnc7",
  "htn_resistant_accaha",
  "htn_resistant_accaha_thz",
  "htn_resistant_jnc7_thz",
  "cc_n_highrisk",
  "cc_smoke",
  "cc_bmi",
  "cc_diabetes",
  "cc_ckd",
  "cc_cvd_mi",
  "cc_cvd_chd",
  "cc_cvd_stroke",
  "cc_cvd_ascvd",
  "cc_cvd_hf",
  "cc_cvd_any",
  "svy_subpop_chol",
  "chol_measured_never",
  "chol_measured_last",
  "chol_total",
  "chol_total_gteq_200",
  "chol_total_gteq_240",
  "chol_trig",
  "chol_trig_gteq_150",
  "chol_hdl",
  "chol_hdl_low",
  "chol_ldl",
  "chol_ldl_5cat",
  "chol_ldl_lt_70",
  "chol_ldl_gteq_70",
  "chol_ldl_lt_100",
  "chol_ldl_gteq_100",
  "chol_ldl_gteq_190",
  "chol_ldl_persistent",
  "chol_nonhdl",
  "chol_nonhdl_5cat",
  "chol_nonhdl_lt_100",
  "chol_nonhdl_gteq_100",
  "chol_nonhdl_gteq_220",
  "chol_med_use",
  "chol_med_use_sr",
  "chol_med_statin",
  "chol_med_ezetimibe",
  "chol_med_pcsk9i",
  "chol_med_bile",
  "chol_med_fibric_acid",
  "chol_med_atorvastatin",
  "chol_med_simvastatin",
  "chol_med_rosuvastatin",
  "chol_med_pravastatin",
  "chol_med_pitavastatin",
  "chol_med_fluvastatin",
  "chol_med_lovastatin",
  "chol_med_other",
  "chol_med_addon_use",
  "chol_med_addon_recommended_ahaacc",
  "chol_med_statin_recommended_ahaacc",
  "chol_med_recommended_ever",
  "ascvd_risk_vh_ahaacc"
 ),

 # variable lables ---------------------------------------------------------

 label = c(
  "participant identifier", # svy_id
  "primary sampling unit", # svy_psu
  "strata", # svy_strata
  "Mobile examination center weights", # svy_weight_mec
  "Calibrated mobile examination center weights", # svy_weight_cal
  "Subpopulation for hypertension", # svy_subpop_htn
  "NHANES cycle", # svy_year
  "Age category, years", # demo_age_cat
  "Race", # demo_race
  "Age, years", # demo_age_years
  "Pregnant", # demo_pregnant
  "Gender", # demo_gender
  "Systolic blood pressure, mm Hg", # bp_sys_mean
  "Diastolic blood pressure, mm Hg", # bp_dia_mean
  "Blood pressure category", # bp_cat_meds_excluded
  "Blood pressure category (including antihypertensive medication use)", # bp_cat_meds_included
  "Blood pressure control (JNC7 guideline)", # bp_control_jnc7
  "Blood pressure control (2017 ACC/AHA BP guideline)", # bp_control_accaha
  "Uncontrolled BP (JNC7 guideline)", # bp_uncontrolled_jnc7
  "Uncontrolled BP (2017 ACC/AHA BP guideline)", # bp_uncontrolled_accaha
  "Self-reported antihypertensive medication use", # bp_med_use
  "Antihypertensive medications recommended (JNC7 guideline)", # bp_med_recommended_jnc7
  "Antihypertensive medications recommended (2017 ACC/AHA BP guideline)", # bp_med_recommended_accaha
  "Number of antihypertensive medication classes", # bp_med_n_class
  "ACE inhibitors", # bp_med_ace
  "Aldosterone antagonists", # bp_med_aldo
  "Alpha-1 blockers", # bp_med_alpha
  "Angiotensin receptor blockers", # bp_med_angioten
  "Beta blockers", # bp_med_beta
  "Central alpha1 agonist and other centrally acting agents", # bp_med_central
  "Calcium channel blockers", # bp_med_ccb
  "Potassium sparing diuretics", # bp_med_diur_Ksparing
  "Loop diuretics", # bp_med_diur_loop
  "Thiazide or thiazide-type diuretics", # bp_med_diur_thz
  "Direct renin inhibitors", # bp_med_renin_inhibitors
  "Direct vasodilators", # bp_med_vasod
  "Hypertension (JNC7 guideline)", # htn_jnc7
  "Hypertension (2017 ACC/AHA BP guideline)", # htn_accaha
  "Awareness of hypertension", # htn_aware
  "Resistant hypertension (JNC7 guideline definition)", # htn_resistant_jnc7
  "Resistant hypertension (2017 ACC/AHA BP guideline)", # htn_resistant_accaha
  "Resistant hypertension (JNC7 guideline, requires thiazide diuretic)", # htn_resistant_accaha_thz
  "Resistant hypertension (2017 ACC/AHA BP guideline, requires thiazide diuretic)", # htn_resistant_jnc7_thz
  "Number of high risk conditions", # cc_n_highrisk
  "Smoking status", # cc_smoke
  "Body mass index, kg/m2", # cc_bmi
  "Prevalent diabetes", # cc_diabetes
  "Prevalent chronic kidney disease", # cc_ckd
  "History of myocardial infarction", # cc_cvd_mi
  "History of coronary heart disease", # cc_cvd_chd
  "History of stroke", # cc_cvd_stroke
  "History of ASCVD", # cc_cvd_ascvd
  "History of heart failure", # cc_cvd_hf
  "History of CVD", # cc_cvd_any
  "Subpopulation for cholesterol", # svy_subpop_chol
  "Cholesterol has never been measured", # chol_measured_never
  "Time since having their cholesterol measured", # chol_measured_last
  "Total cholesterol, mg/dL", # chol_total
  "Total cholesterol \u2265 200 mg/dL", # chol_total_gteq_200
  "Total cholesterol \u2265 240 mg/dL", # chol_total_gteq_240
  "Triglycerides, mg/dL", # chol_trig
  "Triglycerides \u2265 150 mg/dL", # chol_trig_gteq_150
  "HDL cholesterol, mg/dL", # chol_hdl
  "HDL cholesterol <40 mg/dL in women (<50 mg/dL in men)", # chol_hdl_low
  "LDL cholesterol, mg/dL", # chol_ldl
  "LDL cholesterol categories", # chol_ldl_5cat
  "LDL cholesterol < 70 mg/dL", # chol_ldl_lt_70
  "LDL cholesterol \u2265 70 mg/dL", # chol_ldl_gteq_70
  "LDL cholesterol < 100 mg/dL", # chol_ldl_lt_100
  "LDL cholesterol \u2265 100 mg/dL", # chol_ldl_gteq_100
  "LDL cholesterol \u2265 190 mg/dL", # chol_ldl_gteq_190
  "LDL persistently elevated (LDL \u2265 100 mg/dL while taking a statin)", # chol_ldl_persistent
  "Non-HDL cholesterol, mg/dL", # chol_nonhdl
  "Non-HDL cholesterol categories", # chol_nonhdl_5cat
  "Non-HDL cholesterol < 100 mg/dL", # chol_nonhdl_lt_100
  "Non-HDL cholesterol \u2265 100 mg/dL", # chol_nonhdl_gteq_100
  "Non-HDL cholesterol \u2265 220 mg/dL", # chol_nonhdl_gteq_220
  "Taking a cholesterol-lowering medication", # chol_med_use
  "Self-reported cholesterol-lowering medication use", # chol_med_use_sr
  "Taking a statin", # chol_med_statin
  "Taking ezetimibe", # chol_med_ezetimibe
  "Taking a PCSK9 inhibitor", # chol_med_pcsk9i
  "Taking a bile acid sequestrant", # chol_med_bile
  "Taking a fibrate", # chol_med_fibric_acid
  "Taking atorvastatin", # chol_med_atorvastatin
  "Taking simvastatin", # chol_med_simvastatin
  "Taking rosuvastatin", # chol_med_rosuvastatin
  "Taking pravastatin", # chol_med_pravastatin
  "Taking pitavastatin", # chol_med_pitavastatin
  "Taking fluvastatin", # chol_med_fluvastatin
  "Taking lovastatin", # chol_med_lovastatin
  "Taking other cholesterol-lowering medication", # chol_med_other
  "Taking add-on lipid-lowering therapy (ezetimibe or PCSK9 inhibitor)", # chol_med_addon_use
  "Recommended add-on lipid-lowering therapy by the 2018 AHA/ACC guideline", # chol_med_addon_recommended_ahaacc
  "Recommended a statin by the 2018 AHA/ACC guideline", # chol_med_statin_recommended_ahaacc
  "Ever been told to take cholesterol-lowering medication", # chol_med_recommended_ever
  "Very high ASCVD risk according to the 2018 AHA/ACC guideline" # ascvd_risk_vh_ahaacc
 ),

 # variable source (i.e., nhanes form) -------------------------------------

 source = c(
  "DEMO", # svy_id
  "DEMO", # svy_psu
  "DEMO", # svy_strata
  "DEMO", # svy_weight_mec
  "Derived", # svy_weight_cal
  "Derived", # svy_subpop_htn
  "DEMO", # svy_year
  "DEMO", # demo_age_cat
  "DEMO", # demo_race
  "DEMO", # demo_age_years
  "DEMO", # demo_pregnant
  "DEMO", # demo_gender
  "Derived", # bp_sys_mean
  "Derived", # bp_dia_mean
  "Derived", # bp_cat_meds_excluded
  "Derived", # bp_cat_meds_included
  "Derived", # bp_control_jnc7
  "Derived", # bp_control_accaha
  "Derived", # bp_uncontrolled_jnc7
  "Derived", # bp_uncontrolled_accaha
  "BPQ", # bp_med_use
  "Derived", # bp_med_recommended_jnc7
  "Derived", # bp_med_recommended_accaha
  "Derived", # bp_med_n_class
  "RXQ", # bp_med_ace
  "RXQ", # bp_med_aldo
  "RXQ", # bp_med_alpha
  "RXQ", # bp_med_angioten
  "RXQ", # bp_med_beta
  "RXQ", # bp_med_central
  "RXQ", # bp_med_ccb
  "RXQ", # bp_med_diur_Ksparing
  "RXQ", # bp_med_diur_loop
  "RXQ", # bp_med_diur_thz
  "RXQ", # bp_med_renin_inhibitors
  "RXQ", # bp_med_vasod
  "Derived", # htn_jnc7
  "Derived", # htn_accaha
  "BPQ", # htn_aware
  "Derived", # htn_resistant_jnc7
  "Derived", # htn_resistant_accaha
  "Derived", # htn_resistant_accaha_thz
  "Derived", # htn_resistant_jnc7_thz
  "Derived", # cc_n_highrisk
  "SMQ", # cc_smoke
  "WHQ", # cc_bmi
  "DIQ", # cc_diabetes
  "Derived", # cc_ckd
  "MCQ", # cc_cvd_mi
  "MCQ", # cc_cvd_chd
  "MCQ", # cc_cvd_stroke
  "MCQ", # cc_cvd_ascvd
  "MCQ", # cc_cvd_hf
  "MCQ", # cc_cvd_any
  "Derived", # svy_subpop_chol
  "BPQ", # chol_measured_never
  "BPQ", # chol_measured_last
  "TCHOL", # chol_total
  "Derived", # chol_total_gteq_200
  "Derived", # chol_total_gteq_240
  "TRIGLY", # chol_trig
  "Derived", # chol_trig_gteq_150
  "HDL", # chol_hdl
  "Derived", # chol_hdl_low
  "TRIGLY", # chol_ldl
  "Derived", # chol_ldl_5cat
  "Derived", # chol_ldl_lt_70
  "Derived", # chol_ldl_gteq_70
  "Derived", # chol_ldl_lt_100
  "Derived", # chol_ldl_gteq_100
  "Derived", # chol_ldl_gteq_190
  "Derived", # chol_ldl_persistent
  "Derived", # chol_nonhdl
  "Derived", # chol_nonhdl_5cat
  "Derived", # chol_nonhdl_lt_100
  "Derived", # chol_nonhdl_gteq_100
  "Derived", # chol_nonhdl_gteq_220
  "RXQ (???)", # chol_med_use
  "BPQ", # chol_med_use_sr
  "RXQ", # chol_med_statin
  "RXQ", # chol_med_ezetimibe
  "RXQ", # chol_med_pcsk9i
  "RXQ", # chol_med_bile
  "RXQ", # chol_med_fibric_acid
  "RXQ", # chol_med_atorvastatin
  "RXQ", # chol_med_simvastatin
  "RXQ", # chol_med_rosuvastatin
  "RXQ", # chol_med_pravastatin
  "RXQ", # chol_med_pitavastatin
  "RXQ", # chol_med_fluvastatin
  "RXQ", # chol_med_lovastatin
  "RXQ", # chol_med_other
  "RXQ", # chol_med_addon_use
  "Derived", # chol_med_addon_recommended_ahaacc
  "Derived", # chol_med_statin_recommended_ahaacc
  "BPQ", # chol_med_recommended_ever
  "Derived" # ascvd_risk_vh_ahaacc
 ),

 # variable type -----------------------------------------------------------

 type = c(
  "svy", # svy_id
  "svy", # svy_psu
  "svy", # svy_strata
  "svy", # svy_weight_mec
  "svy", # svy_weight_cal
  "svy", # svy_subpop_htn
  "time", # svy_year
  "catg", # demo_age_cat
  "catg", # demo_race
  "ctns", # demo_age_years
  "bnry", # demo_pregnant
  "catg", # demo_gender
  "ctns", # bp_sys_mean
  "ctns", # bp_dia_mean
  "catg", # bp_cat_meds_excluded
  "catg", # bp_cat_meds_included
  "bnry", # bp_control_jnc7
  "bnry", # bp_control_accaha
  "bnry", # bp_uncontrolled_jnc7
  "bnry", # bp_uncontrolled_accaha
  "bnry", # bp_med_use
  "bnry", # bp_med_recommended_jnc7
  "bnry", # bp_med_recommended_accaha
  "catg", # bp_med_n_class
  "bnry", # bp_med_ace
  "bnry", # bp_med_aldo
  "bnry", # bp_med_alpha
  "bnry", # bp_med_angioten
  "bnry", # bp_med_beta
  "bnry", # bp_med_central
  "bnry", # bp_med_ccb
  "bnry", # bp_med_diur_Ksparing
  "bnry", # bp_med_diur_loop
  "bnry", # bp_med_diur_thz
  "bnry", # bp_med_renin_inhibitors
  "bnry", # bp_med_vasod
  "bnry", # htn_jnc7
  "bnry", # htn_accaha
  "bnry", # htn_aware
  "bnry", # htn_resistant_jnc7
  "bnry", # htn_resistant_accaha
  "bnry", # htn_resistant_accaha_thz
  "bnry", # htn_resistant_jnc7_thz
  "catg", # cc_n_highrisk
  "catg", # cc_smoke
  "catg", # cc_bmi
  "bnry", # cc_diabetes
  "bnry", # cc_ckd
  "bnry", # cc_cvd_mi
  "bnry", # cc_cvd_chd
  "bnry", # cc_cvd_stroke
  "bnry", # cc_cvd_ascvd
  "bnry", # cc_cvd_hf
  "bnry", # cc_cvd_any
  "svy", # svy_subpop_chol
  "bnry", # chol_measured_never
  "catg", # chol_measured_last
  "ctns", # chol_total
  "bnry", # chol_total_gteq_200
  "bnry", # chol_total_gteq_240
  "ctns", # chol_trig
  "bnry", # chol_trig_gteq_150
  "ctns", # chol_hdl
  "bnry", # chol_hdl_low
  "ctns", # chol_ldl
  "catg", # chol_ldl_5cat
  "bnry", # chol_ldl_lt_70
  "bnry", # chol_ldl_gteq_70
  "bnry", # chol_ldl_lt_100
  "bnry", # chol_ldl_gteq_100
  "bnry", # chol_ldl_gteq_190
  "bnry", # chol_ldl_persistent
  "ctns", # chol_nonhdl
  "catg", # chol_nonhdl_5cat
  "bnry", # chol_nonhdl_lt_100
  "bnry", # chol_nonhdl_gteq_100
  "bnry", # chol_nonhdl_gteq_220
  "bnry", # chol_med_use
  "bnry", # chol_med_use_sr
  "bnry", # chol_med_statin
  "bnry", # chol_med_ezetimibe
  "bnry", # chol_med_pcsk9i
  "bnry", # chol_med_bile
  "bnry", # chol_med_fibric_acid
  "bnry", # chol_med_atorvastatin
  "bnry", # chol_med_simvastatin
  "bnry", # chol_med_rosuvastatin
  "bnry", # chol_med_pravastatin
  "bnry", # chol_med_pitavastatin
  "bnry", # chol_med_fluvastatin
  "bnry", # chol_med_lovastatin
  "bnry", # chol_med_other
  "bnry", # chol_med_addon_use
  "bnry", # chol_med_addon_recommended_ahaacc
  "bnry", # chol_med_statin_recommended_ahaacc
  "bnry", # chol_med_recommended_ever
  "bnry" # ascvd_risk_vh_ahaacc
 ),

 # is variable an outcome? -------------------------------------------------

 outcome = c(
  FALSE, # svy_id
  FALSE, # svy_psu
  FALSE, # svy_strata
  FALSE, # svy_weight_mec
  FALSE, # svy_weight_cal
  FALSE, # svy_subpop_htn
  FALSE, # svy_year
  TRUE, # demo_age_cat
  TRUE, # demo_race
  TRUE, # demo_age_years
  TRUE, # demo_pregnant
  TRUE, # demo_gender
  TRUE, # bp_sys_mean
  TRUE, # bp_dia_mean
  TRUE, # bp_cat_meds_excluded
  TRUE, # bp_cat_meds_included
  TRUE, # bp_control_jnc7
  TRUE, # bp_control_accaha
  TRUE, # bp_uncontrolled_jnc7
  TRUE, # bp_uncontrolled_accaha
  TRUE, # bp_med_use
  TRUE, # bp_med_recommended_jnc7
  TRUE, # bp_med_recommended_accaha
  TRUE, # bp_med_n_class
  TRUE, # bp_med_ace
  TRUE, # bp_med_aldo
  TRUE, # bp_med_alpha
  TRUE, # bp_med_angioten
  TRUE, # bp_med_beta
  TRUE, # bp_med_central
  TRUE, # bp_med_ccb
  TRUE, # bp_med_diur_Ksparing
  TRUE, # bp_med_diur_loop
  TRUE, # bp_med_diur_thz
  TRUE, # bp_med_renin_inhibitors
  TRUE, # bp_med_vasod
  TRUE, # htn_jnc7
  TRUE, # htn_accaha
  TRUE, # htn_aware
  TRUE, # htn_resistant_jnc7
  TRUE, # htn_resistant_accaha
  TRUE, # htn_resistant_accaha_thz
  TRUE, # htn_resistant_jnc7_thz
  TRUE, # cc_n_highrisk
  TRUE, # cc_smoke
  TRUE, # cc_bmi
  TRUE, # cc_diabetes
  TRUE, # cc_ckd
  TRUE, # cc_cvd_mi
  TRUE, # cc_cvd_chd
  TRUE, # cc_cvd_stroke
  TRUE, # cc_cvd_ascvd
  TRUE, # cc_cvd_hf
  TRUE, # cc_cvd_any
  FALSE, # svy_subpop_chol
  TRUE, # chol_measured_never
  TRUE, # chol_measured_last
  TRUE, # chol_total
  TRUE, # chol_total_gteq_200
  TRUE, # chol_total_gteq_240
  TRUE, # chol_trig
  TRUE, # chol_trig_gteq_150
  TRUE, # chol_hdl
  TRUE, # chol_hdl_low
  TRUE, # chol_ldl
  TRUE, # chol_ldl_5cat
  TRUE, # chol_ldl_lt_70
  TRUE, # chol_ldl_gteq_70
  TRUE, # chol_ldl_lt_100
  TRUE, # chol_ldl_gteq_100
  TRUE, # chol_ldl_gteq_190
  TRUE, # chol_ldl_persistent
  TRUE, # chol_nonhdl
  TRUE, # chol_nonhdl_5cat
  TRUE, # chol_nonhdl_lt_100
  TRUE, # chol_nonhdl_gteq_100
  TRUE, # chol_nonhdl_gteq_220
  TRUE, # chol_med_use
  TRUE, # chol_med_use_sr
  TRUE, # chol_med_statin
  TRUE, # chol_med_ezetimibe
  TRUE, # chol_med_pcsk9i
  TRUE, # chol_med_bile
  TRUE, # chol_med_fibric_acid
  TRUE, # chol_med_atorvastatin
  TRUE, # chol_med_simvastatin
  TRUE, # chol_med_rosuvastatin
  TRUE, # chol_med_pravastatin
  TRUE, # chol_med_pitavastatin
  TRUE, # chol_med_fluvastatin
  TRUE, # chol_med_lovastatin
  TRUE, # chol_med_other
  TRUE, # chol_med_addon_use
  TRUE, # chol_med_addon_recommended_ahaacc
  TRUE, # chol_med_statin_recommended_ahaacc
  TRUE, # chol_med_recommended_ever
  TRUE # ascvd_risk_vh_ahaacc
 ),

 # can variable be used in groups? -----------------------------------------

 group = c(
  FALSE, # svy_id
  FALSE, # svy_psu
  FALSE, # svy_strata
  FALSE, # svy_weight_mec
  FALSE, # svy_weight_cal
  FALSE, # svy_subpop_htn
  FALSE, # svy_year
  TRUE, # demo_age_cat
  TRUE, # demo_race
  TRUE, # demo_age_years
  TRUE, # demo_pregnant
  TRUE, # demo_gender
  TRUE, # bp_sys_mean
  TRUE, # bp_dia_mean
  TRUE, # bp_cat_meds_excluded
  TRUE, # bp_cat_meds_included
  TRUE, # bp_control_jnc7
  TRUE, # bp_control_accaha
  TRUE, # bp_uncontrolled_jnc7
  TRUE, # bp_uncontrolled_accaha
  TRUE, # bp_med_use
  TRUE, # bp_med_recommended_jnc7
  TRUE, # bp_med_recommended_accaha
  TRUE, # bp_med_n_class
  TRUE, # bp_med_ace
  TRUE, # bp_med_aldo
  TRUE, # bp_med_alpha
  TRUE, # bp_med_angioten
  TRUE, # bp_med_beta
  TRUE, # bp_med_central
  TRUE, # bp_med_ccb
  TRUE, # bp_med_diur_Ksparing
  TRUE, # bp_med_diur_loop
  TRUE, # bp_med_diur_thz
  TRUE, # bp_med_renin_inhibitors
  TRUE, # bp_med_vasod
  TRUE, # htn_jnc7
  TRUE, # htn_accaha
  TRUE, # htn_aware
  TRUE, # htn_resistant_jnc7
  TRUE, # htn_resistant_accaha
  TRUE, # htn_resistant_accaha_thz
  TRUE, # htn_resistant_jnc7_thz
  TRUE, # cc_n_highrisk
  TRUE, # cc_smoke
  TRUE, # cc_bmi
  TRUE, # cc_diabetes
  TRUE, # cc_ckd
  TRUE, # cc_cvd_mi
  TRUE, # cc_cvd_chd
  TRUE, # cc_cvd_stroke
  TRUE, # cc_cvd_ascvd
  TRUE, # cc_cvd_hf
  TRUE, # cc_cvd_any
  FALSE, # svy_subpop_chol
  TRUE, # chol_measured_never
  TRUE, # chol_measured_last
  TRUE, # chol_total
  TRUE, # chol_total_gteq_200
  TRUE, # chol_total_gteq_240
  TRUE, # chol_trig
  TRUE, # chol_trig_gteq_150
  TRUE, # chol_hdl
  TRUE, # chol_hdl_low
  TRUE, # chol_ldl
  TRUE, # chol_ldl_5cat
  TRUE, # chol_ldl_lt_70
  TRUE, # chol_ldl_gteq_70
  TRUE, # chol_ldl_lt_100
  TRUE, # chol_ldl_gteq_100
  TRUE, # chol_ldl_gteq_190
  TRUE, # chol_ldl_persistent
  TRUE, # chol_nonhdl
  TRUE, # chol_nonhdl_5cat
  TRUE, # chol_nonhdl_lt_100
  TRUE, # chol_nonhdl_gteq_100
  TRUE, # chol_nonhdl_gteq_220
  TRUE, # chol_med_use
  TRUE, # chol_med_use_sr
  TRUE, # chol_med_statin
  TRUE, # chol_med_ezetimibe
  TRUE, # chol_med_pcsk9i
  TRUE, # chol_med_bile
  TRUE, # chol_med_fibric_acid
  TRUE, # chol_med_atorvastatin
  TRUE, # chol_med_simvastatin
  TRUE, # chol_med_rosuvastatin
  TRUE, # chol_med_pravastatin
  TRUE, # chol_med_pitavastatin
  TRUE, # chol_med_fluvastatin
  TRUE, # chol_med_lovastatin
  TRUE, # chol_med_other
  TRUE, # chol_med_addon_use
  TRUE, # chol_med_addon_recommended_ahaacc
  TRUE, # chol_med_statin_recommended_ahaacc
  TRUE, # chol_med_recommended_ever
  TRUE # ascvd_risk_vh_ahaacc
 ),


 # can variable be used for subsetting? ------------------------------------


 subset = c(
  FALSE, # svy_id
  FALSE, # svy_psu
  FALSE, # svy_strata
  FALSE, # svy_weight_mec
  FALSE, # svy_weight_cal
  FALSE, # svy_subpop_htn
  FALSE, # svy_year
  TRUE, # demo_age_cat
  TRUE, # demo_race
  TRUE, # demo_age_years
  TRUE, # demo_pregnant
  TRUE, # demo_gender
  TRUE, # bp_sys_mean
  TRUE, # bp_dia_mean
  TRUE, # bp_cat_meds_excluded
  TRUE, # bp_cat_meds_included
  TRUE, # bp_control_jnc7
  TRUE, # bp_control_accaha
  TRUE, # bp_uncontrolled_jnc7
  TRUE, # bp_uncontrolled_accaha
  TRUE, # bp_med_use
  TRUE, # bp_med_recommended_jnc7
  TRUE, # bp_med_recommended_accaha
  TRUE, # bp_med_n_class
  TRUE, # bp_med_ace
  TRUE, # bp_med_aldo
  TRUE, # bp_med_alpha
  TRUE, # bp_med_angioten
  TRUE, # bp_med_beta
  TRUE, # bp_med_central
  TRUE, # bp_med_ccb
  TRUE, # bp_med_diur_Ksparing
  TRUE, # bp_med_diur_loop
  TRUE, # bp_med_diur_thz
  TRUE, # bp_med_renin_inhibitors
  TRUE, # bp_med_vasod
  TRUE, # htn_jnc7
  TRUE, # htn_accaha
  TRUE, # htn_aware
  TRUE, # htn_resistant_jnc7
  TRUE, # htn_resistant_accaha
  TRUE, # htn_resistant_accaha_thz
  TRUE, # htn_resistant_jnc7_thz
  TRUE, # cc_n_highrisk
  TRUE, # cc_smoke
  TRUE, # cc_bmi
  TRUE, # cc_diabetes
  TRUE, # cc_ckd
  TRUE, # cc_cvd_mi
  TRUE, # cc_cvd_chd
  TRUE, # cc_cvd_stroke
  TRUE, # cc_cvd_ascvd
  TRUE, # cc_cvd_hf
  TRUE, # cc_cvd_any
  FALSE, # svy_subpop_chol
  TRUE, # chol_measured_never
  TRUE, # chol_measured_last
  TRUE, # chol_total
  TRUE, # chol_total_gteq_200
  TRUE, # chol_total_gteq_240
  TRUE, # chol_trig
  TRUE, # chol_trig_gteq_150
  TRUE, # chol_hdl
  TRUE, # chol_hdl_low
  TRUE, # chol_ldl
  TRUE, # chol_ldl_5cat
  TRUE, # chol_ldl_lt_70
  TRUE, # chol_ldl_gteq_70
  TRUE, # chol_ldl_lt_100
  TRUE, # chol_ldl_gteq_100
  TRUE, # chol_ldl_gteq_190
  TRUE, # chol_ldl_persistent
  TRUE, # chol_nonhdl
  TRUE, # chol_nonhdl_5cat
  TRUE, # chol_nonhdl_lt_100
  TRUE, # chol_nonhdl_gteq_100
  TRUE, # chol_nonhdl_gteq_220
  TRUE, # chol_med_use
  TRUE, # chol_med_use_sr
  TRUE, # chol_med_statin
  TRUE, # chol_med_ezetimibe
  TRUE, # chol_med_pcsk9i
  TRUE, # chol_med_bile
  TRUE, # chol_med_fibric_acid
  TRUE, # chol_med_atorvastatin
  TRUE, # chol_med_simvastatin
  TRUE, # chol_med_rosuvastatin
  TRUE, # chol_med_pravastatin
  TRUE, # chol_med_pitavastatin
  TRUE, # chol_med_fluvastatin
  TRUE, # chol_med_lovastatin
  TRUE, # chol_med_other
  TRUE, # chol_med_addon_use
  TRUE, # chol_med_addon_recommended_ahaacc
  TRUE, # chol_med_statin_recommended_ahaacc
  TRUE, # chol_med_recommended_ever
  TRUE # ascvd_risk_vh_ahaacc
 ),


 # can variable be used for stratifying? -----------------------------------


 stratify = c(
  FALSE, # svy_id
  FALSE, # svy_psu
  FALSE, # svy_strata
  FALSE, # svy_weight_mec
  FALSE, # svy_weight_cal
  FALSE, # svy_subpop_htn
  FALSE, # svy_year
  TRUE, # demo_age_cat
  TRUE, # demo_race
  FALSE, # demo_age_years
  TRUE, # demo_pregnant
  TRUE, # demo_gender
  FALSE, # bp_sys_mean
  FALSE, # bp_dia_mean
  TRUE, # bp_cat_meds_excluded
  TRUE, # bp_cat_meds_included
  TRUE, # bp_control_jnc7
  TRUE, # bp_control_accaha
  TRUE, # bp_uncontrolled_jnc7
  TRUE, # bp_uncontrolled_accaha
  TRUE, # bp_med_use
  TRUE, # bp_med_recommended_jnc7
  TRUE, # bp_med_recommended_accaha
  TRUE, # bp_med_n_class
  TRUE, # bp_med_ace
  TRUE, # bp_med_aldo
  TRUE, # bp_med_alpha
  TRUE, # bp_med_angioten
  TRUE, # bp_med_beta
  TRUE, # bp_med_central
  TRUE, # bp_med_ccb
  TRUE, # bp_med_diur_Ksparing
  TRUE, # bp_med_diur_loop
  TRUE, # bp_med_diur_thz
  TRUE, # bp_med_renin_inhibitors
  TRUE, # bp_med_vasod
  TRUE, # htn_jnc7
  TRUE, # htn_accaha
  TRUE, # htn_aware
  TRUE, # htn_resistant_jnc7
  TRUE, # htn_resistant_accaha
  TRUE, # htn_resistant_accaha_thz
  TRUE, # htn_resistant_jnc7_thz
  TRUE, # cc_n_highrisk
  TRUE, # cc_smoke
  TRUE, # cc_bmi
  TRUE, # cc_diabetes
  TRUE, # cc_ckd
  TRUE, # cc_cvd_mi
  TRUE, # cc_cvd_chd
  TRUE, # cc_cvd_stroke
  TRUE, # cc_cvd_ascvd
  TRUE, # cc_cvd_hf
  TRUE, # cc_cvd_any
  FALSE, # svy_subpop_chol
  TRUE, # chol_measured_never
  TRUE, # chol_measured_last
  FALSE, # chol_total
  TRUE, # chol_total_gteq_200
  TRUE, # chol_total_gteq_240
  TRUE, # chol_trig
  TRUE, # chol_trig_gteq_150
  FALSE, # chol_hdl
  TRUE, # chol_hdl_low
  FALSE, # chol_ldl
  TRUE, # chol_ldl_5cat
  TRUE, # chol_ldl_lt_70
  TRUE, # chol_ldl_gteq_70
  TRUE, # chol_ldl_lt_100
  TRUE, # chol_ldl_gteq_100
  TRUE, # chol_ldl_gteq_190
  TRUE, # chol_ldl_persistent
  FALSE, # chol_nonhdl
  TRUE, # chol_nonhdl_5cat
  TRUE, # chol_nonhdl_lt_100
  TRUE, # chol_nonhdl_gteq_100
  TRUE, # chol_nonhdl_gteq_220
  TRUE, # chol_med_use
  TRUE, # chol_med_use_sr
  TRUE, # chol_med_statin
  TRUE, # chol_med_ezetimibe
  TRUE, # chol_med_pcsk9i
  TRUE, # chol_med_bile
  TRUE, # chol_med_fibric_acid
  TRUE, # chol_med_atorvastatin
  TRUE, # chol_med_simvastatin
  TRUE, # chol_med_rosuvastatin
  TRUE, # chol_med_pravastatin
  TRUE, # chol_med_pitavastatin
  TRUE, # chol_med_fluvastatin
  TRUE, # chol_med_lovastatin
  TRUE, # chol_med_other
  TRUE, # chol_med_addon_use
  TRUE, # chol_med_addon_recommended_ahaacc
  TRUE, # chol_med_statin_recommended_ahaacc
  TRUE, # chol_med_recommended_ever
  TRUE # ascvd_risk_vh_ahaacc
 ),

 # what module does this variable belong to? -------------------------------

 module = c(
  "none", # svy_id
  "none", # svy_psu
  "none", # svy_strata
  "none", # svy_weight_mec
  "none", # svy_weight_cal
  "none", # svy_subpop_htn
  "none", # svy_year
  "htn", # demo_age_cat
  "htn", # demo_race
  "htn", # demo_age_years
  "htn", # demo_pregnant
  "htn", # demo_gender
  "htn", # bp_sys_mean
  "htn", # bp_dia_mean
  "htn", # bp_cat_meds_excluded
  "htn", # bp_cat_meds_included
  "htn", # bp_control_jnc7
  "htn", # bp_control_accaha
  "htn", # bp_uncontrolled_jnc7
  "htn", # bp_uncontrolled_accaha
  "htn", # bp_med_use
  "htn", # bp_med_recommended_jnc7
  "htn", # bp_med_recommended_accaha
  "htn", # bp_med_n_class
  "htn", # bp_med_ace
  "htn", # bp_med_aldo
  "htn", # bp_med_alpha
  "htn", # bp_med_angioten
  "htn", # bp_med_beta
  "htn", # bp_med_central
  "htn", # bp_med_ccb
  "htn", # bp_med_diur_Ksparing
  "htn", # bp_med_diur_loop
  "htn", # bp_med_diur_thz
  "htn", # bp_med_renin_inhibitors
  "htn", # bp_med_vasod
  "htn", # htn_jnc7
  "htn", # htn_accaha
  "htn", # htn_aware
  "htn", # htn_resistant_jnc7
  "htn", # htn_resistant_accaha
  "htn", # htn_resistant_accaha_thz
  "htn", # htn_resistant_jnc7_thz
  "chol", # cc_n_highrisk
  "htn", # cc_smoke
  "htn", # cc_bmi
  "htn", # cc_diabetes
  "htn", # cc_ckd
  "htn", # cc_cvd_mi
  "htn", # cc_cvd_chd
  "htn", # cc_cvd_stroke
  "htn", # cc_cvd_ascvd
  "htn", # cc_cvd_hf
  "htn", # cc_cvd_any
  "none", # svy_subpop_chol
  "chol", # chol_measured_never
  "chol", # chol_measured_last
  "chol", # chol_total
  "chol", # chol_total_gteq_200
  "chol", # chol_total_gteq_240
  "chol", # chol_trig
  "chol", # chol_trig_gteq_150
  "chol", # chol_hdl
  "chol", # chol_hdl_low
  "chol", # chol_ldl
  "chol", # chol_ldl_5cat
  "chol", # chol_ldl_lt_70
  "chol", # chol_ldl_gteq_70
  "chol", # chol_ldl_lt_100
  "chol", # chol_ldl_gteq_100
  "chol", # chol_ldl_gteq_190
  "chol", # chol_ldl_persistent
  "chol", # chol_nonhdl
  "chol", # chol_nonhdl_5cat
  "chol", # chol_nonhdl_lt_100
  "chol", # chol_nonhdl_gteq_100
  "chol", # chol_nonhdl_gteq_220
  "chol", # chol_med_use
  "chol", # chol_med_use_sr
  "chol", # chol_med_statin
  "chol", # chol_med_ezetimibe
  "chol", # chol_med_pcsk9i
  "chol", # chol_med_bile
  "chol", # chol_med_fibric_acid
  "chol", # chol_med_atorvastatin
  "chol", # chol_med_simvastatin
  "chol", # chol_med_rosuvastatin
  "chol", # chol_med_pravastatin
  "chol", # chol_med_pitavastatin
  "chol", # chol_med_fluvastatin
  "chol", # chol_med_lovastatin
  "chol", # chol_med_other
  "chol", # chol_med_addon_use
  "chol", # chol_med_addon_recommended_ahaacc
  "chol", # chol_med_statin_recommended_ahaacc
  "chol", # chol_med_recommended_ever
  "chol" # ascvd_risk_vh_ahaacc
 )
)


# variable descriptions ---------------------------------------------------

variable_description <- tibble::tribble(
 ~variable, ~description,
 "svy_id", "NHANES participant unique identifier.",
 "svy_psu", "Population sampling unit. This variable is used to account for the non-random selection of study participants for NHANES",
 "svy_strata", "Population stratification. This variable is used to account for the non-random selection of study participants for NHANES",
 "svy_weight_mec", "Weight applied to produce statistical estimates for the non-institutionalized US population. This weight is used for calculating means and proportions.",
 "svy_weight_cal", "Weight applied to produce statistical estimates for the non-institutionalized US population. This weight is used for estimating population counts and is recalibrated to account for participants excluded from this analysis due to missing data on systolic blood pressure, diastolic blood pressure or self-reported antihypertensive medication use.",
 "svy_subpop_htn", "This indicates that the person has data needed to be included in the analysis of blood pressure or hypertension data (i.e., they had at least one systolic and diastolic blood pressure measurement and they had information on self-reported antihypertensive medication use).",
 "svy_year", "NHANES survey cycle: 1999-2000, 2001-2002, 2003-2004, 2005-2006, 2007-2008, 2009-2010, 2011-2012, 2013-2014, 2015-2016, 2017-2020",
 "demo_age_cat", "Age grouping: 18-44, 45-64, 65-74, \u2265 75 years",
 "demo_race", "Self-reported race/ethnicity. From 1999-2000 through 2009-2010 this was available as non-Hispanic White, non-Hispanic Black, Hispanic and other. From 2011-2012 through 2017-2020 this was available as non-Hispanic White, non-Hispanic Black, non-Hispanic Asian, Hispanic and other.",
 "demo_age_years", "Participant age in years.  Participants > 80 years of age are given an age of 80 years.",
 "demo_pregnant", "Pregnancy status. This is defined by either self-report of being pregnant or a positive pregnancy test conducted during the study visit.",
 "demo_gender", "Self-reported gender",
 "bp_sys_mean", "Mean systolic blood pressure in mm Hg. This is based on the average of up to 3 readings.  Overall, >95% of participants with at least one systolic blood pressure reading had three readings.  From 1999-2000 through 2015-2016, systolic blood pressure was measured using a mercury sphygmomanometer.  In 2017-2020, systolic blood pressure was measured using an oscillometric device.  The systolic blood pressure in 2017-2020 was calibrated to the mercury device by adding 1.5 mm Hg to the mean measured value.",
 "bp_dia_mean", "Mean diastolic blood pressure in mm Hg. This is based on the average of up to 3 readings.  Overall, >95% of participants with at least one diastolic blood pressure reading had three readings.  From 1999-2000 through 2015-2016, diastolic blood pressure was measured using a mercury sphygmomanometer.  In 2017-2020, diastolic blood pressure was measured using an oscillometric device.  The diastolic blood pressure in 2017-2020 was calibrated to the mercury device by subtracting 1.0 mm Hg to the mean measured value.",
 "bp_cat_meds_excluded", "Systolic/diastolic blood pressure <120/80, 120-129/<80, 130-139/80-89, 140-159/90-99, \u2265 160/100. Participants were placed in the category associated with higher blood pressure (e.g., someone with systolic blood pressure of 150 mm Hg and diastolic blood pressure of 76 mm Hg was placed in the \u2265 140/90 mm Hg category)",
 "bp_cat_meds_included", "Systolic/diastolic blood pressure <120/80, 120-129/<80, 130-139/80-89, 140-159/90-99, \u2265 160/100. Participants taking antihypertensive medication were placed in a separate category.  Participants were placed in the category associated with higher blood pressure (e.g., someone with systolic blood pressure of 150 mm Hg and diastolic blood pressure of 76 mm Hg was placed in the \u2265 140/90 mm Hg category)",
 "bp_control_jnc7", "Systolic and diastolic blood pressure controlled to the levels recommended in the JNC7 guideline, systolic blood pressure < 140 mm Hg and diastolic blood pressure < 90 mm Hg.",
 "bp_control_accaha", "Systolic and diastolic blood pressure controlled to the levels recommended in the 2017 ACC/AHA BP guideline, systolic blood pressure < 130 mm Hg and diastolic blood pressure < 80 mm Hg except for those \u2265 65 years of age without diabetes, chronic kidney disease, history of cardiovascular disease or 10-year predicted ASCVD risk \u2265 10% estimated using the Pooled Cohort risk equations. For this group, blood pressure control was defined as systolic blood pressure < 130 mm Hg",
 "bp_uncontrolled_jnc7", "Systolic blood pressure \u2265 140 mm Hg or diastolic blood pressure \u2265 90 mm Hg",
 "bp_uncontrolled_accaha", "Systolic blood pressure \u2265 130 mm Hg or diastolic blood pressure \u2265 80 mm Hg except for individuals without diabetes, chronic kidney disease, history of cardiovascular disease or 10-year predicted ASCVD risk \u2265 10% estimated using the Pooled Cohort risk equations. For this group, uncontrolled blood pressure was defined as systolic blood pressure \u2265 130 mm Hg",
 "bp_med_use", "Self-reported use of antihypertensive medication",
 "bp_med_recommended_jnc7", "Systolic blood pressure \u2265 140 mm Hg or diastolic blood pressure \u2265 90 mm Hg; Systolic blood pressure \u2265 130 mm Hg or diastolic blood pressure \u2265 80 mm Hg for those with chronic kidney disease or diabetes. Those taking antihypertensive medications were considered to be recommended treatment by this definition.",
 "bp_med_recommended_accaha", "Systolic blood pressure \u2265 140 mm Hg or diastolic blood pressure \u2265 90 mm Hg; Systolic blood pressure \u2265 130 mm Hg or diastolic blood pressure \u2265 80 mm Hg for those with chronic kidney disease, diabetes, 10-year predicted atherosclerotic cardiovascular disease risk by the pooled cohort risk equations or age \u2265 65 years. Those taking antihypertensive medications were considered to be recommended treatment by this definition.",
 "bp_med_n_class", "Number of antihypertensive medication classes being taken based on the pill bottle review",
 "bp_med_ace", "Taking an angiotensin converting enzyme inhibitor, defined using the pill bottle review. Drugs in this class included bnazepril, captopril, enalapril, fosinopril, lisonopril, moexipril, perindopril, quinapril, ramipril, trandolapril",
 "bp_med_aldo", "Taking an aldosterone antagonist, defined using the pill bottle review. Drugs in this class included eplerenone, spironolactone.",
 "bp_med_alpha", "Taking an alpha blocker, defined using the pill bottle review. Drugs in this class included doxazosin, prazosin, terazosin.",
 "bp_med_angioten", "Taking an angiotensin receptor blocker, defined using the pill bottle review. Drugs in this class included candesartan, eprosartan, irbesartan, losartan, olmesartan, telmisartan, valsartan, azilsartan.",
 "bp_med_beta", "Taking a beta blocker. Drugs in this class included acebutolol, atenolol, betaxolol, bisoprolol, carvedilol, labetalol, metoprolol, nadolol, nebivolol, pindolol, propranolol.",
 "bp_med_central", "Taking a centrally acting agents, defined using the pill bottle review. Drugs in this class included clonidine, guanabenz, guanfaacine, methyldopa, reserpine.",
 "bp_med_ccb", "Taking a calcium channel blocker, defined using the pill bottle review. Drugs in this class included amlodipine, diltiazem, felodipine, isradipine, nicardipine, nifedipine, nisoldipine, verapamil.",
 "bp_med_diur_Ksparing", "Taking a potassium-sparing diuretic, defined using the pill bottle review. Drugs in this class included amiloride, triamterene.",
 "bp_med_diur_loop", "Taking a loop diuretic, defined using the pill bottle review. Drugs in this class included bumetanide, furosemide, torsemide, ethacrynic acid.",
 "bp_med_diur_thz", "Taking a thiazide diuretic, defined using the pill bottle review. Drugs in this class included bendroflumethiazide, chlorthalidone, chlorothiazide, hydrochlorothiazide, indapamide, metolazone, polythiazide.",
 "bp_med_renin_inhibitors", "Taking a renin inhibitor, defined using the pill bottle review. Drugs in this class included aliskiren.",
 "bp_med_vasod", "Taking a vasodilator, defined using the pill bottle review. Drugs in this class included hydralazine, minoxidil.",
 "htn_jnc7", "Hypertension defined by the JNC7 guideline, systolic blood pressure \u2265 140 mm Hg, diastolic blood pressure \u2265 90 mm Hg or self-reported antihypertensive medication use.",
 "htn_accaha", "Hypertension defined by the 2017 ACC/AHA blood pressure guideline, systolic blood pressure \u2265 130 mm Hg, diastolic blood pressure \u2265 80 mm Hg or self-reported antihypertensive medication use.",
 "htn_aware", "Self-report of a prior diagnosis of antihypertensive medication.",
 "htn_resistant_jnc7", "Taking 4 or more classes of antihypertensive medication, systolic blood pressure \u2265 140 mm Hg or diastolic blood pressure \u2265 90 mm Hg with the use of 3 classes of antihypertensive medication, or systolic blood pressure \u2265 130 mm Hg or diastolic blood pressure \u2265 80 mm Hg with the use of 3 classes of antihypertensive medication for those with diabetes or chronic kidney disease.",
 "htn_resistant_accaha", "Taking 4 or more classes of antihypertensive medication, systolic blood pressure \u2265 140 mm Hg or diastolic blood pressure \u2265 90 mm Hg with the use of 3 classes of antihypertensive medication, or systolic blood pressure \u2265 130 mm Hg or diastolic blood pressure \u2265 80 mm Hg with the use of 3 classes of antihypertensive medication for those <65 years of age and those \u2265 65 years of age with diabetes, chronic kidney disease or high cardiovascular risk defined by a history of cardiovascular disease or 10-year predicted risk \u2265 10% using the pooled cohort risk equations.",
 "htn_resistant_jnc7_thz", "Taking 4 or more classes of antihypertensive medication, systolic blood pressure \u2265 140 mm Hg or diastolic blood pressure \u2265 90 mm Hg with the use of 3 classes of antihypertensive medication, or systolic blood pressure \u2265 130 mm Hg or diastolic blood pressure \u2265 80 mm Hg with the use of 3 classes of antihypertensive medication for those with diabetes or chronic kidney disease.  To meet this definition of resistant hypertension, the participant had to be taking a thiazide diuretic.",
 "htn_resistant_accaha_thz", "Taking 4 or more classes of antihypertensive medication, systolic blood pressure \u2265 140 mm Hg or diastolic blood pressure \u2265 90 mm Hg with the use of 3 classes of antihypertensive medication, or systolic blood pressure \u2265 130 mm Hg or diastolic blood pressure \u2265 80 mm Hg with the use of 3 classes of antihypertensive medication for those < 65 years of age and those \u2265 65 years of age with diabetes, chronic kidney disease or high cardiovascular risk defined by a history of cardiovascular disease or 10-year predicted risk \u2265 10% using the pooled cohort risk equations.  To meet this definition of resistant hypertension, the participant had to be taking a thiazide diuretic.",
 "cc_n_highrisk", "Self-reported history of coronary heart disease, myocardial infarction, stroke or heart failure or 10-year predicted risk \u2265 10% estimated by the pooled cohort risk equations",
 "cc_smoke", "Self-reported current cigarette smoking",
 "cc_bmi", "Body mass index in kg/m2, estimated using the height and weight measured during the study examination.",
 "cc_diabetes", "HbA1c \u2265 6.5% or self-report of a prior diagnosis of diabetes with use of insulin or oral glucose-lowering medications.",
 "cc_ckd", "Estimated glomerular filtration rate < 60 ml/min/1.73 m2 or albumin-to-creatinine > 30 mg/g. Estimated glomerular filtration rate was calculated using the 2021 serum creatinine-based equation.",
 "cc_cvd_mi", "Self-reported history of myocardial infarction",
 "cc_cvd_chd", "Self-reported history of myocardial infarction or coronary heart disease",
 "cc_cvd_stroke", "Self-reported history of stroke",
 "cc_cvd_ascvd", "Self-reported history of coronary heart disease, myocardial infarction or stroke",
 "cc_cvd_hf", "Self-reported history of heart failure",
 "cc_cvd_any", "Self-reported history of coronary heart disease, myocardial infarction, stroke or heart failure"
)


nhanes_key <- dplyr::left_join(nhanes_variables, variable_description)

usethis::use_data(nhanes_key, overwrite = TRUE)


# older code --------------------------------------------------------------

# key_data <- fread(file.path(here(), 'data-raw', 'nhanes_key.csv'))
#
# key_variables <- key_data %>%
#  as_inline(tbl_variables = 'variable',
#            tbl_values = setdiff(names(key_data), 'variable'))
#
# key_recoder <- key_data %>%
#  select(variable, label) %>%
#  deframe() %>%
#  c("svy_year" = "NHANES cycle",
#    "std_error" = "Standard error",
#    "ci_lower" = "Lower 95% CI",
#    "ci_upper" = "Upper 95% CI")
#
# key_minimum_value <- nhanes_data %>%
#  select(all_of(key_data$variable[key_data$type == 'ctns'])) %>%
#  map(min, na.rm = TRUE) %>%
#  map(floor) %>%
#  map(as.integer)
#
# key_maximum_value <- nhanes_data %>%
#  select(all_of(key_data$variable[key_data$type == 'ctns'])) %>%
#  map(max, na.rm = TRUE) %>%
#  map(ceiling) %>%
#  map(as.integer)
#
# key_svy_funs <-
#  data.table(
#   name = c('mean',
#            'quantile',
#            'count',
#            'percentage'),
#   svy_stat_fun = list('svy_stat_mean',
#                       'svy_stat_quantile',
#                       'svy_stat_count',
#                       'svy_stat_percentage'),
#   svy_statby_fun = list('svy_statby_mean',
#                         'svy_statby_quantile',
#                         'svy_statby_count',
#                         'svy_statby_percentage')
#  ) %>%
#  split(by = 'name') %>%
#  map(unlist)
#
# key_svy_calls <- list(
#  'ctns' = c(Mean = 'mean',
#             Quantiles = 'quantile'),
#  'catg' = c(Percentage = 'percentage',
#             Count = 'count'),
#  'bnry' = c(Percentage = 'percentage',
#             Count = 'count'),
#  'intg' = c(Percentage = 'percentage',
#             Count = 'count')
# )
#
# key_variable_choices <- map(
#  .x = list(
#   outcome = key_data[outcome == TRUE, .(class, label, variable)],
#   exposure = key_data[exposure == TRUE, .(class, label, variable)],
#   subset = key_data[subset == TRUE, .(class, label, variable)],
#   group = key_data[group == TRUE, .(class, label, variable)]
#  ),
#  .f = ~ .x %>%
#   split(by = 'class', keep.by = FALSE) %>%
#   map(deframe)
# )
#
#
# nhanes_key <- list(
#  data = key_data,
#  variables = key_variables,
#  variable_choices = key_variable_choices,
#  minimum_values = key_minimum_value,
#  maximum_values = key_maximum_value,
#  recoder = key_recoder,
#  svy_funs = key_svy_funs,
#  svy_calls = key_svy_calls,
#  time_var = key_data[type == 'time', variable]
# )


