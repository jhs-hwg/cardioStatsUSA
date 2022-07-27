
# make the data used in shiny app
nhanes_bp <-
 nhanes_load(as = 'tibble') %>%
 nhanes_recode() %>%
 nhanes_rename()

setDT(nhanes_bp)

usethis::use_data(nhanes_bp, overwrite = TRUE)
