
library(testthat)
library(haven)

test_that("nhanes_bp data matches source data from SAS", {

 nhanes_sas <- here::here() %>%
  file.path('data-raw', 'small9920.sas7bdat') %>%
  haven::read_sas() %>%
  nhanes_rename()

 nhanes_key <- here() %>%
  file.path('data-raw', 'nhanes_key.csv') %>%
  fread()

 # number of NAs should match:

 for(i in names(nhanes_bp)){

  type <- nhanes_key[variable == i, type]

  expect_equal(sum(is.na(nhanes_sas[[i]])),
               sum(is.na(nhanes_bp[[i]])))

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

})

