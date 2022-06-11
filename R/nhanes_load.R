

nhanes_recode <- function(){

 data_in <- read_sas('data/small9920.sas7bdat')

 # make all names lower case - don't have to remember which are all capitals.
 names(data_in) <- tolower(names(data_in))

 data_recode <- data_in |>
  mutate(

   # Start re-coding ----
   # Blood pressure ----

   # BP categories according to the 2017 ACC/AHA BP guideline
   # (not accounting for antihypertensive medication use)
   bpcat = factor(
    bpcat,
    levels = 1:5,
    labels = c(
     "SBP < 120 and DBP < 80 mm Hg",
     "SBP of 120 to <130 and DBP < 80 mm Hg",
     "SBP of 130 to <140 or DBP 80 to < 90 mm Hg (and SBP<140 and DBP<90)",
     "SBP of 140 to <160 or DBP 90 to <100 mm Hg (and SBP<100 and DBP<100)",
     "SBP ≥ 160 or DBP ≥ 100 mm Hg"
    )
   ),

   # BP categories according to the 2017 ACC/AHA BP guideline
   # (accounting for antihypertensive medication use)
   bpcatmed = factor(
    bpcatmed,
    levels = 1:6,
    labels = c(
     "SBP < 120 and DBP < 80 mm Hg",
     "SBP of 120 to <130 and DBP < 80 mm Hg",
     "SBP of 130 to <140 or DBP 80 to < 90 mm Hg (and SBP<140 and DBP < 90)",
     "SBP of 140 to <160 or DBP 90 to <100 mm Hg (and SBP<100 and DBP<100)",
     "SBP ≥ 160 or DBP ≥ 100 mm Hg",
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

   across(
    .cols = c(jnc7htn,
              accahahtn,
              htn_aware,
              htmeds,
              jnc7tx,
              newgdltx,
              jnc7_control,
              accaha_control,
              rht_jnc7,
              rht_accaha),
    .fns = ~ factor(.x, levels = c(0,1), labels = c("No", "Yes"))
   ),

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
    labels = c("Women", "Men")
   ),

   # race
   race_wbaho = factor(
    race_wbaho,
    levels = 1:5,
    labels = c(
     "non-Hispanic White",
     "non-Hispanic Black",
     "non-Hispanic Asian",
     "Hispanic ",
     "Other"
    )
   ),

   across(
    .cols = c(pregnant,
              diabetes,
              ckd,
              hxmi,
              hxchd,
              hxstroke,
              hxhf,
              hxascvd,
              hxcvd_hf),
    .fns = ~ factor(.x, levels = c(0, 1), labels = c("No", "Yes"))
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

   # End re-coding ----

  )

}
