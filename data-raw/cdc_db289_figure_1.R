

cdc_db289_figure_1 <- tibble::tribble(
 ~demo_gender, ~demo_age_cat, ~estimate, ~std_error,
 "Overall",       "18-39",       7.5,       1.0,
 "Men",           "18-39",       9.2,       1.4,
 "Women",         "18-39",       5.6,       1.1,
 "Overall",       "40-59",       33.2,      1.7,
 "Men",           "40-59",       37.2,      2.9,
 "Women",         "40-59",       29.4,      2.0,
 "Overall",       "60+",         63.1,      2.1,
 "Men",           "60+",         58.5,      2.2,
 "Women",         "60+",         66.8,      2.6
)

setDT(cdc_db289_figure_1)
usethis::use_data(cdc_db289_figure_1, overwrite = TRUE)

