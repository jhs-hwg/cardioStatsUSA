

is_discrete <- function(variable_name){
 key$variables[[variable_name]]$type %in% c('bnry', 'catg')
}
