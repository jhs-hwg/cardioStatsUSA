

#' subset a svy design object
#'
#' @param design A survey design object.
#'
#' @param subset_var (_character_[length 1]) the variable to subset with.
#'
#' @param subset_values (_character_[length 1+]) the values of the subset
#'   variable that will be retained.
#'
svy_design_subset <- function(
  design,
  subset_calls
){

 subset_arg <- map(
  .x = subset_calls,
  .f = paste,
  collapse = "\", \""
 ) %>%
  map2_chr(
   .y = names(subset_calls),
   .f = ~ glue("{.y} %in% c(\"{.x}\")")
  ) %>%
  paste(collapse = ' & ') %>%
  parse_expr()

 do.call("subset", args = list(x = design, subset = subset_arg))

}
