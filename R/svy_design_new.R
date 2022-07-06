

#' Make a new design object
#'
#' @param data nhanes data - should be recoded (see [nhanes_recode])
#' @param years the years to be included in the analysis
#' @param exposure the exposure variable
#' @param n_exposure_group how many exposure groups? only applies to
#'  continuous exposure variables
#' @param exposure_cut_type how to cut the exposure groups? only applies to
#'  continuous exposure variables.
#' @param pool are the results pooled across multiple NHANES cycles?
#'  if so, say 'yes', o.w. say 'no'
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


 fctrs <- data %>%
  sapply(is.factor) %>%
  which() %>%
  names()

 divide_by <- length(years)

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
