
library(testthat)

test_that("nhanes_shiny data matches source data from SAS", {

 nhanes_shiny <- nhanes_shiny_load()

 nhanes_sas <- here() %>%
  file.path('data', 'small9920.sas7bdat') %>%
  read_sas() %>%
  nhanes_rename()

 nhanes_key <- here() %>%
  file.path('data', 'nhanes_key.csv') %>%
  fread()

 # number of NAs should match:

 for(i in names(nhanes_shiny)){

  type <- nhanes_key[variable == i, type]

  expect_equal(sum(is.na(nhanes_sas[[i]])),
               sum(is.na(nhanes_shiny[[i]])))

  if(type %in% c('ctns', 'svy', 'intg') ){

   # these variable should be exactly the same
   expect_equivalent(nhanes_sas[[i]], nhanes_shiny[[i]])

  } else if(type %in% c('catg', 'bnry', 'time')){

   # categorical variables that were recoded should have same counts
   counts_sas   <- sort(table(nhanes_sas[[i]]))
   counts_shiny <- sort(table(nhanes_shiny[[i]]))
   expect_equivalent(counts_sas, counts_shiny)

  } else {

   stop("unrecognized variable type: ", type)

  }


 }

})

