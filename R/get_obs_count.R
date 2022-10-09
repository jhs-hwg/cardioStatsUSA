

get_obs_count <- function(design, weighted = FALSE){

 if(!weighted) return(
  nrow(design$variables)
 )

 if("svy_weight_cal" %in% names(design$variables))
  return(
   round(sum(design$variables$svy_weight_cal, na.rm = TRUE))
  )

 round(sum(1/design$prob, na.rm = TRUE))


}
