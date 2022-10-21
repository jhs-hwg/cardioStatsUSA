

check_nobs <- function(x, min_size = 30){

 if(nrow(x$design$variables) < min_size){
  stop("Less than ", min_size, " observations are present in the requested",
       " NHANES data. This is not a large enough sample to provide reliable",
       " estimates.", call. = FALSE)
 }

}

check_vars_in_data <- function(..., data_names, data_label) {

 .dots <- rlang::dots_list(...)

 for(i in seq_along(.dots)){

  if(!is.null(.dots[[i]])){

   variable_role <- names(.dots)[i]
   variable_name <- .dots[[i]]

   if( !(variable_name %in% data_names) ){

    stop(
     variable_role, " ", variable_name,
     " was not found in ", data_label,
     call. = FALSE
    )

   }

  }

 }

}

# nocov start
check_group_counts <- function(x, min_size = 5){

 count_vars <- c(x$by_variables)

 if(x$outcome$type != 'ctns'){
  count_vars <- c(x$outcome$variable, count_vars)
 }

 count_vars_combn <- paste(count_vars, collapse = ', ')

 count_expr <- glue::glue(
  "droplevels(x$design$variables, except = x$outcome$variable)[,
     data.table(table({count_vars_combn}))
  ]"
 ) %>%
  rlang::parse_expr()

 counts <- rlang::eval_bare(count_expr)

 if(any(counts$N < min_size)){

  low_counts <- counts[N < min_size]
  low_counts_msg <- vector('character', nrow(low_counts))

  setnames(low_counts,
           old = count_vars,
           new = x$key$label[match(count_vars, x$key$variable)])

  .n <- names(low_counts)

  for(i in seq(nrow(low_counts))){
   low_counts_msg[i] <-
    paste(.n, low_counts[i, ], sep = ' = ') %>%
    glue::glue_collapse(sep = " and ", last = " has ")
  }

  group_msg <- low_counts_msg[1]
  # group_msg <- paste(low_counts_msg, collapse = '\n')

  stop("At least one of the groups to be analyzed has less than ",
       min_size, " observations. This is not a large enough sample ",
       "size. For example, the group of participants with ", group_msg,
       " observations.", call. = FALSE)

 }

}
# nocov end


check_key <- function(nhanes_key){

 required_names <- key_guide$name[key_guide$required]

 if(!all(required_names %in% names(nhanes_key))){

  missing_names <- required_names %>%
   setdiff(names(nhanes_key)) %>%
   paste(collapse = ', ')

  stop("required columns are not present in NHANES key: ",
       missing_names,
       call. = FALSE)

 }

 extra_names <- setdiff(names(nhanes_key), key_guide$name)

 if(!is_empty(extra_names)){

  stop("unrecognized names in NHANES key: ",
       paste(extra_names, collapse = ', '),
       call. = FALSE)

 }

 key_types <- vapply(nhanes_key, typeof, character(1))

 for(i in names(key_types)){
  if(key_types[i] != key_guide$type[key_guide$name == i]){
   stop("NHANES key column ", i, " should have type ",
        key_guide$type[key_guide$name == i], " but instead ",
        "has type ", key_types[i])
  }
 }

 invisible(nhanes_key)

}











