
#' FILL IN
#'
#' @param dt FILL IN
#' @param type FILL IN
#' @param stat FILL IN
#' @param n_obs FILL IN
#' @param n_psu FILL IN
#' @param n_strata FILL IN
#'
#' @return FILL IN
#'
#' @export
#'
#' @noRd
#'
svy_stat_suppress <- function(dt, type, stat, n_obs, n_psu, n_strata) {

 # fails <- is.nan(dt$std_error) | dt$std_error == 0
 #
 # if(any(fails)){
 #
 #  first_offense <- min(which(fails))
 #
 #  stat_label <- switch(
 #   dt$statistic[first_offense],
 #   "q25" = "25th percentile",
 #   "q50" = "50th percentile",
 #   "q75" = "75th percentile",
 #   dt$statistic[first_offense]
 #  )
 #
 #  outcome_label <- dt$outcome[first_offense]
 #
 #  if(type != 'ctns')
 #   outcome_label <- paste(outcome_label,
 #                          dt$level[first_offense], sep = ' = ')
 #
 #  stop("could not estimate a standard error for the ",
 #       stat_label, " of ", outcome_label, ". ",
 #       "This is probably occurring due to an insufficient ",
 #       "number of observations in the requested data.",
 #       call. = FALSE)
 # }

 suppress_fun <- paste('svy_stat_suppress', type, sep = '_')

 dt$unreliable_status <- rep(FALSE, nrow(dt))
 dt$unreliable_reason <- rep(NA_character_, nrow(dt))
 dt$review_needed <- rep(FALSE, nrow(dt))
 dt$review_reason <- rep(NA_character_, nrow(dt))

 if(stat %in% c('count')) suppress_fun <- 'svy_stat_suppress_ctns'

 out <- do.call(suppress_fun,
                args = list(dt = dt,
                            n_obs = n_obs,
                            n_psu = n_psu,
                            n_strata = n_strata))

}

svy_stat_suppress_ctns <- function(dt, n_obs, n_psu, n_strata){


 # rse: relative standard error
 rse <- dt$std_error / dt$estimate

 if( any(is.nan(rse)) ) rse[is.nan(rse)] <- -Inf

 if(any(rse >= 0.3)){

  dt$unreliable_status[rse >= 0.3] <- TRUE
  dt$unreliable_reason %<>% insert_text(which(rse >= 0.3),
                                        "Relative SE >= 0.30")

 }

 if(any(dt$n_obs < 30)){

  dt$unreliable_status[dt$n_obs < 30] <- TRUE
  dt$unreliable_reason %<>% insert_text(which(dt$n_obs < 30),
                                        "Sample size < 30")

 }


 if(any(is.infinite(rse))){

  dt$unreliable_status[is.infinite(rse)] <- TRUE
  dt$unreliable_reason %<>% insert_text(which(is.infinite(rse)),
                                        "SE unestimable")

 }

 dt

}

svy_stat_suppress_intg <- function(dt, n_obs, n_psu, n_strata){
 svy_stat_suppress_bnry(dt, n_obs, n_psu, n_strata)
}

svy_stat_suppress_catg <- function(dt, n_obs, n_psu, n_strata){
 svy_stat_suppress_bnry(dt, n_obs, n_psu, n_strata)
}

svy_stat_suppress_bnry <- function(dt, n_obs, n_psu, n_strata){

 n_df <- n_psu - n_strata

 # When applicable for complex surveys, if the sample size and confidence
 # interval criteria are met for presentation and the degrees of freedom
 # are fewer than 8, then the proportion should be flagged for statistical
 # review by the clearance official. This review may result in either the
 # presentation or the suppression of the proportion.

 if(n_df < 8){

  dt$review_needed[] <- TRUE
  dt$review_reason[] <- "degrees of freedom < 8"


 }

 p  <- dt$estimate  / 100
 q  <- 1 - p
 se <- dt$std_error / 100

 if(any(p < .Machine$double.eps)){

  dt$review_needed[p < .Machine$double.eps] <- TRUE
  dt$review_reason %<>% insert_text(which(p < .Machine$double.eps),
                                 "Zero events")

 }

 if(any(q < .Machine$double.eps)){

  dt$review_needed[q < .Machine$double.eps] <- TRUE
  dt$review_reason %<>% insert_text(which(q < .Machine$double.eps),
                                 "All observations are events")

 }


 ci_width <- with(dt, (ci_upper - ci_lower) / 100)

 if( any(is.nan(ci_width)) ) ci_width[is.nan(ci_width)] <- Inf

 # Large absolute confidence interval width
 # If the absolute confidence interval width is greater than or
 # equal to 0.30, then the proportion should be suppressed.

 if(any(ci_width >= 0.30)){

  dt$unreliable_status[ci_width >= 0.30] <- TRUE
  dt$unreliable_reason %<>% insert_text(which(ci_width >= 0.30),
                                     "CI width >= 0.30")

 }

 n_eff = ifelse(
  test = (0 < p & p < 1),
  yes = pmin((p * (1 - p)) / (se ^ 2), n_obs),
  no =  n_obs
 )

 if(any(is.na(n_eff))) n_eff[is.na(n_eff)] <- n_obs

 # Sample size (n_eff)
 # Estimated proportions should be based on a minimum denominator sample size
 # and effective denominator sample size (when applicable) of 30. Estimates
 # with either a denominator sample size or an effective denominator sample
 # size (when applicable) less than 30 should be suppressed.

 if(any(n_eff < 30)){

  dt$unreliable_status[n_eff < 30] <- TRUE
  dt$unreliable_reason %<>% insert_text(which(n_eff < 30),
                                     "Effective sample size < 30")

 }

 # Korn and Graubard CI relative width for p
 ci_width_relative_p = ifelse(p > 0, 100*(ci_width / p), NA)

 # Korn and Graubard CI relative width for q
 ci_width_relative_q = ifelse(q > 0, 100*(ci_width / q), NA)


 # Relative confidence interval width
 # If the absolute confidence interval width is between 0.05 and 0.30 and the
 # relative confidence interval width is more than 130%, then the proportion
 # should be suppressed.
 # If the absolute confidence interval width is between 0.05 and 0.30 and the
 # relative confidence interval width is less than or equal to 130%, then the
 # proportion can be presented if the degrees of freedom criterion below is met.

 p_unreliable <- ci_width_relative_p > 130 & ci_width > 0.05 & ci_width < 0.3

 if(any(p_unreliable)){

  dt$unreliable_status[p_unreliable] <- TRUE
  dt$unreliable_reason %<>% insert_text(which(p_unreliable),
                                     "Relative CI width > 130%")

 }

 # Complementary proportions
 # If all criteria are met for presenting the proportion but not for its
 # complement, then the proportion should be shown. A footnote indicating that
 # the complement of the proportion may be unreliable should be provided.

 # Determine if estimate should be flagged as having an unreliable
 # complement; Complementary proportions are reliable unless Relative
 # CI width is greater than 130%;
 q_unreliable <- ci_width_relative_q > 130 & ci_width > 0.05 & ci_width < 0.3

 if(any(q_unreliable)){

  dt$review_needed[q_unreliable] <- TRUE
  dt$review_reason %<>% insert_text(which(q_unreliable),
                                    "Unreliable complement")

 }

 return(dt)

}


insert_text <- function(x, index, text){

 for(i in index){
  if(is.na(x[i])) {
   x[i] <- text
  } else {
   x[i] <- paste(x[i], text, sep = '; ')
  }
 }

 x

}





