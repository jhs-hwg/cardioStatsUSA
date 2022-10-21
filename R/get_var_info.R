


#' Title
#'
#' @param x \[character(1)\]
#'
#' a variable name that is present in the `variable` column of `key`
#'
#' @param key \[data.frame\]
#'
#' `r describe_nhanes_key_input()`
#'
#' @param field \[character(1)\]
#'
#' the column name in `nhanes_key` to get information from.
#'
#' @return a character value
#'
#' @export
#'
#' @examples
#'
#' # the low-level working function
#' get_var_info('bp_sys_mean', key = nhanes_key, field = 'class')
#'
#' # the convenience functions
#' get_variable_class('bp_sys_mean')
#' get_variable_label('bp_sys_mean')
#' get_variable_source('bp_sys_mean')
#' get_variable_description('bp_sys_mean')
#' get_variable_module('bp_sys_mean')
#'

get_var_info <- function(x, key, field){
 if(missing(key)) key <- cardioStatsUSA::nhanes_key
 key[[field]][key$variable == x]
}

#' @rdname get_var_info
#' @export
get_variable_class <- function(x, key) get_var_info(x, key, 'class')
#' @rdname get_var_info
#' @export
get_variable_label <- function(x, key) get_var_info(x, key, 'label')
#' @rdname get_var_info
#' @export
get_variable_source <- function(x, key) get_var_info(x, key, 'source')
#' @rdname get_var_info
#' @export
get_variable_description <- function(x, key) get_var_info(x, key, 'description')
#' @rdname get_var_info
#' @export
get_variable_type <- function(x, key) get_var_info(x, key, 'type')
#' @rdname get_var_info
#' @export
get_variable_module <- function(x, key) get_var_info(x, key, 'module')
