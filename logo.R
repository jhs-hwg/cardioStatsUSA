
devtools::load_all()

library(ggplot2)

ds <- nhanes_bp %>%
 .[svy_subpop_htn == 1] %>%
 .[, svy_weight := svy_weight_mec] %>%
 svy_design_new(
  n_exposure_group = numeric(),
  years = levels(nhanes_bp$svy_year),
  pool = 'no'
 ) %>%
 subset(demo_pregnant == 'No' | is.na(demo_pregnant)) %>%
 subset(bp_med_use == 'Yes')

smry <- ds %>%
 svy_design_summarize(outcome = 'bp_control_jnc7',
                      key = nhanes_key,
                      age_standardize = TRUE,
                      user_calls = c('percentage')) %>%
 filter(bp_control_jnc7 == 'Yes')


trend_1 <-  c("1999-2000", "2007-2008")

trend_2 <- c("2007-2008", "2013-2014")

trend_3 <- c("2013-2014",  "2017-2020")

p <- ggplot(smry, aes(x = svy_year, y = estimate)) +
 geom_point(size=1.2, color = '#8a0303') +
 geom_line(data = filter(smry, svy_year %in% trend_1),
           aes(group = 1),
           color = '#8a0303') +
 geom_line(data = filter(smry, svy_year %in% trend_2),
           aes(group = 1),
           color = '#8a0303') +
 geom_line(data = filter(smry, svy_year %in% trend_3),
           aes(group = 1),
           color = '#8a0303') +
 theme_void()


hexSticker::sticker(
 p,
 package = "nhanesTrends",
 p_color = 'black',
 h_fill = 'white',
 h_color = 'grey',
 p_size = 35,
 s_x = 1,
 s_y = 0.85,
 s_width = 1.7,
 s_height = 0.75,
 dpi = 600,
 filename = "logo.png"
)
