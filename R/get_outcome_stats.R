
get_outcome_stats <- function(outcome_type) {

 switch(
  outcome_type,
  'ctns' = c(Mean = 'mean',
             Quantiles = 'quantile'),
  'catg' = c(Percentage = 'percentage',
             `Percentage (Korn and Graubard CI)` = 'percentage_kg',
             Count = 'count'),
  'bnry' = c(Percentage = 'percentage',
             `Percentage (Korn and Graubard CI)` = 'percentage_kg',
             Count = 'count'),
  'intg' = c(Percentage = 'percentage',
             `Percentage (Korn and Graubard CI)` = 'percentage_kg',
             Count = 'count')
 )

}
