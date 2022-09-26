

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
nhanes_summarize <- function(outcome,
                             exposure = NULL,
                             group = NULL,
                             years = 'last_5',
                             pool = FALSE,
                             subset_variables = list(),
                             subset_values = list(),
                             age_wts = NULL){

 # back-end objects
 key          <- cardioStatsUSA::nhanes_key
 nhanes       <- cardioStatsUSA::nhanes_bp

 # TODO check inputs

 # outcome, statistics to compute
 outcome_type <- key$variables[[outcome]]$type
 stats        <- key$svy_calls[[outcome_type]]

 # silly conversion to make pool consistent w/the svy functions
 if(is.logical(pool)) pool <- ifelse(pool, yes = 'yes', no = 'no')

 years <- switch(
  years[1],
  'all' = levels(nhanes$svy_year),
  'last_5' = last(levels(nhanes$svy_year), n = 5),
  'most_recent' = last(levels(nhanes$svy_year), n = 1),
  years
 )

 # prepare calls to subset
 subset_calls <- list()

 n_exposure_group  <- NULL
 exposure_cut_type <- NULL

 if(is_continuous(exposure)){
  n_exposure_group <- 3
  exposure_cut_type <- 'frequency'
 }

 # create calls to subset(), but don't eval yet
 for(i in seq_along(subset_variables)){

   if(is_continuous(subset_variables[[i]])){

    # need to create the subsetting variables based on continuous
    # cut-points before creating the design object. Doing this
    # in the reverse order won't work b/c survey doesn't let you
    # modify the design object's data.

    nhanes[[ paste(subset_variables[[i]], 'tmp', sep='_') ]] <-
     fifelse(
      nhanes[[ subset_variables[[i]] ]] %between% c(subset_values[[i]]),
      yes = 'yes',
      no = 'no'
     )

    subset_calls[[ paste(subset_variables[[i]], 'tmp', sep='_') ]] <- "yes"

   } else {

    subset_calls[[ subset_variables[[i]] ]] <- subset_values[[i]]

   }



 }

 # nhanes key has a column named outcome, so we need to make a
 # unique name that points to the outcome given by the user.
 outcome_name <- outcome
 type_subpop <- nhanes_key$data[variable == outcome_name, subpop]

 # restrict the sample to the relevant sub-population
 colname_subpop <- paste('svy_subpop', type_subpop, sep = '_')

 nhanes_subpop <- nhanes %>%
  .[.[[colname_subpop]] == 1]

 # if the count of a variable was requested, calibrate the
 # weights so that the sum of observations in the sub-population
 # matches the sum of weights in nhanes. (this is why we only created
 # the calls to subset() above, because we may need to calibrate the
 # weights before we do our subetting)
 smry_counts <- smry_no_counts <- NULL

 if('count' %in% stats){

  smry_counts <- nhanes_bp %>%
   nhanes_calibrate(nhanes_sub = nhanes_subpop) %>%
   .[, svy_weight := svy_weight_cal] %>%
   svy_design_new(
    exposure = exposure,
    n_exposure_group = n_exposure_group,
    exposure_cut_type = exposure_cut_type,
    years = years,
    pool = pool
   ) %>%
   svy_design_subset(subset_calls) %>%
   svy_design_summarize(
    outcome = outcome,
    statistic = 'count',
    exposure = exposure,
    group = group,
    age_standardize = !is.null(age_wts),
    age_wts = age_wts
   )
 }

 stats_no_count <- setdiff(stats, 'count')

 if(!is_empty(stats_no_count)){

  smry_no_counts <- nhanes_subpop %>%
   .[, svy_weight := svy_weight_mec] %>%
   svy_design_new(
    exposure = exposure,
    n_exposure_group = n_exposure_group,
    exposure_cut_type = exposure_cut_type,
    years = years,
    pool = pool
   ) %>%
   svy_design_subset(subset_calls) %>%
   svy_design_summarize(
    outcome = outcome,
    statistic = stats_no_count,
    exposure = exposure,
    group = group,
    age_standardize = !is.null(age_wts),
    age_wts = age_wts
   )

 }

 bind_smry(smry_counts, smry_no_counts)

}
