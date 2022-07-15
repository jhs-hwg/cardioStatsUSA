
#' @title Load the nhanes data
#'
#' No re-coding is applied.
#'
#' @param as The class of data set to be returned. Valid options are
#'  'tibble', 'data.frame', or 'data.table'.
#'
#' @param fname the file name to load from the data directory
#'
#' @return data set inheriting from `as`
#'
#' @noRd
#'
nhanes_load <- function(as = 'tibble', fname = 'small9920.sas7bdat'){

 if(!file.exists(file.path(here::here(), 'data-raw', fname))){
  stop("the file \'", fname, "\' could not be found in data-raw/\n",
       "do you need to download ", fname, " from ",
       "https://github.com/jhs-hwg/nhanesShinyBP?")
 }

 data_in <- haven::read_sas(
  file.path(here::here(), 'data-raw', 'small9920_07142022v2.sas7bdat')
 )

 switch(
  as,
  'tibble' = tibble::as_tibble(data_in),
  'data.frame' = as.data.frame(data_in),
  'data.table' = data.table::as.data.table(data_in),
  stop("unrecognized return type: ", as, call. = FALSE)
 )

}
