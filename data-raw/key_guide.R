

key_guide <-
 tibble::tribble(
  ~name,         ~type,       ~required, ~purpose,
  "class",       "character",  TRUE,     "divide variables into classes",
  "variable",    "character",  TRUE,     "variable name in NHANES data",
  "label",       "character",  TRUE,     "label to present in results",
  "source",      "character",  FALSE,    "indicate where this variable is from",
  "type",        "character",  TRUE,     "variable type impacts summary results",
  "outcome",     "logical",    TRUE,     "indicate if variable is an outcome",
  "group",       "logical",    TRUE,     "indicate if variable is a grouper",
  "subset",      "logical",    TRUE,     "indicate if variable is a subsetter",
  "stratify",    "logical",    TRUE,     "indicate if variable is a stratifier",
  "module",      "character",  FALSE,    "indicate what module this variable belongs to",
  "description", "character",  TRUE,     "describe the variable in detail"
 )

usethis::use_data(key_guide, overwrite = TRUE)
