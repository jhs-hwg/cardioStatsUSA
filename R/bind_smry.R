
bind_smry <- function(x, y){

 outcome   <- attr(x, "outcome")
 exposure  <- attr(x, "exposure")
 statistic <- attr(x, "statistic")
 group     <- attr(x, "group")

 if(is.null(outcome)){

  outcome   <- attr(y, "outcome")
  exposure  <- attr(y, "exposure")
  statistic <- attr(y, "statistic")
  group     <- attr(y, "group")

 }

 output <- rbindlist(list(x, y))

 attr(output, "outcome")   <- outcome
 attr(output, "exposure")  <- exposure
 attr(output, "statistic") <- statistic
 attr(output, "group")     <- group

 output

}
