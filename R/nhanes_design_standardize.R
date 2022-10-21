

#' Standardize an NHANES design
#'
#' @param x \[nhanes_design\]
#'
#' `r document_nhanes_design()`
#'
#' @param standard_variable \[character(1)\]
#'
#' The name of the variable used to create standardization groups.
#'   The default is to use `demo_age_cat`, which leads to age
#'   standardization.
#'
#' @param standard_weights \[numeric(n)\]
#'
#' The proportionate weights for each group defined by the standard variable.
#'   The number of weights should equal the number of groups defined by
#'   `standard_variable` and all weights must be >0.
#'
#' @return an [nhanes_design] object.
#'
#' @export
#'
nhanes_design_standardize <- function(x,
                                      standard_variable = 'demo_age_cat',
                                      standard_weights = c(0.155,
                                                           0.454,
                                                           0.215,
                                                           0.177)){

 by_vars <- c(x$time$variable,
              x$group$variable,
              x$stratify$variable)

 over <- by_vars %>%
  setdiff(standard_variable) %>%
  as_svy_formula()

 exclude_miss <- c(x$outcome$variable, by_vars) %>%
  setdiff(standard_variable) %>%
  as_svy_formula()

 x$design <- survey::svystandardize(by = as_svy_formula(standard_variable),
                                    over = over,
                                    design = x$design,
                                    population = standard_weights,
                                    excluding.missing = exclude_miss)

 x$standard <- list(variable = standard_variable,
                    weights = standard_weights)

 x$operations <- c(x$operations, 'standardize')

 x

}
