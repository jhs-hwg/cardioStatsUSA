
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cardioStatsUSA <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/jhs-hwg/nhanes-shiny-bp/branch/main/graph/badge.svg)](https://app.codecov.io/gh/jhs-hwg/nhanes-shiny-bp?branch=main)
[![R-CMD-check](https://github.com/jhs-hwg/nhanes-shiny-bp/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jhs-hwg/nhanes-shiny-bp/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Our goal is to provide a platform for exploration of the National Health
and Nutrition Examination Survey (NHANES) data.

## Installation

You can install the development version of cardioStatsUSA from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("jhs-hwg/cardioStatsUSA")
```

## Example

The shiny application is hosted on a public server, but you can also run
it locally:

``` r
library(cardioStatsUSA)
app_run()
```

## Why we made this

## Methods

### Weights

if counts are requested, we re-calibrate weights.

### Validation of results from the shiny application

We have replicated results from prior NHANES publications to verify that
routines used to conduct analyses in this app are valid. Based on these
tests, we have identified some cases where our app does not exactly
match previously published articles, and we note those cases here.

TO BE WRITTEN: notes on tests showing exact match with [Muntner et
al](https://jamanetwork.com/journals/jama/fullarticle/2770254)

TO BE WRITTEN: notes on discrepancies with results in [Carey et
al.](https://www.ahajournals.org/doi/10.1161/HYPERTENSIONAHA.118.12191)

## Results

### Participant characteristics

``` r
suppressPackageStartupMessages({
 library(cardioStatsUSA)
 library(magrittr)
 library(gtsummary)
 library(tidyverse)
 library(survey)
 library(gt)
})


tbl_summary_data <- as_tibble(nhanes_bp) %>% 
 filter(svy_subpop_htn == 1) %>% 
 mutate(nobs = 1) %>% 
 select(
  svy_psu,
  svy_strata,
  svy_weight_mec,
  svy_year,
  nobs,
  starts_with('demo'),
  starts_with('bp'), - bp_cat_meds_excluded,
  starts_with('htn'),
  starts_with('cc')
 ) 

for(i in names(tbl_summary_data)){
 attr(tbl_summary_data[[i]], 'label') <- nhanes_key$variables[[i]]$label
}

tbl_summary_design <- tbl_summary_data %>% 
 svydesign(ids = ~ svy_psu,
           strata = ~ svy_strata,
           weights = ~ svy_weight_mec,
           data = .,
           nest = TRUE)

tbl_summary_design %>% 
 tbl_svysummary(
  by = svy_year,
  include = c(nobs, 
              starts_with("demo"),
              starts_with('bp'), 
              starts_with('htn'),
              starts_with('cc')),
  missing = 'no',
  label = list(nobs ~ "No. of Adults"),
  statistic = list(
   all_categorical() ~ "{p}",
   all_continuous() ~ "{mean} ({sd})",
   nobs ~ "{N_unweighted}"
  )
 ) %>%
 modify_header(all_stat_cols() ~ "**{level}**") %>%
 modify_footnote(all_stat_cols() ~ NA)
```

<div id="ozjguddqgs" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ozjguddqgs .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ozjguddqgs .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ozjguddqgs .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ozjguddqgs .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ozjguddqgs .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ozjguddqgs .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ozjguddqgs .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ozjguddqgs .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ozjguddqgs .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ozjguddqgs .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ozjguddqgs .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ozjguddqgs .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#ozjguddqgs .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ozjguddqgs .gt_from_md > :first-child {
  margin-top: 0;
}

#ozjguddqgs .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ozjguddqgs .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ozjguddqgs .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ozjguddqgs .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ozjguddqgs .gt_row_group_first td {
  border-top-width: 2px;
}

#ozjguddqgs .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ozjguddqgs .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ozjguddqgs .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ozjguddqgs .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ozjguddqgs .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ozjguddqgs .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ozjguddqgs .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ozjguddqgs .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ozjguddqgs .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ozjguddqgs .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ozjguddqgs .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ozjguddqgs .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ozjguddqgs .gt_left {
  text-align: left;
}

#ozjguddqgs .gt_center {
  text-align: center;
}

#ozjguddqgs .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ozjguddqgs .gt_font_normal {
  font-weight: normal;
}

#ozjguddqgs .gt_font_bold {
  font-weight: bold;
}

#ozjguddqgs .gt_font_italic {
  font-style: italic;
}

#ozjguddqgs .gt_super {
  font-size: 65%;
}

#ozjguddqgs .gt_two_val_uncert {
  display: inline-block;
  line-height: 1em;
  text-align: right;
  font-size: 60%;
  vertical-align: -0.25em;
  margin-left: 0.1em;
}

#ozjguddqgs .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#ozjguddqgs .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ozjguddqgs .gt_slash_mark {
  font-size: 0.7em;
  line-height: 0.7em;
  vertical-align: 0.15em;
}

#ozjguddqgs .gt_fraction_numerator {
  font-size: 0.6em;
  line-height: 0.6em;
  vertical-align: 0.45em;
}

#ozjguddqgs .gt_fraction_denominator {
  font-size: 0.6em;
  line-height: 0.6em;
  vertical-align: -0.05em;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1"><strong>Characteristic</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>1999-2000</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2001-2002</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2003-2004</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2005-2006</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2007-2008</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2009-2010</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2011-2012</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2013-2014</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2015-2016</strong></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1"><strong>2017-2020</strong></th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">No. of Adults</td>
<td class="gt_row gt_center">4,694</td>
<td class="gt_row gt_center">5,184</td>
<td class="gt_row gt_center">4,838</td>
<td class="gt_row gt_center">5,015</td>
<td class="gt_row gt_center">5,665</td>
<td class="gt_row gt_center">6,043</td>
<td class="gt_row gt_center">5,337</td>
<td class="gt_row gt_center">5,694</td>
<td class="gt_row gt_center">5,552</td>
<td class="gt_row gt_center">8,013</td></tr>
    <tr><td class="gt_row gt_left">Age category, years</td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">18 to 44</td>
<td class="gt_row gt_center">56</td>
<td class="gt_row gt_center">53</td>
<td class="gt_row gt_center">52</td>
<td class="gt_row gt_center">50</td>
<td class="gt_row gt_center">49</td>
<td class="gt_row gt_center">48</td>
<td class="gt_row gt_center">47</td>
<td class="gt_row gt_center">48</td>
<td class="gt_row gt_center">45</td>
<td class="gt_row gt_center">45</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">45 to 64</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">36</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">35</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">65 to 74</td>
<td class="gt_row gt_center">9.0</td>
<td class="gt_row gt_center">8.2</td>
<td class="gt_row gt_center">9.2</td>
<td class="gt_row gt_center">9.3</td>
<td class="gt_row gt_center">8.7</td>
<td class="gt_row gt_center">9.9</td>
<td class="gt_row gt_center">9.9</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">13</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">75+</td>
<td class="gt_row gt_center">6.0</td>
<td class="gt_row gt_center">6.5</td>
<td class="gt_row gt_center">6.7</td>
<td class="gt_row gt_center">7.0</td>
<td class="gt_row gt_center">7.4</td>
<td class="gt_row gt_center">7.2</td>
<td class="gt_row gt_center">7.2</td>
<td class="gt_row gt_center">7.0</td>
<td class="gt_row gt_center">7.8</td>
<td class="gt_row gt_center">7.5</td></tr>
    <tr><td class="gt_row gt_left">Race</td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Non-Hispanic White</td>
<td class="gt_row gt_center">70</td>
<td class="gt_row gt_center">72</td>
<td class="gt_row gt_center">73</td>
<td class="gt_row gt_center">72</td>
<td class="gt_row gt_center">69</td>
<td class="gt_row gt_center">68</td>
<td class="gt_row gt_center">66</td>
<td class="gt_row gt_center">66</td>
<td class="gt_row gt_center">64</td>
<td class="gt_row gt_center">64</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Non-Hispanic Black</td>
<td class="gt_row gt_center">10</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Non-Hispanic Asian</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">5.0</td>
<td class="gt_row gt_center">5.3</td>
<td class="gt_row gt_center">5.6</td>
<td class="gt_row gt_center">5.5</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Hispanic</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">16</td>
<td class="gt_row gt_center">15</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Other</td>
<td class="gt_row gt_center">4.7</td>
<td class="gt_row gt_center">4.4</td>
<td class="gt_row gt_center">5.1</td>
<td class="gt_row gt_center">5.2</td>
<td class="gt_row gt_center">5.7</td>
<td class="gt_row gt_center">6.7</td>
<td class="gt_row gt_center">2.7</td>
<td class="gt_row gt_center">2.7</td>
<td class="gt_row gt_center">3.7</td>
<td class="gt_row gt_center">4.1</td></tr>
    <tr><td class="gt_row gt_left">Age, years</td>
<td class="gt_row gt_center">44 (17)</td>
<td class="gt_row gt_center">45 (17)</td>
<td class="gt_row gt_center">45 (17)</td>
<td class="gt_row gt_center">46 (17)</td>
<td class="gt_row gt_center">46 (17)</td>
<td class="gt_row gt_center">46 (17)</td>
<td class="gt_row gt_center">46 (17)</td>
<td class="gt_row gt_center">46 (18)</td>
<td class="gt_row gt_center">47 (18)</td>
<td class="gt_row gt_center">48 (18)</td></tr>
    <tr><td class="gt_row gt_left">Pregnant</td>
<td class="gt_row gt_center">2.5</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">1.7</td>
<td class="gt_row gt_center">2.1</td>
<td class="gt_row gt_center">0.9</td>
<td class="gt_row gt_center">1.1</td>
<td class="gt_row gt_center">1.0</td>
<td class="gt_row gt_center">1.1</td>
<td class="gt_row gt_center">1.2</td>
<td class="gt_row gt_center">0.9</td></tr>
    <tr><td class="gt_row gt_left">Gender</td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Men</td>
<td class="gt_row gt_center">48</td>
<td class="gt_row gt_center">48</td>
<td class="gt_row gt_center">49</td>
<td class="gt_row gt_center">48</td>
<td class="gt_row gt_center">48</td>
<td class="gt_row gt_center">49</td>
<td class="gt_row gt_center">49</td>
<td class="gt_row gt_center">48</td>
<td class="gt_row gt_center">48</td>
<td class="gt_row gt_center">49</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Women</td>
<td class="gt_row gt_center">52</td>
<td class="gt_row gt_center">52</td>
<td class="gt_row gt_center">51</td>
<td class="gt_row gt_center">52</td>
<td class="gt_row gt_center">52</td>
<td class="gt_row gt_center">51</td>
<td class="gt_row gt_center">51</td>
<td class="gt_row gt_center">52</td>
<td class="gt_row gt_center">52</td>
<td class="gt_row gt_center">51</td></tr>
    <tr><td class="gt_row gt_left">Systolic blood pressure, mm Hg</td>
<td class="gt_row gt_center">123 (19)</td>
<td class="gt_row gt_center">123 (19)</td>
<td class="gt_row gt_center">123 (18)</td>
<td class="gt_row gt_center">122 (18)</td>
<td class="gt_row gt_center">122 (17)</td>
<td class="gt_row gt_center">120 (17)</td>
<td class="gt_row gt_center">122 (17)</td>
<td class="gt_row gt_center">121 (17)</td>
<td class="gt_row gt_center">123 (17)</td>
<td class="gt_row gt_center">123 (17)</td></tr>
    <tr><td class="gt_row gt_left">Diastolic blood pressure, mm Hg</td>
<td class="gt_row gt_center">73 (12)</td>
<td class="gt_row gt_center">72 (12)</td>
<td class="gt_row gt_center">71 (12)</td>
<td class="gt_row gt_center">70 (12)</td>
<td class="gt_row gt_center">71 (11)</td>
<td class="gt_row gt_center">70 (12)</td>
<td class="gt_row gt_center">71 (11)</td>
<td class="gt_row gt_center">70 (11)</td>
<td class="gt_row gt_center">70 (11)</td>
<td class="gt_row gt_center">72 (11)</td></tr>
    <tr><td class="gt_row gt_left">Blood pressure category (including antihypertensive medication use)</td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">SBP &lt;120 and DBP &lt;80 mm Hg</td>
<td class="gt_row gt_center">43</td>
<td class="gt_row gt_center">44</td>
<td class="gt_row gt_center">42</td>
<td class="gt_row gt_center">43</td>
<td class="gt_row gt_center">43</td>
<td class="gt_row gt_center">45</td>
<td class="gt_row gt_center">42</td>
<td class="gt_row gt_center">45</td>
<td class="gt_row gt_center">40</td>
<td class="gt_row gt_center">40</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">SBP of 120 to &lt;130 and DBP &lt; 80 mm Hg</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">13</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">SBP of 130 to &lt;140 or DBP 80 to &lt;90 mm Hg</td>
<td class="gt_row gt_center">18</td>
<td class="gt_row gt_center">18</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">13</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">SBP of 140 to &lt;160 or DBP 90 to &lt;100 mm Hg</td>
<td class="gt_row gt_center">8.5</td>
<td class="gt_row gt_center">7.7</td>
<td class="gt_row gt_center">7.8</td>
<td class="gt_row gt_center">7.4</td>
<td class="gt_row gt_center">7.0</td>
<td class="gt_row gt_center">5.6</td>
<td class="gt_row gt_center">5.9</td>
<td class="gt_row gt_center">6.1</td>
<td class="gt_row gt_center">6.7</td>
<td class="gt_row gt_center">7.2</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">SBP 160+ or DBP 100+ mm Hg</td>
<td class="gt_row gt_center">2.6</td>
<td class="gt_row gt_center">2.9</td>
<td class="gt_row gt_center">2.6</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">1.6</td>
<td class="gt_row gt_center">1.5</td>
<td class="gt_row gt_center">1.8</td>
<td class="gt_row gt_center">1.6</td>
<td class="gt_row gt_center">1.7</td>
<td class="gt_row gt_center">2.1</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">taking antihypertensive medications</td>
<td class="gt_row gt_center">16</td>
<td class="gt_row gt_center">16</td>
<td class="gt_row gt_center">19</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">22</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">24</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">24</td></tr>
    <tr><td class="gt_row gt_left">Self-reported antihypertensive medication use</td>
<td class="gt_row gt_center">16</td>
<td class="gt_row gt_center">16</td>
<td class="gt_row gt_center">19</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">22</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">24</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">24</td></tr>
    <tr><td class="gt_row gt_left">Antihypertensive medications recommended by JNC7</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">31</td>
<td class="gt_row gt_center">31</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">31</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">35</td></tr>
    <tr><td class="gt_row gt_left">Antihypertensive medications recommended by ACC/AHA 2017</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">37</td></tr>
    <tr><td class="gt_row gt_left">Number of antihypertensive medication classes</td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">None</td>
<td class="gt_row gt_center">81</td>
<td class="gt_row gt_center">80</td>
<td class="gt_row gt_center">77</td>
<td class="gt_row gt_center">76</td>
<td class="gt_row gt_center">74</td>
<td class="gt_row gt_center">74</td>
<td class="gt_row gt_center">73</td>
<td class="gt_row gt_center">73</td>
<td class="gt_row gt_center">71</td>
<td class="gt_row gt_center">71</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">One</td>
<td class="gt_row gt_center">9.4</td>
<td class="gt_row gt_center">9.2</td>
<td class="gt_row gt_center">9.6</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">14</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Two</td>
<td class="gt_row gt_center">6.7</td>
<td class="gt_row gt_center">7.0</td>
<td class="gt_row gt_center">7.9</td>
<td class="gt_row gt_center">7.5</td>
<td class="gt_row gt_center">8.8</td>
<td class="gt_row gt_center">8.4</td>
<td class="gt_row gt_center">9.1</td>
<td class="gt_row gt_center">9.7</td>
<td class="gt_row gt_center">9.7</td>
<td class="gt_row gt_center">8.8</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Three</td>
<td class="gt_row gt_center">2.6</td>
<td class="gt_row gt_center">2.7</td>
<td class="gt_row gt_center">3.8</td>
<td class="gt_row gt_center">4.0</td>
<td class="gt_row gt_center">3.9</td>
<td class="gt_row gt_center">5.0</td>
<td class="gt_row gt_center">3.9</td>
<td class="gt_row gt_center">4.1</td>
<td class="gt_row gt_center">4.1</td>
<td class="gt_row gt_center">4.3</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Four or more</td>
<td class="gt_row gt_center">0.6</td>
<td class="gt_row gt_center">0.8</td>
<td class="gt_row gt_center">1.6</td>
<td class="gt_row gt_center">1.9</td>
<td class="gt_row gt_center">1.6</td>
<td class="gt_row gt_center">1.9</td>
<td class="gt_row gt_center">1.7</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">1.4</td>
<td class="gt_row gt_center">1.8</td></tr>
    <tr><td class="gt_row gt_left">ACE inhibitors</td>
<td class="gt_row gt_center">6.4</td>
<td class="gt_row gt_center">7.6</td>
<td class="gt_row gt_center">9.2</td>
<td class="gt_row gt_center">9.5</td>
<td class="gt_row gt_center">9.9</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">12</td></tr>
    <tr><td class="gt_row gt_left">Aldosterone antagonists</td>
<td class="gt_row gt_center">0.4</td>
<td class="gt_row gt_center">0.3</td>
<td class="gt_row gt_center">0.6</td>
<td class="gt_row gt_center">0.5</td>
<td class="gt_row gt_center">0.6</td>
<td class="gt_row gt_center">0.8</td>
<td class="gt_row gt_center">0.5</td>
<td class="gt_row gt_center">0.7</td>
<td class="gt_row gt_center">1.0</td>
<td class="gt_row gt_center">1.1</td></tr>
    <tr><td class="gt_row gt_left">Alpha-1 blockers</td>
<td class="gt_row gt_center">1.4</td>
<td class="gt_row gt_center">1.0</td>
<td class="gt_row gt_center">1.1</td>
<td class="gt_row gt_center">0.8</td>
<td class="gt_row gt_center">1.2</td>
<td class="gt_row gt_center">1.0</td>
<td class="gt_row gt_center">0.9</td>
<td class="gt_row gt_center">1.0</td>
<td class="gt_row gt_center">0.8</td>
<td class="gt_row gt_center">1.0</td></tr>
    <tr><td class="gt_row gt_left">Angiotensin receptor blockers</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">3.0</td>
<td class="gt_row gt_center">4.4</td>
<td class="gt_row gt_center">4.4</td>
<td class="gt_row gt_center">6.5</td>
<td class="gt_row gt_center">6.4</td>
<td class="gt_row gt_center">5.7</td>
<td class="gt_row gt_center">6.1</td>
<td class="gt_row gt_center">7.4</td>
<td class="gt_row gt_center">7.7</td></tr>
    <tr><td class="gt_row gt_left">Beta blockers</td>
<td class="gt_row gt_center">5.9</td>
<td class="gt_row gt_center">6.7</td>
<td class="gt_row gt_center">9.0</td>
<td class="gt_row gt_center">10</td>
<td class="gt_row gt_center">9.6</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">10</td>
<td class="gt_row gt_center">10</td>
<td class="gt_row gt_center">9.9</td>
<td class="gt_row gt_center">12</td></tr>
    <tr><td class="gt_row gt_left">Central alpha1 agonist and other centrally acting agents</td>
<td class="gt_row gt_center">0.8</td>
<td class="gt_row gt_center">0.5</td>
<td class="gt_row gt_center">0.7</td>
<td class="gt_row gt_center">0.5</td>
<td class="gt_row gt_center">0.6</td>
<td class="gt_row gt_center">0.5</td>
<td class="gt_row gt_center">0.9</td>
<td class="gt_row gt_center">0.9</td>
<td class="gt_row gt_center">0.5</td>
<td class="gt_row gt_center">0.8</td></tr>
    <tr><td class="gt_row gt_left">Calcium channel blockers</td>
<td class="gt_row gt_center">6.3</td>
<td class="gt_row gt_center">5.1</td>
<td class="gt_row gt_center">6.2</td>
<td class="gt_row gt_center">6.8</td>
<td class="gt_row gt_center">6.0</td>
<td class="gt_row gt_center">6.6</td>
<td class="gt_row gt_center">6.3</td>
<td class="gt_row gt_center">7.8</td>
<td class="gt_row gt_center">6.7</td>
<td class="gt_row gt_center">7.4</td></tr>
    <tr><td class="gt_row gt_left">Potassium sparing diuretics</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">1.8</td>
<td class="gt_row gt_center">1.9</td>
<td class="gt_row gt_center">1.6</td>
<td class="gt_row gt_center">1.7</td>
<td class="gt_row gt_center">1.2</td>
<td class="gt_row gt_center">1.1</td>
<td class="gt_row gt_center">0.9</td>
<td class="gt_row gt_center">0.7</td>
<td class="gt_row gt_center">0.4</td></tr>
    <tr><td class="gt_row gt_left">Loop diuretics</td>
<td class="gt_row gt_center">2.3</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">2.7</td>
<td class="gt_row gt_center">2.5</td>
<td class="gt_row gt_center">2.8</td>
<td class="gt_row gt_center">2.8</td>
<td class="gt_row gt_center">2.6</td>
<td class="gt_row gt_center">2.6</td>
<td class="gt_row gt_center">2.5</td>
<td class="gt_row gt_center">2.5</td></tr>
    <tr><td class="gt_row gt_left">Thiazide or thiazide-type diuretics</td>
<td class="gt_row gt_center">5.5</td>
<td class="gt_row gt_center">6.4</td>
<td class="gt_row gt_center">7.6</td>
<td class="gt_row gt_center">8.2</td>
<td class="gt_row gt_center">8.6</td>
<td class="gt_row gt_center">8.6</td>
<td class="gt_row gt_center">9.2</td>
<td class="gt_row gt_center">8.4</td>
<td class="gt_row gt_center">8.7</td>
<td class="gt_row gt_center">7.8</td></tr>
    <tr><td class="gt_row gt_left">Direct renin inhibitors</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td></tr>
    <tr><td class="gt_row gt_left">Direct vasodilators</td>
<td class="gt_row gt_center">0.2</td>
<td class="gt_row gt_center">0.1</td>
<td class="gt_row gt_center">0.1</td>
<td class="gt_row gt_center">0.2</td>
<td class="gt_row gt_center">0.2</td>
<td class="gt_row gt_center">0.3</td>
<td class="gt_row gt_center">0.4</td>
<td class="gt_row gt_center">0.4</td>
<td class="gt_row gt_center">0.3</td>
<td class="gt_row gt_center">0.5</td></tr>
    <tr><td class="gt_row gt_left">Blood pressure control (SBP &lt; 140 mm Hg and DBP &lt; 90 mm Hg)</td>
<td class="gt_row gt_center">82</td>
<td class="gt_row gt_center">82</td>
<td class="gt_row gt_center">82</td>
<td class="gt_row gt_center">84</td>
<td class="gt_row gt_center">84</td>
<td class="gt_row gt_center">86</td>
<td class="gt_row gt_center">85</td>
<td class="gt_row gt_center">86</td>
<td class="gt_row gt_center">84</td>
<td class="gt_row gt_center">83</td></tr>
    <tr><td class="gt_row gt_left">Blood pressure control (SBP &lt; 130 mm Hg and DBP &lt; 80 mm Hg)</td>
<td class="gt_row gt_center">59</td>
<td class="gt_row gt_center">61</td>
<td class="gt_row gt_center">62</td>
<td class="gt_row gt_center">63</td>
<td class="gt_row gt_center">65</td>
<td class="gt_row gt_center">67</td>
<td class="gt_row gt_center">65</td>
<td class="gt_row gt_center">67</td>
<td class="gt_row gt_center">64</td>
<td class="gt_row gt_center">64</td></tr>
    <tr><td class="gt_row gt_left">Uncontrolled BP (SBP &gt;= 140 mm Hg or DBP &gt;= 90 mm Hg)</td>
<td class="gt_row gt_center">18</td>
<td class="gt_row gt_center">18</td>
<td class="gt_row gt_center">18</td>
<td class="gt_row gt_center">16</td>
<td class="gt_row gt_center">16</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">16</td>
<td class="gt_row gt_center">17</td></tr>
    <tr><td class="gt_row gt_left">Uncontrolled BP (SBP &gt;= 130 mm Hg or DBP &gt;= 80 mm Hg)</td>
<td class="gt_row gt_center">41</td>
<td class="gt_row gt_center">39</td>
<td class="gt_row gt_center">38</td>
<td class="gt_row gt_center">37</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">36</td>
<td class="gt_row gt_center">36</td></tr>
    <tr><td class="gt_row gt_left">Hypertension (JNC7 guideline definition)</td>
<td class="gt_row gt_center">27</td>
<td class="gt_row gt_center">27</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">30</td>
<td class="gt_row gt_center">30</td>
<td class="gt_row gt_center">31</td>
<td class="gt_row gt_center">31</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">33</td></tr>
    <tr><td class="gt_row gt_left">Hypertension (2017 ACC/AHA BP guideline definition)</td>
<td class="gt_row gt_center">45</td>
<td class="gt_row gt_center">45</td>
<td class="gt_row gt_center">45</td>
<td class="gt_row gt_center">44</td>
<td class="gt_row gt_center">44</td>
<td class="gt_row gt_center">43</td>
<td class="gt_row gt_center">46</td>
<td class="gt_row gt_center">44</td>
<td class="gt_row gt_center">46</td>
<td class="gt_row gt_center">47</td></tr>
    <tr><td class="gt_row gt_left">Awareness of hypertension</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">30</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">31</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">32</td></tr>
    <tr><td class="gt_row gt_left">Resistant hypertension (JNC7 guideline definition)</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">2.1</td>
<td class="gt_row gt_center">3.4</td>
<td class="gt_row gt_center">3.5</td>
<td class="gt_row gt_center">3.5</td>
<td class="gt_row gt_center">3.6</td>
<td class="gt_row gt_center">3.5</td>
<td class="gt_row gt_center">3.6</td>
<td class="gt_row gt_center">3.3</td>
<td class="gt_row gt_center">3.5</td></tr>
    <tr><td class="gt_row gt_left">Resistant hypertension (2017 ACC/AHA BP guideline definition)</td>
<td class="gt_row gt_center">2.1</td>
<td class="gt_row gt_center">2.4</td>
<td class="gt_row gt_center">3.9</td>
<td class="gt_row gt_center">4.1</td>
<td class="gt_row gt_center">3.8</td>
<td class="gt_row gt_center">4.0</td>
<td class="gt_row gt_center">3.8</td>
<td class="gt_row gt_center">4.1</td>
<td class="gt_row gt_center">3.5</td>
<td class="gt_row gt_center">3.9</td></tr>
    <tr><td class="gt_row gt_left">Resistant hypertension (2017 ACC/AHA BP guideline definition requires thiazide diuretic)</td>
<td class="gt_row gt_center">1.3</td>
<td class="gt_row gt_center">1.4</td>
<td class="gt_row gt_center">2.1</td>
<td class="gt_row gt_center">2.3</td>
<td class="gt_row gt_center">2.1</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">2.3</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">2.1</td>
<td class="gt_row gt_center">1.8</td></tr>
    <tr><td class="gt_row gt_left">Resistant hypertension (JNC7 guideline definition requires thiazide diuretic)</td>
<td class="gt_row gt_center">1.5</td>
<td class="gt_row gt_center">1.6</td>
<td class="gt_row gt_center">2.4</td>
<td class="gt_row gt_center">2.6</td>
<td class="gt_row gt_center">2.4</td>
<td class="gt_row gt_center">2.5</td>
<td class="gt_row gt_center">2.5</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">2.1</td></tr>
    <tr><td class="gt_row gt_left">Smoking status</td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Never</td>
<td class="gt_row gt_center">51</td>
<td class="gt_row gt_center">51</td>
<td class="gt_row gt_center">49</td>
<td class="gt_row gt_center">51</td>
<td class="gt_row gt_center">53</td>
<td class="gt_row gt_center">55</td>
<td class="gt_row gt_center">56</td>
<td class="gt_row gt_center">57</td>
<td class="gt_row gt_center">57</td>
<td class="gt_row gt_center">58</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Former</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">24</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">25</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">Current</td>
<td class="gt_row gt_center">24</td>
<td class="gt_row gt_center">25</td>
<td class="gt_row gt_center">26</td>
<td class="gt_row gt_center">24</td>
<td class="gt_row gt_center">23</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">18</td>
<td class="gt_row gt_center">17</td></tr>
    <tr><td class="gt_row gt_left">Body mass index, kg/m2</td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">&lt;25</td>
<td class="gt_row gt_center">37</td>
<td class="gt_row gt_center">36</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">31</td>
<td class="gt_row gt_center">29</td>
<td class="gt_row gt_center">27</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">25 to &lt;30</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">35</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">34</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">33</td>
<td class="gt_row gt_center">32</td>
<td class="gt_row gt_center">31</td>
<td class="gt_row gt_center">31</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">30 to &lt;35</td>
<td class="gt_row gt_center">17</td>
<td class="gt_row gt_center">18</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">19</td>
<td class="gt_row gt_center">19</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">20</td>
<td class="gt_row gt_center">21</td>
<td class="gt_row gt_center">21</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">35+</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">17</td>
<td class="gt_row gt_center">18</td>
<td class="gt_row gt_center">20</td></tr>
    <tr><td class="gt_row gt_left">Prevalent diabetes</td>
<td class="gt_row gt_center">6.8</td>
<td class="gt_row gt_center">7.0</td>
<td class="gt_row gt_center">7.9</td>
<td class="gt_row gt_center">7.9</td>
<td class="gt_row gt_center">9.8</td>
<td class="gt_row gt_center">9.9</td>
<td class="gt_row gt_center">10</td>
<td class="gt_row gt_center">10</td>
<td class="gt_row gt_center">11</td>
<td class="gt_row gt_center">12</td></tr>
    <tr><td class="gt_row gt_left">Prevalent chronic kidney disease</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">13</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">12</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">15</td>
<td class="gt_row gt_center">14</td>
<td class="gt_row gt_center">14</td></tr>
    <tr><td class="gt_row gt_left">Number of high risk conditions</td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td>
<td class="gt_row gt_center"></td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">3 or fewer</td>
<td class="gt_row gt_center">98</td>
<td class="gt_row gt_center">98</td>
<td class="gt_row gt_center">98</td>
<td class="gt_row gt_center">97</td>
<td class="gt_row gt_center">97</td>
<td class="gt_row gt_center">96</td>
<td class="gt_row gt_center">96</td>
<td class="gt_row gt_center">96</td>
<td class="gt_row gt_center">97</td>
<td class="gt_row gt_center">96</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">4</td>
<td class="gt_row gt_center">1.7</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">2.1</td>
<td class="gt_row gt_center">2.5</td>
<td class="gt_row gt_center">3.0</td>
<td class="gt_row gt_center">3.0</td>
<td class="gt_row gt_center">3.4</td>
<td class="gt_row gt_center">2.7</td>
<td class="gt_row gt_center">3.2</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">5</td>
<td class="gt_row gt_center">0.2</td>
<td class="gt_row gt_center">0.3</td>
<td class="gt_row gt_center">0.3</td>
<td class="gt_row gt_center">0.7</td>
<td class="gt_row gt_center">0.8</td>
<td class="gt_row gt_center">0.5</td>
<td class="gt_row gt_center">0.8</td>
<td class="gt_row gt_center">0.6</td>
<td class="gt_row gt_center">0.5</td>
<td class="gt_row gt_center">0.5</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">6</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">0.2</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">0.1</td>
<td class="gt_row gt_center">0.3</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">0</td></tr>
    <tr><td class="gt_row gt_left" style="text-align: left; text-indent: 10px;">7 or more</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">&lt;0.1</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td>
<td class="gt_row gt_center">0</td></tr>
    <tr><td class="gt_row gt_left">History of myocardial infarction</td>
<td class="gt_row gt_center">3.5</td>
<td class="gt_row gt_center">2.9</td>
<td class="gt_row gt_center">3.8</td>
<td class="gt_row gt_center">3.5</td>
<td class="gt_row gt_center">3.3</td>
<td class="gt_row gt_center">3.2</td>
<td class="gt_row gt_center">3.2</td>
<td class="gt_row gt_center">3.2</td>
<td class="gt_row gt_center">3.4</td>
<td class="gt_row gt_center">3.6</td></tr>
    <tr><td class="gt_row gt_left">History of coronary heart disease</td>
<td class="gt_row gt_center">4.9</td>
<td class="gt_row gt_center">4.6</td>
<td class="gt_row gt_center">5.5</td>
<td class="gt_row gt_center">5.1</td>
<td class="gt_row gt_center">4.8</td>
<td class="gt_row gt_center">4.9</td>
<td class="gt_row gt_center">4.5</td>
<td class="gt_row gt_center">5.2</td>
<td class="gt_row gt_center">5.3</td>
<td class="gt_row gt_center">5.7</td></tr>
    <tr><td class="gt_row gt_left">History of stroke</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">2.6</td>
<td class="gt_row gt_center">2.8</td>
<td class="gt_row gt_center">3.2</td>
<td class="gt_row gt_center">2.6</td>
<td class="gt_row gt_center">2.9</td>
<td class="gt_row gt_center">2.9</td>
<td class="gt_row gt_center">2.8</td>
<td class="gt_row gt_center">3.6</td></tr>
    <tr><td class="gt_row gt_left">History of ASCVD</td>
<td class="gt_row gt_center">6.1</td>
<td class="gt_row gt_center">6.0</td>
<td class="gt_row gt_center">7.1</td>
<td class="gt_row gt_center">6.9</td>
<td class="gt_row gt_center">6.9</td>
<td class="gt_row gt_center">6.5</td>
<td class="gt_row gt_center">6.5</td>
<td class="gt_row gt_center">7.0</td>
<td class="gt_row gt_center">7.1</td>
<td class="gt_row gt_center">8.2</td></tr>
    <tr><td class="gt_row gt_left">History of heart failure</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">2.1</td>
<td class="gt_row gt_center">2.4</td>
<td class="gt_row gt_center">2.4</td>
<td class="gt_row gt_center">2.2</td>
<td class="gt_row gt_center">2.0</td>
<td class="gt_row gt_center">2.8</td>
<td class="gt_row gt_center">2.5</td>
<td class="gt_row gt_center">2.4</td>
<td class="gt_row gt_center">2.6</td></tr>
    <tr><td class="gt_row gt_left">History of CVD</td>
<td class="gt_row gt_center">6.8</td>
<td class="gt_row gt_center">6.7</td>
<td class="gt_row gt_center">7.9</td>
<td class="gt_row gt_center">7.7</td>
<td class="gt_row gt_center">7.6</td>
<td class="gt_row gt_center">7.2</td>
<td class="gt_row gt_center">7.6</td>
<td class="gt_row gt_center">7.8</td>
<td class="gt_row gt_center">7.8</td>
<td class="gt_row gt_center">9.1</td></tr>
  </tbody>
  
  
</table>
</div>

# %>%
#  as_gt() %>%
#  tab_source_note("Table values are mean (standard deviation) or percent.")
