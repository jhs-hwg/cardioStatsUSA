
plotly_viz_make_hover <- function(data, stat_all, exposure, key) {

 numeric_cols <- get_numeric_colnames(data)

 stat_cols <- intersect(stat_all, unique(data$statistic))

 data$exposure_label <- ""
 label_sep <- ""

 if(is_used(exposure)){
  data$exposure_label <- key$variables %>%
   getElement(exposure) %>%
   getElement('label') %>%
   paste(data[[exposure]], sep = ': ')
  label_sep <- "\n"
 }

 data %>%
  as_tibble() %>%
  mutate(across(all_of(numeric_cols), table_value)) %>%
  mutate(
   stat_label = glue(
    "{str_to_title(statistic)}: \\
    {estimate} (95% CI {ci_lower}, {ci_upper})"
   )
  ) %>%
  select(-all_of(numeric_cols)) %>%
  pivot_wider(names_from = statistic, values_from = stat_label) %>%
  unite(col = 'hover', !!!stat_cols, sep = '<br>') %>%
  mutate(hover = glue("{exposure_label}{label_sep}{hover}")) %>%
  as.data.table()

}
