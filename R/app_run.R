
# nocov start

library(shiny)

#' Run the NHANES application
#'
#' `r describe_nhanes_app()`
#'
#' @param nhanes_data \[data.frame\] the data used by the application.
#' @param nhanes_key \[data.frame\] the key used to analyze `nhanes_data`.
#'
#' @details
#'
#' The default values of `nhanes_data` and `nhanes_key` are provided
#'   to make the app run out-of-the-box, but are also good examples
#'   for extending the app to work with your own data. For more
#'   details on extending the app, please see (TODO: EXTEND VIGNETTE)
#'
#' @return runs a shiny application locally
#' @export
#'
app_run <- function(nhanes_data = cardioStatsUSA::nhanes_data,
                    nhanes_key = cardioStatsUSA::nhanes_key) {

 # coerce inputs to data.tables but don't copy them.
 if(!is.data.table(nhanes_data)) setDT(nhanes_data)
 if(!is.data.table(nhanes_key))  setDT(nhanes_key)

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
    purrr::map(
     .f = function(data_split){
      data_split %>%
       getElement('variable') %>%
       purrr::set_names(data_split$label)
     }
    )
  )

 age_cat_levels <- levels(nhanes_data$demo_age_cat)

 age_cat_ids <- paste("standard",
                      "weights",
                      seq(length(age_cat_levels)),
                      sep = "_")

 # default weights for age standardization
 # yes, 7 should be 7.1, but this sums to 100 and that's more intuitive.
 age_cat_wts <- c(49.3, 33.6, 10.1,  7)

 # if a different age variable is provided, you're going to want
 # a new default set of weights based on the new age categories
 if(!all(age_cat_levels == c("18 to 44", "45 to 64", "65 to 74", "75+"))){

  nhd <- nhanes_design(nhanes_data[svy_subpop_htn==1],
                       key = nhanes_key,
                       outcome_variable = 'demo_age_cat',
                       pool = TRUE)

  age_cat_wts <- nhd %>%
   nhanes_design_summarize(simplify_output = T,
                           outcome_stats = 'percentage') %>%
   .[['estimate']] %>%
   round(1)

 }

 standard_weights <- purrr::pmap(
  .l = list(age_cat_ids, age_cat_levels, age_cat_wts),
  .f = function(id, label, value){
   numericInput(inputId=id,
                label=label,
                value = value,
                min = .1)
  }
 )

 standard_weights_width <-
  (100 - length(age_cat_levels) + 1) / length(age_cat_levels)

 # convert to character (the expected type for splitLayout)
 standard_weights_width <- paste0(standard_weights_width, "%")


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

 compute_ready <-
  "((input.pool == 'no' & input.year_stratify.length > 0) |
   input.pool == 'yes')
    & (
   input.outcome.length > 0
  )
    & (
   input.statistic.length > 0
  )"

 helper_compute <- c(
  "Click on this button to compute your statistics. This button is blue when you have entered enough information to calculate statistics. If you still need to provide more information, this button will be grey and cannot be clicked."
 )

 helper_do <- c(
  "You can choose to see your results as a figure or in a dataset. The dataset will provide one row for each statistic (e.g., one row for each age group for age-stratified statistics). It is similar to a table but the data can be sorted in the dataset."
 )

 helper_fig_type <- c(
  "You can choose to make a bar graph or a point and error graph.<br/>",
  "<ol>
    <li>The bar graph includes annotations for each bar that show the primary statistic from your analysis</li>
    <li>The point and error graph includes error bars that cover a 95% confidence interval for the primary statistic in your analysis.</li>
  </ol>",
  "No matter what type of graph you choose, you can always see every statistic in your analysis by hovering your mouse over the part of the graph you are interested in."
 )

 helper_age_standard <- c(
  "Age standardization, sometimes referred to as age adjustment, is a method that applies observed age-specific rates to a standard age distribution. The method adjusts for the confounding effect of age. Standard age proportions are calculated by dividing the age-specific Census population (P) by the total Census population number (T). The standardizing percentages (100 * P/T) must each by > 0 and should collectively sum to 100.<br/>",
  "There are two steps:",
  "<ol>
    <li>Choose a standard population. The default population for this application is adults aged 18 and over in NHANES cycles from 1999-2000 through 2017-2020</li>
    <li>The age-specific prevalence from the study population is multiplied by the proportion of people in that age group in the standard population, and results summed up to get the age-adjusted estimates.</li>
  </ol>",
  "Details and examples are provided online by the <a href=\"http://medbox.iiab.me/modules/en-cdc/www.cdc.gov/nchs/tutorials/nhanes/NHANESAnalyses/AgeStandardization/age_standardization_intro.htm\">Centers for Disease Control tutorial on age standardization</a>"
 )

 helper_pool <- c(
  "Data can be presented for individual cycles or multiple cycles pooled together."
 )

 helper_year_stratify <- c(
  "You can select individual NHANES cycles and then present statistics for each one, separately, by clicking the box next to the cycle(s) you would like to include. You can also click the buttons below the cycles to select all 10, the last 5, or deselect everything. Any combination of cycles is allowed."
 )

 helper_year_pool <- c(
  "You can pool multiple cycles together and present statistics for the aggregate of NHANES participants in these cycles. Adjust the slider below so that it contains the cycles you want to pool. Note that the cycles on the lower and upper boundaries of the slider are included."
 )

 helper_subset_n <- c(
  "You can restrict your analytic population to participants meeting specific criteria. Up to five exclusion criteria can be applied.<br/>For example, you may want to restrict the population to non-pregnant individuals. To do this, select \"Yes - one restriction\" from the drop-down menu, select \"pregnant\" and participants to include (e.g., check the box next to no)."
 )

 helper_outcome <- c(
  "The outcome variable you select will be summarized in your results.<br><br>",
  "There are two boxes:
  <ul>
   <li><b>Select outcome type</b>: the type you select determines what options will be available in the outcome variable input</li>
   <li><b>Select outcome variable</b>: the variable you select will be the variable that is summarized in your results</li>
  </ul><br>",
  "For example, the outcome variables that can be selected when outcome type is \"Hypertension\" include hypertension defined by the JNC7 and 2017 ACC/AHA BP guidelines, awareness of hypertension, and resistant hypertension."
 )

 helper_statistic <- c(
  "Multiple statistics may be requested.</p>
   <p>For continuous outcomes, options include</p>
   <ul>
     <li><em>Mean</em>: estimates the mean value of the outcome</li>
     <li><em>Quantile</em>: estimates 25th, 50th, and 75th percentile of the outcome.</li>
   </ul>
   <p>For categorical outcomes, options include</p>
   <ul>
     <li><em>Percentage</em>: estimates the prevalence of the outcome</li>
     <li><em>Percentage (Korn and Graubard)</em>: estimates the prevalence and uses Korn and Graubard&#39;s method to estimate a 95% confidence interval</li>
     <li><em>Count</em>: estimates the number of US adults with the outcome.</li>
   </ul>"
 )

 helper_statistic_primary <- c(
  "The primary statistic is the one that will define bars (or points) in your figure.</p>
   <p> Although only one statistic can define the objects in the plot, all of the statistics you select are shown in text that appears when you hover your mouse over objects in the plot"
 )

 helper_group <- c(
  "This produces results for sub-groups on the same graph. If there are too many bars/data points, the results will be presented on multiple graphs."
 )

 helper_stratify <- c(
  "This produces results for sub-groups in separate panels."
 )

 # User interface (UI) -----------------------------------------------------
 ui <- function(request){

  fluidPage(

   introjsUI(),

   introBox(
    titlePanel("Cardiometabolic statistics for US adults"),
    data.step = 1,
    data.intro = paste(
     "Welcome! These instructions will teach you",
     "how to use the \"Cardiometabolic statistics for US adults\" website,",
     "an open-source application for analysis and visualization of",
     "National Health and Nutrition Examination Survey (NHANES) data."
    )
   ),

   sidebarLayout(

    # Sidebar -----------------------------------------------------------------
    sidebarPanel(

     column(
      width = 6,
      style='padding-right: 5px; padding-left: 1px',
      actionButton(inputId = "help",
                   "Instructions",
                   icon = icon("question"),
                   width = "100%")
     ),

     column(
      width = 6,
      style='padding-left: 5px; padding-right: 1px',
      bookmarkButton(width = "100%",
                     label = "Bookmark")
     ),

     # actionButton(inputId = "help",
     #              "Instructions",
     #              icon = icon("question"),
     #              width = "100%"),

     HTML('<br>'),HTML('<br>'),HTML('<br>'),

     introBox(
      conditionalPanel(
       condition = compute_ready,
       actionButton(
        inputId =  "run",
        label = "Compute results",
        icon = icon("cog"),
        width = "96%",
        style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"
       ) %>%
        shinyhelper::helper(type = "inline",
                            title = "Compute results",
                            content = helper_compute)
      ),

      conditionalPanel(
       condition = paste("!(", compute_ready, ")", sep = ''),
       actionButton(
        inputId =  "wont_do_computation",
        label = "Compute results",
        icon = icon("cog"),
        width = "96%",
        style = "color: #fff; background-color: #808080; border-color: #2e6da4"
       ) %>%
        shinyhelper::helper(type = "inline",
                            title = "Compute results",
                            content = helper_compute)
      ),
      data.step = 2,
      data.intro = paste(
       helper_compute
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
      ) %>%
       shinyhelper::helper(type = "inline",
                           title = "How to present your results?",
                           content = helper_do),
      data.step = 3,
      data.intro = helper_do
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
      ) %>%
       shinyhelper::helper(type = "inline",
                           title = "Figure type",
                           content = helper_fig_type)
     ),

     introBox(

      awesomeCheckbox(
       inputId = "age_standardize",
       label = "Age-adjustment by standardization?",
       value = FALSE,
       status = "primary"
      ),

      conditionalPanel(
       condition = "input.age_standardize == true",
       h5("Weights for each age group (must be >0)"),

       do.call(splitLayout,
               args = c(standard_weights,
                        cellWidths = standard_weights_width)) %>%
        shinyhelper::helper(type = "inline",
                            title = "Age standardization",
                            content = helper_age_standard)

       # older version was fixed at 4 categories
       # splitLayout(
       #  numericInput(inputId="standard_weights_1",
       #               label="18-44",
       #               value = 49.3,
       #               min = 5),
       #  numericInput(inputId="standard_weights_2",
       #               label="45-64",
       #               value = 33.6,
       #               min = 5),
       #  numericInput(inputId="standard_weights_3",
       #               label="65-74",
       #               value = 10.1,
       #               min = 5),
       #  numericInput(inputId="standard_weights_4",
       #               label="75+",
       #               value = 7.0,
       #               min = 5),
       #  cellWidths = "24.25%"
       # ) %>%
       #  shinyhelper::helper(type = "inline",
       #                      title = "Age standardization",
       #                      content = helper_age_standard)

      ),
      data.step = 4,
      data.intro = paste(
       "Results can be presented crude or age-adjusted."
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
      ) %>%
       shinyhelper::helper(type = "inline",
                           title = "Pool results or stratify by cycle?",
                           content = helper_pool),

      data.step = 5,
      data.intro = helper_pool
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
      ) %>%
       shinyhelper::helper(type = "inline",
                           title = "Analyze selected NHANES cycle(s)",
                           content = helper_year_stratify),
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
      ) %>%
       shinyhelper::helper(type = "inline",
                           title = "Choose a range of cycles to pool",
                           content = helper_year_pool)
     ),

     introBox(
      pickerInput("subset_n",
                  "Restrict analysis to specific sub-population?",
                  choices = c("No" = 0,
                              "Yes - one restriction" = 1,
                              "Yes - two restrictions" = 2,
                              "Yes - three restrictions" = 3,
                              "Yes - four restrictions" = 4,
                              "Yes - five restrictions" = 5),
                  selected = "None",
                  width = "100%") %>%
       shinyhelper::helper(type = "inline",
                           title = "Restrict analysis to specific sub-population",
                           content = helper_subset_n),
      data.step = 6,
      data.intro = helper_subset_n
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
        ) %>%
         shinyhelper::helper(
          type = "inline",
          title = "Outcome variable",
          content = helper_outcome
         )
       ),
       data.step = 7,
       data.intro = helper_outcome
      )
     ),

     conditionalPanel(
      condition = 'input.outcome.length > 0',
      prettyCheckboxGroup(
       inputId = 'statistic',
       label = 'Select statistic(s) to compute',
       choices = character(),
       selected = NULL,
       width = '100%'
      ) %>%
       shinyhelper::helper(
        type = "inline",
        title = "Statistic(s) to compute",
        content = helper_statistic
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
      ) %>%
       shinyhelper::helper(
        type = "inline",
        title = "Primary statistic",
        content = helper_statistic_primary
       )
     ),

     introBox(
      h3("Stratify results"),
      data.step = 8,
      data.intro = paste(
       "You can present results in sub-groups",
       "defined by a stratifying variable"
      )
     ),

     fluidRow(
      introBox(
       h4("Stratification on the same panel",
          style = "text-align: left; padding-left: 15px"),
       column(
        6,
        style='padding-right: 2px;',
        pickerInput(
         inputId = 'group_class',
         label = 'Select stratification type',
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
         label = 'Select stratification variable',
         choices = character(),
         selected = NULL,
         multiple = TRUE,
         options = pickerOptions(maxOptions = 1,
                                 liveSearch = TRUE,
                                 noneSelectedText = 'Options depend on type'),
         width = '100%'
        ) %>%
         shinyhelper::helper(
          type = "inline",
          title = "Stratification (within panel)",
          content = helper_group
         )
       ),
       data.step = 9,
       data.intro = helper_group
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
       h4("Stratification on separate panels",
          style = "text-align: left; padding-left: 15px"),
       column(
        6,
        style='padding-right: 2px;',
        pickerInput(
         inputId = 'stratify_class',
         label = 'Select stratification type',
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
         label = 'Select stratification variable',
         choices = character(),
         selected = NULL,
         multiple = TRUE,
         options = pickerOptions(maxOptions = 1,
                                 liveSearch = TRUE,
                                 noneSelectedText = 'Options depend on type'),
         width = '100%'
        ) %>%
         shinyhelper::helper(
          type = "inline",
          title = "Stratification (between panel)",
          content = helper_stratify
         )
       ),
       data.step = 10,
       data.intro = helper_stratify
      )
     )
    ),

    # Main panel --------------------------------------------------------------
    mainPanel(
     DTOutput('explore_output'),
     uiOutput("visualize_output")
    )

   ),

   shinyjs::useShinyjs()

  )

 }



 # Server ------------------------------------------------------------------
 server <- function(input, output, session) {

  n_exclusion_max <- 5

  # uses 'helpfiles' directory by default
  # in this example, we use the withMathJax parameter to render formulae
  shinyhelper::observe_helpers(withMathJax = TRUE)

  setBookmarkExclude(c("run",
                       "select_all_years",
                       "select_last_5",
                       "deselect_all_years"))

  # Read values from state$values when we restore
  onRestore(function(state) {

   shinyjs::delay(500, {

    if(state$input$subset_n > 0){

     for(i in seq(as.numeric(state$input$subset_n))){

      ss_val_ctns <- paste('subset_value', i, 'ctns', sep = '_')
      ss_val_catg <- paste('subset_value', i, 'catg', sep = '_')

      if(!all(state$input[[ss_val_ctns]] == 0)){
       updateSliderInput(session,
                         inputId = ss_val_ctns,
                         value = state$input[[ss_val_ctns]])
      }


      if(is_used(state$input[[ss_val_catg]])){
       updatePrettyCheckboxGroup(session,
                                 inputId = ss_val_catg,
                                 selected = state$input[[ss_val_catg]])
      }

     }

    }

    if(is_used(state$input$outcome)){
     updatePickerInput(
      session = session,
      inputId = 'outcome',
      selected = state$input$outcome
     )

     shinyjs::delay(200, {
      updatePrettyCheckboxGroup(
       session = session,
       inputId = 'statistic',
       selected = state$input$statistic
      )
      shinyjs::delay(200, {
       updatePickerInput(
        session = session,
        inputId = 'statistic_primary',
        selected = state$input$statistic_primary
       )
      })
     })

    }

    if(state$input$age_standardize){

     shinyjs::delay(200, {

      weight_input_index <- grep(x = names(state$input),
                                 pattern = '^standard_weights')
      for(i in weight_input_index){

       .standard_weight <- names(state$input)[i]
       updateNumericInput(session = session,
                          inputId = .standard_weight,
                          value = state$input[[.standard_weight]])

      }

     })

    }


    if(is_used(state$input$group))
     updatePickerInput(
      session = session,
      inputId = 'group',
      selected = state$input$group
     )

    if(is_used(state$input$stratify))
     updatePickerInput(
      session = session,
      inputId = 'stratify',
      selected = state$input$stratify
     )

   })


  })

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

   if(is_empty(intersect(input$statistic, outcome_stats))){
    updatePrettyCheckboxGroup(
     session = session,
     inputId = 'statistic',
     choices = outcome_stats,
     selected = outcome_stats[1]
    )
   }


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

   }

  })

  observeEvent(input$statistic, {


   outcome_type <- nhanes_key[variable==input$outcome, type]
   outcome_stats <- get_outcome_stats(outcome_type)
   stat_primary_choices <- outcome_stats[match(input$statistic, outcome_stats)]

   if(is_used(input$statistic_primary)){

    selected <- if(input$statistic_primary %in% stat_primary_choices){
     input$statistic_primary
    } else {
     stat_primary_choices[1]
    }

   } else {
    selected <- stat_primary_choices[1]
   }

   updatePickerInput(
    session = session,
    inputId = 'statistic_primary',
    choices = stat_primary_choices,
    selected = selected
   )

   # if('count' %in% input$statistic){
   #
   #  updateAwesomeCheckbox(session = session,
   #                        inputId = 'age_standardize',
   #                        value = FALSE)
   #
   # }


  })

  purrr::map(
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
        sort(
         unique(
          stats::na.omit(nhanes_data[[ input[[ss_var]] ]])
         )
        ) %>%
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

  output$subset_ui <- renderUI({

    if(input$subset_n < 1) return(NULL)

    map(
     .x = seq(as.integer(input$subset_n)),
     ~ {

      new_id <- paste('subset_variable', .x, sep = '_')
      new_id_val_catg <- paste('subset_value', .x, 'catg', sep = '_')
      new_id_val_ctns <- paste('subset_value', .x, 'ctns', sep = '_')

      ss_var_is_ctns <- new_id %>%
       jsc_write_subset_ctns(ctns_subset_variables)

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
          value = input[[new_id_val_ctns]] %||% c(0, 0),
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

   withProgress(message = "Doing summary computations", expr = {

    pool <- input$pool == 'yes'

    standard_weights <- NULL

    if(input$age_standardize){
     standard_weights <- c(input$standard_weights_1,
                           input$standard_weights_2,
                           input$standard_weights_3,
                           input$standard_weights_4)
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

    if(as.numeric(input$subset_n) > 0){
     # as.integer b/c subset_n is a character value
     subset_indices <- seq(as.integer(input$subset_n))
    }

    for(i in subset_indices){

     ss_var <- paste('subset_variable', i, sep = '_')

     if(is_used(input[[ss_var]])){

      ss_type <- get_variable_type(input[[ss_var]], nhanes_key)

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
       standard_weights = standard_weights,
       simplify_output = FALSE
      ),
     silent = TRUE
    )

    incProgress(1)

   })

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

   withProgress(message = "Preparing plots", expr = {

    plot_out <- smry() %>%
     nhanes_design_viz(
      statistic_primary = input$statistic_primary,
      geom = input$geom
     )

    incProgress(1)

   })

   plot_out

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
    formatRound(columns = get_numeric_colnames(results), digits = 1)
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
  observeEvent(input$help,
               introjs(session,
                       options = list("nextLabel" = "Continue",
                                      "prevLabel" = "Previous")))

  # for testing, maybe?
  # exportTestValues(smry = smry())

 }

 # Calling shinyapp --------------------------------------------------------

 # shinyApp(ui, server)
 shinyApp(ui, server, enableBookmarking = 'url')

}

# nocov end
