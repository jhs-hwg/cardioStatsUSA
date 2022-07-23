# TODO
# smry <- tribble(
#  ~estimate,	~std_error, ~ci_lower, 	~ci_upper,	~n_eff_SAS,	~kg_wdth_SAS,	~kg_relw_p_SAS,	~kg_relw_q_SAS,	~p_reliable_SAS,	~q_reliable_SAS,	~p_staistical_SAS,
#  26.7192,	    1.3762,	   24.0241,	   29.5494,	   1033.87,	   0.055253,	     20.6793,	       7.53994,	            1,	              1,	            0,
#  26.3107,	    1.237,	    23.8868,	   28.8466,	   1266.99,	   0.049597,	     18.8507,	       6.73061,	            1,	              1,	            0,
#  29.7108,	    1.2419,	   27.2687,	   32.2426,	   1353.97,	   0.049739,	      16.741,	       7.07633,	            1,	              1,	            0,
#  29.27,	      1.0892,	   27.1277,	   31.4833,	   1744.97,	   0.043556,	     14.8808,	       6.15808,	            1,	              1,	            0,
#  29.8917,	    0.9171,	   28.0858,	   31.7457,	   2491.58,	   0.036599,	      12.244,	       5.22041,	            1,	              1,	            0,
#  29.4645,	    1.2401,	   27.0264,	   31.9935,	   1351.43,	   0.049671,	     16.8579,	       7.04196,	            1,	              1,	            0,
#  30.1448,	    1.5356,	   27.1274,	   33.2958,	   892.98,	    0.061684,	     20.4627,	       8.83032,	            1,	              1,	            0,
#  31.3705,	    0.9034,	   29.5897,	   33.1934,	  2637.86,	    0.036037,	     11.4876,	       5.25096,	            1,	              1,	            0,
#  31.3212,	    1.1973,	   28.9629,	   33.7539,	  1500.57,	     0.04791,	     15.2962,	        6.9759,            	1,              	1,	            0,
#  32.2631,	    1.1304,	   30.0343,	    34.554,	  1710.23,	    0.045197,	     14.0089,	       6.67245,	            1,	              1,	            0
# )
#
# data <- nhanes_load(as = 'tibble', fname = 'nhanes_bp-raw.sas7bdat')
#
# design <- svydesign(ids = ~ SDMVPSU,
#                     strata = ~ SDMVSTRA,
#                     weights = ~ newwt,
#                     data = data,
#                     nest = TRUE)
#
#
# ###################################testing the function for reliability of proportion####################
# #########################################################################################################
# for(i in seq(nrow(reliab_prop))){
#  expect_equal(reliab_prop$n_eff_SAS, reliab_prop$n_eff)
#  expect_equal(reliab_prop$kg_wdth_SAS, reliab_prop$kg_wdth)
#  expect_equal(reliab_prop$kg_relw_p_SAS, reliab_prop$kg_relw_p)
#  expect_equal(reliab_prop$kg_relw_q_SAS, reliab_prop$kg_relw_q)
#  expect_equal(reliab_prop$p_reliable_SAS, reliab_prop$p_reliable)
#  expect_equal(reliab_prop$q_reliable_SAS, reliab_prop$q_reliable)
#  expect_equal(reliab_prop$p_staistical_SAS, reliab_prop$p_staistical)
# }
#





































