
svy_stat_prop <- function(outcome, cat, design, ...) {

 if(is_discrete(outcome)){
  design$variables[[outcome]] <- as.factor(design$variables[[outcome]])
 }

svyciprop(~I(outcome==cat), design = design, method="beta") %>%
  svy_stat_adorn(stat_type = 'proportion',
                 stat_fun = 'stat')
}

