#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param x
#' @param design
#' @param ...
svy_stat_count <- function(outcome, design, key, ...) {

 if(key$variables[[outcome]]$type == 'intg'){

  design$variables[[outcome]] %<>% as.factor()

 }

 svytotal(x = as_svy_formula(outcome),
          na.rm = TRUE,
          design = design) %>%
  svy_stat_adorn(stat_type = 'count',
                 stat_fun = 'stat')


}






