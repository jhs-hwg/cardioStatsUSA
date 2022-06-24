

libname nh "H:\studies\CVD\shared\Amgen Cardiac Collaboration\Users\Ligong\NHANES Shiny app";

data cohort;
set nh.small9920;
run;

%macro surv_means(data,weight,domain,variable,cat);
proc surveymeans data=&data.;
cluster SDMVPSU;
strata SDMVSTRA;
weight &weight.;
domain &domain.;
var  &variable.;
ods output domain=&variable._1;
run;

data &variable._&cat.;
set &variable._1;
length Var_Name $256 CI $50 CI_final $50;
Var_Name=VarName;
rse=round(StdErr/Mean,0.01);
if rse>=.3 then p_reliable=0; else p_reliable=1;
CI=compress(left(put(Mean,5.1)))||' ('||strip(put(StdErr,5.1))||')';
var_cat=&cat.;
CI_final=CI;
if p_reliable=0 then CI_final="-";
keep Var_Name var_cat CI_final rse p_reliable CI ;
run;
proc print;run;
%mend;

%surv_means(cohort,newwt,surveyyr("1"),avgsbp,1);
%surv_means(cohort,newwt,surveyyr("2"),avgsbp,2);
%surv_means(cohort,newwt,surveyyr("3"),avgsbp,3);
%surv_means(cohort,newwt,surveyyr("4"),avgsbp,4);
%surv_means(cohort,newwt,surveyyr("5"),avgsbp,5);
%surv_means(cohort,newwt,surveyyr("6"),avgsbp,6);
%surv_means(cohort,newwt,surveyyr("7"),avgsbp,7);
%surv_means(cohort,newwt,surveyyr("8"),avgsbp,8);
%surv_means(cohort,newwt,surveyyr("9"),avgsbp,9);
%surv_means(cohort,newwt,surveyyr("10"),avgsbp,10);

%macro surv_freq_twoway(data,weight,subpop,variable,num);
proc surveyfreq data=&data.;
tables &subpop.*&variable. /row cl(type=CP) clwt;
cluster SDMVPSU;
strata SDMVSTRA;
weight &weight.;
ods output Summary=&variable._1a CrossTabs=&variable._2a;
run;

data &variable._1;
set &variable._1a end=last;
retain Nsum Npsu Nstrata;
if Label1 in ('Number of Observations', 'Number of Observations Used') then Nsum=cValue1;
if Label1='Number of Clusters' then Npsu=cValue1;
if Label1='Number of Strata' then Nstrata=cValue1;
df=Npsu-Nstrata;
var_name="&variable.";
keep Nsum Npsu Nstrata var_name DF;
if last;
run;

data &variable._2;
set &variable._2a;
var_name="&variable.";
var_level=&variable.;
keep var_level Frequency WgtFreq RowPercent RowStdErr var_name RowLowerCL RowUpperCL LowerCLWgtFreq UpperCLWgtFreq;
rename RowPercent=percent RowStdErr=StdErr RowLowerCL=LowerCL RowUpperCL=UpperCL;
if var_level^=. and &subpop.=&num.;
run;

data &variable._3;
merge &variable._1 &variable._2;
by var_name;
p=percent/100;
sep=stderr/100;
run;

data &variable.;
set &variable._3;
length CI_prop CI_final CI_wgtfreq $50;
q=1-p;

df_flag=0;
if df < 8 then df_flag=1;

*effective sample size;
*compute n effective;
if (0 < p < 1) then n_eff = (p*(1-p))/(sep**2);
else n_eff=nsum;
if (n_eff=. or n_eff > nsum) then n_eff=nsum;

*Korn and Graubard CI absolute width;
kg_wdth=(uppercl - lowercl)/100;

CI_prop=compress(left(put(percent,5.1)))||' ('||strip(put(lowercl,5.1))||', '||strip(put(uppercl,5.1))||')';
CI_wgtfreq=compress(left(put(WgtFreq,5.1)))||' ('||strip(put(LowerCLWgtFreq,5.1))||', '||strip(put(UpperCLWgtFreq,5.1))||')';

*Korn and Graubard CI relative width for p;
if (p>0) then kg_relw_p=100*(kg_wdth/p); else kg_relw_p=.;

*Korn and Graubard CI relative width for q;
if (q>0) then kg_relw_q=100*(kg_wdth/q); else kg_relw_q=.;

*Proportions with CI width <= 0.05 are reliable, unless;
p_reliable=1;
*if Effective sample size is less than 30, then not reliable;
*if Absolute CI width is greater than or equal 0.30, then not reliable;
*if Relative CI width is greater than 130% , then not reliable;
if n_eff < 30 then p_reliable=0;
else if kg_wdth ge 0.30 then p_reliable=0;
else if (kg_relw_p > 130 and kg_wdth > 0.05 and kg_wdth < 0.3) then p_reliable=0;

*Determine if estimate should be flagged as having an unreliable complement;
*Complementary proportions are reliable, unless Relative CI width is greater than 130% ;
if (p_reliable=1) then do;

q_reliable=1;
if (kg_relw_q > 130 and kg_wdth > 0.05 and kg_wdth < 0.3) then q_reliable=0;
end;

*Estimates with df < 8 or percents = 0 or 100 or unreliable complement are flagged for statistical review;
p_staistical=0;
if p_reliable=1 then do;
if df_flag=1 or p=0 or p=1 or q_reliable=0 then p_staistical =1;
end;

CI_final=CI_prop;
if p_reliable=0 then CI_final="-";

keep var_name var_level frequency WgtFreq nsum DF  Percent StdErr n_eff
kg_wdth kg_relw_p kg_relw_q p_reliable q_reliable p_staistical  CI_prop CI_final CI_wgtfreq;

run;
proc print;run;
%mend;

%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,1);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,2);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,3);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,4);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,5);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,6);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,7);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,8);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,9);
%surv_freq_twoway(cohort,newwt,surveyyr,Jnc7htn,10);

%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,1);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,2);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,3);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,4);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,5);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,6);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,7);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,8);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,9);
%surv_freq_twoway(cohort,newwt,surveyyr,bpcatmed,10);
