
filter_variable_choices <- function(variable_choices, variables_to_omit){

 variable_choices %>%
  map(tibble::enframe,
      name = 'variable_label',
      value = 'variable_name') %>%
  rbindlist(idcol = 'variable_class') %>%
  .[ ! (variable_name %in% variables_to_omit) ] %>%
  split(by = 'variable_class', keep.by = FALSE) %>%
  map(deframe)

}
