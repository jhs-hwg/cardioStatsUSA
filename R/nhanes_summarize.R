

#' Generate summaries of NHANES
#'
#' The description should include
#' - what is NHANES
#' - Who is included in the data to be summarized
#' - How is the summary computed
#'
#' @param outcome (*character*; length 1; no default)
#'   The variable to be summarized.
#' @param exposure (*character*; length 1; default is none)
#'
#' @param group (*character*; length 1; default is none)
#'
#' @param years (*character*; length may vary; default = 'all')
#'   Valid options are
#'   - 'all' (includes all NHANES cycles)
#'   - 'last_5' (includes the last 5 most recent NHANES cycles)
#'   - 'most_recent' (include the most recent NHANES cycle)
#'
#' @param pool (*logical*; length 1; default = `FALSE`)
#'
#' @param subset_variables (*list*; length may vary)
#'
#' @param subset_values (*list*; length must match `subset_variables`)
#'
#' @param age_wts (*numeric*; length 4; default is none)
#'
#' @return a `data.table` with summarized values
#'
#' @export
#'
#' @examples
#'
#' nhanes_summarize("bp_sys_mean")
#'
nhanes_summarize <- function(data,
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
                             subset_calls = list(),
                             age_wts = NULL,
                             simplify_output = TRUE){


 if(missing(data)) data <- cardioStatsUSA::nhanes_data
 if(missing(key)) key <- cardioStatsUSA::nhanes_key

 type_subpop <- key[variable == outcome_variable, module]

 dt_data <- as.data.table(data)
 dt_key <- as.data.table(key)

 colname_subpop <- paste('svy_subpop', type_subpop, sep = '_')

 dt_sub <- dt_data %>%
  # restrict the sample to the relevant sub-population
  .[.[[colname_subpop]] == 1] %>%
  # restrict to observations where analysis variables are non-missing.
  na.omit(cols = c(time_variable,
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

 if(!is.null(age_wts)){
  ds %<>% nhanes_design_standardize(
   standard_variable = 'demo_age_cat',
   standard_weights = age_wts
  )
 }

 nhanes_design_summarize(ds, simplify_output = simplify_output)

}
