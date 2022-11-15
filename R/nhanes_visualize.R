

#' Visualize summaries of NHANES
#'
#' @inheritParams nhanes_summarize
#'
#' @inheritParams nhanes_design_viz
#'
#' @inherit nhanes_design_viz return
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
                             standard_variable = 'demo_age_cat',
                             standard_weights = NULL,
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
                          standard_variable = standard_variable,
                          standard_weights = standard_weights,
                          simplify_output = FALSE)

 fig <- nhanes_design_viz(
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

 list(fig_data = smry$results,
      fig_object = fig)

}
