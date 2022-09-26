

# reliability of proportions

is_reliable_prop <- function(data, design, smry) {
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
