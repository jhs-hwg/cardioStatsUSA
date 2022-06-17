#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

is_used <- function(x = NULL) {

 if(is.null(x)) return(FALSE)

  !(x == 'None' | is_empty(x))

}
