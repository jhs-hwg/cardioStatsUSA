
library(testthat)

suppressPackageStartupMessages(
 source(file.path(here::here(), 'packages.R'))
)

r_files <- list.files('R', pattern = '\\.R$', full.names = TRUE)

for(f in r_files) source(f)

test_dir(path = "tests/testthat/")

