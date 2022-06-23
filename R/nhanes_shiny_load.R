


nhanes_shiny_load <- function(){

 fpath_data <- here() %>%
  file.path('data')

 if(!file.exists(file.path(fpath_data, 'nhanes_shiny.csv'))){

  nhanes_data <- nhanes_shiny_make(write_data = FALSE)

  fwrite(nhanes_data, file.path(fpath_data, 'nhanes_shiny.rds'))

  return(nhanes_data)

 }

 data_in <- fread(file.path(fpath_data, 'nhanes_shiny.csv'))

 fctrs <- read_rds(file.path(fpath_data, 'nhanes_shiny_fctrs.rds'))

 for(f in names(fctrs))
  data_in[, .f := factor(.f, levels = fctrs[[f]]), env = list(.f=f)]

 data_in

}
