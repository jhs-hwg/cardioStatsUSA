

#' Write rules for conditional panels in JavaScript
#'
#' @param key_data the data element from key
#' @param var_type can be 'ctns', 'bnry', or 'ttev'
#' @param var_role can be 'outcome', 'exposure', or 'group'
#'
#' @return a string that should be placed into the condition
#'   arg of conditionalPanel
#'
#' @noRd
#'
jsc_write_cpanel <- function(key_data, var_type, var_role){

 variable_names <- key_data %>%
  .[type == var_type & .[[var_role]] == TRUE] %>%
  .[['variable']]

 if(is_empty(variable_names))
  return("false")

 c_init <- glue("input.{var_role} == '{variable_names}'") %>%
  glue_collapse(sep = ' | ')


 glue("input.{var_role}.length > 0 & ({c_init})")

}





