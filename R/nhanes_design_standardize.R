

#' Title
#'
#' @param x
#' @param standard_variable
#' @param standard_weights
#'
#' @return
#' @export
#'
#' @examples
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
