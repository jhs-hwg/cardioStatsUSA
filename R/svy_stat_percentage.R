
svy_stat_percentage <- function(outcome, design, ...) {


 if(is_discrete(outcome)){
  design$variables[[outcome]] %<>% as.factor()
 }

 svymean(x = as_svy_formula(outcome),
         design = design,
         na.rm = TRUE) %>%
  svy_stat_adorn(stat_type = 'percentage',
                 stat_fun = 'stat')

}
