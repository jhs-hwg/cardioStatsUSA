#' Subset an NHANES design object
#'
#' @param x \[nhanes_design\]
#'
#' `r document_nhanes_design()`
#'
#' @param subset \[expression\]
#'
#' An expression indicating what rows to keep.
#'   Missing values are taken as false.
#'
#' @return an [nhanes_design] object.
#'
#' @export
#'
#' @includeRmd rmd/nhanes_design_subset.Rmd


nhanes_design_subset <- function(x, subset){

 if(missing(subset)) return(x)

 if(!is.null(x$subset_rows)){
  stop("NHANES design has already been subsetted. To ensure",
       " the expected result occurs when subsetting, NHANES",
       " design objects can only be subsetted once. This is",
       " enforced so that nhanes_design_update() works as intended.",
       " If you need to add more conditions to your subset,",
       " you can do subset(A & B) instead of subset(A) and",
       " subset(B)")
 }




 e <- substitute(subset)
 r <- eval(e, x$design$variables, parent.frame())
 r <- r & !is.na(r)
 x$design <- x$design[r, ]
 # TODO: make subset_rows a list so we can do multiple subsets
 x$subset_rows <- which(r)
 x$operations <- c(x$operations, 'subset')
 x

}
