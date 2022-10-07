

parse_subset_calls <- function(subset_calls) {

 purrr::map2_chr(
  .x = subset_calls,
  .y = names(subset_calls),
  .f = ~ {
   if(is.character(.x)){
    .x_vec <- paste(parse_subset_value(.x), collapse = ", ")
    glue("{.y} %in% c({.x_vec})")
   } else {
    .x_vec <- paste(.x, collapse = ', ')
    glue("{.y} %between% c({.x_vec})")
   }
  }
 ) %>%
  paste(collapse = ' & ') %>%
  rlang::parse_expr()

}

# only used above
parse_subset_value <- function(x){
 paste("\'", x, "\'", sep = '') %>%
  gsub(pattern = "\'Missing\'",
       replacement = "NA",
       x = .)
}
