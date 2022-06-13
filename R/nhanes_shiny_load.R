


nhanes_shiny_load <- function(){

 if(!file.exists('data/nhanes_shiny.csv')){

  nhanes_data <- nhanes_shiny_make(write_data = FALSE)

  fwrite(nhanes_data, 'data/nhanes_shiny.rds')

  return(nhanes_data)

 }

 data_in <- fread('data/nhanes_shiny.csv',
                  na.strings = c('', 'NA'),
                  stringsAsFactors = TRUE)

 fctrs <- read_rds('data/nhanes_shiny_fctrs.rds')

 for(f in names(fctrs)) levels(data_in[[f]]) <- fctrs[[f]]

 data_in

}
