
.onLoad <- function(libname, pkgname){

 rspec <- table.glue::round_spec() %>%
  table.glue::round_using_magnitude(digits = c(2, 1, 0),
                                    breaks = c(10, 100, Inf))

 names(rspec) <- paste('table.glue.', names(rspec), sep = '')

 options(rspec)

}
