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
                       outcome_type,
                       exposure,
                       group,
                       stat_all,
                       statistic_primary,
                       geom,
                       years,
                       pool,
                       reorder_cats=FALSE){

 if(outcome_type == 'intg' && statistic_primary != 'quantile'){
  outcome_type <- 'catg'
 }

 if(outcome_type == 'catg' && pool == 'no'){

  if(is_used(exposure) && is_used(group)){

   exposure_label <- key$variables[[exposure]]$label
   env <- list(g = group, e = exposure)

   data <- data %>%
    .[, e := paste(exposure_label, e, sep = ' = '), env = env] %>%
    .[, g := paste(g, e, sep = '; '), env = env] %>%
    .[, e := NULL, env = env]

   exposure <- NULL


  } else if (is_used(exposure) && !is_used(group)){

   group <- exposure
   exposure <- NULL

  }

 }

 if( pool == 'yes' ){

  data[[key$time_var]] <-
   as.factor(glue("{years[1]} through {years[length(years)]}"))

 }

 if(outcome_type == 'bnry')
  data <- data[x == 'Yes', env = list(x = outcome)]

 if(is_used(group)){

  data_fig <- split(data, by = group) %>%
   discard(~nrow(.x) == 0)

  title_addons <- paste(key$variables[[group]]$label,
                        names(data_fig), sep = ' = ')

 } else {
  data_fig <- list(data)
  title_addons <- ""
 }

 map2(data_fig,
      title_addons,
      .f = plotly_viz_worker,
      key = key,
      outcome = outcome,
      outcome_type = outcome_type,
      exposure = exposure,
      stat_all = stat_all,
      statistic_primary = statistic_primary,
      geom = geom,
      pool = pool,
      reorder_cats = reorder_cats)

}


plotly_viz_worker <- function(data,
                              title_addon,
                              key,
                              outcome,
                              outcome_type,
                              exposure,
                              stat_all,
                              statistic_primary,
                              geom,
                              pool,
                              reorder_cats) {

 if(nrow(data) == 0) return(NULL)

 if('quantile' %in% stat_all){
  stat_all <- c(stat_all, 'q25', 'q50', 'q75')
 }

 if(statistic_primary == 'quantile'){
  statistic_primary <- 'q50'
 }

 exposure_used <- is_used(exposure)

 stacked_and_pooled <-
  outcome_type == 'catg' && pool == 'yes'

 stacked_stratified_noexp <-
  outcome_type == 'catg' && pool == 'no' && !exposure_used

 data_hovertext <- data %>%
  plotly_viz_make_hover(
   stat_all = stat_all,
   exposure = ifelse(stacked_stratified_noexp, outcome, exposure),
   key = key
  )

 if(!exposure_used){
  exposure <- 'fake_._exposure'
  data[[exposure]] <- 1
 }

 join_names <- intersect(names(data), names(data_hovertext))

 data_fig <- data %>%
  .[statistic == statistic_primary] %>%
  .[data_hovertext, on = join_names] %>%
  droplevels()

 if(exposure_used && reorder_cats){

  new_levels <- data_fig %>%
   .[, .(mean(estimate)), by = exposure] %>%
   .[order(V1)] %>%
   .[[exposure]] %>%
   as.character()

  levels(data_fig[[exposure]]) <- new_levels

 }

 data_fig <- data_fig %>%
  split(
   by = ifelse(
    test = stacked_and_pooled || stacked_stratified_noexp,
    yes = outcome,
    no = exposure
   )
  )

 fig <- plot_ly(height = 600)

 bumps <- c(0)

 if(length(data_fig) > 1){

  n_exposure_cats <- length(data_fig)

  bounds <- n_exposure_cats * 1/2 * c(-1/10, 1/10)

  bumps <- seq(bounds[1], bounds[2], length.out = length(data_fig))

 }

 # browser()

 for(i in seq_along(data_fig)){

  switch(

   geom,

   'bar' = {

    fig <- fig %>%
     add_trace(
      type = geom,

      x = data_fig[[i]][[ifelse(stacked_and_pooled,
                                exposure,
                                key$time_var)]],

      y = data_fig[[i]]$estimate,
      text = table_value(data_fig[[i]]$estimate),
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

 if(geom == 'bar' && outcome_type == 'catg')
  fig %<>% layout(barmode = 'stack')

 xaxis <- yaxis <- list()

 if(geom == 'scatter'){
  tick_vals <- unique(as.numeric(data[[key$time_var]]))
  xaxis$tickvals <- tick_vals
  xaxis$ticktext <- levels(data[[key$time_var]])[tick_vals]
  xaxis$tickmode <- 'array'
 }

 legend_args <- list()

 if(exposure_used){

  legend_title <- key %>%
   getElement('variables') %>%
   getElement(ifelse(stacked_and_pooled, outcome, exposure)) %>%
   getElement('label') %>%
   str_replace_all(" ", "\n")

  legend_args$title <- list(
   text = glue("<b>{legend_title}</b>")
  )

 }

 if(stacked_and_pooled) title_addon <- levels(data[[key$time_var]])

 fig_title <-  paste(c(key$variables[[outcome]]$label, title_addon),
                     collapse = '<br>')

 xaxis$title = ifelse(stacked_and_pooled,
                      key$variables[[exposure]]$label %||% "",
                      key$variables[[key$time_var]]$label)

 yaxis$title <- if(outcome_type == 'ctns'){

  key$variables[[outcome]]

 } else {

  stats <- key$svy_calls[[outcome_type]]
  names(stats)[stats == statistic_primary]

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
   annotations = list(x = 0.5,
                      y = -0.25,
                      text = "(Courtesy of Byron, Ligong, and Paul)",
                      showarrow = F,
                      xref='paper',
                      yref='paper'),
   xaxis = xaxis,
   yaxis = yaxis,
   legend = legend_args
  )

}




