#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

plotly_viz_make_hover <- function(data_fig, stat_all) {

 numeric_cols <- get_numeric_colnames(data_fig)

 stat_cols <- intersect(stat_all, unique(data_fig$statistic))

 data_fig %>%
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
  as.data.table()

}
