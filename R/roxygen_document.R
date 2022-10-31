
# nocov start

describe_weights <- function(standard_weights, age_lvls=NULL){

 if(is.null(age_lvls))
  age_lvls <- levels(cardioStatsUSA::nhanes_data$demo_age_cat)

 .standard_weights <- standard_weights %>%
  paste0("%") %>%
  glue::glue_collapse(sep = ', ', last = ', and ')

 .age_lvls <- glue::glue_collapse(age_lvls, sep = ', ', last = ', and ')

 glue::glue("{.standard_weights} being {.age_lvls} years of age, respectively")

}

describe_module_sample <- function(type = 'htn'){
 switch(
  type,
  "htn" = "There were 107,622 NHANES 1999-2000 to 2017-March 2020 participants. We restricted the the dataset to adults >=18 years of age. This exclusion was applied because statistics for BP levels and hypertension in children and adolescents are markedly different than for adults. We further restricted the population to participants who completed the in-home interview and study examination, with one or more SBP and DBP measurement, and who had data on self-reported antihypertensive medication use."
 )
}

tabulate_module_sample <- function(type = 'htn',
                                   subset_calls = NULL,
                                   subset_labs = NULL){

 kable_data <- switch(
  type,
  "htn" = data.frame(
   check.names = FALSE,
   Inclusion = c(
    "Participants",
    ">=18 years old",
    "Completed interview and examination",
    "Had SBP and DBP measurements",
    "Had self-reported information on antihypertensive medication"
   ),
    Overall = c(107622, 63041, 59799, 56286, 56035),
   `1999-2000` = c(9965, 5448, 4976, 4755, 4694),
   `2001-2002` = c(11039, 5993, 5592, 5251, 5184),
   `2003-2004` = c(10122, 5620, 5303, 4902, 4838),
   `2005-2006` = c(10348, 5563, 5334, 5028, 5015),
   `2007-2008` = c(10149, 6228, 5995, 5670, 5665),
   `2009-2010` = c(10537, 6527, 6360, 6053, 6043),
   `2011-2012` = c(9756, 5864, 5615, 5436, 5337),
   `2013-2014` = c(10175, 6113, 5924, 5700, 5694),
   `2015-2016` = c(9971, 5992, 5735, 5557, 5552),
   `2017-2020` = c(15560, 9693, 8965, 8024, 8013)
  )
 )

 if(!is.null(subset_calls)){

  nhanes <- switch(
   type,
   'htn' = nhanes_data[svy_subpop_htn == 1],
   'chol' = nhanes_data[svy_subpop_chol == 1]
  )

  for(i in seq_along(subset_calls)){

   col <- names(subset_calls)[i]
   val <- subset_calls[[i]]

   nhanes %<>% .[.[[col]] %in% val]

   kable_data_new <- c(
    Inclusion = subset_labs[i],
    Overall = nrow(nhanes),
    table(nhanes$svy_year)
   )

   kable_data <- rbindlist(
    list(
     kable_data,
     as.data.table(as.list(kable_data_new))
    )
   )

  }

 }


 knitr::kable(kable_data)


}

describe_nhanes_data_input <- function(){

 paste(
   "A set of NHANES data with one row per survey",
   "participant and one column per variable.",
   "See [nhanes_data] for more details"
  )

}

describe_nhanes_key_input <- function(){
 paste("A data set with one row per variable and with columns",
       "that describe the variable. See [nhanes_key] for more details")
}

describe_nhanes_program <- function() {
 "The NHANES program was initiated in the early 1960s and beginning in 1999 has been conducted continuously, in two-year cycles. The protocols for each cycle were approved by the NCHS Institutional Review Board. Written informed consent was obtained from each participant."
}

describe_nhanes_data <- function(){
 "NHANES data include in-home interviews and study examinations conducted at mobile examination centers. The interview included questions about demographics, health behaviors, prior diagnoses, medication use, and medical history. During the interview, the labels of medications that participants reported taking in the preceding 30 days were recorded. During the study examination, height and weight were measured, blood samples were used to measure cholesterol, glycated hemoglobin and serum creatinine, and a spot urine sample was used to measure albumin and creatinine and to conduct a pregnancy test."
}

describe_nhanes_app <- function(){
 "This application allows you to analyze NHANES data interactively. You can select NHANES cycles from 1999-2000 to 2017-2020 to be analyzed. Contiguous cycles can be combined to increase precision. Estimates are weighted to represent the non-institutionalized US population and you may incorporate age-adjustment through direct standardization to account for the changing age of the US population. Count estimates are calibrated to match the estimated total number of US adults. You can visualize summaries of outcomes for the overall population and in subgroups defined by stratifying variables. All figures and datasets you create can be saved. Following CDC recommendations, unreliable statistical estimates are automatically suppressed."
}

document_nhanes_design <- function(){
 "an NHANES design object. See [nhanes_design] for more details."
}

document_outcome_stat_options <- function(){

 stats <- c('ctns', 'intg', 'catg', 'bnry') %>%
  purrr::set_names() %>%
  purrr::map(get_outcome_stats)

 glue::glue(
  "For continuous outcomes, valid options include
  - '{stats$ctns['Mean']}': estimates the mean value of the outcome
  - '{stats$ctns['Quantiles']}': estimates 25th, 50th, and 75th percentile of the outcome.

  For categorical outcomes, valid options include
  - '{stats$bnry['Percentage']}': estimates the prevalence of the outcome
  - '{stats$bnry['Percentage (Korn and Graubard CI)']}': estimates the prevalence and uses Korn and Graubard's method to estimate a 95% confidence interval
  - '{stats$bnry['Count']}': estimates the number of US adults with the outcome.
  "
 )

}

# nocov end
