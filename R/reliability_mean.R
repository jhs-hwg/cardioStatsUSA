
is_reliable_mean <- function(smry){
   output <- smry %>%
   #Calculate realtive standard error:
   mutate(rse=std_error/mean,

          # if rse>=.3 then p_reliable=0;
          p_reliable=ifelse(rse>=0.3, 0, 1),

          #create means with confidence intervals
          means=format(round((mean), digits=1), nsmall=1),
          se=format(round((std_error), digits=1), nsmall=1),

          CI_mean=glue("{means} ({se})"),

          #create the finalized means with confidence intervals, with the value suppressed if p_reliable==0
          CI_final=ifelse(p_reliable==0, NA, CI_mean))
 }
