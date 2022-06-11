

nhanes_design_new <- function(data, years){

 divide_by <- length(years)

 data_design <- subset(data, surveyyr %in% years)

 svydesign(ids = ~ psu,
           strata = ~strata,
           weights = ~wts_mec_2yr,
           data = data_in,
           nest = TRUE)

}
