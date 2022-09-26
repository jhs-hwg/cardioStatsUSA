
# make the data used in shiny app
source(file.path(here::here(), "data-raw", "nhanes_load.R"))
source(file.path(here::here(), "data-raw", "nhanes_recode.R"))
source(file.path(here::here(), "data-raw", "nhanes_rename.R"))

nhanes_bp <-
 nhanes_load(as = 'tibble') %>%
 nhanes_recode() %>%
 nhanes_rename()

setDT(nhanes_bp)

usethis::use_data(nhanes_bp, overwrite = TRUE)
