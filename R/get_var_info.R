


#' Title
#'
#' @param key
#' @param x
#' @param field
#'
#' @return
#' @export
#'
#' @examples
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
get_variable_subpop <- function(x, key) get_var_info(x, key, 'subpop')
