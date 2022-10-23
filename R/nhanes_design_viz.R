#' Visualize a summary of NHANES data
#'
#' Analyze the prevalence, mean, or quantiles of an outcome
#'   over time.
#'
#' @param x \[nhanes_design\]
#'
#' `r document_nhanes_design()`
#'
#' @param statistic_primary \[character(1)\]
#'
#' the statistic that defines the geometric objects in the plot. Other
#'   statistics will be featured in the text that appears when the users
#'   mouse hovers over the corresponding object.
#'
#' @param title \[character(1)\]
#'
#' The title that will appear above the plot. If this is not supplied,
#'   the title will be generated using the `key` data in `x`.
#'
#' @param geom \[character(1)\]
#'
#' The type of figure that will be made. Valid options are:
#'
#' - `'bar'` creates a bar plot with annotations on the bars
#'
#' - `'point'` creates a scatter plot with 95% confidence interval error bars
#'
#' @param reorder_cats \[logical(1)\]
#'
#' whether to re-order the categorical group variable so that its levels
#'  are shown in increasing order by the expected outcome.
#'
#' @param width \[numeric(1)\]
#'
#' the width of the plot, in pixels
#'
#' @param height \[numeric(1)\]
#'
#' the height of the plot, in pixels
#'
#' @param size_point \[numeric(1)\]
#'
#' the size of points in the plot. (only relevant if `'geom' = 'point'`)
#'
#' @param size_error \[numeric(1)\]
#'
#' the size of error bars in the plot. (only relevant if `'geom' = 'point'`)
#'
#' @return a `plotly` object
#'
#' @export

# nhanes_design(data = nhanes_bp, key = nhanes_key,
#               outcome_variable = 'bp_med_n_class',
#               group_variable = 'cc_ckd') %>%
#  nhanes_design_summarize(simplify_output = FALSE) %>%
#  nhanes_design_viz()

