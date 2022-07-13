

###################################testing the function for reliability of proportion####################
#########################################################################################################
for(i in seq(nrow(reliab_prop))){
 expect_equal(reliab_prop$n_eff_SAS, reliab_prop$n_eff)
 expect_equal(reliab_prop$kg_wdth_SAS, reliab_prop$kg_wdth)
 expect_equal(reliab_prop$kg_relw_p_SAS, reliab_prop$kg_relw_p)
 expect_equal(reliab_prop$kg_relw_q_SAS, reliab_prop$kg_relw_q)
 expect_equal(reliab_prop$p_reliable_SAS, reliab_prop$p_reliable)
 expect_equal(reliab_prop$q_reliable_SAS, reliab_prop$q_reliable)
 expect_equal(reliab_prop$p_staistical_SAS, reliab_prop$p_staistical)
}

