
plotly_viz_make_hover <- function(data, stat_all, group, group_label) {

 numeric_cols <- get_numeric_colnames(data)

 stat_cols <- intersect(stat_all, unique(data$statistic))

 data$group_label <- ""
 label_sep <- ""

 if(is_used(group) && group != 'fake_._group'){
  data$group_label <- group_label %>%
   paste(data[[group]], sep = ': ')
  label_sep <- "\n"
 }

 data %>%
  .[, (numeric_cols) := lapply(.SD, table_value), .SDcols = numeric_cols] %>%
  .[,
    stat_show := fifelse(
     unreliable_status,
     yes = paste0(" -Unreliable-<br>  Reasons: ", unreliable_reason),
     no = ""
    )] %>%
  .[stat_show == "",
    stat_show := paste0(estimate, " (95% CI ", ci_lower, ", ", ci_upper, ")")
  ] %>%
  .[, stat_label := paste(stat_recode(statistic), stat_show, sep = ": ")] %>%
  .[, c(numeric_cols,
        "unreliable_reason",
        "unreliable_status",
        "review_reason",
        "review_needed",
        "stat_show") := NULL] %>%
  dcast(formula = ... ~ statistic, value.var = "stat_label") %>%
  .[, hover := do.call(paste, c(.SD, sep="<br>")), .SDcols = stat_cols] %>%
  .[, hover := paste0(group_label, label_sep, hover)]

}


stat_recode <- function(stat){

 fcase(
  stat == "percentage_kg", "Percentage (Korn & Graubard CI)",
  stat == "mean", "Mean",
  stat == "percentage", "Percentage",
  stat == "count", "Count",
  stat == "q25", "25th %",
  stat == "q50", "50th %",
  stat == "q75", "75th %"
 )

}
