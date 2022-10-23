
discretize <- function(x, method, n_group){

 breaks <-
  switch(method,
         'frequency' = get_breaks_frequency(x, n_group),
         'interval' = get_breaks_interval(x, n_group))

 labels <- character(n_group)

 for(i in seq_along(labels)){
  labels[i] <- table_glue("{breaks[i]} to <{breaks[i+1]}")
 }

 cut(x,
     breaks = breaks,
     include.lowest = TRUE,
     right = FALSE,
     labels = labels)

}

get_breaks_frequency <- function(x, n_group){

 probs <- seq(0, 1, length.out = n_group+1)

 stats::quantile(x, probs = probs, na.rm = TRUE)

}
get_breaks_interval <- function(x, n_group){

 bounds <- range(x, na.rm = TRUE)

 seq(bounds[1], bounds[2], length.out = n_group+1)

}
