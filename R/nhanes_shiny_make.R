

#' make the data used in shiny app
#'
#' 'make' means we can use this function to make a file in the data directory.
#'
#' @param write_data if `TRUE`, the file is written.
#'   If `FALSE`, data are returned and no file is written.
#'
nhanes_shiny_make <- function(write_data = TRUE){

 nhanes_data <- nhanes_load(as = 'data.table') %>%
  nhanes_recode() %>%
  nhanes_rename()

 if(!write_data) return(nhanes_data)

 nhanes_fctrs <- nhanes_data %>%
  select(where(is.factor)) %>%
  map(levels)

 write_rds(nhanes_fctrs, 'data/nhanes_shiny_fctrs.rds')

 fwrite(nhanes_data, 'data/nhanes_shiny.csv')

 NULL

}


