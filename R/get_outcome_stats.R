
get_outcome_stats <- function(outcome_type) {

 switch(
  outcome_type,
  'ctns' = c(Mean = 'mean', Quantiles = 'quantile'),
  'catg' = c(Percentage = 'percentage', Count = 'count'),
  'bnry' = c(Percentage = 'percentage', Count = 'count'),
  'intg' = c(Percentage = 'percentage', Count = 'count')
 )

}
