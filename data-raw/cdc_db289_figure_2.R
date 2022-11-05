
cdc_db289_figure_2 <- tibble::tribble(
 ~demo_race,          ~demo_gender, ~estimate, ~std_error,
 "Non-Hispanic White", "Total",      27.8,      1.4,
 "Non-Hispanic Black", "Total",      40.3,      2.0,
 "Non-Hispanic Asian", "Total",      25.0,      1.7,
 "Hispanic",           "Total",      27.8,      1.4,
 "Non-Hispanic White", "Men",        29.7,      2.1,
 "Non-Hispanic Black", "Men",        40.6,      2.2,
 "Non-Hispanic Asian", "Men",        28.7,      2.6,
 "Hispanic",           "Men",        27.3,      2.0,
 "Non-Hispanic White", "Women",      25.6,      1.4,
 "Non-Hispanic Black", "Women",      39.9,      2.1,
 "Non-Hispanic Asian", "Women",      21.9,      2.2,
 "Hispanic",           "Women",      28.0,      1.2
)

setDT(cdc_db289_figure_2)
usethis::use_data(cdc_db289_figure_2, overwrite = TRUE)
