
# this is used to identify when a continuous variable
# has been selected. It's tricky b/c you have to write
# the logic in JavaScript (hence the pre-fix jsc)
jsc_write_subset_ctns <- function(input_id, ctns_variables){

 x <- paste('input', input_id, sep = '.')

 ctns_variables_quoted <- paste0("\'",ctns_variables, "\'")

 paste(x, ctns_variables_quoted, sep = ' == ', collapse = ' | ')

 # glue("{x}.length > 0 & ({var_is_ctns})")

}
