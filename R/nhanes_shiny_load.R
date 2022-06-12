


nhanes_shiny_load <- function(){

 if(!file.exists('data/nhanes_shiny.csv')){

  nhanes_data <- nhanes_shiny_make(write_data = FALSE)

  fwrite(nhanes_data, 'data/nhanes_shiny.csv')

  return(nhanes_data)

 }

 fread('data/nhanes_shiny.csv', na.strings = c('', 'NA'))

}
