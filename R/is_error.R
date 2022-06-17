#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param x
is_error <- function(x) {

  inherits(x, 'try-error')

}
