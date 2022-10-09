library(shiny)

#' Run the NHANES BP application
#'
#' @param ... currently not used
#'
#' @return runs a shiny application locally
#'
#' @export
#'

# TODO: drop lipids, fix pool, and drop grps with few obs

app_run <- function(nhanes_data = cardioStatsUSA::nhanes_data,
                    nhanes_key = cardioStatsUSA::nhanes_key) {

 time_variable <- nhanes_key$variable[nhanes_key$type == 'time']
 time_values <- levels(nhanes_data[[time_variable]])

 variable_choices <- list(
  outcome  = nhanes_key[outcome  == TRUE, .(class, label, variable)],
  group    = nhanes_key[group    == TRUE, .(class, label, variable)],
  subset   = nhanes_key[subset   == TRUE, .(class, label, variable)],
  stratify = nhanes_key[stratify == TRUE, .(class, label, variable)]
 ) %>%
  purrr::map(
  .f = ~ .x %>%
   split(by = 'class', keep.by = FALSE) %>%
   purrr::map(deframe)
 )

 ctns_variables <- nhanes_key[type == 'ctns', variable]

 boundaries <- ctns_variables %>%
  purrr::set_names(ctns_variables) %>%
  purrr::map(
   ~ nhanes_data[[.x]] %>%
    range(na.rm = TRUE) %>%
    as.list() %>%
    purrr::set_names(nm = c('min', 'max'))
  )

 ctns_group_variables <- ctns_variables %>%
  intersect(unlist(variable_choices$group))

 ctns_subset_variables <- ctns_variables %>%
  intersect(unlist(variable_choices$subset))

 # User interface (UI) -----------------------------------------------------

 ui <- fluidPage(

  introjsUI(),

  introBox(
   titlePanel("Cardiometabolic statistics for US adults"),
   data.step = 1,
   data.intro = paste(
    "This application analyzes data from the",
    "National Health and Nutrition Examination Survey (NHANES)."
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
      label = 'Select figure type',
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
      choices = time_values,
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
      choices = time_values,
      selected = c(time_values[1], last(time_values)),
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
        choices = names(variable_choices$outcome),
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
      h3("Group",
         style = "text-align: left; padding-left: 15px"),
      column(
       6,
       style='padding-right: 2px;',
       pickerInput(
        inputId = 'group_class',
        label = 'Select group type',
        choices = names(variable_choices$group),
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
        label = 'Select group variable',
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
       "defined by the 'group' variable. If you just want to look at",
       "the outcome in the overall US population, don't select a group",
       "If you have already selected something, you can click it again to",
       "deselect it."
      )
     )
    ),

    conditionalPanel(
     condition = jsc_write_cpanel(nhanes_key, 'ctns', 'group'),

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
        inputId = 'stratify_class',
        label = 'Select stratify type',
        choices = names(variable_choices$stratify),
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
        inputId = 'stratify',
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
       "'group' variable is that the stratifying variable creates one output",
       "per group, while the 'group' variable creates one output that contains",
       "results for each group.",
       "(Some exceptions apply for outcome variables with >2 categories)"
      )
     )
    ),
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

  n_exclusion_max <- 5

  # UI updating -------------------------------------------------------------

  observeEvent(input$select_all_years, {
   updatePrettyCheckboxGroup(
    inputId = 'year_stratify',
    selected = time_values
   )
  })

  observeEvent(input$select_last_5, {

   fifth_or_last <- min(length(time_values), 5)

   updatePrettyCheckboxGroup(
    inputId = 'year_stratify',
    selected = rev(time_values)[seq(fifth_or_last)]
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

      ss_var_is_ctns<-
       jsc_write_subset_ctns(new_id, ctns_subset_variables)

      new_value_choices <- input[[new_id]] %||% character()

      if(!is_empty(new_value_choices)){
       new_value_choices <- levels(nhanes_data[[new_value_choices]])
      }

      new_min <- 0
      new_max <- 0

      if(!is.null(input[[new_id]])){

       if(input[[new_id]] %in% ctns_subset_variables){

        new_min <- boundaries[[input[[new_id]]]]$min
        new_max <- boundaries[[input[[new_id]]]]$max

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
        choices = variable_choices$subset,
        selected = isolate(input[[new_id]]) %||% character(),
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1),
        width = "100%"
       ),

       conditionalPanel(
        condition = as.character(
         glue('input.{new_id}.length > 0 & {ss_var_is_ctns}')
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
         glue('input.{new_id}.length > 0 & !({ss_var_is_ctns})')
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
    choices = variable_choices$outcome[[input$outcome_class]]
   )

  })

  observeEvent(input$group_class, {

   updatePickerInput(
    session = session,
    inputId = 'group',
    choices = variable_choices$group[[input$group_class]]
   )

  })

  observeEvent(input$stratify_class, {

   updatePickerInput(
    session = session,
    inputId = 'stratify',
    choices = variable_choices$stratify[[input$stratify_class]]
   )

  })

  observeEvent(input$outcome, {

   outcome_type <- nhanes_key[variable==input$outcome, type]
   outcome_stats <- get_outcome_stats(outcome_type)

   updatePrettyCheckboxGroup(
    session = session,
    inputId = 'statistic',
    choices = outcome_stats,
    selected = outcome_stats[1]
   )

   if(!is.null(input$group)){

    if(input$outcome == input$group){

     updatePickerInput(
      session = session,
      inputId = 'group',
      choices = nhanes_key$variable_choices$group,
      selected = character(0)
     )

    }

   }

   for(i in seq(n_exclusion_max)){

    ss_var <- paste('subset_variable', i, sep = '_')
    ss_val_ctns <- paste('subset_value', i, 'ctns', sep = '_')
    ss_val_catg <- paste('subset_value', i, 'catg', sep = '_')

    # I don't think this is necessary anymore
    # if(!is.null(input[[ss_var]])){
    #
    #  if(input$outcome == input[[ss_var]]){
    #
    #   updatePickerInput(
    #    session = session,
    #    inputId = ss_var,
    #    choices = nhanes_key$variable_choices$group,
    #    selected = character(0)
    #   )
    #
    #   updatePickerInput(
    #    session = session,
    #    inputId = ss_var,
    #    choices = nhanes_key$variable_choices$group,
    #    selected = character(0)
    #   )
    #
    #   updatePrettyCheckboxGroup(
    #    inputId = ss_val_catg,
    #    selected = character(0)
    #   )
    #
    #   updateSliderInput(
    #    inputId = ss_val_ctns,
    #    value = c(0,0)
    #    # TODO: fix
    #    # value = c(min(nhanes_data[[input[[ss_var]]]], na.rm = TRUE),
    #    #           max(nhanes_data[[input[[ss_var]]]], na.rm = TRUE))
    #   )
    #
    #  }
    #
    # }


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

     if(input[[ss_var]]  %in% ctns_subset_variables){

      .min <- boundaries[[input[[ss_var]]]]$min
      .max <- boundaries[[input[[ss_var]]]]$max

      updateSliderInput(inputId = ss_val_ctns,
                        min = .min,
                        max = .max,
                        value = c(.min, .max))

     } else {

      miss_add <- "Missing"

      updatePrettyCheckboxGroup(
       inputId = ss_val_catg,
       choices =
        levels(nhanes_data[[ input[[ss_var]] ]]) %||%
        sort(unique(na.omit(nhanes_data[[ input[[ss_var]] ]]))) %>%
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

  observeEvent(input$group, {

   if(!is.null(input$outcome)){

    if(input$outcome == input$group){

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

   # continuous group variable
   if(input$group %in% ctns_variables){

    updatePickerInput(
     session = session,
     inputId = "n_exposure_group",
     selected = character(0)
    )

   }


  })

  # Stat summary ------------------------------------------------------------

  smry <- reactive({

   pool <- input$pool == 'yes'

   age_wts <- NULL

   if(input$age_standardize){
    age_wts <- c(input$age_wts_1,
                 input$age_wts_2,
                 input$age_wts_3,
                 input$age_wts_4)
   }

   outcome_variable  <- input_infer(input$outcome,  default = NULL)
   group_variable    <- input_infer(input$group,    default = NULL)
   stratify_variable <- input_infer(input$stratify, default = NULL)

   time_values_selected <- if(pool){

     time_start <- which(time_values == input$year_pool[1])
     time_end   <- which(time_values == input$year_pool[2])

     time_values[seq(time_start, time_end)]

   } else {

    input$year_stratify

   }

   subset_indices <- c()
   subset_calls <- list()

   if(input$subset_n > 0){
    # as.integer b/c subset_n is a character value
    subset_indices <- seq(as.integer(input$subset_n))
   }

   for(i in subset_indices){

    ss_var <- paste('subset_variable', i, sep = '_')

    if(is_used(input[[ss_var]])){

     ss_type <- get_variable_type(nhanes_key, input[[ss_var]])

     # the inputs defined in the UI only allow ctns or catg
     if(ss_type %in% c('bnry', 'intg')) ss_type <- 'catg'

     ss_val <- paste('subset_value', i, ss_type, sep = '_')

     if(ss_type == 'ctns'){

      if(!all(input[[ss_val]] == 0)){
       subset_calls[[ input[[ss_var]] ]] <- input[[ss_val]]
      }

     }

     if(ss_type == 'catg'){

      if (!is_empty(input[[ss_val]])){
       subset_calls[[ input[[ss_var]] ]] <- input[[ss_val]]
      }

     }

    }

   }

   smry <- try(
    expr = nhanes_data %>%
     nhanes_summarize(
      key = nhanes_key,
      outcome_variable = outcome_variable,
      outcome_quantiles = c(0.25, 0.50, 0.75),
      outcome_stats = input$statistic,
      group_variable = group_variable,
      group_cut_n = input$n_exposure_group,
      group_cut_type = input$exposure_cut_type,
      stratify_variable = stratify_variable,
      time_variable = time_variable,
      time_values = time_values_selected,
      pool = pool,
      subset_calls = subset_calls,
      age_wts = age_wts,
      simplify_output = FALSE
     ),
    silent = TRUE
   )

   if(is_nhanes_design(smry)){

    return(smry)

   } else {

    shinyalert::shinyalert(title = "Error",
                           text = gsub(pattern = 'Error : ',
                                       replacement = '',
                                       x = smry[1],
                                       fixed = TRUE),
                           type = "error")

   }



  }) %>%
   bindEvent(input$run)

  plots <- reactive({

   if(input$do != 'figure') return(NULL)
   if(!is_nhanes_design(smry())) return(NULL)

   smry() %>%
    nhanes_design_viz(
    statistic_primary = input$statistic_primary,
    geom = input$geom
   )

  }) %>%
   bindEvent(smry())

  dt_explore <- reactive({

   if(input$do != 'data') return(NULL)
   if(!is_nhanes_design(smry())) return(NULL)

   results <- smry()$results

   colnames <- names(results)

   for(i in seq_along(colnames)){

    label_index <- match(colnames[i], nhanes_key$variable)

    if(!is.na(label_index)){
     colnames[i] <- nhanes_key$label[label_index]
    }
   }

   results %>%
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
     colnames = colnames
    ) %>%
    formatRound(columns = get_numeric_colnames(results), digits = 2)
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

 shinyApp(ui, server)

}
