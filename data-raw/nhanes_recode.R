

#' recode categories of discrete variables in nhanes
#'
#' instructions are taken from docs/instructions_NHANES.docx
#'
#' @param data if NULL, data are loaded with `nhanes_load`
#'
#' @noRd
nhanes_recode <- function(data = NULL){

 if(is.null(data)) data <- nhanes_load(as = 'tibble')

 # make names lower case - don't want to remember which are caps.
 names(data) <- tolower(names(data))

 # begin recoding ----
 out <- data %>%
  mutate(
   # temporary things for debugging ----
   # newwt = wtmec2yr,
   # Demographics ----

   # Age categories
   agecat4 = factor(
    agecat4,
    levels = 1:4,
    labels = c(
     "18 to 44",
     "45 to 64",
     "65 to 74",
     "75+"
    )
   ),

   # gender
   riagendr = factor(
    riagendr,
    levels = 1:2,
    labels = c("Men", "Women")
   ),

   # race
   race_wbaho = factor(
    race_wbaho,
    levels = 1:5,
    labels = c(
     "Non-Hispanic White",
     "Non-Hispanic Black",
     "Non-Hispanic Asian",
     "Hispanic",
     "Other"
    )
   ),

   race_black = factor(
    if_else(race_wbaho == "Non-Hispanic Black", "Yes", "No"),
    levels = c("No", "Yes")
   ),


   # number of BP medication classes
   num_htn_class = factor(
    num_htn_class,
    levels = 0:7,
    labels = c("None",
               "One",
               "Two",
               "Three",
               "Four or more",
               "Four or more",
               "Four or more",
               "Four or more")
   ),

   # Blood pressure ----

   # BP categories according to the 2017 ACC/AHA BP guideline
   # (not accounting for antihypertensive medication use)
   bpcat = factor(
    bpcat,
    levels = 1:5,
    labels = c(
     "SBP <120 and DBP <80 mm Hg",
     "SBP of 120 to <130 and DBP <80 mm Hg",
     "SBP of 130 to <140 or DBP 80 to <90 mm Hg",
     "SBP of 140 to <160 or DBP 90 to <100 mm Hg",
     "SBP 160+ or DBP 100+ mm Hg"
    )
   ),

   # BP categories according to the 2017 ACC/AHA BP guideline
   # (accounting for antihypertensive medication use)
   bpcatmed = factor(
    bpcatmed,
    levels = 1:6,
    labels = c(
     "SBP <120 and DBP <80 mm Hg",
     "SBP of 120 to <130 and DBP < 80 mm Hg",
     "SBP of 130 to <140 or DBP 80 to <90 mm Hg",
     "SBP of 140 to <160 or DBP 90 to <100 mm Hg",
     "SBP 160+ or DBP 100+ mm Hg",
     "taking antihypertensive medications"
    )
   ),

   # survey year
   surveyyr = factor(
    surveyyr,
    levels = 1:10,
    labels = c(
     "1999-2000",
     "2001-2002",
     "2003-2004",
     "2005-2006",
     "2007-2008",
     "2009-2010",
     "2011-2012",
     "2013-2014",
     "2015-2016",
     "2017-2020"
    )
   ),

   bp_uncontrolled_jnc7 = -1 * (jnc7_control-1),
   bp_uncontrolled_accaha = -1 * (accaha_control-1),

   across(
    .cols = c(jnc7htn,
              accahahtn,
              htn_aware,
              htmeds,
              jnc7tx,
              newgdltx,
              jnc7_control,
              accaha_control,
              control14090,
              control13080,
              bp_uncontrolled_jnc7,
              bp_uncontrolled_accaha,
              uncontrol14090,
              uncontrol13080,
              rht_jnc7,
              rht_accaha,
              rht_accahathz,
              rht_jnc7thz,
              ace,
              aldo,
              alpha,
              angioten,
              beta,
              central,
              ccb,
              diur_ksparing,
              diur_loop,
              diur_thz,
              renin_inhibitors,
              vasod),
    .fns = ~ factor(.x, labels = c("No", "Yes"))
   ),




   # Cholesterol ----


   ldl_5cat = factor(
    ldl_5cat,
    levels = 1:5,
    labels = c(
     "< 70 mg/dL",
     "70 to <100 mg/dL",
     "100 to <130 mg/dL",
     "130 to <190 mg/dL",
     ">= 190 mg/dL" )
   ),

   nonhdl_5cat = factor(
    nonhdl_5cat,
    levels = 1:5,
    labels = c(
     "< 100 mg/dL",
     "100 to <130 mg/dL",
     "130 to <160 mg/dL",
     "160 to <220 mg/dL",
     ">= 220 mg/dL")
   ),


   time_cholmeas = factor(
    time_cholmeas,
    levels = 1:3,
    labels = c(
     "In the past year",
     "1 to 5 years ago",
     ">5 years ago (possibly never)"
    )
   ),

   # highriskcond = factor(
   #  highriskcond,
   #  levels = 0:9,
   #  labels = c(
   #   "0",
   #   "1",
   #   "2",
   #   "3 or more",
   #   "3 or more",
   #   "3 or more",
   #   "3 or more",
   #   "3 or more",
   #   "3 or more",
   #   "3 or more"
   #  )
   # ),

   # 0/1 indicators ----

   # tricky ones...
   across(
    .cols = c(diabetes,
              hxmi,
              hxchd,
              hxstroke,
              hxascvd,
              hxhf,
              hxcvd_hf),
    .fns = ~ if_else(.x == 2, 0, .x)
   ),

   cholmeas_never = factor(
    cholmeas_never,
    levels = c(0, 1),
    labels = c(
     "Cholesterol has been measured previously",
     "Never had cholesterol measured"
    )
   ),

   across(
    .cols = c(pregnant,
              ckd,
              diabetes,
              hxmi,
              hxchd,
              hxstroke,
              hxascvd,
              hxhf,
              hxcvd_hf,
              ldl_lt70,
              ldl_gt70,
              ldl_lt100,
              ldl_gt100,
              ldl_gt190,
              nonh_lt100,
              nonh_gt100,
              nonh_gt220,
              tg150pl,
              lowhdl,
              total_c200pl,
              total_c240pl,
              persistent_ldl,
              vhr,
              combination,
              addontherapy,
              recommended_ill,
              llt_rec_2018,
              toldcholmeds,
              cholmeds_sr,
              cholmeds,
              statin,
              ezetimibe,
              pcsk9i,
              bile,
              fibric_acid,
              atorvastatin,
              simvastatin,
              rosuvastatin,
              pravastatin,
              pitavastatin,
              fluvastatin,
              lovastatin,
              other_chol),
    .fns = ~ factor(.x,
                    levels = c(0, 1),
                    labels = c("No", "Yes"))
   ),

   # Co-morbid conditions ----

   # Smoking
   nfc_smoker = factor(
    nfc_smoker,
    levels = 0:2,
    labels = c(
     "Never",
     "Former",
     "Current"
    )
   ),

   # BMI category, kg/m2
   bmicat = factor(
    bmicat,
    levels = 1:4,
    labels = c(
     "<25",
     "25 to <30",
     "30 to <35",
     "35+"
    )
   )
  )

 # finish recoding ----

 out


}









