

#' Visualize summaries of NHANES
#'
#' @inheritParams nhanes_summarize
#'
#' @param statistic_primary (character) the statistic that defines the
#'   geometric objects in the plot.
#' @param geom (character) can be 'bar' or 'points'
#' @param reorder_cats (logical) whether to re-order the categorical exposure
#'   variable so that its levels are shown in increasing order by the expected
#'   outcome.
#' @param width width of the plot, in pixels
#' @param height height of the plot, in pixels
#'
#' @return a plotly visualization
#'
#' @export
#'
nhanes_visualize <- function(outcome,
                             exposure = NULL,
                             group = NULL,
                             years = 'last_5',
                             pool = FALSE,
                             subset_variables = list(),
                             subset_values = list(),
                             age_wts = NULL,
                             statistic_primary = NULL,
                             geom = 'bar',
                             reorder_cats = FALSE,
                             width = NULL,
                             height = NULL){

 nhanes <- nhanesShinyBP::nhanes_bp

 years <- switch(
  years[1],
  'all' = levels(nhanes$svy_year),
  'last_5' = last(levels(nhanes$svy_year), n = 5),
  'most_recent' = last(levels(nhanes$svy_year), n = 1),
  years
 )

 # silly conversion to make pool consistent w/the svy functions
 if(is.logical(pool)) pool <- ifelse(pool, yes = 'yes', no = 'no')

 smry <- nhanes_summarize(outcome, exposure, group, years, pool,
                          subset_variables, subset_values, age_wts)

 if(is.null(statistic_primary)){

  outcome_type <-
   nhanesShinyBP::nhanes_key$variables[[outcome]]$type

  statistic_primary <-
   nhanesShinyBP::nhanes_key$svy_calls[[outcome_type]][1]

 }

 plotly_viz(
  data = smry,
  statistic_primary = statistic_primary,
  geom = geom,
  years = years,
  pool = pool,
  reorder_cats = reorder_cats,
  width = width,
  height = height
 )

}
