

get_numeric_colnames <- function(dt){

 colnames(dt)[sapply(dt, is.numeric)]

}
