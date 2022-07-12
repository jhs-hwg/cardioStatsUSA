
# make the data used in shiny app
nhanes_bp <-
 nhanes_load(as = 'data.table') %>%
 nhanes_recode() %>%
 nhanes_rename()

usethis::use_data(nhanes_bp, overwrite = TRUE)
