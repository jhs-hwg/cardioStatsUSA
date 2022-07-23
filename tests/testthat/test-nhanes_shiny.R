
library(testthat)
library(haven)



nhanes_sas <- here::here() %>%
 file.path('data-raw', 'nhanes_bp-raw.sas7bdat') %>%
 haven::read_sas() %>%
 nhanes_rename()

key <- nhanes_key$data

test_that(
 desc = 'inverse variables have total discordance',
 code = {

  concordant_accaha <- with(nhanes_bp,
                            table(bp_control_accaha,
                                  bp_uncontrolled_accaha)) %>%
   diag() %>%
   sum()

  expect_equal(concordant_accaha, 0)

  concordant_jnc7 <- with(nhanes_bp,
                          table(bp_control_jnc7,
                                bp_uncontrolled_jnc7)) %>%
   diag() %>%
   sum()

  expect_equal(concordant_jnc7, 0)


 }

)

test_that(
 desc = 'Number of NAs and category counts match',
 code = {
  for(i in names(nhanes_bp)){

   type <- key[variable == i, type]

   expect_equal(sum(is.na(nhanes_sas[[i]])),
                sum(is.na(nhanes_bp[[i]])))

   if(i != 'svy_weight' && i %in% names(nhanes_sas)){

    if(type %in% c('ctns', 'svy') ){

     # these variable should be exactly the same
     expect_equal(nhanes_sas[[i]], nhanes_bp[[i]], ignore_attr = TRUE)

    } else if(type %in% c('catg', 'bnry', 'time')){

     # categorical variables that were recoded should have same counts
     counts_sas   <- sort(table(nhanes_sas[[i]]))
     counts_shiny <- sort(table(nhanes_bp[[i]]))

     # don't test the counts if I manually lumped categories together
     if(length(counts_sas) == length(counts_shiny))
      expect_equal(counts_sas, counts_shiny, ignore_attr = TRUE)

    } else {

     stop("unrecognized variable type: ", type)

    }

   }

  }
 }
)



