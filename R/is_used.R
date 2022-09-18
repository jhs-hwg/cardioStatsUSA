

is_used <- function(x = NULL) {

 if(is.null(x)) return(FALSE)

 if(is_empty(x)) return(FALSE)

 !(x[1] == 'None')

}
