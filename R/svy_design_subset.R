

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
  subset_var,
  subset_values
){

 subset_values_collapsed <- subset_values %>%
  paste(collapse = "\", \"")

 subset_expr <-
  glue("{subset_var} %in% c(\"{subset_values_collapsed}\")") %>%
  parse_expr()

 do.call("subset", args = list(x = design, subset = subset_expr))

}
