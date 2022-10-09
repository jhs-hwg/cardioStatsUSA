

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
nhanes_visualize <- function(data,
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
                             statistic_primary = NULL,
                             geom = 'bar',
                             reorder_cats = FALSE,
                             width = NULL,
                             height = NULL,
                             size_point = NULL,
                             size_error = NULL){

 if(geom %in% c('point', 'points')) geom <- 'scatter'

 smry <- nhanes_summarize(data = data,
                          key = key,
                          outcome_variable = outcome_variable,
                          outcome_quantiles = outcome_quantiles,
                          group_variable = group_variable,
                          group_cut_n = group_cut_n,
                          group_cut_type = group_cut_type,
                          stratify_variable = stratify_variable,
                          time_variable = time_variable,
                          time_values = time_values,
                          pool = pool,
                          subset_calls = subset_calls,
                          age_wts = age_wts,
                          simplify_output = FALSE)


 nhanes_design_viz(
  smry,
  statistic_primary = statistic_primary,
  geom = geom,
  reorder_cats = reorder_cats,
  width = width,
  height = height,
  size_point = size_point,
  size_error = size_error
 )

}
