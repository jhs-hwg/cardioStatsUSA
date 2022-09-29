
# make the data used in shiny app
source(file.path(here::here(), "data-raw", "nhanes_load.R"))
source(file.path(here::here(), "data-raw", "nhanes_recode.R"))
source(file.path(here::here(), "data-raw", "nhanes_rename.R"))

nhanes_bp <-
 nhanes_load(as = 'tibble') %>%
 nhanes_recode() %>%
 nhanes_rename()

setDT(nhanes_bp)

nhanes_key <- cardioStatsUSA::nhanes_key

for(i in names(nhanes_bp)){
 if(is.null(attr(nhanes_bp[[i]], 'label'))){
  attr(nhanes_bp[[i]], 'label') <- nhanes_key$variables[[i]]$label
 }
}

usethis::use_data(nhanes_bp, overwrite = TRUE)
