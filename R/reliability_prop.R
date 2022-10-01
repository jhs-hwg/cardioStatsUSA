

# reliability of proportions

add_reliability <- function(smry, design) {

 n_obs <- get_obs_count(design)
 n_psu <- get_psu_count(design)
 n_strata <- get_strata_count(design)

 degrees_of_freedom <- n_psu - n_strata

 smry$reliable <- 0

 smry[statistic == 'percentage',
      reliable := is_perc_reliable(p = estimate/100,
                                   se = std_error/100,
                                   ci_width = (ci_upper - ci_lower)/100,
                                   df = degrees_of_freedom,
                                   n_obs = n_obs)]

}

is_perc_reliable <- function(p, se, ci_width, df, n_obs){

 browser()

 q = 1 - p

 df_flag = ifelse(df < 8, 1, 0)

 n_eff = ifelse((0 < p & 1 > p), (p * (1 - p)) / (se ^ 2), n_obs)
 n_eff = ifelse(is.na(n_eff) | n_eff > n_obs, n_obs, n_eff)

 # Korn and Graubard CI relative width for p
 ci_width_p = ifelse(p > 0, 100 * (ci_width / p), NA)

 # Korn and Graubard CI relative width for q
 ci_width_q = ifelse(q > 0, 100 * (ci_width / q), NA)

 ci_width_p

 # Proportions with CI width <= 0.05 are reliable, unless:
 # if Effective sample size is less than 30, then not reliable;
 # if Absolute CI width is greater than or equal 0.30, then not reliable;
 # if Relative CI width is greater than 130% , then not reliable;
 p_reliable <- n_eff < 30 | ci_width >= 0.30 |
  (ci_width_p > 130 & ci_width > 0.05 & ci_width < 0.3)

 # Determine if estimate should be flagged as having an unreliable
 # complement; Complementary proportions are reliable unless Relative
 # CI width is greater than 130%;
 q_reliable = ci_width_q > 130 & ci_width > 0.05 & ci_width < 0.3

 # estimates with df < 8 or percents = 0 or 100 or unreliable
 # complement are flagged for statistical review;
 p_statistical = ifelse(
  p_reliable == 1 & (df_flag == 1 | p == 0 | p == 1 | q_reliable == 0),
  yes = 1,
  no = 0
 )

}
