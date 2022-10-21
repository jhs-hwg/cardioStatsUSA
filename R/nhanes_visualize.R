

#' Visualize summaries of NHANES
#'
#' @inheritParams nhanes_summarize
#'
#' @param statistic_primary \[character(1)\]
#'
#'   the statistic that defines the geometric objects in the plot.
#'
#' @param geom \[character(1)\]
#'
#' What type of plot to create. Valid options are
#'
#' - `'bar'` A bar plot will be created
#'
#' - `'point'` A scatter plot will be created
#'
#' @param reorder_cats \[logical(1)\]
#'
#' whether to re-order the categorical exposure
#'   variable so that its levels are shown in increasing order by the expected
#'   outcome.
#'
#' @param width
#'
#' width of the plot, in pixels
#'
#' @param height
#'
#' height of the plot, in pixels
#'
#' @param size_point
#'
#' the size of points in the plot (only relevant if `geom = 'point'`)
#'
#' @param size_error
#'
#' the size of error bars in the plot (only relevant if `geom = 'point'`)
#'
#' @return a plotly visualization
#'
#' @export
#'
#' @examples
#'
#' # Plotly objects do not render for example R code. Please see vignettes
#' # for examples of nhanes_visualize. TODO: ADD LINK
#'
#'
nhanes_visualize <- function(data,
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
                             age_wts = NULL,
                             statistic_primary = NULL,
                             title = NULL,
                             geom = 'bar',
                             reorder_cats = FALSE,
                             width = NULL,
                             height = NULL,
                             size_point = NULL,
                             size_error = NULL){

 if(geom %in% c('point', 'points')) geom <- 'scatter'

 outcome_stats <- outcome_stats %||% statistic_primary

 smry <- nhanes_summarize(data = data,
                          key = key,
                          outcome_variable = outcome_variable,
                          outcome_quantiles = outcome_quantiles,
                          outcome_stats = outcome_stats,
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
  title = title,
  geom = geom,
  reorder_cats = reorder_cats,
  width = width,
  height = height,
  size_point = size_point,
  size_error = size_error
 )

}
