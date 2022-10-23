
library(testthat)

key <- nhanes_key$data

test_that(
 desc = 'inverse variables have total discordance',
 code = {

  concordant_accaha <- with(nhanes_data,
                            table(bp_control_accaha,
                                  bp_uncontrolled_accaha)) %>%
   diag() %>%
   sum()

  expect_equal(concordant_accaha, 0)

  concordant_jnc7 <- with(nhanes_data,
                          table(bp_control_jnc7,
                                bp_uncontrolled_jnc7)) %>%
   diag() %>%
   sum()

  expect_equal(concordant_jnc7, 0)


 }

)

# LOCAL tests
# pm_23sep2022 <- haven::read_sas('data-raw/final9920_0923022.sas7bdat')
#
# pm_23jul2022 <- haven::read_sas('data-raw/nhanes_data-raw.sas7bdat')
#
# length(names(pm_23jul2022))
#
# setdiff(names(pm_23jul2022), names(pm_23sep2022))
#
# nhanes_sas <- nhanes_load(as = 'tibble') %>%
#  nhanes_rename()
#
# test_that(
#  desc = 'Number of NAs and category counts match',
#  code = {
#   for(i in names(nhanes_data)){
#
#    type <- key[variable == i, type]
#
#    expect_equal(sum(is.na(nhanes_sas[[i]])),
#                 sum(is.na(nhanes_data[[i]])))
#
#    if(!grepl('^svy_weight', x = i) && i %in% names(nhanes_sas)){
#
#     if(type %in% c('ctns', 'svy') ){
#
#      # these variable should be exactly the same
#      expect_equal(nhanes_sas[[i]], nhanes_data[[i]], ignore_attr = TRUE)
#
#     } else if(type %in% c('catg', 'bnry', 'time')){
#
#      # categorical variables that were recoded should have same counts
#      counts_sas   <- sort(table(nhanes_sas[[i]]))
#      counts_shiny <- sort(table(nhanes_data[[i]]))
#
#      # don't test the counts if I manually lumped categories together
#      if(length(counts_sas) == length(counts_shiny))
#       expect_equal(counts_sas, counts_shiny, ignore_attr = TRUE)
#
#     } else {
#
#      stop("unrecognized variable type: ", type)
#
#     }
#
#    }
#
#   }
#  }
# )



