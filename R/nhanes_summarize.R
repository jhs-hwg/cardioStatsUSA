

#' Generate summaries of NHANES
#'
#' The description should include
#' - what is NHANES
#' - Who is included in the data to be summarized
#' - How is the summary computed
#'
#' @inheritParams nhanes_design
#'
#' @inheritParams nhanes_design_summarize
#'
#' @param subset_calls \[named list(n)\]
#'
#'  the names of `subset_calls` are variable names, and the values are
#'    values of the variable to include in the subsetted data. For example,
#'    `subset_calls = list("demo_gender" = "Women")` will subset the data
#'    to include rows where `demo_gender` is equal to `"Women"`. Multiple
#'    entries are allowed and collapsed with the logical `&` operator.
#'    For example, `subset_calls = list(demo_gender = "Women", bp_med_use = "Yes")`
#'    will subset the data to include rows where `demo_gender` is equal
#'    to `'Women'` AND `bp_med_use` is equal to `"Yes"`
#'
#' @inheritParams nhanes_design_standardize
#'
#' @inherit nhanes_design_summarize return
#'
#' @export
#'
#' @examples
#'
#' nhanes_summarize(data = nhanes_data,
#'                  key = nhanes_key,
#'                  outcome_variable = "bp_sys_mean")
#'
nhanes_summarize <- function(data,
                             key,
                             outcome_variable,
                             outcome_quantiles = NULL,
                             outcome_stats = NULL,
                             group_variable = NULL,
                             group_cut_n = NULL,
                             group_cut_type = NULL,
                             stratify_variable = NULL,
                             time_variable = 'svy_year',
                             time_values = NULL,
                             pool = FALSE,
                             subset_calls = list(),
                             standard_variable = 'demo_age_cat',
                             standard_weights = NULL,
                             simplify_output = TRUE){

 if(missing(data)) data <- cardioStatsUSA::nhanes_data
 if(missing(key)) key <- cardioStatsUSA::nhanes_key

 if(is_used(stratify_variable) && is_used(group_variable)){

  if(stratify_variable == group_variable){
   stop("The two stratification variables should not be the same. However, ",
        key[variable == stratify_variable, label],
        " is selected for both variables.", call. = FALSE)
  }

 }

 if(!is.data.table(data)){
  dt_sub <- dt_data <- as.data.table(data)
 } else {
  dt_sub <- dt_data <- data
 }

 if(!is.data.table(key)){
  dt_key <- as.data.table(key)
 } else {
  dt_key <- key
 }

 if('module' %in% names(dt_key)){

  type_subpop <- dt_key$module[dt_key$variable == outcome_variable]
  colname_subpop <- paste('svy_subpop', type_subpop, sep = '_')

  if(colname_subpop %in% names(dt_data)){

   dt_sub <- dt_data %>%
    # restrict the sample to the relevant sub-population
    .[.[[colname_subpop]] == 1]

  } else {

   stop("Module ", type_subpop, " was found in the supplied key, ",
        "but the variable ", colname_subpop, " was not found in the ",
        "supplied NHANES data. ", colname_subpop, " should be present ",
        "with values of 0 for omitting and 1 for including ",
        "participants into the sub-population.",
        call. = FALSE)

  }

 }

 dt_sub <- dt_sub %>%
  # restrict to observations where analysis variables are non-missing.
  stats::na.omit(cols = c(time_variable,
                          outcome_variable,
                          group_variable,
                          stratify_variable)) %>%
  # re-calibrate weights to match the total in nhanes_data
  nhanes_calibrate(nhanes_full = dt_data)

 ds <- nhanes_design(data = dt_sub,
                     key = dt_key,
                     outcome_variable = outcome_variable,
                     outcome_quantiles = outcome_quantiles,
                     group_variable = group_variable,
                     group_cut_n = group_cut_n,
                     group_cut_type = group_cut_type,
                     stratify_variable = stratify_variable,
                     time_variable = time_variable,
                     time_values = time_values,
                     pool = pool)

 if(!is_empty(subset_calls)){
  ds %<>% nhanes_design_subset(
   subset = rlang::eval_bare(
    parse_subset_calls(subset_calls)
   )
  )
 }

 if(!is.null(standard_weights)){
  ds %<>% nhanes_design_standardize(
   standard_variable = standard_variable,
   standard_weights = standard_weights
  )
 }

 nhanes_design_summarize(ds,
                         outcome_stats = outcome_stats %||% ds$stats[1],
                         simplify_output = simplify_output)

}
