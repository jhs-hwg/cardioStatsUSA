library(shiny)

#' Run the NHANES BP application
#'
#' @param ... currently not used
#'
#' @return runs a shiny application locally
#'
#' @export
#'

# TODO: fix bug with pooled results: 2017-2020 through 2017-2020

app_run <- function(...) {

 # User interface (UI) -----------------------------------------------------

 ui <- fluidPage(

  introjsUI(),

  introBox(
   titlePanel("Cardiometabolic statistics for US adults"),
   data.step = 1,
   data.intro = paste(
    "This application analyzes blood pressure from",
    "1999 through 2020 using data from the National Health and",
    "Nutrition Examination Survey (NHANES). It includes survey",
    "participants who attended their NHANES interview and examination,",
    "who provided information on antihypertensive medication use, and",
    "who had complete data on systolic and diastolic blood pressure."
   )
  ),

  sidebarLayout(

   # Sidebar -----------------------------------------------------------------
   sidebarPanel(

    actionButton(inputId = "help",
                 "Press for instructions",
                 icon = icon("question"),
                 width = "100%"),

    HTML('<br>'), HTML('<br>'),

    introBox(
     conditionalPanel(
      condition = compute_ready(),
      actionButton(
       inputId =  "run",
       label = "Compute results",
       icon = icon("cog"),
       width = "100%",
       style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
      )
     ),

     conditionalPanel(
      condition = paste("!(", compute_ready(), ")", sep = ''),
      actionButton(
       inputId =  "wont_do_computation",
       label = "Compute results",
       icon = icon("cog"),
       width = "100%",
       style = "color: #fff; background-color: #808080; border-color: #2e6da4"
      )
     ),
     data.step = 2,
     data.intro = paste(
      "If this button is blue, all the required inputs have been filled in",
      "and you can generate results by clicking the button. If it is grey,",
      "at least one required input is unspecified. Required inputs are:",
      "(1) How to present results,",
      "(2) Pool results or stratify by cycle,",
      "(3) select cycles to include,",
      "(4) Select an outcome, and",
      "(5) Statistic(s) to compute. Remember that you need to press",
      "this button to make things appear in the main window AND to update",
      "the results that you see in the main window."
     )
    ),

    HTML('<br>'),

    introBox(
     pickerInput(
      inputId = "do",
      label = "How to present results?",
      choices = c(
       "As a dataset" = 'data',
       # "As a table" = 'table',
       "As a figure" = 'figure'
      ),
      choicesOpt = list(
       icon = c(
        "glyphicon-list",
        "glyphicon-tasks",
        "glyphicon-stats"
       )
      ),
      multiple = FALSE,
      selected = 'figure',
      width = "100%"
     ),
     data.step = 3,
     data.intro = paste(
      "You can select whether to generate a table with summary data",
      "or a figure that visualizes the summary data. Both options",
      "give output that can be saved and used outside of the application."
     )
    ),

    conditionalPanel(
     "input.do == 'figure'",
     radioGroupButtons(
      inputId = 'geom',
      label = 'Select a plotting geometry',
      choices = c("Bars" = "bar", "Points" = "scatter"),
      selected = "bar",
      status = "primary",
      width = "100%",
      justified = TRUE,
      checkIcon = list(yes = icon("ok", lib = "glyphicon"))
     )
    ),

    introBox(

     conditionalPanel(
      # if 'count' is not in the selected statistics
      "input.statistic.indexOf('count') == -1",
      awesomeCheckbox(
       inputId = "age_standardize",
       label = "Age-adjustment by standardization?",
       value = FALSE,
       status = "primary"
      )
     ),

     introBox(
      conditionalPanel(
       condition = "input.age_standardize == true",
       h5("Weights for each age group (must be >0)"),

       introBox(
        splitLayout(
         numericInput(inputId="age_wts_1",
                      label="18-44",
                      value = 49.3,
                      min = 5),
         numericInput(inputId="age_wts_2",
                      label="45-64",
                      value = 33.6,
                      min = 5),
         numericInput(inputId="age_wts_3",
                      label="65-74",
                      value = 10.1,
                      min = 5),
         numericInput(inputId="age_wts_4",
                      label="75+",
                      value = 7.0,
                      min = 5),
         cellWidths = "24.25%"
        ),
        data.step = 6,
        data.intro = paste(
         "IMPORTANT: each weight value for each age group should be >0.",
         "If any of them aren't, then the app won't do age standardization.",
         "Do they have to add up to 100? No, but it is more interpretable",
         "if they do."
        )

       )

      ),
      data.step = 5,
      data.intro = paste(
       "Default weights are from doi:10.1001/jama.2020.14545,",
       "with the standard being all adults with hypertension",
       "across 1999 through 2018"
      )
     ),
     data.step = 4,
     data.intro = paste(
      "Adjustment for age with direct standardization can be used",
      "if you want to examine age-adjusted trends over time.",
      "To opt-out of age-adjustment, uncheck the age-adjustment box."
     )
    ),

    introBox(

     pickerInput(
      inputId = "pool",
      label = "Pool results or stratify by cycle?",
      choices = c("Pool results" = "yes",
                  "Stratify by cycle" = "no"),
      selected = "no",
      multiple = TRUE,
      options = pickerOptions(maxOptions = 1),
      width = "100%"
     ),

     data.step = 7,
     data.intro = paste(
      "To look at results over time, select 'stratify by cycle'.",
      "To stack all of the data together and summarize a contiguous",
      "time period of your choice, select 'pool results'"
     )

    ),

    conditionalPanel(
     condition = "input.pool == 'no'",
     prettyCheckboxGroup(
      inputId = "year_stratify",
      label = "Select NHANES cycle(s)",
      inline = TRUE,
      selected = NULL,
      choices = levels(nhanes_bp[[nhanes_key$time_var]]),
      width = "100%"
     ),
     actionGroupButtons(
      inputIds = c('select_all_years',
                   'select_last_5',
                   'deselect_all_years'),
      labels = c("All cycles",
                 "Last 5",
                 "None"),
      status = 'primary',
      fullwidth = TRUE
     ),
     br()
    ),

    conditionalPanel(
     condition = "input.pool == 'yes'",
     sliderTextInput(
      inputId = "year_pool",
      label = "Choose a range of cycles to pool:",
      choices = levels(nhanes_bp[[nhanes_key$time_var]]),
      selected = levels(nhanes_bp[[nhanes_key$time_var]])[c(6, 10)],
      width = "100%"
     )
    ),

    introBox(
     pickerInput("subset_n",
                 "How many exclusions do you want to make?",
                 choices = c("None" = 0,
                             "One" = 1,
                             "Two" = 2,
                             "Three" = 3,
                             "Four" = 4,
                             "Five" = 5),
                 selected = "None",
                 width = "100%"),
     data.step = 9,
     data.intro = paste(
      "You may restrict the analysis to subsets of survey participants using",
      "exclusions. For each exclusion you request (up to 5), an additional",
      "box will appear to select a variable that will define the exclusion.",
      "When you select the variable, possible groups to include will appear."
     )
    ),


    uiOutput("subset_ui"),

    fluidRow(
     introBox(
      h3("Outcome",
         style = "text-align: left; padding-left: 15px"),
      column(
       6,
       style='padding-right: 2px;',
       pickerInput(
        inputId = 'outcome_class',
        label = 'Select outcome type',
        choices = names(nhanes_key$variable_choices$outcome),
        selected = NULL,
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1,
                                liveSearch = TRUE),
        width = '100%'
       )
      ),
      column(
       6,
       style='padding-left: 2px;',
       pickerInput(
        inputId = 'outcome',
        label = 'Select outcome variable',
        choices = character(),
        selected = NULL,
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1,
                                liveSearch = TRUE,
                                noneSelectedText = 'Options depend on type'),
        width = '100%'
       )
      ),
      data.step = 8,
      data.intro = paste(
       "the 'outcome' variable will be summarized in your results.",
       "Once you select an outcome, a set of possible statistics to compute",
       "will appear below this box. Also, if you are creating a figure, you",
       "will be asked to pick a primary statistic to present in your figure."
      )
     )
    ),

    conditionalPanel(
     condition = 'input.outcome.length > 0',
     prettyCheckboxGroup(
      inputId = 'statistic',
      label = glue('Select statistic(s) to compute'),
      choices = character(),
      selected = NULL,
      width = '100%'
     )
    ),

    conditionalPanel(
     "input.outcome.length > 0 & (input.do == 'figure' | input.do == 'table')",
     pickerInput(
      inputId = 'statistic_primary',
      label = 'Select a primary statistic',
      choices = character(),
      multiple = TRUE,
      options = pickerOptions(maxOptions = 1),
      width = "100%"
     )
    ),

    fluidRow(
     introBox(
      h3("Exposure",
         style = "text-align: left; padding-left: 15px"),
      column(
       6,
       style='padding-right: 2px;',
       pickerInput(
        inputId = 'exposure_class',
        label = 'Select exposure type',
        choices = names(nhanes_key$variable_choices$exposure),
        selected = NULL,
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1,
                                liveSearch = TRUE),
        width = '100%'
       )
      ),
      column(
       6,
       style='padding-left: 2px;',
       pickerInput(
        inputId = 'exposure',
        label = 'Select exposure variable',
        choices = character(),
        selected = NULL,
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1,
                                liveSearch = TRUE,
                                noneSelectedText = 'Options depend on type'),
        width = '100%'
       )
      ),
      data.step = 10,
      data.intro = paste(
       "Summarized values of the outcome will be presented among groups",
       "defined by the 'exposure' variable. If you just want to look at",
       "the outcome in the overall US population, don't select an exposure.",
       "If you have already selected something, you can click it again to",
       "deselect it."
      )
     )
    ),

    # introBox(
    #  pickerInput(
    #   inputId = 'exposure',
    #   label = 'Select an exposure',
    #   choices = nhanes_key$variable_choices$exposure,
    #   selected = NULL,
    #   multiple = TRUE,
    #   options = pickerOptions(maxOptions = 1),
    #   width = "100%"
    #  ),
    #  data.step = 10,
    #  data.intro = paste(
    #   "Summarized values of the outcome will be presented among groups",
    #   "defined by the 'exposure' variable. If you just want to look at",
    #   "the outcome in the overall US population, don't select an exposure.",
    #   "If you have already selected something, you can click it again to",
    #   "deselect it."
    #  )
    # ),

    conditionalPanel(
     condition = jsc_write_cpanel(nhanes_key$data, 'ctns', 'exposure'),

     pickerInput(
      inputId = 'n_exposure_group',
      label = 'Select number of groups',
      choices = c("Two" = "2",
                  "Three" = "3",
                  "Four" = "4"),
      selected = character(),
      multiple = TRUE,
      options = pickerOptions(maxOptions = 1),
      width = "100%"
     ),

     radioGroupButtons(
      inputId = "exposure_cut_type",
      label = "How to discretize?",
      choices = c("Equal intervals" = 'interval',
                  "Equal size" = 'frequency'),
      justified = TRUE,
      width = "100%",
      checkIcon = list(
       yes = icon("ok", lib = "glyphicon"))
     )
    ),

    fluidRow(
     introBox(
      h3("Stratify results",
         style = "text-align: left; padding-left: 15px"),
      column(
       6,
       style='padding-right: 2px;',
       pickerInput(
        inputId = 'group_class',
        label = 'Select stratify type',
        choices = names(nhanes_key$variable_choices$group),
        selected = NULL,
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1,
                                liveSearch = TRUE),
        width = '100%'
       )
      ),
      column(
       6,
       style='padding-left: 2px;',
       pickerInput(
        inputId = 'group',
        label = 'Select stratify variable',
        choices = character(),
        selected = NULL,
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1,
                                liveSearch = TRUE,
                                noneSelectedText = 'Options depend on type'),
        width = '100%'
       )
      ),
      data.step = 11,
      data.intro = paste(
       "You may compute results in different populations using the 'stratify'",
       "variable. The difference between the 'stratifying' variable and the",
       "'exposure' variable is that the stratifying variable creates one output",
       "per group, while the exposure variable creates one output that contains",
       "results for each group.",
       "(Some exceptions apply for outcome variables with >2 categories)"
      )
     )
    ),

    # introBox(
    #
    #  pickerInput(
    #   inputId = 'group',
    #   label = 'Select a stratifying variable',
    #   choices = nhanes_key$variable_choices$group,
    #   selected = NULL,
    #   multiple = TRUE,
    #   options = pickerOptions(maxOptions = 1),
    #   width = "100%"
    #  ),
    #
    #  data.step = 11,
    #  data.intro = paste(
    #   "You may compute results in different populations using the 'stratify'",
    #   "variable. The difference between the 'stratifying' variable and the",
    #   "'exposure' variable is that the stratifying variable creates one output",
    #   "per group, while the exposure variable creates one output that contains",
    #   "results for each group.",
    #   "(Some exceptions apply for outcome variables with >2 categories)"
    #  )
    #
    # )

   ),

   # Main panel --------------------------------------------------------------
   mainPanel(
    DTOutput('explore_output'),
    uiOutput("visualize_output")
   )

  )

 )

 # Server ------------------------------------------------------------------
 server <- function(input, output, session) {

  nhanes_cycles <- levels(nhanes_bp[[nhanes_key$time_var]])
  n_exclusion_max <- 5

  # UI updating -------------------------------------------------------------

  observeEvent(input$select_all_years, {
   updatePrettyCheckboxGroup(
    inputId = 'year_stratify',
    selected = nhanes_cycles
   )
  })

  observeEvent(input$select_last_5, {

   fifth_or_last <- min(length(nhanes_cycles), 5)

   updatePrettyCheckboxGroup(
    inputId = 'year_stratify',
    selected = rev(nhanes_cycles)[seq(fifth_or_last)]
   )
  })

  observeEvent(input$deselect_all_years, {
   updatePrettyCheckboxGroup(inputId = 'year_stratify',
                             selected = character(0))
  })

  output$subset_ui <-
   renderUI({

    if(input$subset_n < 1) return(NULL)

    map(
     .x = seq(as.integer(input$subset_n)),
     ~ {

      new_id <- paste('subset_variable', .x, sep = '_')
      new_id_val_catg <- paste('subset_value', .x, 'catg', sep = '_')
      new_id_val_ctns <- paste('subset_value', .x, 'ctns', sep = '_')


      jsc_ctns_subset_variable <- glue(
       "input.{new_id}.length > 0 &
             (input.{new_id} == 'demo_age_years' |
              input.{new_id} == 'bp_sys_mean'    |
              input.{new_id} == 'bp_dia_mean'    )")

      new_value_choices <- input[[new_id]] %||% character()

      if(!is_empty(new_value_choices)){
       new_value_choices <- levels(nhanes_bp[[new_value_choices]])
      }

      new_min <- 0
      new_max <- 0

      if(!is.null(input[[new_id]])){

       if(input[[new_id]] %in% c('demo_age_years',
                                 'bp_sys_mean',
                                 'bp_dia_mean')){

        new_min <- nhanes_key$minimum_values[[ input[[new_id]] ]]
        new_max <- nhanes_key$maximum_values[[ input[[new_id]] ]]

       }

      }

      ..x <- ""

      if(input$subset_n > 1){
       ..x <- switch(.x,
                     '1' = "first ",
                     '2' = "second ",
                     '3' = "third ",
                     '4' = "fourth ",
                     '5' = "fifth ")
      }

      tagList(
       pickerInput(
        inputId = new_id,
        label = paste0("Select the ", ..x,
                      "variable to create your sub-population"),
        choices = nhanes_key$variable_choices$subset,
        selected = isolate(input[[new_id]]) %||% character(),
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1),
        width = "100%"
       ),

       conditionalPanel(
        condition = as.character(
         glue('input.{new_id}.length > 0 & {jsc_ctns_subset_variable}')
        ),
        suppressWarnings(
         sliderInput(
          inputId = new_id_val_ctns,
          label = "Include values between the dots:",
          min = new_min,
          max = new_max,
          value = isolate(input[[new_id_val_ctns]]) %||% c(0, 0),
          ticks = FALSE,
          step = 1,
          width = '100%'
         )
        )
       ),

       conditionalPanel(
        condition = as.character(
         glue('input.{new_id}.length > 0 & !({jsc_ctns_subset_variable})')
        ),
        prettyCheckboxGroup(
         inputId = new_id_val_catg,
         label = 'Include these participants:',
         choices = c(new_value_choices, 'Missing'),
         selected = isolate(input[[new_id_val_catg]]) %||% character(),
         width = "100%"
        )
       )
      )
     }
    )

   })

  observeEvent(input$outcome_class, {

   updatePickerInput(
    session = session,
    inputId = 'outcome',
    choices = nhanes_key$variable_choices$outcome[[input$outcome_class]]
   )

  })

  observeEvent(input$exposure_class, {

   updatePickerInput(
    session = session,
    inputId = 'exposure',
    choices = nhanes_key$variable_choices$exposure[[input$exposure_class]]
   )

  })

  observeEvent(input$group_class, {

   updatePickerInput(
    session = session,
    inputId = 'group',
    choices = nhanes_key$variable_choices$group[[input$group_class]]
   )

  })

  observeEvent(input$outcome, {

   updatePrettyCheckboxGroup(
    session = session,
    inputId = 'statistic',
    choices = nhanes_key$svy_calls[[nhanes_key$variables[[input$outcome]]$type]],
    selected = nhanes_key$svy_calls[[nhanes_key$variables[[input$outcome]]$type]][1]
   )


   if(!is.null(input$exposure)){

    if(input$outcome == input$exposure){

     updatePickerInput(
      session = session,
      inputId = 'exposure',
      choices = nhanes_key$variable_choices$exposure,
      selected = character(0)
     )

    }

   }

   for(i in seq(n_exclusion_max)){

    ss_var <- paste('subset_variable', i, sep = '_')
    ss_val_ctns <- paste('subset_value', i, 'ctns', sep = '_')
    ss_val_catg <- paste('subset_value', i, 'catg', sep = '_')

    if(!is.null(input[[ss_var]])){

     if(input$outcome == input[[ss_var]]){

      updatePickerInput(
       session = session,
       inputId = ss_var,
       choices = nhanes_key$variable_choices$exposure,
       selected = character(0)
      )

      updatePickerInput(
       session = session,
       inputId = ss_var,
       choices = nhanes_key$variable_choices$exposure,
       selected = character(0)
      )

      updatePrettyCheckboxGroup(
       inputId = ss_val_catg,
       selected = character(0)
      )

      updateSliderInput(
       inputId = ss_val_ctns,
       value = c(nhanes_key$minimum_values[[input[[ss_var]]]],
                 nhanes_key$maximum_values[[input[[ss_var]]]])
      )

     }

    }


   }



  })

  observeEvent(input$statistic, {

   updatePickerInput(
    session = session,
    inputId = 'statistic_primary',
    choices = input$statistic,
    selected = input$statistic[1]
   )

   if('count' %in% input$statistic){

    updateAwesomeCheckbox(session = session,
                          inputId = 'age_standardize',
                          value = FALSE)

   }


  })

  map(
   .x = seq(n_exclusion_max),
   .f = ~ {

    ss_var <- paste('subset_variable', .x, sep = '_')
    ss_val_ctns <- paste('subset_value', .x, 'ctns', sep = '_')
    ss_val_catg <- paste('subset_value', .x, 'catg', sep = '_')

    observeEvent(input[[ss_var]], {

     ctns_subset_variable <- input[[ss_var]]  %in% c('demo_age_years',
                                                     'bp_sys_mean',
                                                     'bp_dia_mean')

     if(ctns_subset_variable){

      .min <- nhanes_key$minimum_values[[input[[ss_var]]]]
      .max <- nhanes_key$maximum_values[[input[[ss_var]]]]

      updateSliderInput(inputId = ss_val_ctns,
                        min = .min,
                        max = .max,
                        value = c(.min, .max))

     } else {

      miss_add <- NULL

      if(any(is.na(nhanes_bp[[ input[[ss_var]] ]]))){
       miss_add <- "Missing"
      }

      updatePrettyCheckboxGroup(
       inputId = ss_val_catg,
       choices =
        levels(nhanes_bp[[ input[[ss_var]] ]]) %||%
        sort(unique(na.omit(nhanes_bp[[ input[[ss_var]] ]]))) %>%
        c(miss_add),
       selected = character(0) #subset_value_selected
      )

     }


     if(!is.null(input$outcome)){

      if(input$outcome == input[[ss_var]]){

       updatePickerInput(
        session = session,
        inputId = 'outcome',
        choices = nhanes_key$variable_choices$outcome,
        selected = character(0)
       )

       updatePrettyCheckboxGroup(
        session = session,
        inputId = 'statistic',
        choices = character(0),
        selected = character(0)
       )

      }

     }


    })

   }
  )

  observeEvent(input$exposure, {

   if(!is.null(input$outcome)){

    if(input$outcome == input$exposure){

     updatePickerInput(
      session = session,
      inputId = 'outcome',
      choices = nhanes_key$variable_choices$outcome,
      selected = character(0)
     )

     updatePrettyCheckboxGroup(
      session = session,
      inputId = 'statistic',
      choices = character(0),
      selected = character(0)
     )

    }

   }

   if(!is_continuous(input$exposure)){

    updatePickerInput(
     session = session,
     inputId = "n_exposure_group",
     selected = character(0)
    )

   }


  })

  # Stat summary ------------------------------------------------------------

  years <- reactive({

   if(input$pool == 'yes'){

    year_levels <- levels(nhanes_bp[[nhanes_key$time_var]])
    year_start <- which(year_levels == input$year_pool[1])
    year_end   <- which(year_levels == input$year_pool[2])

    return(year_levels[seq(year_start, year_end)])

   }

   input$year_stratify


  })

  smry <- reactive({

   subset_indices <- c()

   if(input$subset_n > 0){
    # as.integer b/c subset_n is a character value
    subset_indices <- seq(as.integer(input$subset_n))
   }

   for(i in subset_indices){

    ss_var <- paste('subset_variable', i, sep = '_')

    if(is_used(input[[ss_var]])){

     ss_val_ctns <- paste('subset_value', i, 'ctns', sep = '_')
     ss_val_catg <- paste('subset_value', i, 'catg', sep = '_')

     if(is_continuous(input[[ss_var]])){

      # need to create the subsetting variables based on continuous
      # cut-points before creating the design object. Doing this
      # in the reverse order won't work b/c survey doesn't let you
      # modify the design object's data.

      nhanes_bp[[ paste(input[[ss_var]], 'tmp', sep='_') ]] <-
       fifelse(
        nhanes_bp[[input[[ss_var]]]] %between% c(input[[ss_val_ctns]]),
        yes = 'yes',
        no = 'no'
       )

     }

    }


   }

   type_subpop <- nhanes_key$data[variable == input$outcome, subpop]

   # restrict the sample to the relevant sub-population
   colname_subpop <- paste('svy_subpop', type_subpop, sep = '_')

   nhanes_subpop <- nhanes_bp %>%
    .[.[[colname_subpop]] == 1]

   # colname_weight <- paste('svy_weight', type_subpop, sep = '_')

   # if the count of a variable was requested, calibrate the
   # weights so that the sum of observations in the sub-population
   # matches the sum of weights

   subset_calls <- list()

   for(i in subset_indices){

    ss_var <- paste('subset_variable', i, sep = '_')

    if(is_used(input[[ss_var]])){

     ss_val_ctns <- paste('subset_value', i, 'ctns', sep = '_')
     ss_val_catg <- paste('subset_value', i, 'catg', sep = '_')

     if(!is_empty(input[[ss_val_catg]]) | !all(input[[ss_val_ctns]] == 0)){

      subset_calls[[ input[[ss_var]] ]] <- input[[ss_val_catg]]

      if(is_continuous(input[[ss_var]])){

       subset_calls[[ paste(input[[ss_var]], 'tmp', sep='_') ]] <- "yes"

      }

     }

    }

   }

   smry_counts <- smry_no_counts <- NULL

   stats <- input$statistic

   if('count' %in% input$statistic){

    smry_counts <- nhanes_bp %>%
     nhanes_calibrate(nhanes_sub = nhanes_subpop) %>%
     .[, svy_weight := svy_weight_cal] %>%
     svy_design_new(
      exposure = input$exposure,
      n_exposure_group = as.numeric(input$n_exposure_group),
      exposure_cut_type = input$exposure_cut_type,
      years = years(),
      pool = input$pool
     ) %>%
     svy_design_subset(subset_calls) %>%
     svy_design_summarize(
      outcome = input$outcome,
      statistic = 'count',
      exposure = input$exposure,
      group = input$group,
      age_standardize = input$age_standardize,
      age_wts = c(
       input$age_wts_1,
       input$age_wts_2,
       input$age_wts_3,
       input$age_wts_4
      )
     )
   }

   stats_no_count <- setdiff(stats, 'count')

   if(!is_empty(stats_no_count)){

    smry_no_counts <- nhanes_subpop %>%
     .[, svy_weight := svy_weight_mec] %>%
      svy_design_new(
       exposure = input$exposure,
       n_exposure_group = as.numeric(input$n_exposure_group),
       exposure_cut_type = input$exposure_cut_type,
       years = years(),
       pool = input$pool
      ) %>%
      svy_design_subset(subset_calls) %>%
      svy_design_summarize(
       outcome = input$outcome,
       statistic = stats_no_count,
       exposure = input$exposure,
       group = input$group,
       age_standardize = input$age_standardize,
       age_wts = c(
        input$age_wts_1,
        input$age_wts_2,
        input$age_wts_3,
        input$age_wts_4
       )
      )

   }

   bind_smry(smry_counts, smry_no_counts)

  }) %>%
   bindEvent(input$run)

  plots <- reactive({

   if(input$do != 'figure') return(NULL)

   plotly_viz(
    data = smry(),
    statistic_primary = input$statistic_primary,
    geom = input$geom,
    years = years(),
    pool = input$pool
   )

  }) %>%
   bindEvent(smry())

  dt_explore <- reactive({

   if(input$do != 'data') return(NULL)

   smry() %>%
    datatable(
     options = list(
      lengthMenu = list(c(5,15,20), c('5','15','20')),
      pageLength = 10,
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf'),
      columnDefs=list(list(className='dt-center',targets="_all"))
     ),
     extensions = 'Buttons',
     filter = "top",
     selection = 'multiple',
     style = 'bootstrap',
     class = 'cell-border stripe',
     rownames = FALSE,
     colnames = recode(names(smry()), !!!nhanes_key$recoder)
    ) %>%
    formatRound(columns = get_numeric_colnames(smry()), digits=3)
  }) %>%
   bindEvent(smry())



  observeEvent(
   plots(), {
    output$visualize_output <- renderUI(plots())
   }
  )

  observeEvent(
   dt_explore(), {
    output$explore_output <- DT::renderDataTable(dt_explore(), server = FALSE)
   }
  )

  # start introjs when button is pressed with custom options and events
  observeEvent(input$help, introjs(session))

 }

 # Calling shinyapp --------------------------------------------------------

 shinyApp(ui, server, ...)

}
