
# nocov start

describe_nhanes_data_input <- function(){

 paste(
   "A set of NHANES data with one row per survey",
   "participant and one column per variable."
  )

}

describe_nhanes_key_input <- function(){
 paste("A data set with one row per variable and with columns",
       "that indicate how this variable should be used in the",
       "Shiny application.")
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

document_nhanes_data <- function(classes = c("Survey",
                                             "Demographics",
                                             "Blood pressure",
                                             "Hypertension",
                                             "Antihypertensive medication",
                                             "Comorbidities")){

 data_to_doc <- nhanes_key %>%
  .[class %in% classes] %>%
  .[variable != 'svy_subpop_chol'] %>%
  .[, class := factor(class, levels = classes)] %>%
  .[order(class)] %>%
  .[variable %in% bp_med_classes,
    class := "Antihypertensive medication classes"] %>%
  droplevels()

 data_to_doc$description %<>% stringr::str_replace_all('\u2265', '>=')

 key_classes <- split(data_to_doc, f = data_to_doc$class)

 for(i in seq_along(key_classes)){

  cat("#", names(key_classes)[i], "variables", "\n")

  for(j in seq_along(key_classes[[i]]$variable)){
   cat("##", key_classes[[i]]$variable[j], "\n")
   cat("- Label: ", key_classes[[i]]$label[j], "\n")
   cat("- Description: ", key_classes[[i]]$description[j], "\n\n")
  }
 }
}

# nocov end
