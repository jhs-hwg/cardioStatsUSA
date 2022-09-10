

input_infer <- function(x, default){
 if(is_used(x)) return(x)
 default
}
