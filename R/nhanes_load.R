
#' @title Load the nhanes data
#'
#' No re-coding is applied.
#'
#' @param as The class of data set to be returned. Valid options are
#'  'tibble', 'data.frame', or 'data.table'.
#'
#' @return data set inheriting from `as`
#'
#' @noRd
#'
nhanes_load <- function(fpath = file.path(here::here(), 'data-raw'),
                        as = 'tibble'){

 data_bp <- haven::read_sas(
  file.path(fpath, 'nhanes_bp-raw.sas7bdat')
 )

 data_lipids <- haven::read_sas(
  file.path(fpath, 'nhanes_lipids-raw.sas7bdat')
 )

 out <- left_join(data_bp, data_lipids) %>%
  mutate(subpopldl = replace(subpopldl, is.na(subpopldl), 0))

 # data_lipids %>% filter(SEQN == 31720)
 # temporary fix
 # out <- out %>%
 #  dplyr::group_by(SEQN) %>%
 #  dplyr::slice(1)


 switch(
  as,
  'tibble' = tibble::as_tibble(out),
  'data.frame' = as.data.frame(out),
  'data.table' = data.table::as.data.table(out),
  stop("unrecognized return type: ", as, call. = FALSE)
 )

}