nhanes_design_viz <- function(x,
                              statistic_primary = NULL,
                              title = NULL,
                              geom = 'bar',
                              reorder_cats=FALSE,
                              width = NULL,
                              height = 600,
                              size_point = NULL,
                              size_error = NULL){

 outcome <- x$outcome$variable
 group <- x$group$variable
 stratify <- x$stratify$variable

 group_used <- is_used(group)
 stratify_used <- is_used(stratify)

 outcome_label <- x$outcome$label
 group_label <- x$group$label
 stratify_label <- x$stratify$label

 time_variable <- x$time$variable
 time_values <- x$time$values
 time_label <- x$time$label

 outcome_type <- x$outcome$type
 stat_all <- get_outcome_stats(outcome_type)
 data <- x$results
 pool <- x$pool

 if(is.null(statistic_primary)) statistic_primary <- stat_all[1]

 if(outcome_type == 'intg' && statistic_primary != 'quantile'){
  outcome_type <- 'catg'
 }

 if(outcome_type == 'catg' && !pool){

  if(group_used && stratify_used){

   data[[group]] <- paste(group_label, data[[group]], sep = ' = ')
   data[[stratify]] <- paste(data[[stratify]], data[[group]], sep = '; ')
   data[[group]] <- NULL

   group <- NULL
   group_label <- NULL
   group_used <- FALSE


  } else if (group_used && !stratify_used){

   stratify <- group
   stratify_label <- group_label
   stratify_used <- TRUE

   group <- NULL
   group_label <- NULL
   group_used <- FALSE

  }

 }

 if(pool){

  if(length(time_values) > 1){
   data[[time_variable]] <-
    as.factor(glue("{time_values[1]} through {time_values[length(time_values)]}"))
  } else {
   data[[time_variable]] <-
    as.factor(time_values[1])
  }

 }

 if(outcome_type == 'bnry'){

  data <- data[data[[outcome]] == 'Yes', ]

 }

 if(!group_used){
  group <- 'fake_._group'
  data[[group]] <- 1
 }

 if(stratify_used){

  data_figs <- split(data, by = stratify) %>%
   discard(~nrow(.x) == 0)

  title_addons <- paste(stratify_label, names(data_figs), sep = ' = ')

 } else {

  data_figs <- list(data)
  title_addons <- ""

 }

 output <- vector('list', length = length(data_figs))

 if(nrow(data) == 0) return(output)

 for(j in seq_along(output)){

  data_fig <- data_figs[[j]]
  title_addon <- title_addons[j]

  stat_all <- x$stats

  if('quantile' %in% stat_all){
   stats_in_x <- unique(data$statistic)
   stats_not_quantile <- setdiff(get_outcome_stats('ctns'), 'quantile')
   stats_quantile <- setdiff(stats_in_x, stats_not_quantile)
   stat_all <- c(stat_all, stats_quantile)
  }

  if(statistic_primary == 'quantile'){
   n_quantiles <- length(stats_quantile)
   if(n_quantiles %% 2 == 0)
    statistic_primary <- stats_quantile[n_quantiles/2]
   else
    statistic_primary <- stats_quantile[(n_quantiles+1)/2]
  }

  stacked_and_pooled <- outcome_type == 'catg' && pool
  stacked_stratified_noexp <- outcome_type == 'catg' && !pool && !group_used

  # if(j==2) browser()

  data_hovertext <- data_fig %>%
   plotly_viz_make_hover(
    stat_all = stat_all,
    group = if(stacked_stratified_noexp) outcome else group,
    group_label = if(stacked_stratified_noexp) x$outcome$label else x$group$label
   )

  join_names <- intersect(names(data_fig), names(data_hovertext))

  data_fig <- data_fig %>%
   .[statistic == statistic_primary] %>%
   .[data_hovertext, on = join_names] %>%
   droplevels()

  if(group_used && reorder_cats){

   new_levels <- data_fig %>%
    .[, .(mean(estimate)), by = group] %>%
    .[order(V1)] %>%
    .[[group]] %>%
    as.character()

   levels(data_fig[[group]]) <- new_levels

  }

  split_by <- if(stacked_and_pooled || stacked_stratified_noexp){
   outcome
  } else {
   group
  }

  data_fig <- data_fig %>%
   setorderv(cols = split_by) %>%
   split(by = split_by)

  fig <- plot_ly(height = height, width = width)

  bumps <- c(0)

  if(length(data_fig) > 1){

   n_group_cats <- length(data_fig)

   bounds <- n_group_cats * 1/2 * c(-1/10, 1/10)

   bumps <- seq(bounds[1], bounds[2], length.out = length(data_fig))

  }


  for(i in seq_along(data_fig)){

   switch(

    geom,

    'bar' = {

     fig <- fig %>%
      add_trace(
       type = geom,
       x = data_fig[[i]][[ifelse(stacked_and_pooled, group, time_variable)]],
       y = data_fig[[i]]$estimate,
       text = ifelse(test = data_fig[[i]]$unreliable_status,
                     yes = "--",
                     no = table_value(data_fig[[i]]$estimate)),
       textposition = 'top middle',
       name = ifelse(
        test = outcome_type != 'catg' || stacked_and_pooled,
        yes = names(data_fig)[i],
        no = as.character(data_fig[[i]][[outcome]])[1]
       ),
       hoverinfo = 'text',
       hovertext = data_fig[[i]]$hover
      )

    },

    'box' = {

     fig <- fig %>%
      add_trace(
       type = geom,
       x = data_fig[[i]][[time_variable]],
       y = data_fig[[i]]$estimate,
       text = table_value(data_fig[[i]]$estimate),
       name = names(data_fig)[i],
       hoverinfo = 'text',
       hovertext = data_fig[[i]]$hover
      )

    },

    'scatter' = {

     error_y <- list(
      symmetric = FALSE,
      arrayminus = data_fig[[i]]$estimate - data_fig[[i]]$ci_lower,
      array = data_fig[[i]]$ci_upper - data_fig[[i]]$estimate
     )

     marker <- list()
     if(!is.null(size_point)) marker$size <- size_point

     fig <- fig %>%
      add_trace(
       type = geom,
       mode = 'markers',
       marker = marker,
       size = size_error,
       x = as.numeric(data_fig[[i]][[time_variable]]) + bumps[i],
       y = data_fig[[i]]$estimate,
       error_y = error_y,
       name = names(data_fig)[i],
       hoverinfo = 'text',
       hovertext = data_fig[[i]]$hover
      )

    }

   )

  }

  if(geom == 'bar' && outcome_type == 'catg')
   fig %<>% layout(barmode = 'stack')

  xaxis <- yaxis <- list(showgrid = FALSE,
                         showline = TRUE)

  yaxis$ticks = "outside"

  if(geom == 'scatter'){
   tick_vals <- unique(as.numeric(data[[time_variable]]))
   xaxis$tickvals <- tick_vals
   xaxis$ticktext <- levels(data[[time_variable]])[tick_vals]
   xaxis$tickmode <- 'array'
  }

  legend_args <- list()

  if(group_used){

   legend_title <- if(stacked_and_pooled){
    outcome_label
   } else {
    group_label
   }

   legend_title %<>%
    strwrap(width = 20) %>%
    paste(collapse = '\n')

   legend_args$title <- list(
    text = glue("<b>{legend_title}</b>")
   )

  } else if (outcome_type == 'catg'){

   legend_title <- outcome_label %>%
    strwrap(width = 20) %>%
    paste(collapse = '\n')

   legend_args$title <- list(
    text = glue("<b>{legend_title}</b>")
   )

  }

  if(stacked_and_pooled) {

   if(outcome_type == 'catg'){
    # to make a little more room for the second row of the title
    yaxis$range <- list(0, 110)
   }

   # this occurs when there are no title addons to worry about
   if(title_addon[1] == ""){
    # data_fig is always a list of data frames at this point,
    # so just access the first one.
    title_addon <- levels(data_fig[[1]][[time_variable]])
   } else {
    # if there are title addons, split them across each year
    title_addon <- c(levels(data_fig[[time_variable]]),title_addon) %>%
     paste(collapse=", ")
   }


  }


  if(stacked_and_pooled && !group_used){
   tick_vals <- unique(as.numeric(data_fig[[time_variable]]))
   xaxis$tickvals <- tick_vals
   xaxis$ticktext <- levels(data_fig[[time_variable]])[tick_vals]
   xaxis$tickmode <- 'array'
  }

  fig_title <- NULL

  if(is.null(title)){

   fig_title <- list(
    text = paste(c(outcome_label, title_addon), collapse = '<br>'),
    x = 0.5
   )

  } else if (title != ""){

   fig_title <- list(
    text = title,
    x = 0.5
   )

  }

  xaxis$title = ifelse(stacked_and_pooled, group_label %||% "", time_label)

  yaxis$title <- if(outcome_type == 'ctns'){

   x$outcome$label

  } else {

   names(stat_all)[stat_all == statistic_primary]

  }

  output[[j]] <- fig |>
   layout(
    title = fig_title,
    font = list(size = 16),
    margin = list(
     t = 100,
     b = 100,
     l = 50,
     r = 50
    ),
    # to add our names to the plot, uncomment this
    # annotations = list(x = 0.5,
    #                    y = -0.25,
    #                    text = "(Courtesy of Byron, Ligong, and Paul)",
    #                    showarrow = F,
    #                    xref='paper',
    #                    yref='paper'),
    xaxis = xaxis,
    yaxis = yaxis,
    legend = legend_args
   )

 }

 output

}






