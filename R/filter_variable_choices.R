#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param variable_choices
#' @param variables_to_omit
filter_variable_choices <- function(variable_choices, variables_to_omit){

 variable_choices %>%
  map(enframe,
      name = 'variable_label',
      value = 'variable_name') %>%
  rbindlist(idcol = 'variable_class') %>%
  .[ ! (variable_name %in% variables_to_omit) ] %>%
  split(by = 'variable_class', keep.by = FALSE) %>%
  map(deframe)

}
