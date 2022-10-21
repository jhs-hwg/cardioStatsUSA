
#' Survey Design for NHANES Data
#'
#' @description NHANES design objects are the data structure used in
#'   the `cardioStatsUSA` package for analysis of NHANES data.
#'
#' @param data \[data.frame\]
#' `r describe_nhanes_data_input()`
#'  See Details for specific requirements.
#'  See [nhanes_data] for an example.
#'
#' @param key \[data.frame\]
#' `r describe_nhanes_key_input()`
#'  See Details for specific requirements.
#'  See [nhanes_key] for an example.
#'
#' @param outcome_variable \[character(1)\]
#' The name of the outcome variable to be summarized.
#'
#' @param outcome_quantiles \[numeric(1+)\]
#' The quantiles to be summarized for a continuous outcome. The default is
#'   `c(0.25, 0.50, 0.75)`. For example,
#'
#' - `outcome_quantiles = c(.5)` will compute the 50th percentile
#'   (i.e., the median)
#'
#' - `outcome_quantiles = c(.25, .5, .75)` will compute the 25th, 50th,
#'    and 75th percentile.
#'
#' - `outcome_quantiles = seq(.1, .9, by = .1)` will compute every 10th
#'   percentile, except for the 0th and 100th
#'
#' @param group_variable \[character(1)\]
#' The name of the group variable. See Details for a description of
#'   the group variable and the stratify variable.
#'
#' @param group_cut_n \[integer(1)\]
#'  The number of groups to form using the group variable. This is only
#'    relevant if the group variable is continuous, and can be omitted.
#'    Default is 3
#'
#' @param group_cut_type \[character(1)\]
#'  The method used to create groups with the grouping variable. This is only
#'    relevant i fthe group variable is continuous, and can be omitted.
#'    Valid options are:
#'
#'    - "interval": equal interval width, e.g., three groups with ages of
#'      0 to <10, 10 to <20, and 20 to < 30 years.
#'
#'    - "frequency": equal frequency, e.g., three groups with ages of
#'      0 to <q, q to <p, and p to <r, where q, p, and r are selected
#'      so that roughly the same number of people are in each group.
#'
#' @param stratify_variable \[character(1)\]
#' the name of the stratify variable. See Details for a description of
#'   the group variable and the stratify variable.
#'
#' @param time_variable \[character(1)\]
#' The name of the time variable. The default, `svy_year`, corresponds to
#'   the variable in `nhanes_data` that indicates which 2 year NHANES cycle
#'   an observation was collected in.
#'
#' @param time_values \[character(1+)\]
#' The time values that will be included in this design object.
#'   The default is to include all time values present in `data`.
#'   Valid options are:
#'
#'   - `'most_recent'`: includes the most recent time value.
#'
#'   - `'last_5'`: includes the 5 most recent time values.
#'
#'   - `'all'`: includes all time values present in `data`.
#'
#'   - You can also give a vector of specific time values, e.g.,
#'   `c("2009-2010", "2011-2012", "2013-2014")`, if these values are
#'   present in the time_variable column (they are for `nhanes_data`).
#'
#' @param pool \[logical(1)\]
#' If `FALSE` (the default), results are presented for individual times,
#'   separately. If `TRUE`, data from each time value are pooled together.
#'   Note that only contiguous cycles should be pooled together, e.g.,
#'   using `pool = TRUE` with `time_values = 'last_5'` is okay, but
#'   using `pool = TRUE` with `time_values = c("2009-2010", "2013-2014")` is
#'   not recommended (that would be a strange result to interpret).
#'
#' @param run_checks \[logical(1)\]
#'
#' If `TRUE` (the default), inputs will be checked for validity. If `FALSE`,
#'  checks of inputs are skipped.
#'
#' @return an [nhanes_design] object.
#'
#' @export
#'
#' @includeRmd rmd/nhanes_design.Rmd
#'
nhanes_design <- function(data,
                          key,
                          outcome_variable,
                          outcome_quantiles = NULL,
                          group_variable = NULL,
                          group_cut_n = NULL,
                          group_cut_type = NULL,
                          stratify_variable = NULL,
                          time_variable = 'svy_year',
                          time_values = NULL,
                          pool = FALSE,
                          run_checks = TRUE){

 info_cols <- c('class',
                'variable',
                'label',
                'source',
                'type',
                'module',
                'description')

 if(!is.data.table(data))
  dt_data <- as.data.table(data)
 else
  dt_data <- data

 if(!is.data.table(key))
  dt_key <- as.data.table(key)
 else
  dt_key <- key

 if(run_checks){

  check_key(dt_key)

  check_vars_in_data(outcome_variable = outcome_variable,
                     group_variable = group_variable,
                     stratify_variable = stratify_variable,
                     data_names = names(dt_data),
                     data_label = 'data')

  check_vars_in_data(outcome_variable = outcome_variable,
                     group_variable = group_variable,
                     stratify_variable = stratify_variable,
                     data_names = dt_key$variable,
                     data_label = 'key')

 }

 # outcome variable ----

 outcome_info <- as.list(dt_key[variable == outcome_variable])[info_cols]

 if(outcome_info$type == 'ctns'){
  if(is.null(outcome_quantiles)) outcome_quantiles <- c(0.25, 0.5, 0.75)
  outcome_info$quantiles <- outcome_quantiles
 }

 # statistics to compute
 outcome_stats <- get_outcome_stats(outcome_info$type)

 if(is.null(time_values)) time_values <- 'all'

 # time_values ----
 time_values <- switch(
  time_values[1],
  'all' = levels(data[[time_variable]]),
  'last_5' = last(levels(data[[time_variable]]), n = 5),
  'most_recent' = last(levels(data[[time_variable]]), n = 1),
  time_values
 )

 time_info <- list(variable = time_variable,
                   values = time_values,
                   label = key[variable==time_variable, label])


 # subset and pool the weights (if needed) ----

 design_data <- dt_data[dt_data[[time_variable]] %in% time_values]

 if(pool){

  divide_by <- length(time_values)

  design_data[, svy_weight_mec := svy_weight_mec / divide_by]

  if('svy_weight_cal' %in% names(design_data)){

   design_data[, svy_weight_cal := svy_weight_cal / divide_by]

  }

 }

 # group variable ----

 group_info <- NULL

 if(is_used(group_variable)){

  group_info <- as.list(dt_key[variable == group_variable])[info_cols]

  if(group_info$type == 'ctns'){

   if(is.null(group_cut_n)) group_cut_n <- 3
   if(is.null(group_cut_type)) group_cut_type <- "frequency"

   set(design_data,
       j = group_variable,
       value = discretize(design_data[[group_variable]],
                          method = group_cut_type,
                          n_group = as.numeric(group_cut_n)))

   group_info$cut_n <- group_cut_n
   group_info$cut_type <- group_cut_type

  }

 }

 # stratify variable ----
 stratify_info <- NULL

 if(is_used(stratify_variable)){
  stratify_info <- as.list(dt_key[variable == stratify_variable])[info_cols]
 }


 design <- svydesign(ids = ~ svy_psu,
                     strata = ~ svy_strata,
                     weights = ~ svy_weight_mec,
                     data = design_data,
                     nest = TRUE)

 # some coercion is done here so that users can set these values to 'none'
 # in nhanes_design_update and have the update work as expected.

 if(!is.null(group_variable)){
  if(tolower(group_variable) == 'none')
   group_variable <- NULL
 }

 if(!is.null(stratify_variable)){
  if(tolower(stratify_variable) == 'none')
   stratify_variable <- NULL
 }

 by_variables <- c(if(pool) NULL else time_variable,
                   group_variable,
                   stratify_variable)

 structure(
  .Data = list(
   data = dt_data,
   key = dt_key,
   outcome = outcome_info,
   group = group_info,
   stratify = stratify_info,
   time = time_info,
   by_variables = by_variables,
   design = design,
   stats = outcome_stats,
   pool = pool,
   standard = NULL,
   subset_rows = NULL,
   operations = NULL
  ),
  class = 'nhanes_design'
 )


}

