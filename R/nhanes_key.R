#' NHANES Variables: Names, Roles, and Descriptions
#'
#' A data frame that describes the elements in `nhanes_data`. Each row
#'   in `nhanes_key` corresponds to a particular variable in `nhanes_data`,
#'   summarizing that variable's information and what roles the variable
#'   can fulfill in the Shiny application.
#'
#' @details Not all variables in `nhanes_data` are described in `nhanes_key`.
#'   For example, `demo_race_black` is not described in `nhanes_key` because
#'   it is only used for calibration of survey weights when counts are
#'   estimated (i.e., it has no direct use in the shiny application).
#'
#' @format A data frame with 97 rows and 11 variables:
#' \describe{
#' \item{class}{The broad class of variables that the current variable belongs to}
#' \item{variable}{The name of the variable in `nhanes_data`}
#' \item{label}{A label that is used to describe the variable in tables and figures}
#' \item{source}{Which NHANES form did this variable come from?}
#' \item{type}{What type of variable this is? `ctns` indicates continous; `catg` categorical; `intg` integer, and `bnry` binary}
#' \item{outcome}{`TRUE/FALSE` - is this variable allowed to be an outcome?}
#' \item{group}{`TRUE/FALSE` - is this variable allowed to be used for groups?}
#' \item{subset}{`TRUE/FALSE` - is this variable allowed to be used for subsetting?}
#' \item{stratify}{`TRUE/FALSE` - is this variable allowed to be used for stratification?}
#' \item{module}{What module does this variable belong to? This is used to subset NHANES data to participants who are included in the given module.}
#' \item{description}{A detailed summary of the variable.}
#' }
"nhanes_key"
