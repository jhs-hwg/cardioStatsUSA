

#' subset a svy design object
#'
#' @param design A survey design object.
#'
#' @param subset_calls expressions for subset to evaluate
#'
#' @noRd
#'
svy_design_subset <- function(
  design,
  subset_calls
){

 if(is_empty(subset_calls)) return(design)

 subset_arg <- map(
  .x = subset_calls,
  .f = parse_subset_values
 ) %>%
  map2_chr(
   .y = names(subset_calls),
   .f = ~ glue("{.y} %in% c({.x})") # \"{.x}\"
  ) %>%
  paste(collapse = ' & ') %>%
  parse_expr()

 do.call("subset", args = list(x = design, subset = subset_arg))

}

# only used above

parse_subset_values <- function(x){
 paste(parse_subset_value(x), collapse = ", ")
}

parse_subset_value <- function(x){
 paste("\'", x, "\'", sep = '') %>%
  stringr::str_replace("\'Missing\'", "NA")
}