#' Modify an NHANES design
#'
#' @param x an [nhanes_design] object
#' @inheritParams nhanes_design
#'
#' @return a modified [nhanes_design] object.
#'
#' @export
#'
#' @includeRmd rmd/nhanes_design_update.Rmd
#'
nhanes_design_update <- function(x,
                                 outcome_variable = NULL,
                                 group_variable = NULL,
                                 group_cut_n = NULL,
                                 group_cut_type = NULL,
                                 stratify_variable = NULL,
                                 time_values = NULL,
                                 pool = NULL){

 # 'update' is a bit of a stretch...but this is fast enough and safer
 ds_new <- nhanes_design(
  data = x$data,
  key = x$key,
  outcome_variable = outcome_variable %||% x$outcome$variable,
  outcome_quantiles = x$outcome$quantiles,
  group_variable = group_variable %||% x$group$variable,
  group_cut_n = group_cut_n %||% x$group$cut_n,
  group_cut_type = group_cut_type %||% x$group$cut_type,
  stratify_variable = stratify_variable %||% x$stratify$variable,
  time_values = time_values %||% x$time$values,
  pool = pool %||% x$pool
 )

 for(i in x$operations){

  if(i == 'subset')
   ds_new$design <- ds_new$design[x$subset_rows, ]

  if(i == 'standardize') ds_new %<>%
    nhanes_design_standardize(standard_variable = x$standard$variable,
                              standard_weights = x$standard$weights)

 }



 ds_new

}


