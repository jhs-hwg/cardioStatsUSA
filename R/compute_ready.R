
compute_ready <- function(){
 "(
   (input.pool == 'no' & input.year_stratify.length > 0) |
   input.pool == 'yes')
    & (
   input.outcome.length > 0
  )
    & (
   input.statistic.length > 0
  )"
}
