# one group blots, continuous outcome mean

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", geom = "point")
    Output
      [[1]]
      

# one group bar blots, continuous outcome quantile

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", outcome_quantiles = seq(1,
        10) / 10, statistic_primary = "quantile")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", outcome_quantiles = seq(1,
        10) / 10, statistic_primary = "quantile", geom = "point")
    Output
      [[1]]
      

# multiple group bar blots, continuous outcome mean

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", group_variable = "demo_gender")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", group_variable = "demo_gender",
        geom = "point")
    Output
      [[1]]
      

# multiple group plots, continuous outcome quantile

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", outcome_quantiles = seq(1,
        10) / 10, statistic_primary = "quantile", group_variable = "demo_gender")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_sys_mean", outcome_quantiles = seq(1,
        10) / 10, statistic_primary = "quantile", group_variable = "demo_gender",
      geom = "point")
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

# one group blots, binary outcome prevalence

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", geom = "point")
    Output
      [[1]]
      

# one group bar blots, binary outcome count

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", statistic_primary = "count")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", statistic_primary = "count",
        geom = "point")
    Output
      [[1]]
      

# multiple group bar blots, binary outcome prevalence

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", group_variable = "demo_gender")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", group_variable = "demo_gender",
        geom = "point")
    Output
      [[1]]
      

# multiple group plots, binary outcome count

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", statistic_primary = "count",
        group_variable = "demo_gender")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "htn_jnc7", statistic_primary = "count",
        group_variable = "demo_gender", geom = "point")
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

# one group blots, categorical outcome prevalence

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", geom = "point")
    Output
      [[1]]
      

# one group bar blots, categorical outcome count

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", statistic_primary = "count")
    Output
      [[1]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", statistic_primary = "count",
        geom = "point")
    Output
      [[1]]
      

# multiple group bar blots, categorical outcome prevalence

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", group_variable = "demo_gender")
    Output
      [[1]]
      
      [[2]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", group_variable = "demo_gender",
        geom = "point")
    Output
      [[1]]
      
      [[2]]
      

# multiple group plots, categorical outcome count

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", statistic_primary = "count",
        group_variable = "demo_gender")
    Output
      [[1]]
      
      [[2]]
      

---

    Code
      nhanes_visualize(outcome_variable = "bp_cat_meds_excluded", statistic_primary = "count",
        group_variable = "demo_gender", geom = "point")
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