#' Print an NHANES design
#'
#' @param x an [nhanes_design] object
#' @param ... currently not used
#'
#' @return the design object, invisibly.
#'
#' @export
#'
#' @includeRmd rmd/nhanes_design_print.Rmd
#'
print.nhanes_design <- function(x, ...){

 current_width <- getOption("width") - 1

 header_detail <- " NHANES design "

 header_sidebar <- "-" %>%
  rep(times = floor((current_width - nchar(header_detail)) / 2)) %>%
  paste(collapse = '')

 header <- paste0(header_sidebar, header_detail, header_sidebar)

 footer <- "-" %>%
  rep(times = getOption('width')) %>%
  paste(collapse = '') %>%
  paste0("\n", .)

 paste_pretty <- function(..., width = getOption('width')){
  paste0(...) %>%
   strwrap(width = width) %>%
   paste(collapse = "\n    ")
 }

 cat_pretty <- function(...) cat(..., sep = "")

 type_pretty <- function(type){
  switch(type,
         'bnry' = "binary",
         'ctns' = 'continuous',
         'catg' = 'categorical',
         'intg' = "integer")
 }

 cat_pretty(header, "\n\n")

 cat_pretty(
  paste_pretty("Outcome variable: ", x$outcome$variable), "\n",
  paste_pretty("- label: ", x$outcome$label), "\n",
  paste_pretty('- type: ', type_pretty(x$outcome$type)), "\n",
  paste_pretty('- description: ', x$outcome$description %||% "None"),
  "\n\n"
 )

 cat_pretty(
  paste_pretty("Group variable: ", x$group$variable %||% "None"),
  "\n"
 )

 if(!is.null(x$group)){

  cat_pretty(
   paste_pretty("- label: ", x$group$label), "\n",
   paste_pretty('- type: ', type_pretty(x$group$type)), "\n",
   paste_pretty('- description: ', x$group$description %||% "None"),
   "\n\n"
  )

 }

 cat_pretty(
  paste_pretty("Stratify variable: ", x$stratify$variable %||% "None"),
  "\n"
 )

 if(!is.null(x$stratify)){

  cat_pretty(
   paste_pretty("- label: ", x$stratify$label), "\n",
   paste_pretty('- type: ', type_pretty(x$stratify$type)), "\n",
   paste_pretty('- description: ', x$stratify$description %||% "None"),
   "\n"
  )

 }


 cat_pretty(
  "\n",
  paste_pretty("N observations"),
  "\n"
 )

 cat_pretty(
  paste_pretty(
   "- Unweighted: ",
   table.glue::table_value(
    get_obs_count(x$design, weighted = FALSE)
   )
  ),
  "\n",
  paste_pretty(
   "- Weighted: ",
   table.glue::table_value(
    get_obs_count(x$design, weighted = TRUE)
   ), "\n"
  )
 )

 cat(footer)

 invisible(x)

}

outcome_is_discrete <- function(x){
 x$outcome$type %in% c('bnry', 'catg', 'intg')
}

outcome_is_continuous <- function(x){
 !outcome_is_discrete(x)
}

has_group <- function(x){
 !is.null(x$group)
}

has_stratify <- function(x){
 !is.null(x$stratify)
}

is_standardized <- function(x){
 !is.null(x$standard)
}

is_subsetted <- function(x){
 !is.null(x$subset_rows)
}

is_nhanes_design <- function(x){
 inherits(x, 'nhanes_design')
}
