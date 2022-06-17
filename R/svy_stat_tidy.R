#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param svystat
svy_stat_tidy <- function(x, outcome, by_vars) {

 tidy_fun <-  paste('svy', get_svy_stat_fun(x),
                    'tidy', get_svy_stat_type(x),
                    sep = '_')

 do.call(tidy_fun, args = list(x = x,
                               outcome = outcome,
                               by_vars = by_vars))

}






