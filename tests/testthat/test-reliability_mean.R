

###################################testing the function for reliability of mean######################
#########################################################################################################
for(i in seq(nrow(reliab_mean))){
 expect_equal(reliab_mean$rse_SAS, reliab_mean$rse)
 expect_equal(reliab_mean$p_reliable_SAS, reliab_mean$p_reliable)
}
