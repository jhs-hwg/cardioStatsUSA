
library(cardioStatsUSA)
library(magrittr)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.height = 5,
  fig.width = 8,
  echo = FALSE
)


text_vignette <- function(x){


 x_out <-
  gsub(pattern = 'blood pressure', replacement = 'BP', x = x, fixed = TRUE)

 x_out <-
  gsub(pattern = '\\u2265', replacement = '>=', x = x_out, fixed = TRUE)

 x_out <-
  gsub(pattern = '≥', replacement = '>=', x = x_out, fixed = TRUE)

 x_out

}

plotly_vignette <- function(x,
                            yaxis_text = 'Percentage',
                            xaxis_text = 'NHANES cycle'){

 margin <- list(l = 25, r = 25, b = 25, t = 0)
 yaxis  <- list(title = list(text = yaxis_text, standoff = 15L))
 xaxis  <- list(title = list(text = xaxis_text, standoff = 15L))


 x[[1]] %>%
  plotly::layout(margin = margin,
                 yaxis = yaxis,
                 xaxis = xaxis) %>%
  plotly::config(displayModeBar = F)

}

make_plot <- function(outcome_variable = NULL,
                      group_variable = NULL,
                      time_values = 'all',
                      subset_addons = NULL,
                      outcome_stats = 'percentage',
                      ...){

 if(is.null(outcome_variable)){
  outcome_variable <- get("outcome_variable", envir = .GlobalEnv)
 }

 .subset_calls <- c(subset_calls, subset_addons)

 plotly_vignette(
  nhanes_visualize(
   data = nhanes_data,
   key = nhanes_key,
   outcome_variable = outcome_variable,
   outcome_stats = outcome_stats,
   group_variable = group_variable,
   subset_calls = .subset_calls,
   time_values = time_values,
   title = "",
   ...)
 )

}
