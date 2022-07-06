

as_svy_formula <- function(x){

 stopifnot(is.character(x))

 x_collapse <- paste(x, collapse = ' + ')

 stats::as.formula( paste("~", x_collapse))

}
