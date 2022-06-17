
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

variable_overlaps <- list(
  "demo_age_cat" = c('demo_age_years'),
  "demo_race" = c(),
  "demo_age_years" = c('demo_age_cat'),
  "demo_pregnant" = c(),
  "demo_gender" = c(),
  "bp_sys_mean" = c(),
  "bp_dia_mean" = c(),
  "bp_cat_meds_excluded" = c(),
  "bp_cat_meds_included" = c(),
  "bp_med_use" = c("htn_jnc7",
                   "htn_accaha",
                   "htn_aware",
                   "htn_resistant_jnc7",
                   "htn_resistant_accaha"),
  "bp_med_recommended_jnc7" = c(),
  "bp_med_recommended_accaha" = c(),
  "bp_med_n_class" = c(),
  "bp_control_jnc7" = c(),
  "bp_control_accaha" = c(),
  "htn_jnc7" = c(),
  "htn_accaha" = c(),
  "htn_aware" = c(),
  "htn_resistant_jnc7" = c(),
  "htn_resistant_accaha" = c(),
  "cc_smoke" = c(),
  "cc_bmi" = c(),
  "cc_diabetes" = c(),
  "cc_ckd" = c(),
  "cc_cvd_mi" = c(),
  "cc_cvd_chd" = c(),
  "cc_cvd_stroke" = c(),
  "cc_cvd_ascvd" = c("cc_cvd_chd",
                     "cc_cvd_stroke"),
  "cc_cvd_hf" = c(),
  "cc_cvd_any" = c("cc_cvd_chd",
                   "cc_cvd_stroke",
                   "cc_cvd_hf")
)

compute_ready <- glue(
 "(input.year.length > 0 &
       input.outcome.length > 0 &
       (input.subset_variable.length == 0 | input.subset_variable == 'None'))
    |
    (input.year.length > 0 &
       input.outcome.length > 0 &
       input.subset_value.length > 0 &
       input.subset_variable.length > 0)"
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
                width = input_width),

   HTML('<br>'), HTML('<br>'),

   prettyCheckboxGroup(
    inputId = "year",
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
   HTML("<br>"),

   pickerInput(
    inputId = "pool",
    label = "Select a pooling strategy",
    choices = c("Pool results across contiguous years" = "pool",
                "Show results for each year" = "stratify",
                "Show results pooled and stratified" = "everything"),
    selected = "stratify",
    multiple = TRUE,
    options = pickerOptions(maxOptions = 1),
    width = input_width
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

   pickerInput(
    inputId = 'subset_variable',
    label = 'Select a subsetting variable',
    choices = variable_choices$subset,
    selected = NULL,
    multiple = TRUE,
    options = pickerOptions(maxOptions = 1),
    width = input_width
   ),

   conditionalPanel(
    condition = 'input.subset_variable.length >= 1',
    prettyCheckboxGroup(
     inputId = 'subset_value',
     label = 'Include these subsets:',
     choices = c(),
     selected = NULL,
     width = input_width
    )
   ),

   pickerInput(
    inputId = 'exposure',
    label = 'Select an exposure',
    choices = variable_choices$exposure,
    selected = NULL,
    multiple = TRUE,
    options = pickerOptions(maxOptions = 1),
    width = input_width
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

   pickerInput(
    inputId = "do",
    label = "How to present results?",
    choices = c("Raw data" = 'data',
                "Tabulate" = 'table',
                "Visualize" = 'plot'),
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
   DTOutput('explore_output')
  )

 )

)

# Server ------------------------------------------------------------------
server = function(input, output, session) {
 # UI updating -------------------------------------------------------------

 observeEvent(input$select_all_years, {
  updatePrettyCheckboxGroup(inputId = 'year',
                            selected = nhanes_cycles)
 })

 observeEvent(input$select_last_5, {

  fifth_or_last <- min(length(nhanes_cycles), 5)

  updatePrettyCheckboxGroup(
   inputId = 'year',
   selected = rev(nhanes_cycles)[seq(fifth_or_last)]
  )
 })

 observeEvent(input$deselect_all_years, {
  updatePrettyCheckboxGroup(inputId = 'year',
                            selected = character(0))
 })

 observeEvent(input$outcome, {

  updatePrettyCheckboxGroup(
   session = session,
   inputId = 'statistic',
   choices = key$svy_calls[[key$variables[[input$outcome]]$type]],
   selected = character(0)
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

  if(!is.null(input$subset_variable)){

   if(input$outcome == input$subset_variable){

    updatePickerInput(
     session = session,
     inputId = 'subset_variable',
     choices = variable_choices$exposure,
     selected = character(0)
    )

    updatePickerInput(
     session = session,
     inputId = 'subset_variable',
     choices = variable_choices$exposure,
     selected = character(0)
    )

    updatePrettyCheckboxGroup(
     inputId = 'subset_value',
     selected = character(0)
    )

   }

  }

 })

 observeEvent(input$subset_variable, {

  updatePrettyCheckboxGroup(
   inputId = 'subset_value',
   choices = levels(nhanes_shiny[[input$subset_variable]]),
   selected = character(0) #subset_value_selected
  )

  if(!is.null(input$outcome)){

   if(input$outcome == input$subset_variable){

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


 })


 # Stat summary ------------------------------------------------------------

 observeEvent(

  input$run, {

   ds <- svy_design_new(nhanes_shiny, years = input$year)


   if(is_used(input$subset_variable))
    ds %<>% svy_design_subset(input$subset_variable,
                              input$subset_values)

   .exposure <- ifelse(
    test = is_used(input$exposure),
    yes = input$exposure,
    no = 'None'
   )

   .group <- ifelse(
    test = is_used(input$group),
    yes = input$group,
    no = 'None'
   )

   smry <- svy_design_summarize(
    design = ds,
    outcome = input$outcome,
    key = key,
    user_calls = input$statistic,
    exposure = .exposure,
    group = .group,
    pool_svy_years = input$pool == 'pool'
   )

   # browser()

   output$explore_output <-
    renderDataTable(

     datatable(
      data = smry,
      options = list(
       lengthMenu = list(c(5,15,20), c('5','15','20')),
       pageLength = 10,
       columnDefs=list(list(className='dt-center',targets="_all"))
      ),
      filter = "top",
      selection = 'multiple',
      style = 'bootstrap',
      class = 'cell-border stripe',
      rownames = FALSE
      # colnames = recode(names(result()), !!!stat_recoder)
     )

    )

  }

 )



}


# Launch ------------------------------------------------------------------

shinyApp(ui = ui, server = server)




