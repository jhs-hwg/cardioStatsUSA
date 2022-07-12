

library(shiny)


#' Run the NHANES BP application
#'
#' @param ... currently not used
#'
#' @return runs a shiny application locally
#'
#' @export
#'
app_run <- function(...) {

 # User interface (UI) -----------------------------------------------------

 ui <- fluidPage(

  titlePanel("NHANES BP"),

  sidebarLayout(

   # Sidebar -----------------------------------------------------------------
   sidebarPanel(

    actionButton(inputId = "help",
                 "Press for instructions",
                 icon = icon("question"),
                 width = "90%"),

    HTML('<br>'), HTML('<br>'),

    pickerInput(
     inputId = "do",
     label = "How to present results?",
     choices = c(
      "As a dataset" = 'data',
      "As a table" = 'table',
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
     selected = 'data',
     width = "95%"
    ),

    awesomeCheckbox(
     inputId = "age_standardize",
     label = "Age-adjustment by standardization?",
     value = TRUE,
     status = "success"
    ),

    pickerInput(
     inputId = "pool",
     label = "Pool results or stratify by cycle?",
     choices = c("Pool results" = "yes",
                 "Stratify by cycle" = "no"),
     selected = "stratify",
     multiple = TRUE,
     options = pickerOptions(maxOptions = 1),
     width = "95%"
    ),

    conditionalPanel(
     condition = "input.pool == 'no'",
     prettyCheckboxGroup(
      inputId = "year_stratify",
      label = "Select NHANES cycle(s)",
      inline = TRUE,
      selected = NULL,
      choices = levels(nhanes_bp[[nhanes_key$time_var]]),
      width = "95%"
     ),
     actionGroupButtons(
      inputIds = c('select_all_years',
                   'select_last_5',
                   'deselect_all_years'),
      labels = c("All",
                 "Last 5",
                 "None"),
      status = 'info'
     ),
     HTML("<br>"),
     HTML("<br>")
    ),

    conditionalPanel(
     condition = "input.pool == 'yes'",
     sliderTextInput(
      inputId = "year_pool",
      label = "Choose a range of cycles to pool:",
      choices = levels(nhanes_bp[[nhanes_key$time_var]]),
      selected = levels(nhanes_bp[[nhanes_key$time_var]])[c(6, 10)],
      width = "90%"
     )
    ),

    pickerInput(
     inputId = 'outcome',
     label = 'Select an outcome',
     choices = nhanes_key$variable_choices$outcome,
     selected = NULL,
     multiple = TRUE,
     options = pickerOptions(maxOptions = 1, liveSearch = TRUE),
     width = "95%"
    ),


    conditionalPanel(
     condition = 'input.outcome.length > 0',
     prettyCheckboxGroup(
      inputId = 'statistic',
      label = glue('Select statistic(s) to compute'),
      choices = character(),
      selected = NULL,
      width = "95%"
     )
    ),

    conditionalPanel(
     "input.do == 'figure'",
     pickerInput(
      inputId = 'geom',
      label = 'Select a plotting geometry',
      choices = c("Bars" = "bar",
                  "Points" = "scatter"),
      selected = "bar",
      multiple = TRUE,
      options = pickerOptions(maxOptions = 1),
      width = "95%"
     )
    ),

    conditionalPanel(
     "input.outcome.length > 0 &
    (input.do == 'figure' | input.do == 'table')",
    pickerInput(
     inputId = 'statistic_primary',
     label = 'Select a primary statistic',
     choices = character(),
     multiple = TRUE,
     options = pickerOptions(maxOptions = 1),
     width = "95%"
    )
    ),

    pickerInput("subset_n",
                "How many exclusions to make?",
                choices = c("None" = 0,
                            "One" = 1,
                            "Two" = 2,
                            "Three" = 3,
                            "Four" = 4,
                            "Five" = 5),
                selected = "None",
                width = "95%"),

    uiOutput("subset_ui"),

    pickerInput(
     inputId = 'exposure',
     label = 'Select an exposure',
     choices = nhanes_key$variable_choices$exposure,
     selected = NULL,
     multiple = TRUE,
     options = pickerOptions(maxOptions = 1),
     width = "95%"
    ),

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
      width = "95%"
     ),

     radioGroupButtons(
      inputId = "exposure_cut_type",
      label = "How to discretize?",
      choices = c("Equal intervals" = 'interval',
                  "Equal size" = 'frequency'),
      justified = TRUE,
      width = "90%",
      checkIcon = list(
       yes = icon("ok", lib = "glyphicon"))
     )
    ),

    pickerInput(
     inputId = 'group',
     label = 'Select a stratifying variable',
     choices = nhanes_key$variable_choices$group,
     selected = NULL,
     multiple = TRUE,
     options = pickerOptions(maxOptions = 1),
     width = "95%"
    ),

    conditionalPanel(
     condition = compute_ready(),
 actionButton(
  inputId =  "run",
  label = "Compute results",
  icon = icon("cog"),
  width = "90%",
  style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
 )
    ),

 conditionalPanel(
  condition = paste("!(", compute_ready(), ")", sep = ''),
  actionButton(
   inputId =  "wont_do_computation",
   label = "Compute results",
   icon = icon("cog"),
   width = "90%",
   style = "color: #fff; background-color: #808080; border-color: #2e6da4"
  )
 )

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


      tagList(
       pickerInput(
        inputId = new_id,
        label = 'Select a subsetting variable',
        choices = nhanes_key$variable_choices$subset,
        selected = isolate(input[[new_id]]) %||% character(),
        multiple = TRUE,
        options = pickerOptions(maxOptions = 1),
        width = "95%"
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
          width = '90%'
         )
        )
       ),

       conditionalPanel(
        condition = as.character(
         glue('input.{new_id}.length > 0 & !({jsc_ctns_subset_variable})')
        ),
        prettyCheckboxGroup(
         inputId = new_id_val_catg,
         label = 'Include these subsets:',
         choices = new_value_choices,
         selected = isolate(input[[new_id_val_catg]]) %||% character(),
         width = "95%"
        )
       )
      )
     }
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

      updatePrettyCheckboxGroup(
       inputId = ss_val_catg,
       choices =
        levels(nhanes_bp[[ input[[ss_var]] ]]) %||%
        sort(unique(na.omit(nhanes_bp[[ input[[ss_var]] ]]))),
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

   if(!is_continuous(input$exposure, nhanes_key)){

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

     if(is_continuous(input[[ss_var]], key = nhanes_key)){

     # need to create the subsetting variables based on continuous
     # cut-points before creating the design object. Doing this
     # in the reverse order won't work b/c survey doesn't let you
     # modify the design object's data.
     nhanes_bp <- nhanes_bp %>%
      .[,
        y := fifelse(x >= a & x <= b, 'yes', 'no'),
        env = list(
         a = input[[ss_val_ctns]][1],
         b = input[[ss_val_ctns]][2],
         x = input[[ss_var]],
         y = paste(input[[ss_var]], 'tmp', sep='_')
        )
      ]

    }

    }


   }

   ds <- nhanes_bp %>%
    svy_design_new(
     exposure = input$exposure,
     n_exposure_group = as.numeric(input$n_exposure_group),
     exposure_cut_type = input$exposure_cut_type,
     years = years(),
     pool = input$pool
    )

   subset_calls <- list()

   for(i in subset_indices){

    ss_var <- paste('subset_variable', i, sep = '_')

    if(is_used(input[[ss_var]])){

     ss_val_ctns <- paste('subset_value', i, 'ctns', sep = '_')
     ss_val_catg <- paste('subset_value', i, 'catg', sep = '_')

     if(!is_empty(input[[ss_val_catg]]) | !all(input[[ss_val_ctns]] == 0)){

      subset_calls[[ input[[ss_var]] ]] <- input[[ss_val_catg]]

      if(is_continuous(input[[ss_var]], key = nhanes_key)){

       subset_calls[[ paste(input[[ss_var]], 'tmp', sep='_') ]] <- "yes"

      }

     }

    }



   }

   ds %<>% svy_design_subset(subset_calls)

   svy_design_summarize(
    design = ds,
    outcome = input$outcome,
    key = nhanes_key,
    user_calls = input$statistic,
    exposure = input$exposure,
    group = input$group,
    pool_svy_years = input$pool == 'yes',
    age_standardize = input$age_standardize
   )

  }) %>%
   bindEvent(input$run)

  plots <- reactive({

   if(input$do != 'figure') return(NULL)

   outcome_type <- nhanes_key$variables[[input$outcome]]$type

   stat_all <- nhanes_key$svy_calls[[outcome_type]]

   plotly_viz(
    data = smry(),
    key = nhanes_key,
    outcome = input$outcome,
    outcome_type = outcome_type,
    exposure = input$exposure,
    group = input$group,
    stat_all = stat_all,
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
 }

 # Calling shinyapp --------------------------------------------------------

 shinyApp(ui, server, ...)

}
