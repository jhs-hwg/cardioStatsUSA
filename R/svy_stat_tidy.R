
#' standardize survey function outputs
#'
#' @param x output from one of the stat functions.
#' @param outcome the outcome variable
#' @param by_vars variables to stratify by
#'
#' @return a data frame
#'
svy_stat_tidy <- function(x, outcome, by_vars) {

 tidy_fun <-  paste('svy', get_svy_stat_fun(x),
                    'tidy', get_svy_stat_type(x),
                    sep = '_')

 out <- do.call(tidy_fun,
                args = list(x = x,
                            outcome = outcome,
                            by_vars = by_vars))

}






