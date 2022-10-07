


get_var_info <- function(key, x, field){
 key[[field]][key$variable == x]
}

get_variable_class       <- function(key, x) get_var_info(key, x, 'class')
get_variable_label       <- function(key, x) get_var_info(key, x, 'label')
get_variable_source      <- function(key, x) get_var_info(key, x, 'source')
get_variable_description <- function(key, x) get_var_info(key, x, 'description')
get_variable_type        <- function(key, x) get_var_info(key, x, 'type')
get_variable_subpop      <- function(key, x) get_var_info(key, x, 'subpop')
