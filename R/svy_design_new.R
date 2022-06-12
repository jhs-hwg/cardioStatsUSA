

#' Make a new design object
#'
#' @param data nhanes data - should be recoded (see [nhanes_recode])
#' @param years the years to be included in the analysis
#'
#' @return a `svydesign` object
#'
svy_design_new <- function(data, years){

 divide_by <- length(years)

 data_design <- subset(data, svy_year %in% years)

 data_design$newwt <- data_design$svy_weight / divide_by

 svydesign(ids = ~ svy_psu,
           strata = ~ svy_strata,
           weights = ~ svy_weight,
           data = data_design,
           nest = TRUE)

}
