

#' Make a new design object
#'
#' @param data nhanes data - should be recoded (see [nhanes_recode])
#' @param years the years to be included in the analysis
#'
#' @return a `svydesign` object
#'
svy_design_new <- function(data,
                           exposure,
                           n_exposure_group,
                           exposure_cut_type,
                           years,
                           pool){

 stopifnot(is.data.table(data))

 divide_by <- length(years)

 fctrs <- data %>%
  sapply(is.factor) %>%
  which() %>%
  names()

 if(pool == 'no') divide_by <- 1

 data_design <- data[svy_year %in% years] %>%
  .[, svy_weight := svy_weight / divide_by]

 if(!is_empty(n_exposure_group)){

  data_design <- data_design %>%
   .[,
     x := discretize(x,
                     method = exposure_cut_type,
                     breaks = n_exposure_group),
     env = list(x = exposure)
   ]

 }

  # .[, (fctrs) := lapply(.SD, fctr_dots_add), .SDcols = fctrs]

 svydesign(ids = ~ svy_psu,
           strata = ~ svy_strata,
           weights = ~ svy_weight,
           data = data_design,
           nest = TRUE)

}


fctr_dots_add <- function(fctr){

 levels(fctr) <- paste('..f..', levels(fctr), sep = '')

 fctr

}
