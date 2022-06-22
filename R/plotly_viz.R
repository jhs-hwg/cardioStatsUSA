#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param data
#' @param key
#' @param outcome
#' @param exposure
#' @param stat_all
#' @param statistic_primary
#' @param geom
plotly_viz <- function(data,
                       key,
                       outcome,
                       exposure,
                       group,
                       stat_all,
                       statistic_primary,
                       geom,
                       reorder_cats=TRUE){

 .f <- switch(
  key$variables[[outcome]]$type,
  "bnry" = plotly_viz_bnry,
  "ctns" = plotly_viz_ctns,
  "catg" = plotly_viz_catg,
  "intg" = plotly_viz_intg
 )

 if(is_used(group)){
  data_fig <- split(data, by = group)
 } else {
  data_fig <- list(data)
 }

 map(data_fig,
     .f = .f,
     key = key,
     outcome = outcome,
     exposure = exposure,
     stat_all = stat_all,
     statistic_primary = statistic_primary,
     geom = geom,
     reorder_cats = reorder_cats)

}


plotly_viz_worker <- function(data,
                              key,
                              outcome,
                              exposure,
                              stat_all,
                              statistic_primary,
                              geom,
                              reorder_cats) {

 if('quantile' %in% stat_all){
  stat_all <- c(stat_all, 'q25', 'q50', 'q75')
 }

 data_hovertext <- plotly_viz_make_hover(data, stat_all)

 join_names <- intersect(names(data), names(data_hovertext))

 if(!is_used(exposure)){
  exposure <- 'fake_._exposure'
  data[[exposure]] <- 1
 }

 data_fig <- data %>%
  .[statistic == statistic_primary] %>%
  .[data_hovertext, on = join_names]

 if(is_used(exposure) && reorder_cats){

  new_levels <- data_fig %>%
   .[, .(mean(estimate)), by = exposure] %>%
   .[order(V1)] %>%
   .[[exposure]] %>%
   as.character()

  levels(data_fig[[exposure]]) <- new_levels

 }


 data_fig <- data_fig %>%
  split(by = exposure)

 fig <- plot_ly()

 bumps <- seq(-1/5, 1/5, length.out = length(data_fig))

 for(i in seq_along(data_fig)){

  switch(

   geom,

   'bar' = {

    fig <- fig %>%
     add_trace(
      type = geom,
      x = data_fig[[i]][[key$time_var]],
      y = data_fig[[i]]$estimate,
      text = table_value(data_fig[[i]]$estimate),
      textposition = 'top middle',
      name = names(data_fig)[i],
      hoverinfo = 'text',
      hovertext = data_fig[[i]]$hover
     )

   },

   'box' = {

    fig <- fig %>%
     add_trace(
      type = geom,
      x = data_fig[[i]][[key$time_var]],
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

    if(statistic_primary == 'quantile'){
     error_y <- list(
      symmetric = FALSE,
      arrayminus = data_fig[[i]]$q50 - data_fig[[i]]$q25,
      array = data_fig[[i]]$q75 - data_fig[[i]]$q50
     )
    }

    fig <- fig %>%
     add_trace(
      type = geom,
      mode = 'markers',
      x = as.numeric(data_fig[[i]][[key$time_var]]) + bumps[i],
      y = data_fig[[i]]$estimate,
      error_y = error_y,
      name = names(data_fig)[i],
      hoverinfo = 'text',
      hovertext = data_fig[[i]]$hover
     )

   }

  )

 }

 xaxis <- yaxis <- list()

 if(is_continuous(outcome)){

  tick_vals <- unique(as.numeric(data[[key$time_var]]))
  xaxis$tickvals <- tick_vals
  xaxis$ticktext <- levels(data[[key$time_var]])[tick_vals]
  xaxis$tickmode <- 'array'

 }

 legend_args <- list()

 if(is_used(exposure)){

  legend_title <- key$variables[[exposure]]$label |>
   str_replace_all(" ", "\n")

  legend_args$title <- list(
   text = glue("<b>{legend_title}</b>")
  )

 }

 fig_title <-  key$variables[[outcome]]$label

 xaxis$title = key$variables[[key$time_var]]$label

 yaxis$title <- if(is_continuous(outcome)){

  key$variables[[outcome]]

 } else {

  outcome_type <- key$variables[[outcome]]$type
  stats <- key$svy_calls[[outcome_type]]
  names(stats)[stats == stat_primary]

 }

 fig |>
  layout(
   title = list(
    text = fig_title,
    x = 0.1
   ),
   font = list(size = 16),
   margin = list(
    t = 100,
    b = 100,
    l = 50,
    r = 50
   ),
   xaxis = xaxis,
   yaxis = yaxis,
   legend = legend_args
  )

}


plotly_viz_bnry <- function(data,
                            key,
                            outcome,
                            exposure,
                            stat_all,
                            statistic_primary,
                            geom,
                            reorder_cats){

 data[x == 'Yes', env = list(x = outcome)] %>%
  plotly_viz_worker(key = key,
                    outcome = outcome,
                    exposure = exposure,
                    stat_all = stat_all,
                    statistic_primary = statistic_primary,
                    geom = geom,
                    reorder_cats = reorder_cats)


}

plotly_viz_ctns <- function(data,
                            key,
                            outcome,
                            exposure,
                            stat_all,
                            statistic_primary,
                            geom,
                            reorder_cats){

 data %>%
  plotly_viz_worker(key = key,
                    outcome = outcome,
                    exposure = exposure,
                    stat_all = stat_all,
                    statistic_primary = statistic_primary,
                    geom = geom,
                    reorder_cats = reorder_cats)


}

plotly_viz_catg <- function(data,
                            key,
                            outcome,
                            exposure,
                            stat_all,
                            statistic_primary,
                            geom,
                            reorder_cats){

 data %>%
  plotly_viz_worker(key = key,
                    outcome = outcome,
                    exposure = exposure,
                    stat_all = stat_all,
                    statistic_primary = statistic_primary,
                    geom = geom,
                    reorder_cats = reorder_cats)


}

plotly_viz_intg <- function(data,
                            key,
                            outcome,
                            exposure,
                            stat_all,
                            statistic_primary,
                            geom,
                            reorder_cats){

 data %>%
  plotly_viz_worker(key = key,
                    outcome = outcome,
                    exposure = exposure,
                    stat_all = stat_all,
                    statistic_primary = statistic_primary,
                    geom = geom,
                    reorder_cats = reorder_cats)


}



