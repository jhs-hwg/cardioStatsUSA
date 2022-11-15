# one group plot, continuous outcome mean

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean")$fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", geom = "point")$fig_object
    Output
      [[1]]
      

# one group bar plot, continuous outcome quantile

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", outcome_quantiles = seq(1,
        10) / 10, statistic_primary = "quantile")$fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", outcome_quantiles = seq(1,
        10) / 10, statistic_primary = "quantile", geom = "point")$fig_object
    Output
      [[1]]
      

# multiple group bar plot, continuous outcome mean

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", group_variable = "demo_gender")$
        fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", group_variable = "demo_gender",
        geom = "point")$fig_object
    Output
      [[1]]
      

# multiple group plots, continuous outcome quantile

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", outcome_quantiles = seq(1,
        10) / 10, statistic_primary = "quantile", group_variable = "demo_gender")$
        fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", outcome_quantiles = seq(1,
        10) / 10, statistic_primary = "quantile", group_variable = "demo_gender",
      geom = "point")$fig_object
    Output
      [[1]]
      

# stratified group plots, continuous outcome quantile

    Code
      plts_bar[[1]]

---

    Code
      plts_bar[[2]]

---

    Code
      plts_pnt[[1]]

---

    Code
      plts_pnt[[2]]

# one group plot, binary outcome prevalence

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7")$fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", geom = "point")$fig_object
    Output
      [[1]]
      

# one group bar plot, binary outcome count

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", statistic_primary = "count")$
        fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", statistic_primary = "count",
        geom = "point")$fig_object
    Output
      [[1]]
      

# multiple group bar plot, binary outcome prevalence

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", group_variable = "demo_gender")$
        fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", group_variable = "demo_gender",
        geom = "point")$fig_object
    Output
      [[1]]
      

# multiple group plots, binary outcome count

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", statistic_primary = "count",
        group_variable = "demo_gender")$fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", statistic_primary = "count",
        group_variable = "demo_gender", geom = "point")$fig_object
    Output
      [[1]]
      

# stratified group plots, binary outcome count

    Code
      plts_bar[[1]]

---

    Code
      plts_bar[[2]]

---

    Code
      plts_pnt[[1]]

---

    Code
      plts_pnt[[2]]

# one group plot, categorical outcome prevalence

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded")$fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", geom = "point")$
        fig_object
    Output
      [[1]]
      

# one group bar plot, categorical outcome count

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", statistic_primary = "count")$
        fig_object
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", statistic_primary = "count",
        geom = "point")$fig_object
    Output
      [[1]]
      

# multiple group bar plot, categorical outcome prevalence

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", group_variable = "demo_gender")$
        fig_object
    Output
      [[1]]
      
      [[2]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", group_variable = "demo_gender",
        geom = "point")$fig_object
    Output
      [[1]]
      
      [[2]]
      

# multiple group plot, categorical outcome count

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", statistic_primary = "count",
        group_variable = "demo_gender")$fig_object
    Output
      [[1]]
      
      [[2]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", statistic_primary = "count",
        group_variable = "demo_gender", geom = "point")$fig_object
    Output
      [[1]]
      
      [[2]]
      

# stratified group plots, categorical outcome count

    Code
      plts_bar[[1]]

---

    Code
      plts_bar[[2]]

---

    Code
      plts_pnt[[1]]

---

    Code
      plts_pnt[[2]]

