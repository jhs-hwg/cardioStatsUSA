

is_var_type <- function(var_name, var_types){
 if(is.null(var_name)) return(FALSE)
 cardioStats.USA::nhanes_key$variables[[var_name]]$type %in% var_types
}

is_binary <- function(variable_name) {

 is_var_type(variable_name, 'bnry')

}

is_discrete <- function(variable_name){

 is_var_type(variable_name, c('bnry', 'catg', 'intg'))

}


is_continuous <- function(variable_name) {

 is_var_type(variable_name, 'ctns')

}
