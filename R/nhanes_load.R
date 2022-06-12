
#' Load the nhanes data
#'
#' No re-coding is applied.
#'
#' @param as The class of data set to be returned. Valid options are
#'  'tibble', 'data.frame', or 'data.table'.
#'
#' @return data set inheriting from `as`
#'
nhanes_load <- function(as = 'tibble'){

 data_in <- read_sas('data/small9920.sas7bdat')

 switch(
  as,
  'tibble' = as_tibble(data_in),
  'data.frame' = as.data.frame(data_in),
  'data.table' = as.data.table(data_in),
  stop("unrecognized return type: ", as, call. = FALSE)
 )

}
