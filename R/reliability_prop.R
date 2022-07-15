
smry <- tribble(
 ~estimate,	~std_error, ~ci_lower, 	~ci_upper,	~n_eff_SAS,	~kg_wdth_SAS,	~kg_relw_p_SAS,	~kg_relw_q_SAS,	~p_reliable_SAS,	~q_reliable_SAS,	~p_staistical_SAS,
 26.7192,	    1.3762,	   24.0241,	   29.5494,	   1033.87,	   0.055253,	     20.6793,	       7.53994,	            1,	              1,	            0,
 26.3107,	    1.237,	    23.8868,	   28.8466,	   1266.99,	   0.049597,	     18.8507,	       6.73061,	            1,	              1,	            0,
 29.7108,	    1.2419,	   27.2687,	   32.2426,	   1353.97,	   0.049739,	      16.741,	       7.07633,	            1,	              1,	            0,
 29.27,	      1.0892,	   27.1277,	   31.4833,	   1744.97,	   0.043556,	     14.8808,	       6.15808,	            1,	              1,	            0,
 29.8917,	    0.9171,	   28.0858,	   31.7457,	   2491.58,	   0.036599,	      12.244,	       5.22041,	            1,	              1,	            0,
 29.4645,	    1.2401,	   27.0264,	   31.9935,	   1351.43,	   0.049671,	     16.8579,	       7.04196,	            1,	              1,	            0,
 30.1448,	    1.5356,	   27.1274,	   33.2958,	   892.98,	    0.061684,	     20.4627,	       8.83032,	            1,	              1,	            0,
 31.3705,	    0.9034,	   29.5897,	   33.1934,	  2637.86,	    0.036037,	     11.4876,	       5.25096,	            1,	              1,	            0,
 31.3212,	    1.1973,	   28.9629,	   33.7539,	  1500.57,	     0.04791,	     15.2962,	        6.9759,            	1,              	1,	            0,
 32.2631,	    1.1304,	   30.0343,	    34.554,	  1710.23,	    0.045197,	     14.0089,	       6.67245,	            1,	              1,	            0
)

data <- nhanes_load(as = 'tibble', fname = 'small9920.sas7bdat')

design <- svydesign(ids = ~ SDMVPSU,
                    strata = ~ SDMVSTRA,
                    weights = ~ newwt,
                    data = data,
                    nest = TRUE)

###################################Function for reliability of proportion################################
#########################################################################################################
is_reliable_prop <- function(data, design, smry)
 {
 Nobs <- get_obs_count(data)
 Npsu <- get_psu_count(design)
 Nstrata <- get_strata_count(design)

 output <- smry %>%
  mutate(df=Npsu-Nstrata,
         p=estimate/100,
         sep=std_error/100,
         q=1-p,
         df_flag=ifelse(df < 8, 1, 0),
         n_eff = ifelse((0 < p & 1 > p), (p*(1-p))/(sep^2), Nobs),
         n_eff = ifelse((is.na(n_eff) | n_eff > Nobs), Nobs, n_eff),

         #Korn and Graubard CI absolute width:
         kg_wdth=(ci_upper - ci_lower)/100,

         #create proportions and frequencies with confidence intervals
         pct=format(round((estimate), digits=1), nsmall=1),
         lci=format(round((ci_lower), digits=1), nsmall=1),
         uci=format(round((ci_upper), digits=1), nsmall=1),

         CI_prop=glue("{pct}% ({lci}, {uci})"),

         #*Korn and Graubard CI relative width for p
         kg_relw_p=ifelse(p > 0, 100*(kg_wdth/p), NA),

         #*Korn and Graubard CI relative width for q
         kg_relw_q=ifelse(q > 0, 100*(kg_wdth/q), NA),

         #Proportions with CI width <= 0.05 are reliable, unless:
         #if Effective sample size is less than 30, then not reliable;
         #if Absolute CI width is greater than or equal 0.30, then not reliable;
         #if Relative CI width is greater than 130% , then not reliable;
         p_reliable=ifelse((n_eff < 30 | kg_wdth >= 0.30 | (kg_relw_p > 130 & kg_wdth > 0.05 & kg_wdth < 0.3)), 0, 1),

         #Determine if estimate should be flagged as having an unreliable complement;
         #Complementary proportions are reliable, unless Relative CI width is greater than 130% ;
         q_reliable=ifelse((p_reliable==1 & kg_relw_q > 130 & kg_wdth > 0.05 & kg_wdth < 0.3), 0, 1),

         #Estimates with df < 8 or percents = 0 or 100 or unreliable complement are flagged for statistical review;
         p_staistical=ifelse(p_reliable==1 & (df_flag==1 | p==0 | p==1 | q_reliable==0), 1, 0),

         #create the finalized proportions with confidence intervals, with the value suppressed if p_reliable==0
         CI_final=ifelse(p_reliable==0, NA, CI_prop))
}
###################################################################################################
###################################################################################################


reliab_prop <- is_reliable_prop(data, design, smry)
