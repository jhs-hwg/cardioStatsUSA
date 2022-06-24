
library(shiny)
library(shinyWidgets)

suppressPackageStartupMessages(
 source(file.path(here::here(), 'packages.R'))
)

r_files <- list.files(file.path(here(), 'R'),
                      pattern = '\\.R$',
                      full.names = TRUE)

for(f in r_files) source(f)

rspec <- round_spec() %>%
 round_using_magnitude(digits = c(2, 1, 0), breaks = c(10, 100, Inf))

names(rspec) <- paste('table.glue.', names(rspec), sep = '')

options(rspec)

nhanes_shiny <- nhanes_shiny_load()
key <- key_load()
nhanes_cycles <- levels(nhanes_shiny[[key$time_var]])

n_exclusion_max <- 5

variable_choices <- map(
 .x = list(
  outcome = key$data[outcome == TRUE, .(class, label, variable)],
  exposure = key$data[exposure == TRUE, .(class, label, variable)],
  subset = key$data[subset == TRUE, .(class, label, variable)],
  group = key$data[group == TRUE, .(class, label, variable)]
 ),
 .f = ~ .x %>%
  split(by = 'class', keep.by = FALSE) %>%
  map(deframe)
)

input_width <- "95%"

compute_ready <- glue(
 "(
   (input.pool == 'no' & input.year_stratify.length > 0) |
   input.pool == 'yes'
 ) & (
   input.outcome.length > 0
 ) & (
   input.statistic.length > 0
 ) "
)


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
    width = input_width
   ),

   pickerInput(
    inputId = "pool",
    label = "Pool results or stratify by cycle?",
    choices = c("Pool results" = "yes",
                "Stratify by cycle" = "no"),
    selected = "stratify",
    multiple = TRUE,
    options = pickerOptions(maxOptions = 1),
    width = input_width
   ),

   conditionalPanel(
    condition = "input.pool == 'no'",
    prettyCheckboxGroup(
     inputId = "year_stratify",
     label = "Select NHANES cycle(s)",
     inline = TRUE,
     selected = NULL,
     choices = nhanes_cycles,
     width = input_width
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
     choices = nhanes_cycles,
     selected = nhanes_cycles[c(6, 10)],
     width = "90%"
    )
   ),

   pickerInput(
    inputId = 'outcome',
    label = 'Select an outcome',
    choices = variable_choices$outcome,
    selected = NULL,
    multiple = TRUE,
    options = pickerOptions(maxOptions = 1),
    width = input_width
   ),


   conditionalPanel(
    condition = 'input.outcome.length > 0',
    prettyCheckboxGroup(
     inputId = 'statistic',
     label = glue('Select statistic(s) to compute'),
     choices = character(),
     selected = NULL,
     width = input_width
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
     width = input_width
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
     width = input_width
    )
   ),

   pickerInput("subset_n",
               "How many exclusions to make?",
               choices = 1:5,
               selected = 1,
               width = input_width),

   uiOutput("subset_ui"),

   pickerInput(
    inputId = 'exposure',
    label = 'Select an exposure',
    choices = variable_choices$exposure,
    selected = NULL,
    multiple = TRUE,
    options = pickerOptions(maxOptions = 1),
    width = input_width
   ),

   conditionalPanel(
    condition = jsc_write_cpanel(key$data, 'ctns', 'exposure'),

    pickerInput(
     inputId = 'n_exposure_group',
     label = 'Select number of groups',
     choices = c("Two" = "2",
                 "Three" = "3",
                 "Four" = "4"),
     selected = character(),
     multiple = TRUE,
     options = pickerOptions(maxOptions = 1),
     width = input_width
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
    choices = variable_choices$group,
    selected = NULL,
    multiple = TRUE,
    options = pickerOptions(maxOptions = 1),
    width = input_width
   ),

   conditionalPanel(
    condition = compute_ready,
    actionButton(
     inputId =  "run",
     label = "Compute results",
     icon = icon("cog"),
     width = "90%",
     style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
    )
   ),

   conditionalPanel(
    condition = paste("!(", compute_ready, ")", sep = ''),
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
server = function(input, output, session) {
 # UI updating -------------------------------------------------------------

 observeEvent(input$select_all_years, {
  updatePrettyCheckboxGroup(inputId = 'year_stratify',
                            selected = nhanes_cycles)
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
    new_id_value <- paste('subset_value', .x, sep = '_')

    new_value_choices <- input[[new_id]] %||% character()

    if(!is_empty(new_value_choices)){
     new_value_choices <- levels(nhanes_shiny[[new_value_choices]])
    }

    tagList(
     pickerInput(
      inputId = new_id,
      label = 'Select a subsetting variable',
      choices = variable_choices$subset,
      selected = isolate(input[[new_id]]) %||% character(),
      multiple = TRUE,
      options = pickerOptions(maxOptions = 1),
      width = input_width
     ),

     conditionalPanel(
      condition = as.character(
       glue('input.{new_id}.length > 0')
      ),
      prettyCheckboxGroup(
       inputId = new_id_value,
       label = 'Include these subsets:',
       choices = new_value_choices,
       selected = isolate(input[[new_id_value]]) %||% character(),
       width = input_width
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
   choices = key$svy_calls[[key$variables[[input$outcome]]$type]],
   selected = key$svy_calls[[key$variables[[input$outcome]]$type]][1]
  )


  if(!is.null(input$exposure)){

   if(input$outcome == input$exposure){

    updatePickerInput(
     session = session,
     inputId = 'exposure',
     choices = variable_choices$exposure,
     selected = character(0)
    )

   }

  }

  for(i in seq(n_exclusion_max)){

   ss_var <- paste('subset_variable', i, sep = '_')
   ss_val <- paste('subset_value', i, sep = '_')

   if(!is.null(input[[ss_var]])){

    if(input$outcome == input[[ss_var]]){

     updatePickerInput(
      session = session,
      inputId = ss_var,
      choices = variable_choices$exposure,
      selected = character(0)
     )

     updatePickerInput(
      session = session,
      inputId = ss_var,
      choices = variable_choices$exposure,
      selected = character(0)
     )

     updatePrettyCheckboxGroup(
      inputId = ss_val,
      selected = character(0)
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
   ss_val <- paste('subset_value', .x, sep = '_')

   observeEvent(input[[ss_var]], {

    updatePrettyCheckboxGroup(
     inputId = ss_val,
     choices = levels(nhanes_shiny[[ input[[ss_var]] ]]),
     selected = character(0) #subset_value_selected
    )

    if(!is.null(input$outcome)){

     if(input$outcome == input[[ss_var]]){

      updatePickerInput(
       session = session,
       inputId = 'outcome',
       choices = variable_choices$outcome,
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
     choices = variable_choices$outcome,
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

  if(!is_continuous(input$exposure, key)){

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

   year_levels <- levels(nhanes_shiny[[key$time_var]])
   year_start <- which(year_levels == input$year_pool[1])
   year_end   <- which(year_levels == input$year_pool[2])

   return(year_levels[seq(year_start, year_end)])

  }

  input$year_stratify


 })

 smry <- reactive({

  ds <- nhanes_shiny %>%
   svy_design_new(
    exposure = input$exposure,
    n_exposure_group = as.numeric(input$n_exposure_group),
    exposure_cut_type = input$exposure_cut_type,
    years = years()
   )

  for(i in seq(n_exclusion_max)){

   ss_var <- paste('subset_variable', i, sep = '_')
   ss_val <- paste('subset_value', i, sep = '_')

   if(is_used(input[[ss_var]]) && !is_empty(input[[ss_val]])){

    ds %<>% svy_design_subset(input[[ss_var]], input[[ss_val]])

   }

  }



  svy_design_summarize(
   design = ds,
   outcome = input$outcome,
   key = key,
   user_calls = input$statistic,
   exposure = input$exposure,
   group = input$group,
   pool_svy_years = input$pool == 'yes'
  )

 }) %>%
  bindEvent(input$run)

 plots <- reactive({

  if(input$do != 'figure') return(NULL)

  outcome_type <- key$variables[[input$outcome]]$type

  stat_all <- key$svy_calls[[outcome_type]]

  plotly_viz(
   data = smry(),
   key = key,
   outcome = input$outcome,
   exposure = input$exposure,
   group = input$group,
   stat_all = stat_all,
   statistic_primary = input$statistic_primary,
   geom = input$geom,
   years = years(),
   pool = input$pool,
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
    colnames = recode(names(smry()), !!!key$recoder)
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
   output$explore_output <- renderDataTable(dt_explore(), server = FALSE)
  }
 )





}


# Launch ------------------------------------------------------------------

shinyApp(ui = ui, server = server)










