
svy_stat_adorn <- function(x, stat_type, stat_fun) {

 x %>%
  attribute_add(.name = '..svy_stat_type..', .value = stat_type) %>%
  attribute_add(.name = '..svy_stat_fun..', .value = stat_fun)

}
