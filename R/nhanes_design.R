
#' Title
#'
#' @param data
#' @param key
#' @param outcome
#' @param group
#' @param group_cut_n
#' @param group_cut_type
#' @param stratify
#' @param time_values
#' @param pool
#' @param run_checks
#'
#' @return
#' @export
#'
#' @examples
#'
#' x <- nhanes_design(data = nhanes_data,
#'                    key = nhanes_key,
#'                    outcome_variable = 'bp_sys_mean')
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

 dt_data <- as.data.table(data)
 dt_key <- as.data.table(key)

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

 divide_by <- if(pool) length(time_values) else 1

 design_data <- dt_data %>%
  .[.[[time_variable]] %in% time_values] %>%
  .[, svy_weight_mec := svy_weight_mec / divide_by]

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
                          breaks = group_cut_n))

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


#' Title
#'
#' @param x
#' @param outcome_variable
#' @param group_variable
#' @param group_cut_n
#' @param group_cut_type
#' @param stratify_varible
#' @param time_values
#' @param pool
#'
#' @return
#' @export
#'
#' @examples
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


#' Title
#'
#' @param x
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
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

