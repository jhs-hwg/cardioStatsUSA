

#' make the data used in shiny app
#'
#' 'make' means we can use this function to make a file in the data directory.
#'
#' @param write_data if `TRUE`, the file is written.
#'   If `FALSE`, data are returned and no file is written.
#'
nhanes_bp_make <- function(){

 nhanes_data <-
  nhanes_load(as = 'data.table') %>%
  nhanes_recode() %>%
  nhanes_rename()

 nhanes_fctrs <- nhanes_data %>%
  select(where(is.factor)) %>%
  map(levels)

 readr::write_rds(nhanes_fctrs,
                  file.path(here::here(),
                            'data',
                            'nhanes_bp_fctrs.rds'))


 nhanes_data

}


