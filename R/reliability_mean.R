
smry <- tribble(
    ~mean,   ~std_error,	   ~rse_SAS,	  ~p_reliable_SAS,
 122.905881, 	0.705291,	  0.005738467,	      1,
 122.498262, 	0.468373,	  0.003823505,      	1,
 122.897972, 	0.512017,	  0.004166197,      	1,
 122.426106,	 0.449395,  	0.003670743,      	1,
 121.593005, 	0.377465,	  0.003104331,	      1,
 120.455949, 	0.4852,	    0.004028026,      	1,
 121.533461, 	0.650174,	  0.005349757,      	1,
 121.478507, 	0.314299,	  0.002587284,	      1,
 123.321755,	 0.460828,	  0.003736795,	      1,
 123.097127,	 0.369664,	  0.003003027,	      1
 )

###################################Function for reliability of mean######################################
#########################################################################################################
is_reliable_mean <- function(smry)
 {
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
##########################################################################################################
##########################################################################################################

reliab_mean<- is_reliable_mean(smry)
