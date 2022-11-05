#' Results from Prior Studies of NHANES Data
#'
#' These datasets contain values from various publications that have been used
#'   to validate the `cardioStatsUSA` shiny application (see [app_run]).
#'
#' @format Data frames with varying numbers of rows and variables.
#' \describe{
#' \item{svy_year}{NHANES cycle.}
#' \item{variable}{variable name.}
#' \item{group}{sub-group defined by variable.}
#' \item{estimate}{point estimate.}
#' \item{std_error}{standard error of the point estimate.}
#' \item{ci_lower}{lower bound of 95% confidence interval for the point estimate.}
#' \item{ci_upper}{upper bound of 95% confidence interval for the point estimate.}
#' }
#'
#' @aliases muntner_jama_2020_etable_1, muntner_hypertension_2022_table_s2,
#'   cdc_db289_figure_2, cdc_db289_figure_2
#' @name replication
"muntner_jama_2020_table_2"

#' @rdname replication
#' @format NULL
"muntner_jama_2020_etable_1"

#' @rdname replication
#' @format NULL
"muntner_hypertension_2022_table_s2"

#' @rdname replication
#' @format NULL
"cdc_db289_figure_1"

#' @rdname replication
#' @format NULL
"cdc_db289_figure_2"

