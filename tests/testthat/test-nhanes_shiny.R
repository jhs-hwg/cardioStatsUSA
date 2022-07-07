
library(testthat)
library(haven)

test_that("nhanes_shiny data matches source data from SAS", {

 nhanes_shiny <- nhanes_bp

 nhanes_sas <- here() %>%
  file.path('data-raw', 'small9920.sas7bdat') %>%
  read_sas() %>%
  nhanes_rename()

 nhanes_key <- here() %>%
  file.path('data-raw', 'nhanes_key.csv') %>%
  fread()

 # number of NAs should match:

 for(i in names(nhanes_shiny)){

  type <- nhanes_key[variable == i, type]

  expect_equal(sum(is.na(nhanes_sas[[i]])),
               sum(is.na(nhanes_shiny[[i]])))

  if(type %in% c('ctns', 'svy', 'intg') ){

   # these variable should be exactly the same
   expect_equal(nhanes_sas[[i]], nhanes_shiny[[i]], ignore_attr = TRUE)

  } else if(type %in% c('catg', 'bnry', 'time')){

   # categorical variables that were recoded should have same counts
   counts_sas   <- sort(table(nhanes_sas[[i]]))
   counts_shiny <- sort(table(nhanes_shiny[[i]]))
   expect_equal(counts_sas, counts_shiny, ignore_attr = TRUE)

  } else {

   stop("unrecognized variable type: ", type)

  }


 }

})

