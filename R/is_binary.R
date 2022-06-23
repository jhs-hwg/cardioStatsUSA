#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param variable_name
is_binary <- function(variable_name, key) {

  key$variables[[variable_name]]$type == 'bnry'

}
