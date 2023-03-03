
**** 1999-2000 data;**** 1999-2000 data; **** 1999-2000 data; **** 1999-2000 data;**** 1999-2000 data; **** 1999-2000 data;

libname nh9900 'O:\REGARDS\NHANES_data\NHANES9900';
libname drugs 'O:\REGARDS\NHANES_data\nhanes_medication_09232015';
libname nhanes2 'O:\REGARDS\NHANES_data\STATINS';

/*Merge 1999-2000 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data nz1;
set nh9900.demo;
run;
proc sort data=nz1; by SEQN; run;

***** Blood pressure questionnaire;
data nz2;
set nh9900.bpq;
run;
proc sort data=nz2; by SEQN; run;

***** Smoking data;
data nz3;
set nh9900.SMQ;
run;
proc sort data=nz3; by SEQN; run;

***** Blood pressure measurements;
data nz4;
set nh9900.BPX; 
run;
proc sort data=nz4; by SEQN; run;

**** Medical history;
data nz5; 
set nh9900.MCQ;
run;
proc sort data=nz5; by SEQN; run;

***** Diabetes questionnaire;
data nz6;
set nh9900.DIQ;
run;
proc sort data=nz6; by SEQN; run;


**** Anthropometrics examination data;
data nz7;
set nh9900.BMX;
run;
proc sort data=nz7; by SEQN; run;

**** Biochemistry data;
data nz8; 
set nh9900.biopro;
run;
proc sort data=nz8; by SEQN; run;

**** Urinalysis data;
data nz9;
set nh9900.alb_cr;
run;
proc sort data=nz9; by SEQN; run;

**** Total cholesterol data;
data nz10;
set nh9900.tchol; drop lbdhdl;
run;
proc sort data=nz10; by SEQN; run;

**** HDL cholesterol data;
data nz11;
set nh9900.hdl;
lbdhdd=lbdhdl;
keep seqn lbdhdd;
run;
proc sort data=nz11; by SEQN; run;

**** HbA1c data;
data nz12;
set nh9900.ghb;
run;
proc sort data=nz12; by SEQN; run;

**** Triglycerides data;
data nz13;
set nh9900.lab13am;
run;
proc sort data=nz13; by SEQN; run;

**** Fasting questionnaire;
data nz14;
set nh9900.fastqx; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=nz14; by SEQN; run;

***** Marge together the 18 data sets;
data nz14a;
merge nz1 nz2 nz3 nz4 nz5 nz6 nz7 nz8 nz9 nz10 nz11  nz12 nz13 nz14;
by SEQN; 
run; 


**** We recode some variables so that this data set can be appended with the NHANES 2011-2012 data;
**** Also, we only keep the relevant variables;
data nz15;
set nz14a;
DMPILLS=DIQ070;
surveyyr=1;
intonly=RIDSTATR;	
ridreth3=.;
dbq700=.;
**** CALIBRATE THE SERUM CREATININE;
lbxscr = 1.013 * lbxscr +0.147;

keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr 
PEASCST1 PEASCCT1 intonly PHDSESN  RIDEXPRG   ;
run;



**** 2001-2002 data; **** 2001-2002 data; **** 2001-2002 data; **** 2001-2002 data; **** 2001-2002 data; **** 2001-2002 data; **** 2001-2002 data; **** 2001-2002 data; 
libname nh0102 'O:\REGARDS\NHANES_data\NHANES0102';

/*Merge 2001-2002 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data ot1;
set nh0102.demo_b;
run;
proc sort data=ot1; by SEQN; run;

***** Blood pressure questionnaire;
data ot2;
set nh0102.bpq_b;
run;
proc sort data=ot2; by SEQN; run;

***** Smoking data;
data ot3;
set nh0102.SMQ_b;
run;
proc sort data=ot3; by SEQN; run;

***** Blood pressure measurements;
data ot4;
set nh0102.BPX_b; 
run;
proc sort data=ot4; by SEQN; run;

**** Medical history;
data ot5; 
set nh0102.MCQ_b;
run;
proc sort data=ot5; by SEQN; run;

***** Diabetes questionnaire;
data ot6;
set nh0102.DIQ_B;
run;
proc sort data=ot6; by SEQN; run;


**** Anthropometrics examination data;
data ot7;
set nh0102.BMX_B;
run;
proc sort data=ot7; by SEQN; run;

**** Biochemistry data;
data ot8; 
set nh0102.biopro_b;
run;
proc sort data=ot8; by SEQN; run;
 
proc contents data=ot8; run;

**** Urinalysis data;
data ot9;
set nh0102.alb_cr_b;
run;
proc sort data=ot9; by SEQN; run;

**** Total cholesterol data;
data ot10;
set nh0102.tchol_b; 
run;
proc sort data=ot10; by SEQN; run;

**** HbA1c data;
data ot11;
set nh0102.ghb_b;
run;
proc sort data=ot11; by SEQN; run;


**** Triglycerides data;
data ot12;
set nh0102.l13am_b;
run;
proc sort data=ot12; by SEQN; run;

**** Fasting questionnaire;
data ot13;
set nh0102.fastqx_b; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=ot13; by SEQN; run;

***** Marge together the 18 data sets;
data ot14;
merge ot1 ot2 ot3 ot4 ot5 ot6  ot7 ot8 ot9 ot10 ot11 ot12  ot13 ;
by SEQN; 
run; 



**** We recode some variables so that this data set can be appended with the NHANES 2011-2012 data;
**** Also, we only keep the relevant variables;
data ot15;
set ot14;
DMPILLS=DIQ070;
surveyyr=2;
intonly=RIDSTATR;	
ridreth3=.;
dbq700=.;
LBDHDD=LBDHDL;
lbxscr=lbdscr;
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr intonly PHDSESN RIDEXPRG PEASCST1 PEASCCT1;
run;
 

 




**** 2003-2004 data; **** 2003-2004 data; **** 2003-2004 data; **** 2003-2004 data; **** 2003-2004 data; **** 2003-2004 data; **** 2003-2004 data; **** 2003-2004 data; **** 2003-2004 data; 
libname nh0304 'O:\REGARDS\NHANES_data\NHANES0304';
/*Merge 2003-2004 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data tfour1;
set nh0304.demo_c;
run;
proc sort data=tfour1; by SEQN; run;

***** Blood pressure questionnaire;
data tfour2;
set nh0304.bpq_c;
run;
proc sort data=tfour2; by SEQN; run;

***** Smoking data;
data tfour3;
set nh0304.SMQ_c;
run;
proc sort data=tfour3; by SEQN; run;

***** Blood pressure measurements;
data tfour4;
set nh0304.BPX_c; 
run;
proc sort data=tfour4; by SEQN; run;

**** Medical history;
data tfour5; 
set nh0304.MCQ_c;
run;
proc sort data=tfour5; by SEQN; run;

***** Diabetes questionnaire;
data tfour6;
set nh0304.DIQ_c;
run;
proc sort data=tfour6; by SEQN; run;


**** Anthropometrics examination data;
data tfour7;
set nh0304.BMX_c;
run;
proc sort data=tfour7; by SEQN; run;

**** Biochemistry data;
data tfour8; 
set nh0304.biopro_c;
run;
proc sort data=tfour8; by SEQN; run;

**** Urinalysis data;
data tfour9;
set nh0304.alb_cr_c;
run;
proc sort data=tfour9; by SEQN; run;

**** Total cholesterol data;
data tfour10;
set nh0304.tchol_c;
run;
proc sort data=tfour10; by SEQN; run;

**** HbA1c data;
data tfour11;
set nh0304.ghb_c;
run;
proc sort data=tfour11; by SEQN; run;
 

**** Triglycerides data;
data tfour12;
set nh0304.l13am_c;
run;
proc sort data=tfour12; by SEQN; run;

**** Fasting questionnaire;
data tfour13;
set nh0304.fastqx_c; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=tfour13; by SEQN; run;



***** Marge together the 18 data sets;
data tfour14;
merge tfour1 tfour2 tfour3 tfour4 tfour5 tfour6 tfour7  tfour8 tfour9 tfour10 tfour11  tfour12 tfour13;
by SEQN; 
run; 
 

**** We recode some variables so that this data set can be appended with the NHANES 2011-2012 data;
**** Also, we only keep the relevant variables;
data tfour15;
set tfour14;
DMPILLS=DIQ070;
surveyyr=3;
intonly=RIDSTATR;	
ridreth3=.;
LBDHDD=LBXHDD;
dbq700=.;
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr 
PEASCST1 PEASCCT1  intonly PHDSESN RIDEXPRG ;
run;




**** 2005-2006 data; **** 2005-2006 data; **** 2005-2006 data; **** 2005-2006 data; **** 2005-2006 data; **** 2005-2006 data; **** 2005-2006 data; **** 2005-2006 data; 
libname nh0506 'O:\REGARDS\NHANES_data\NHANES0506';
/*Merge 2005-2006 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data fs1;
set nh0506.demo_d;
run;
proc sort data=fs1; by SEQN; run;

***** Blood pressure questionnaire;
data fs2;
set nh0506.bpq_d;
run;
proc sort data=fs2; by SEQN; run;

***** Smoking data;
data fs3;
set nh0506.SMQ_d;
run;
proc sort data=fs3; by SEQN; run;

***** Blood pressure measurements;
data fs4;
set nh0506.BPX_d; 
run;
proc sort data=fs4; by SEQN; run;

**** Medical history;
data fs5; 
set nh0506.MCQ_d;
run;
proc sort data=fs5; by SEQN; run;

***** Diabetes questionnaire;
data fs6;
set nh0506.DIQ_d;
run;
proc sort data=fs6; by SEQN; run;


**** Anthropometrics examination data;
data fs7;
set nh0506.BMX_d;
run;
proc sort data=fs7; by SEQN; run;

**** Biochemistry data;
data fs8; 
set nh0506.biopro_d;
run;
proc sort data=fs8; by SEQN; run;

**** Urinalysis data;
data fs9;
set nh0506.alb_cr_d;
run;
proc sort data=fs9; by SEQN; run;

**** Total cholesterol data;
data fs10;
set nh0506.tchol_d;
run;
proc sort data=fs10; by SEQN; run;

**** HbA1c data;
data fs11;
set nh0506.ghb_d;
run;
proc sort data=fs11; by SEQN; run;


**** Triglycerides data;
data fs12;
set nh0506.trigly_d;
run;
proc sort data=fs12; by SEQN; run;

**** Fasting questionnaire;
data fs13;
set nh0506.fastqx_d; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=fs13; by SEQN; run;

**** HDL cholesterol data;
data fs13a;
set nh0506.hdl_d;
run;
proc sort data=fs13a; by SEQN; run;



***** Marge together the 18 data sets;
data fs14;
merge fs1 fs2 fs3 fs4 fs5 fs6 fs7 fs8 fs9 fs10 fs11  fs12 fs13 fs13a;
by SEQN; 
run; 


**** We recode some variables so that this data set can be appended with the NHANES 2011-2012 data;
**** Also, we only keep the relevant variables;
data fs15;
set fs14;
DMPILLS=DID070;
surveyyr=4;
intonly=RIDSTATR;	
lbxscr = -0.016 + 0.978 * lbxscr;
ridreth3=.;
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr 
 PEASCST1 PEASCCT1 intonly PHDSESN RIDEXPRG ;
run;










**** 2007-2008 data; **** 2007-2008 data; **** 2007-2008 data; **** 2007-2008 data; **** 2007-2008 data; **** 2007-2008 data; **** 2007-2008 data; **** 2007-2008 data; 
libname nh0708 'O:\REGARDS\NHANES_data\NHANES0708'; 
/*Merge 2007-2008 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data se1;
set nh0708.demo_e;
run;
proc sort data=se1; by SEQN; run;

***** Blood pressure questionnaire;
data se2;
set nh0708.bpq_e;
run;
proc sort data=se2; by SEQN; run;

***** Smoking data;
data se3;
set nh0708.SMQ_e;
run;
proc sort data=se3; by SEQN; run;

***** Blood pressure measurements;
data se4;
set nh0708.BPX_e; 
run;
proc sort data=se4; by SEQN; run;

**** Medical history;
data se5; 
set nh0708.MCQ_e;
run;
proc sort data=se5; by SEQN; run;

***** Diabetes questionnaire;
data se6;
set nh0708.DIQ_e;
run;
proc sort data=se6; by SEQN; run;


**** Anthropometrics examination data;
data se7;
set nh0708.BMX_e;
run;
proc sort data=se7; by SEQN; run;

**** Biochemistry data;
data se8; 
set nh0708.biopro_e;
run;
proc sort data=se8; by SEQN; run;

**** Urinalysis data;
data se9;
set nh0708.alb_cr_e;
run;
proc sort data=se9; by SEQN; run;

**** Total cholesterol data;
data se10;
set nh0708.tchol_e;
run;
proc sort data=se10; by SEQN; run;

**** HDL cholesterol data;
data se11;
set nh0708.hdl_e;
run;
proc sort data=se11; by SEQN; run;

**** HbA1c data;
data se12;
set nh0708.ghb_e;
run;
proc sort data=se12; by SEQN; run;


**** Triglycerides data;
data se13;
set nh0708.trigly_e;
run;
proc sort data=se13; by SEQN; run;

**** Fasting questionnaire;
data se13a;
set nh0708.fastqx_e; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=se13a; by SEQN; run;


***** Marge together the 18 data sets;
data se14;
merge se1 se2 se3 se4 se5 se6 se7 se8 se9 se10 se11  se12 se13 se13a;
by SEQN; 
run; 


**** We recode some variables so that this data set can be appended with the NHANES 2011-2012 data;
**** Also, we only keep the relevant variables;
data se15;
set se14;
DMPILLS=DID070;
surveyyr=5;
intonly=RIDSTATR;	
ridreth3=.;
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
 LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr 
 PEASCST1 PEASCCT1 intonly PHDSESN RIDEXPRG ;
run;

















**** 2009-2010 data; **** 2009-2010 data; **** 2009-2010 data; **** 2009-2010 data; **** 2009-2010 data; **** 2009-2010 data; **** 2009-2010 data; **** 2009-2010 data; 
libname nh0910 'O:\REGARDS\NHANES_data\NHANES0910';
/*Merge 2009-2010 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data nt1;
set nh0910.demo_f;
run;
proc sort data=nt1; by SEQN; run;

***** Blood pressure questionnaire;
data nt2;
set nh0910.bpq_f;
run;
proc sort data=nt2; by SEQN; run;

***** Smoking data;
data nt3;
set nh0910.SMQ_f;
run;
proc sort data=nt3; by SEQN; run;

***** Blood pressure measurements;
data nt4;
set nh0910.BPX_f; 
run;
proc sort data=nt4; by SEQN; run;

**** Medical history;
data nt5; 
set nh0910.MCQ_f;
run;
proc sort data=nt5; by SEQN; run;

***** Diabetes questionnaire;
data nt6;
set nh0910.DIQ_f;
run;
proc sort data=nt6; by SEQN; run;

**** Anthropometrics examination data;
data nt7;
set nh0910.BMX_f;
run;
proc sort data=nt7; by SEQN; run;

**** Biochemistry data;
data nt8; 
set nh0910.biopro_f;
run;
proc sort data=nt8; by SEQN; run;

**** Urinalysis data;
data nt9;
set nh0910.alb_cr_f;
run;
proc sort data=nt9; by SEQN; run;

**** Total cholesterol data;
data nt10;
set nh0910.tchol_f;
run;
proc sort data=nt10; by SEQN; run;

**** HDL cholesterol data;
data nt11;
set nh0910.hdl_f;
run;
proc sort data=nt11; by SEQN; run;

**** HbA1c data;
data nt12;
set nh0910.ghb_f;
run;
proc sort data=nt12; by SEQN; run;


**** Triglycerides data;
data nt13;
set nh0910.trigly_f;
run;
proc sort data=nt13; by seqn; run;

**** Fasting questionnaire;
data nt13a;
set nh0910.fastqx_f; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=nt13a; by SEQN; run;

***** Marge together the 18 data sets;
data nt14;
merge nt1 nt2 nt3 nt4 nt5 nt6 nt7 nt8 nt9 nt10 nt11  nt12 nt13 nt13a;
by SEQN; 
run; 


**** We recode some variables so that this data set can be appended with the NHANES 2011-2012 data;
**** Also, we only keep the relevant variables;
data nt15;
set nt14;
DMPILLS=DIQ070;
surveyyr=6;
intonly=RIDSTATR;	
ridreth3=.;
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr 
PEASCST1 PEASCCT1 intonly PHDSESN RIDEXPRG ;
run;













**** 2011-2012 data; **** 2011-2012 data; **** 2011-2012 data; **** 2011-2012 data; **** 2011-2012 data; **** 2011-2012 data; **** 2011-2012 data; **** 2011-2012 data; 
libname nh1112 'O:\REGARDS\NHANES_data\NHANES1112';
/*Merge 2011-2012 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data et1;
set nh1112.demo_g;
run;
proc sort data=et1; by SEQN; run;

***** Blood pressure questionnaire;
data et2;
set nh1112.bpq_g;
run;
proc sort data=et2; by SEQN; run;

***** Smoking data;
data et3;
set nh1112.SMQ_g;
run;
proc sort data=et3; by SEQN; run;

***** Blood pressure measurements;
data et4;
set nh1112.BPX_g; 
run;
proc sort data=et4; by SEQN; run;

**** Medical history;
data et5; 
set nh1112.MCQ_g;
run;
proc sort data=et5; by SEQN; run;

***** Diabetes questionnaire;
data et6;
set nh1112.DIQ_g;
run;
proc sort data=et6; by SEQN; run;

**** Anthropometrics examination data;
data et7;
set nh1112.BMX_g;
run;
proc sort data=et7; by SEQN; run;

**** Biochemistry data;
data et8; 
set nh1112.biopro_g;
run;
proc sort data=et8; by SEQN; run;

**** Urinalysis data;
data et9;
set nh1112.alb_cr_g;
run;
proc sort data=et9; by SEQN; run;

**** Total cholesterol data;
data et10;
set nh1112.tchol_g;
run;
proc sort data=et10; by SEQN; run;

**** HDL cholesterol data;
data et11;
set nh1112.hdl_g;
run;
proc sort data=et11; by SEQN; run;

**** HbA1c data;
data et12;
set nh1112.ghb_g;
run;
proc sort data=et12; by SEQN; run;


**** Triglycerides data;
data et13;
set nh1112.trigly_g;
run;
proc sort data=et13; by seqn; run;

**** Fasting questionnaire;
data et13a;
set nh1112.fastqx_g; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=et13a; by SEQN; run;

***** Marge together the 18 data sets;
data et14;
merge et1 et2 et3 et4 et5 et6 et7 et8 et9 et10 et11 et12 et13 et13a;
by SEQN; 
run; 

**** We recode some variables so that this data set can be appended with the NHANES 2011-2012 data;
**** Also, we only keep the relevant variables;
data et15;
set et14;
DMPILLS=DIQ070;
surveyyr=7;
intonly=RIDSTATR;	
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr 
PEASCST1 PEASCCT1  intonly PHDSESN RIDEXPRG ;
run;







**** 2013-2014 data; **** 2013-2014 data; **** 2013-2014 data; **** 2013-2014 data; **** 2013-2014 data; **** 2013-2014 data; **** 2013-2014 data; **** 2013-2014 data; 
libname nhanes 'O:\REGARDS\NHANES_data\NHANES1314';
/*Merge 2013-2014 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data aa1;
set nhanes.demo_h;
run;
proc sort data=aa1; by SEQN; run;

***** Blood pressure questionnaire;
data aa2;
set nhanes.bpq_h;
run;
proc sort data=aa2; by SEQN; run;

***** Smoking data;
data aa3;
set nhanes.SMQ_h;
run;
proc sort data=aa3; by SEQN; run;

***** Blood pressure measurements;
data aa4;
set nhanes.BPX_h; 
run;
proc sort data=aa4; by SEQN; run;

**** Medical history;
data aa5; 
set nhanes.MCQ_h;
run;
proc sort data=aa5; by SEQN; run;

***** Diabetes questionnaire;
data aa6;
set nhanes.DIQ_h;
run;
proc sort data=aa6; by SEQN; run;

**** Anthropometrics examination data;
data aa7;
set nhanes.BMX_h;
run;
proc sort data=aa7; by SEQN; run;

**** Biochemistry data;
data aa8; 
set nhanes.biopro_h;
run;
proc sort data=aa8; by SEQN; run;


**** Urinalysis data;
data aa9;
set nhanes.alb_cr_h;
run;
proc sort data=aa9; by SEQN; run;

**** Total cholesterol data;
data aa10;
set nhanes.tchol_h;
run;
proc sort data=aa10; by SEQN; run;

**** HDL cholesterol data;
data aa11;
set nhanes.hdl_h;
run;
proc sort data=aa11; by SEQN; run;

**** HbA1c data;
data aa12;
set nhanes.ghb_h;
run;
proc sort data=aa12; by SEQN; run;


**** Triglycerides data;
data aa13;
set nhanes.trigly_h;
run;
proc sort data=aa13; by seqn; run;

**** Fasting questionnaire;
data aa13a;
set nhanes.fastqx_h; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=aa13a; by SEQN; run;

***** Marge together the 18 data sets;
data aa14;
merge aa1 aa2 aa3 aa4 aa5 aa6 aa7 aa8 aa9 aa10 aa11  aa12 aa13 aa13a;
by SEQN; 
run; 


**** We recode some variables so that this data set can be appended with the NHANES 2011-2012 data;
**** Also, we only keep the relevant variables;
data aa15;
set aa14;
DMPILLS=DIQ070;
surveyyr=8;
intonly=RIDSTATR;	
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr 
PEASCST1 PEASCCT1 intonly PHDSESN RIDEXPRG ;
run;




**** 2015-2016 data; **** 2015-2016 data; **** 2015-2016 data; **** 2015-2016 data; **** 2015-2016 data; **** 2015-2016 data; **** 2015-2016 data; **** 2015-2016 data; 
libname nhanesi 'O:\REGARDS\NHANES_data\NHANES1516';

/*Merge 2015-2016 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data a1;
set nhanesi.demo_i;
run;
proc sort data=a1; by SEQN; run;

***** Blood pressure questionnaire;
data a2;
set nhanesi.bpq_i;
run;
proc sort data=a2; by SEQN; run;

**** Smoking data;
data a3;
set nhanesi.SMQ_i;
run;
proc sort data=a3; by SEQN; run;

***** Blood pressure measurements;
data a4;
set nhanesi.BPX_i; 
run;
proc sort data=a4; by SEQN; run;

**** Medicare history;
data a5; 
set nhanesi.MCQ_i;
run;
proc sort data=a5; by SEQN; run;

**** Diabetes questionnaire;
data a6;
set nhanesi.DIQ_i;
run;
proc sort data=a6; by SEQN; run;

**** Anthropometrics examination data;
data a7;
set nhanesi.BMX_i;
run;
proc sort data=a7; by SEQN; run;

**** Biochemistry data;
data a8; 
set nhanesi.biopro_i;
run;
proc sort data=a8; by SEQN; run;

**** Urinalysis data;
data a9;
set nhanesi.alb_cr_i;
run;
proc sort data=a9; by SEQN; run;

**** Total cholesterol data;
data a10;
set nhanesi.tchol_i;
run;
proc sort data=a10; by SEQN; run;

**** HDL cholesterol data;
data a11;
set nhanesi.hdl_i;
run;
proc sort data=a11; by SEQN; run;

**** HbA1c data;
data a12;
set nhanesi.ghb_i;
run;
proc sort data=a12; by SEQN; run;


**** Triglycerides data;
data a13;
set nhanesi.trigly_i;
run;
proc sort data=a13; by seqn; run;


**** Fasting questionnaire;
data a13a;
set nhanesi.fastqx_i; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=a13a; by SEQN; run;

**** We recode some variables so that this data set can be appended with the NHANES 2013-2014 data;
**** Also, we only keep the relevant variables;
data a14;
merge a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a13a;
by SEQN; 
run; 

data a15;
set a14;
DMPILLS=DIQ070;
surveyyr=9;
intonly=RIDSTATR;
PEASCST1=.;
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr wtsaf2yr
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA WTINT2YR WTMEC2YR  ridstatr  surveyyr 
PEASCST1  PEASCCT1 intonly PHDSESN RIDEXPRG    ;
run;







**** 2017-2020 data; **** 2017-2020 data; **** 2017-2020 data; **** 2017-2020 data; **** 2017-2020 data; **** 2017-2020 data; **** 2017-2020 data; **** 2017-2020 data; 
libname nhanesk 'O:\REGARDS\NHANES_data\NHANES1720';

/*Merge 2017-2020 datasets and keep relevant variables*/
**** DEMOGRAPHICS;
data nh1_1720;
set nhanesk.p_demo;
run;
proc sort data=nh1_1720; by SEQN; run;

***** Blood pressure questionnaire;
data nh2_1720;
set nhanesk.p_bpq;
run;
proc sort data=nh2_1720; by SEQN; run;

**** Smoking data;
data nh3_1720;
set nhanesk.p_SMQ;
run;
proc sort data=nh3_1720; by SEQN; run;

***** Blood pressure measurements;
data nh4_1720;
set nhanesk.p_BPXo; 
run;
proc sort data=nh4_1720; by SEQN; run;

**** Medical history;
data nh5_1720; 
set nhanesk.p_mcq;
run;
proc sort data=nh5_1720; by SEQN; run;

**** Diabetes questionnaire;
data nh6_1720;
set nhanesk.p_diq;
run;
proc sort data=nh6_1720; by SEQN; run;

**** Anthropometrics examination data;
data nh7_1720;
set nhanesk.p_bmx;
run;
proc sort data=nh7_1720; by SEQN; run;

**** Biochemistry data;
data nh8_1720; 
set nhanesk.p_biopro;
run;
proc sort data=nh8_1720; by SEQN; run;

**** Urinalysis data;
data nh9_1720;
set nhanesk.p_alb_cr;
run;
proc sort data=nh9_1720; by SEQN; run;

**** Total cholesterol data;
data nh10_1720;
set nhanesk.p_tchol;
run;
proc sort data=nh10_1720; by SEQN; run;

**** HDL cholesterol data;
data nh11_1720;
set nhanesk.p_hdl;
run;
proc sort data=nh11_1720; by SEQN; run;

**** HbA1c data;
data nh12_1720;
set nhanesk.p_ghb;
run;
proc sort data=nh12_1720; by SEQN; run;


**** Triglycerides data;
data nh13_1720;
set nhanesk.p_trigly;
run;
proc sort data=nh13_1720; by seqn; run;


**** Fasting questionnaire;
data nh13a_1720;
set nhanesk.p_fastqx; keep seqn  PHAFSTHR PHAFSTMN PHDSESN;
run;
proc sort data=nh13a_1720; by SEQN; run;


**** We recode some variables so that this data set can be appended with the NHANES 2013-2014 data;
**** Also, we only keep the relevant variables;
data nh1720_merged;
merge nh1_1720 nh2_1720 nh3_1720 nh4_1720 nh5_1720 nh6_1720 nh7_1720 nh8_1720 
nh9_1720 nh10_1720 nh11_1720 nh12_1720 nh13_1720 nh13a_1720;
by SEQN; 
run; 

data nh15_nh20;
set nh1720_merged;
DMPILLS=DIQ070;
surveyyr=10;
intonly=RIDSTATR;
PEASCST1=.;
PEASCCT1=.;
**** CALIBRATE THE BLOOD PRESSURE VALUES AS THEY TRANSITIIONED FROM MERCURY TO OMRON DEVICES;
bpxdi1=BPXODI1-1.3;
bpxdi2=BPXODI2-1.3; 
bpxdi3=BPXODI3-1.3; 
bpxdi4=.;
bpxsy1=BPXOSY1+1.5;
bpxsy2=BPXOSY2+1.5; 
bpxsy3=BPXOSY3+1.5; 
bpxsy4=.;
wtint2yr=WTINTPRP; 
wtmec2yr=WTMECPRP; 
wtsaf2yr=wtsafprp; 
keep BMXBMI BMXWAIST BPQ020 BPQ030 BPQ060 BPQ080 BPQ040A BPQ050A BPQ090D BPQ100D BPXDI1 BPXDI2 BPXDI3 BPXDI4 BPXSY1 BPXSY2 BPXSY3 BPXSY4 DIQ010 DIQ050 DMPILLS lbxtr 
LBDHDD LBXGH LBXSGL  LBXSCR LBXTC MCQ160B MCQ160C MCQ160D MCQ160E MCQ160F MCQ220 RIDRETH3 
PHAFSTHR PHAFSTMN RIAGENDR RIDAGEYR RIDRETH1 SDMVPSU SDMVSTRA SEQN SMQ020 SMQ040 URXUCR URXUMA    ridstatr  surveyyr 
PEASCST1 PEASCCT1 intonly PHDSESN RIDEXPRG wtint2yr wtmec2yr wtsaf2yr ;
run;





/*Append together the datasets*/ 
proc append base=nz15 data=ot15; run;
proc append base=nz15 data=tfour15; run;
proc append base=nz15 data=fs15; run;
proc append base=nz15 data=se15; run;
proc append base=nz15 data=nt15; run;
proc append base=nz15 data=et15; run;
proc append base=nz15 data=aa15; run;
proc append base=nz15 data=a15; run;
proc append base=nz15 data=nh15_nh20; run;



**** READ IN ANTIHYPERTENSIVE MEDICATION DATA;
**** THE APPROACH FOR THIS IS ON LINE 2000;
libname lei2 "O:\REGARDS\NHANES_data\antiht_meds20092014\update_2_2023";
data antihtmeds; set lei2.seqn_antihyper_9900_1720; antihtavailable=1; 
keep seqn ace aldo alpha angioten beta ccb dhpccb ndhpccb central diur_ksparing diur_loop diur_thz renin_inhibitors vasod combination med_infox n_aht_pills;
run;


proc sort data=nz15; by seqn; run;
proc sort data=antihtmeds; by seqn; run;

data nz16; merge nz15 antihtmeds; by seqn; run; 



/*Code variables*/
data m1;
set nz16;

/*Calculate average BP*/

/*Calculate average BP*/
if BPXSY1=0 then BPXSY1=.;
if BPXSY2=0 then BPXSY2=.;
if BPXSY3=0 then BPXSY3=.;
if BPXSY4=0 then BPXSY4=.;
if BPXDI1=0 then BPXDI1=.;
if BPXDI2=0 then BPXDI2=.;
if BPXDI3=0 then BPXDI3=.;
if BPXDI4=0 then BPXDI4=.;

avgsbp= mean(of BPXSY1 BPXSY2 BPXSY3 BPXSY4);
avgdbp= mean (of BPXDI1 BPXDI2 BPXDI3 BPXDI4);
/*Create htmeds variable: 1= taking htn meds; 2= not taking htn meds*/
htmeds=0;
if bpq020=1 and bpq050a=1 then htmeds=1;
if bpq020=. or bpq020=7 or bpq020=9 then htmeds=.;
if bpq020=1 and (bpq040a=. or bpq040a=7 or bpq040a=9) then htmeds=.;
if bpq020=1 and bpq040a=1 and (bpq050a=. or bpq050a=7 or bpq050a=9) then htmeds=.;
num_htn_class=ace+aldo+alpha+angioten+beta+central+ccb+diur_Ksparing+diur_loop+diur_thz+Renin_inhibitors+vasod; 
takingantiht=0;
if htmeds=1 and num_htn_class>0 then takingantiht=1;
htpills2pl=0;
if n_aht_pills>=2 then htpills2pl=1;
run;
 

**** KEEP THE RELEVANT VARIABLES THAT I NEED;
data t2; set m1; 
keep seqn avgdbp avgsbp     htmeds     surveyyr bmxwaist bmxbmi bpq020 bpq030 bpq040a bpq050a bpq100d diq010 dmpills diq050 lbxtr wtsaf2yr
mcq160b mcq160c mcq160e mcq160f PHAFSTHR lbdhdd lbxgh lbxsgl lbxscr lbxtc  riagendr ridageyr ridreth1 sdmvpsu sdmvstra seqn smq020 smq040 urxucr urxuma wtmec2yr 
ridstatr ridreth3  BPXSY1 BPXSY2 BPXSY3 BPXSY4 BPXDI1 BPXDI2 BPXDI3 BPXDI4 RIDEXPRG PEASCST1 PEASCCT1
RIDEXPRG  
num_htn_class ace aldo alpha angioten beta central ccb diur_Ksparing diur_loop diur_thz Renin_inhibitors vasod dhpccb ndhpccb
takingantiht combination htpills2pl n_aht_pills; 
run;

***** Below, age and race categories are created;
data t3; set t2;
**** FOR NHANES 1999-2006, the upper age is 85 years but its 80 years in subsequent NHANES;
**** WE RECODE NHANES 1999-2006 to have an upper limit of 80 years;
if ridageyr>=80 then ridageyr=80;
agecat4=0;
if ridageyr>=18 and ridageyr<45 then agecat4=1;
if ridageyr>=45 and ridageyr<65 then agecat4=2;
if ridageyr>=65 and ridageyr<75 then agecat4=3;
if ridageyr>=75 then agecat4=4;

male=0;
if riagendr=1 then male=1;

pregnant=0;
if RIDEXPRG=1 then pregnant=1;
if RIDEXPRG=3 then pregnant=.;

**** CREATE RACE CATEGORIES;
race_wbaho=0;
if surveyyr=1 and ridreth1=3 then race_wbaho=1; 
if surveyyr=1 and ridreth1=4 then race_wbaho=2; 
if surveyyr=1 and (ridreth1=1 or ridreth1=2) then race_wbaho=4;
if surveyyr=1 and ridreth1=5 then race_wbaho=5; 

if surveyyr=2 and ridreth1=3 then race_wbaho=1;
if surveyyr=2 and ridreth1=4 then race_wbaho=2; 
if surveyyr=2 and (ridreth1=1 or ridreth1=2) then race_wbaho=4; 
if surveyyr=2 and ridreth1=5 then race_wbaho=5; 

if surveyyr=3 and ridreth1=3 then race_wbaho=1; 
if surveyyr=3 and ridreth1=4 then race_wbaho=2; 
if surveyyr=3 and (ridreth1=1 or ridreth1=2) then race_wbaho=4; 
if surveyyr=3 and ridreth1=5 then race_wbaho=5; 

if surveyyr=4 and ridreth1=3 then race_wbaho=1; 
if surveyyr=4 and ridreth1=4 then race_wbaho=2; 
if surveyyr=4 and (ridreth1=1 or ridreth1=2) then race_wbaho=4;
if surveyyr=4 and ridreth1=5 then race_wbaho=5; 

if surveyyr=5 and ridreth1=3 then race_wbaho=1; 
if surveyyr=5 and ridreth1=4 then race_wbaho=2; 
if surveyyr=5 and (ridreth1=1 or ridreth1=2) then race_wbaho=4; 
if surveyyr=5 and ridreth1=5 then race_wbaho=5; 

if surveyyr=6 and ridreth1=3 then race_wbaho=1; 
if surveyyr=6 and ridreth1=4 then race_wbaho=2; 
if surveyyr=6 and (ridreth1=1 or ridreth1=2) then race_wbaho=4; 
if surveyyr=6 and ridreth1=5 then race_wbaho=5; 

if surveyyr=7 and ridreth3=3 then race_wbaho=1; 
if surveyyr=7 and ridreth3=4 then race_wbaho=2; 
if surveyyr=7 and ridreth3=6 then race_wbaho=3; 
if surveyyr=7 and (ridreth3=1 or ridreth3=2) then race_wbaho=4; 
if surveyyr=7 and ridreth3=7 then race_wbaho=5; 

if surveyyr=8 and ridreth3=3 then race_wbaho=1; 
if surveyyr=8 and ridreth3=4 then race_wbaho=2; 
if surveyyr=8 and ridreth3=6 then race_wbaho=3; 
if surveyyr=8 and (ridreth3=1 or ridreth3=2) then race_wbaho=4; 
if surveyyr=8 and ridreth3=7 then race_wbaho=5; 

if surveyyr=9 and ridreth3=3 then race_wbaho=1; 
if surveyyr=9 and ridreth3=4 then race_wbaho=2; 
if surveyyr=9 and ridreth3=6 then race_wbaho=3; 
if surveyyr=9 and (ridreth3=1 or ridreth3=2) then race_wbaho=4; 
if surveyyr=9 and ridreth3=7 then race_wbaho=5; 

if surveyyr=10 and ridreth3=3 then race_wbaho=1; 
if surveyyr=10 and ridreth3=4 then race_wbaho=2; 
if surveyyr=10 and ridreth3=6 then race_wbaho=3; 
if surveyyr=10 and (ridreth3=1 or ridreth3=2) then race_wbaho=4; 
if surveyyr=10 and ridreth3=7 then race_wbaho=5; 


/*Create current smoking variable: 1=Yes, 2=No*/

nfc_smoker=0;
if SMQ040=3 and SMQ020=1 then nfc_smoker=1;
if (SMQ040=1 or SMQ040=2) and SMQ020=1 then nfc_smoker=2;
if SMQ020=. or SMQ020=7 or SMQ020=9 then nfc_smoker=.;
if SMQ020=1 and (SMQ040=. or SMQ040=7 or SMQ040=8 or SMQ040=9) then nfc_smoker=.;

/* Create BMI categories*/
bmicat=.;
if bmxbmi>10 and bmxbmi<25 then bmicat=1;
if bmxbmi>25 and bmxbmi<30 then bmicat=2;
if bmxbmi>30 and bmxbmi<35 then bmicat=3;
if bmxbmi>=35 then bmicat=4;

/*Create diabetes variables: 1-yes; 2-no*/
diabetes=2;  
if (DIQ010=1 and (DMPILLS=1 or DIQ050=1)) or (LBXGH>=6.5) then diabetes=1;

diabetes_exp=2;  
if (DIQ010=1 and (DMPILLS=1 or DIQ050=1)) or (LBXGH>=6.5) or lbxsgl>=200 or (PHAFSTHR>=8 and lbxsgl>=126) then diabetes_exp=1;




**** Calculate estimated glomerular filtration rate;
****RIAGENDR = sex (1=male,2=female);
****RIDAGEYR = age in years
**** LBXSCR= serum creatinine in mg/dL;
if riagendr=2 then Kappa=lbxscr/0.7;
if riagendr=1 then Kappa=lbxscr/0.9;
term1=kappa;
if riagendr=2 then a1=-0.241;
if riagendr=1 then a1=-0.302;
a2=-1.2;
c=0.9938;
d=1;
if riagendr=2 then d=1.012;
if term1<=1 then egfr=142 *(term1**a1) * (c**ridageyr) * d; 
if term1>1  then egfr=142 *(term1**a2) * (c**ridageyr) * d;

egfrlt60=0;
if egfr<60 and egfr>0 then egfrlt60=1;
**** CODE albuminuria;
acr=urxuma/urxucr*100;
acr30pl=0;
if acr>30 then acr30pl=1;
if urxuma=. then acr30pl=.;
if urxucr=. then acr30pl=.;
ckd=0;
if acr30pl=1 or egfrlt60=1 then ckd=1;


/*code hx of mi*/
hxmi=2;
if mcq160e=1 then hxmi=1;
if mcq160e=9 or mcq160e=. then hxmi=.;

/*code hx of chd*/
hxchd=2;
if mcq160c=1 or mcq160e=1 then hxchd=1;
if mcq160c=7 or mcq160e=9 or mcq160e=. then hxchd=.;

/*code hx of stroke*/
hxstroke=2;
if mcq160f=1 then hxstroke=1;
if mcq160f=9 or mcq160f=. then hxstroke=.;

/*code hx of ascvd*/
hxascvd=2;
if hxmi=1 or hxchd=1 or hxstroke=1 then hxascvd=1;

/*code hx of HF*/
hxhf=2;
if mcq160b=1 then hxhf=1;
if mcq160b=9 or mcq160b=. then hxhf=.;
/*code hx of cvd, including HF*/
hxcvd_hf=2;
if hxascvd=1 or hxhf=1 then hxcvd_hf=1;
run;

proc print data=t3 (obs=50); var lbxscr riagendr ridageyr egfr; run;
 

****Calculate 10-year predicted risk using the Pooled-Cohort risk equations;
data t4; set t3;
if htmeds=0 then sbp_treated=0; 
if htmeds=1 then sbp_treated=1; 

smoker01=0;
if nfc_smoker=2 then smoker01=1;

if diabetes=1 then dm01=1;
if diabetes=2 then dm01=0;

if ridageyr>0 then do; age_log=log(ridageyr); end;
age_log_sq=age_log**2;

if lbxtc>0 then do; cholest_log=log(lbxtc); end;
inx_age_chol=age_log*cholest_log;

if lbdhdd>0 then do;  hdl_log=log(lbdhdd); end;
inx_age_hdl=age_log*HDL_log;

if sbp_treated=1 then do; sbp_treat_log=log(avgsbp);sbp_untreat_log=0; end;
if sbp_treated=0 then do; sbp_untreat_log=log(avgsbp);sbp_treat_log=0; end;

inx_age_sbp_t=age_log*sbp_treat_log;
inx_age_sbp_ut=age_log*sbp_untreat_log;

inx_age_smoker=age_log*smoker01;

* Note: the following code does not require modifications;
/*White females*/
if male=0 and race_wbaho^=2 then ind_sum=(-29.799)*age_log+4.884*age_log_sq+13.54*cholest_log+(-3.114)*inx_age_chol+(-13.578)*hdl_log+3.149*inx_age_hdl+2.019*sbp_treat_log+
						1.957*sbp_untreat_log+7.574*smoker01+(-1.665)*inx_age_smoker+0.661*dm01;
if male=0 and race_wbaho^=2 then ind_sum_dif=ind_sum-(-29.18);

/*Black females*/
if male=0 and race_wbaho=2 then ind_sum=17.114*age_log+0.94*cholest_log+(-18.92)*hdl_log+4.475*inx_age_hdl+29.291*sbp_treat_log+(-6.432)*inx_age_sbp_t+27.820*sbp_untreat_log+
						(-6.087)*inx_age_sbp_ut+0.691*smoker01+0.874*dm01;
if male=0 and race_wbaho=2 then ind_sum_dif=ind_sum-86.61;

/*White males*/
if male=1 and race_wbaho^=2 then ind_sum=12.344*age_log+11.853*cholest_log+(-2.664)*inx_age_chol+(-7.99)*hdl_log+1.769*inx_age_hdl+1.797*sbp_treat_log+1.764*sbp_untreat_log+
						7.837*smoker01+(-1.795)*inx_age_smoker+0.658*dm01;
if male=1 and race_wbaho^=2 then ind_sum_dif=ind_sum-61.18;


/*Black males*/
if male=1 and race_wbaho=2 then ind_sum=2.469*age_log+0.302*cholest_log+(-0.307)*hdl_log+1.916*sbp_treat_log+1.809*sbp_untreat_log+0.549*smoker01+0.645*dm01;							
if male=1 and race_wbaho=2 then ind_sum_dif=ind_sum-19.54;


***FINAL RISK PREDICTION EQUATIONS;
/*White females*/
if male=0 and race_wbaho^=2 then risk=1-0.9665**exp(ind_sum_dif); * 10-year risk calculation. S10=0.9665;
/*Black females*/
if male=0 and race_wbaho=2 then risk=1-0.9533**exp(ind_sum_dif); * 10-year risk calculation. S10=0.9533;
/*White males*/
if male=1 and race_wbaho^=2 then risk=1-0.9144**exp(ind_sum_dif); * 10-year risk calculation. S10=0.9144;
/*Black males*/
if male=1 and race_wbaho=2 then risk=1-0.8954**exp(ind_sum_dif); * 10-year risk calculation. S10=0.8954;

if risk>=0 and risk < 0.05 then riskcat10yr=1;
if risk>=0.05 and risk<0.1 then riskcat10yr=2;
if risk>=0.1 and risk<0.20 then riskcat10yr=3;
if risk>=0.2 and risk<1.01 then riskcat10yr=4;
if hxcvd_hf=1 then riskcat10yr=5;

highrisk75=0;
if risk>=0.075 or hxcvd_hf=1 then highrisk75=1;
highrisk10=0;
if risk>=0.10 or hxcvd_hf=1 then highrisk10=1;
run;

data t4; set t4;
**** CODING RESISTANT HYPERTENSION - JNC7 DEFINITION REQUIRING A THIAZIDE DIURETIC;
rht_jnc7thz =0;
if htmeds=1 and num_htn_class>=4 and diur_thz=1 then rht_jnc7thz=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=140 or avgdbp>=90) and diur_thz=1 then rht_jnc7thz=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=130 or avgdbp>=80) and (ckd=1 or dm01=1) and diur_thz=1 then rht_jnc7thz=1;


**** CODING RESISTANT HYPERTENSION - 2017 ACC/AHA DEFINITION REQUIRING A THIAZIDE DIURETIC;
rht_accahathz =0;
if htmeds=1 and num_htn_class>=4 and diur_thz=1 then rht_accahathz=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=130 or avgdbp>=80) and (ridageyr<65) and diur_thz=1 then rht_accahathz=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=130 or avgdbp>=80) and (ridageyr>=65 and (ckd=1 or dm01=1 or highrisk10=1)) and diur_thz=1 then rht_accahathz=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=130)and (ridageyr>=65 and (ckd^=1 and dm01^=1 and highrisk10^=1)) and diur_thz=1 then rht_accahathz=1;
 

**** CODING RESISTANT HYPERTENSION - JNC7 DEFINITION NOT REQUIRING A THIAZIDE DIURETIC;
rht_jnc7=0;
if htmeds=1 and num_htn_class>=4 then rht_jnc7=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=140 or avgdbp>=90) then rht_jnc7=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=130 or avgdbp>=80) and (ckd=1 or dm01=1) then rht_jnc7=1;

**** CODING RESISTANT HYPERTENSION - 2017 ACC/AHA DEFINITION NOT REQUIRING A THIAZIDE DIURETIC;
rht_accaha=0;
if htmeds=1 and num_htn_class>=4 then rht_accaha=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=130 or avgdbp>=80) and (ridageyr<65)then rht_accaha=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=130 or avgdbp>=80) and (ridageyr>=65 and (ckd=1 or dm01=1 or highrisk10=1)) then rht_accaha=1;
if (htmeds=1 and num_htn_class>=3) and (avgsbp>=130)and (ridageyr>=65 and (ckd^=1 and dm01^=1 and highrisk10^=1))  then rht_accaha=1;
run;

data t4; set t4;
**** BELOW I CREATE THE BLOOD PRESSURE CATEGORIES USED IN THE NEW GUIDELINE;
if avgsbp<120 and avgdbp<80 then bpcat=1;
if (avgsbp>=120 and avgsbp<130 and avgdbp<80) then bpcat=2;
if (avgsbp>=130 and avgsbp<140 and avgdbp<90) or (avgsbp<140 and avgdbp>=80 and avgdbp<90) then bpcat=3;
if (avgsbp>=140 and avgsbp<160 and avgdbp<100) or (avgsbp<160 and avgdbp>=90 and avgdbp<100) then bpcat=4;
if avgsbp>=160 or avgdbp>=100 then bpcat=5;
bpcatmed=bpcat;
if htmeds=1 then bpcatmed=6; 
*** HYPERTENSION ACCORDING TO THE JNC7 GUIDELINE;
jnc7htn=0;
if avgsbp>=140 or avgdbp>=90 or htmeds=1 then jnc7htn=1;
**** HYPERTENSION ACCORDING TO THE 2017 ACC/AHA BP GUIDELINE;
accahahtn=0;
if avgsbp>=130 or avgdbp>=80 or htmeds=1 then accahahtn=1;
**** AWARENESS OF HAVING HYPERTENSION;
htn_aware=0;
if bpq020=1 then htn_aware=1; 
if bpq020=. or bpq020=7 or bpq020=9 then htn_aware=.;


**** CODE JNC7 ELIGIBILITY FOR ANTIHYPERTENSIVE TREATMENT; 
jnc7tx=0;
if htmeds=1 then jnc7tx=1; 
if (avgsbp>=140 or avgdbp>=90) then  jnc7tx=1; 
if (avgsbp>=130 or avgdbp>=80) and dm01=1 then jnc7tx=1; 
if (avgsbp>=130 or avgdbp>=80) and ckd=1 then  jnc7tx=1; 

**** CODE NEW GUIDELINE TREATMENT ELIGIBILITY FOR ANTIHYPERTENSIVE TREATMENT;
 newgdltx=0; 
if avgsbp>=140 or avgdbp>=90 or htmeds=1 then newgdltx=1; 
if (avgsbp>=130 or avgdbp>=80) and (highrisk10=1) then newgdltx=1; 
if (avgsbp>=130 or avgdbp>=80) and ckd=1 then newgdltx=1;
if (avgsbp>=130 or avgdbp>=80) and dm01=1 then newgdltx=1;
if ridageyr>=65 and avgsbp>=130 then newgdltx=1; 

*** MAKE SURE BP CONTROL VARIABLES ARE CORRECTLY DEFINED;
**** CONTROLLED BP DEFINITIONS;
control14090=0;
if avgsbp<140 and avgdbp<90 then control14090=1;

control13080=0;
if avgsbp<130 and avgdbp<80 then control13080=1;

jnc7_control=0;
if dm01~=1 and ckd~=1 and avgsbp<140 and avgdbp<90 then jnc7_control=1;
if (dm01=1 or ckd=1) and avgsbp<130 and avgdbp<80 then jnc7_control=1;

accaha_control=0;
if avgsbp<130 and avgdbp<80 then accaha_control=1;
if avgsbp<130 and ridageyr>=65 and highrisk10=0 and dm01=0 and ckd=0 then accaha_control=1;

*** ESC/ESH HYPERTENSION;
esceshhtn=0;
if avgsbp>=140 or avgdbp>=90 or htmeds=1 then esceshhtn=1;

***ESC/ESH RECOMMENDED TREATMENT;
escesh7tx=0;
if htmeds=1 then escesh7tx=1; 
if (avgsbp>=140 or avgdbp>=90) then  escesh7tx=1; 

***ESC/ESH BP CONTROL 1; 
escesh_control1=0;
if avgsbp<140 and avgdbp<90 then escesh_control1=1;

***ESC/ESH BP CONTROL 2; 
escesh_control2=0;
if ridageyr<65 and ckd=0 and (avgsbp<130 and avgdbp<80) then  escesh_control2=1;
if ridageyr<65 and ckd=1 and (avgsbp<140 and avgdbp<80) then  escesh_control2=1;
if ridageyr>=65 and (avgsbp<140 and avgdbp<80) then  escesh_control2=1;

**** UNCONTROLLED BP DEFINITIONS;
uncontrol14090=0;
if avgsbp>=140 or avgdbp>=90 then uncontrol14090=1;

uncontrol13080=0;
if avgsbp>=130 or avgdbp>=80 then uncontrol13080=1;

jnc7_uncontrol=0;
if dm01~=1 and ckd~=1 and (avgsbp>=140 or avgdbp>=90) then jnc7_uncontrol=1;
if (dm01=1 or ckd=1) and (avgsbp>=130 or avgdbp>=80) then jnc7_uncontrol=1;

accaha_uncontrol=0;
if (avgsbp>=130 or avgdbp>=80) and ridageyr<65 then accaha_uncontrol=1;
if (avgsbp>=130 or avgdbp>=80) and ridageyr>=65 and (highrisk10=1 or dm01=1 or ckd=1) then accaha_uncontrol=1;
if avgsbp>=130 then accaha_uncontrol=1;

escesh_uncontrol1=0;
if avgsbp>=140 or avgdbp>=90 then escesh_uncontrol1=1;

escesh_uncontrol2=0;
if ridageyr<65 and ckd=0 and (avgsbp>=130 or avgdbp>=80) then  escesh_uncontrol2=1;
if ridageyr<65 and ckd=1 and (avgsbp>=140 or avgdbp>=80) then  escesh_uncontrol2=1;
if ridageyr>=65 and (avgsbp>=140 or avgdbp>=80) then  escesh_uncontrol2=1;
run;

 


**** We restrict the analysis to participants >=20 years of age; 
**** We will also require that they attend the MEC visit (i.e., they have a MEC weight);
data t5; set t4;
subpop=1;
if ridageyr<18 then delete;
run;

data t5; set t5;
if wtmec2yr=0 or wtmec2yr=. then delete;
run;
 
proc freq data=t5; tables subpop*surveyyr; run;


**** We are going to require people have 3 valid blood pressure measurements and they are not missing antihypertensive medication use; 
**** First, we count the number of valid blood pressure measurements;
data t5b; set t5;
subpophtn=subpop;
sbp1valid=1; if BPXSY1=. then sbp1valid=0; 
sbp2valid=1; if BPXSY2=. then sbp2valid=0;
sbp3valid=1; if BPXSY3=.  then sbp3valid=0;
sbp4valid=1; if BPXSY4=. then sbp4valid=0;

dbp1valid=1; if BPXDI1=. or BPXDI1=0 then dbp1valid=0;
dbp2valid=1; if BPXDI2=. or BPXDI2=0 then dbp2valid=0;
dbp3valid=1; if BPXDI3=. or BPXDI3=0 then dbp3valid=0;
dbp4valid=1; if BPXDI4=. or BPXDI4=0 then dbp4valid=0;

sbpcount=sum(of sbp1valid sbp2valid sbp3valid sbp4valid);
dbpcount=sum(of dbp1valid dbp2valid dbp3valid dbp4valid);

if avgsbp=. or avgdbp=. then subpophtn=0;
if sbpcount<1 then subpophtn=0;
if dbpcount<1 then subpophtn=0;
run;

data t5c; set t5b; 
if htmeds=. then subpophtn=0;
run;
 
proc freq data=t5c; tables subpophtn*surveyyr; run;

proc freq data=t5c; where subpop=1; weight wtmec2yr; table surveyyr; run;
proc freq data=t5c; where subpophtn=1; weight wtmec2yr; table surveyyr; run;

*** WE RECALIBRATE THE WEIGHTS FOR MISSING DATA (missing SBP, DBP or SELF-REPORTED ANTIHYPERTENSIVE MEDICATION) BY AGE, RACE, SEX, NHANES cycle;
*** FIRST WE CREATE THE AGE, RACE, SEX CATEGORIES;
data t5e; set t5c;
age10=1;
if RIDAGEYR>=45 and RIDAGEYR<65 then age10=2;
if RIDAGEYR>=65 then age10=3;
/*Race: 1 or 2= Hispanic; 3=white; 4=black; 6 = Asian; 7=other*/
if age10=1 and RIAGENDR=1 and race_wbaho^=2 then asr=111;
if age10=1 and RIAGENDR=1 and race_wbaho=2 then asr=112;
if age10=1 and RIAGENDR=2 and  race_wbaho^=2 then asr=121;
if age10=1 and RIAGENDR=2 and  race_wbaho=2 then asr=122;

if age10=2 and RIAGENDR=1 and race_wbaho^=2 then asr=211;
if age10=2 and RIAGENDR=1 and race_wbaho=2 then asr=212;
if age10=2 and RIAGENDR=2 and  race_wbaho^=2 then asr=221;
if age10=2 and RIAGENDR=2 and  race_wbaho=2 then asr=222;

if age10=3 and RIAGENDR=1 and race_wbaho^=2 then asr=311;
if age10=3 and RIAGENDR=1 and race_wbaho=2 then asr=312;
if age10=3 and RIAGENDR=2 and  race_wbaho^=2 then asr=321;
if age10=3 and RIAGENDR=2 and  race_wbaho=2 then asr=322;
run;

****CALIBRATE NHANES 1999-2000;****CALIBRATE NHANES 1999-2000;****CALIBRATE NHANES 1999-2000;****CALIBRATE NHANES 1999-2000;****CALIBRATE NHANES 1999-2000;
data t5e_9900; set t5e; if surveyyr=1; run;
proc means data=t5e_9900 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal9900 sum=sum; run;  
data cal9900a; set cal9900; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_9900 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal9900v2 sum=sum; run;  
data cal9900v2a; set cal9900v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal9900a; by asr; run;
proc sort data=cal9900v2a; by asr; run;

data cal9900v3; merge cal9900a cal9900v2a; by asr; run;
data cal9900v3; set cal9900v3;  ratio=total/partial; run;

proc sort data=cal9900v3; by asr; run;
proc sort data=t5e_9900; by asr; run;

data t9900recal; merge t5e_9900 cal9900v3; by asr; run;
data t9900recal; set t9900recal;  newwt=(wtmec2yr*ratio); n=1; run;

***CONFIRM CALIBRATION WORKED!;
proc freq data=t9900recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t9900recal; where subpop=1; weight newwt; tables n; run;
proc freq data=t9900recal; where subpophtn=1; weight newwt; tables n; run;



****CALIBRATE NHANES 2001-2002;****CALIBRATE NHANES 2001-2002;****CALIBRATE NHANES 2001-2002;****CALIBRATE NHANES 2001-2002;****CALIBRATE NHANES 2001-2002;****CALIBRATE NHANES 2001-2002;
data t5e_0102; set t5e; if surveyyr=2; run;
proc means data=t5e_0102 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal9900 sum=sum; run;  
data cal9900a; set cal9900; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_0102 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal9900v2 sum=sum; run;  
data cal9900v2a; set cal9900v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal9900a; by asr; run;
proc sort data=cal9900v2a; by asr; run;

data cal9900v3; merge cal9900a cal9900v2a; by asr; run;
data cal9900v3; set cal9900v3;  ratio=total/partial; run;

proc sort data=cal9900v3; by asr; run;
proc sort data=t5e_0102; by asr; run;

data t0102recal; merge t5e_0102 cal9900v3; by asr; run;
data t0102recal; set t0102recal;  newwt=(wtmec2yr*ratio); n=1; run;

**** CONFIRM CALIBRATION WORKED;
proc freq data=t0102recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t0102recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t0102recal; where subpophtn=1; weight newwt; tables n; run;



****CALIBRATE NHANES 2003-2004; ****CALIBRATE NHANES 2003-2004; ****CALIBRATE NHANES 2003-2004;****CALIBRATE NHANES 2003-2004; ****CALIBRATE NHANES 2003-2004; ****CALIBRATE NHANES 2003-2004;
data t5e_0304; set t5e; if surveyyr=3; run;
proc means data=t5e_0304 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal0304 sum=sum; run;  
data cal0304a; set cal0304; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_0304 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal0304v2 sum=sum; run;  
data cal0304v2a; set cal0304v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal0304a; by asr; run;
proc sort data=cal0304v2a; by asr; run;

data cal0304v3; merge cal0304a cal0304v2a; by asr; run;
data cal0304v3; set cal0304v3;  ratio=total/partial; run;

proc sort data=cal0304v3; by asr; run;
proc sort data=t5e_0304; by asr; run;

data t0304recal; merge t5e_0304 cal0304v3; by asr; run;
data t0304recal; set t0304recal;  newwt=(wtmec2yr*ratio); n=1; run;

**** CONFIRM CALIBRATION WORKED;
proc freq data=t0304recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t0304recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t0304recal; where subpophtn=1; weight newwt; tables n; run;


****CALIBRATE NHANES 2005-2006;****CALIBRATE NHANES 2005-2006;****CALIBRATE NHANES 2005-2006;****CALIBRATE NHANES 2005-2006;****CALIBRATE NHANES 2005-2006;****CALIBRATE NHANES 2005-2006;
data t5e_0506; set t5e; if surveyyr=4; run;
proc means data=t5e_0506 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal0506 sum=sum; run;  
data cal0506a; set cal0506; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_0506 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal0506v2 sum=sum; run;  
data cal0506v2a; set cal0506v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal0506a; by asr; run;
proc sort data=cal0506v2a; by asr; run;

data cal0506v3; merge cal0506a cal0506v2a; by asr; run;
data cal0506v3; set cal0506v3;  ratio=total/partial; run;

proc sort data=cal0506v3; by asr; run;
proc sort data=t5e_0506; by asr; run;

data t0506recal; merge t5e_0506 cal0506v3; by asr; run;
data t0506recal; set t0506recal;  newwt=(wtmec2yr*ratio); n=1; run;

***** CONFIRM CALIBRATION WORKED;
proc freq data=t0506recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t0506recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t0506recal; where subpophtn=1; weight newwt; tables n; run;






****CALIBRATE NHANES 2007-2008; ****CALIBRATE NHANES 2007-2008; ****CALIBRATE NHANES 2007-2008; ****CALIBRATE NHANES 2007-2008; ****CALIBRATE NHANES 2007-2008;

data t5e_0708; set t5e; if surveyyr=5; run;
proc means data=t5e_0708 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal0708 sum=sum; run;  
data cal0708a; set cal0708; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_0708 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal0708v2 sum=sum; run;  
data cal0708v2a; set cal0708v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal0708a; by asr; run;
proc sort data=cal0708v2a; by asr; run;

data cal0708v3; merge cal0708a cal0708v2a; by asr; run;
data cal0708v3; set cal0708v3;  ratio=total/partial; run;

proc sort data=cal0708v3; by asr; run;
proc sort data=t5e_0708; by asr; run;

data t0708recal; merge t5e_0708 cal0708v3; by asr; run;
data t0708recal; set t0708recal;  newwt=(wtmec2yr*ratio); n=1; run;

*** CONFIRM CALIBRATION WORKED;
proc freq data=t0708recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t0708recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t0708recal; where subpophtn=1; weight newwt; tables n; run;




****CALIBRATE NHANES 2009-2010; ****CALIBRATE NHANES 2009-2010; ****CALIBRATE NHANES 2009-2010; ****CALIBRATE NHANES 2009-2010; ****CALIBRATE NHANES 2009-2010; 
data t5e_0910; set t5e; if surveyyr=6; run;
proc means data=t5e_0910 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal0910 sum=sum; run;  
data cal0910a; set cal0910; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_0910 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal0910v2 sum=sum; run;  
data cal0910v2a; set cal0910v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal0910a; by asr; run;
proc sort data=cal0910v2a; by asr; run;

data cal0910v3; merge cal0910a cal0910v2a; by asr; run;
data cal0910v3; set cal0910v3;  ratio=total/partial; run;

proc sort data=cal0910v3; by asr; run;
proc sort data=t5e_0910; by asr; run;

data t0910recal; merge t5e_0910 cal0910v3; by asr; run;
data t0910recal; set t0910recal;  newwt=(wtmec2yr*ratio); n=1; run;

*** CONFIRM CALIBRATION WORKED;
proc freq data=t0910recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t0910recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t0910recal; where subpophtn=1; weight newwt; tables n; run;





****CALIBRATE NHANES 2011-2012;****CALIBRATE NHANES 2011-2012;****CALIBRATE NHANES 2011-2012;****CALIBRATE NHANES 2011-2012;****CALIBRATE NHANES 2011-2012;****CALIBRATE NHANES 2011-2012; 
data t5e_1112; set t5e; if surveyyr=7; run;
proc means data=t5e_1112 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal112 sum=sum; run;  
data cal112a; set cal112; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_1112 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal112v2 sum=sum; run;  
data cal112v2a; set cal112v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal112a; by asr; run;
proc sort data=cal112v2a; by asr; run;

data cal112v3; merge cal112a cal112v2a; by asr; run;
data cal112v3; set cal112v3;  ratio=total/partial; run;

proc sort data=cal112v3; by asr; run;
proc sort data=t5e_1112; by asr; run;

data t1112recal; merge t5e_1112 cal112v3; by asr; run;
data t1112recal; set t1112recal;  newwt=(wtmec2yr*ratio); n=1; run;

*** CONFIRM CALIBRATION WORKED;
proc freq data=t1112recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t1112recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t1112recal; where subpophtn=1; weight newwt; tables n; run;



****CALIBRATE NHANES 2013-2014;****CALIBRATE NHANES 2013-2014;****CALIBRATE NHANES 2013-2014;****CALIBRATE NHANES 2013-2014;****CALIBRATE NHANES 2013-2014;****CALIBRATE NHANES 2013-2014;
data t5e_1314; set t5e; if surveyyr=8; run;
proc means data=t5e_1314 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal314 sum=sum; run;  
data cal314a; set cal314; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_1314 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal314v2 sum=sum; run;  
data cal314v2a; set cal314v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal314a; by asr; run;
proc sort data=cal314v2a; by asr; run;

data cal314v3; merge cal314a cal314v2a; by asr; run;
data cal314v3; set cal314v3;  ratio=total/partial; run;

proc sort data=cal314v3; by asr; run;
proc sort data=t5e_1314; by asr; run;

data t1314recal; merge t5e_1314 cal314v3; by asr; run;
data t1314recal; set t1314recal;  newwt=(wtmec2yr*ratio); n=1; run;

*** CONFIRM CALIBRATION WORKED;
proc freq data=t1314recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t1314recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t1314recal; where subpophtn=1; weight newwt; tables n; run;




****CALIBRATE NHANES 2015-2016;****CALIBRATE NHANES 2015-2016;****CALIBRATE NHANES 2015-2016;****CALIBRATE NHANES 2015-2016;****CALIBRATE NHANES 2015-2016;
data t5e_1516; set t5e; if surveyyr=9; run;
proc means data=t5e_1516 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal516 sum=sum; run;  
data cal516a; set cal516; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_1516 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal516v2 sum=sum; run;  
data cal516v2a; set cal516v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal516a; by asr; run;
proc sort data=cal516v2a; by asr; run;

data cal516v3; merge cal516a cal516v2a; by asr; run;
data cal516v3; set cal516v3;  ratio=total/partial; run;

proc sort data=cal516v3; by asr; run;
proc sort data=t5e_1516; by asr; run;

data t1516recal; merge t5e_1516 cal516v3; by asr; run;
data t1516recal; set t1516recal;  newwt=(wtmec2yr*ratio); n=1; run;

*** CONFIRM CALIBRATION WORKED;
proc freq data=t1516recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t1516recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t1516recal; where subpophtn=1; weight newwt; tables n; run;



****CALIBRATE NHANES 2017-2020;****CALIBRATE NHANES 2017-2020;****CALIBRATE NHANES 2017-2020;****CALIBRATE NHANES 2017-2020;****CALIBRATE NHANES 2017-2020;
data t5e_1720; set t5e; if surveyyr=10; run;
proc means data=t5e_1720 n sum; var wtmec2yr; where subpop=1; class asr; output out=cal1720 sum=sum; run;  
data cal1720a; set cal1720; if _type_=1; total=sum; keep asr total; run;
proc means data=t5e_1720 n sum; where subpophtn=1; var wtmec2yr; class asr; output out=cal1720v2 sum=sum; run;  
data cal1720v2a; set cal1720v2; if _type_=1; partial=sum; keep asr partial; run;

proc sort data=cal1720a; by asr; run;
proc sort data=cal1720v2a; by asr; run;

data cal1720v3; merge cal1720a cal1720v2a; by asr; run;
data cal1720v3; set cal1720v3;  ratio=total/partial; run;

proc sort data=cal1720v3; by asr; run;
proc sort data=t5e_1720; by asr; run;

data t1720recal; merge t5e_1720 cal1720v3; by asr; run;
data t1720recal; set t1720recal;  newwt=(wtmec2yr*ratio); n=1; run;

*** CONFIRM CALIBRATION WORKED;
proc freq data=t1720recal; where subpop=1; weight wtmec2yr; tables n; run;
proc freq data=t1720recal; where subpophtn=1; weight wtmec2yr; tables n; run;
proc freq data=t1720recal; where subpophtn=1; weight newwt; tables n; run;

data final9920; set t9900recal; run;

proc append data=t0102recal base=final9920; run;
proc append data=t0304recal base=final9920; run;
proc append data=t0506recal base=final9920; run;
proc append data=t0708recal base=final9920; run;
proc append data=t0910recal base=final9920; run;
proc append data=t1112recal base=final9920; run;
proc append data=t1314recal base=final9920; run;
proc append data=t1516recal base=final9920; run;
proc append data=t1720recal base=final9920; run;





/* 
*** SOME NOTES FOR THE READ-ME FILE;
*** DIFFERENCES IN RHT BETWEEN THE APP AND BOB CAREY'S PAPER (PMID: 30580690)

proc print data=app1; where ace=0 and carey_ace=1; var seqn surveyyr; run; * the one difference is CILAZAPRIL - probably OK to miss; run;
proc print data=app1; where ccb=0 and carey_ccb=1; var seqn surveyyr; run; * The one difference is NIMODIPINE - probably OK to exclude; run;
proc print data=app1; where alpha=0 and carey_alpha1=1; var seqn surveyyr; run; * It looks like TAMSULOSIN; May be other drugs;
proc print data=app1; where central=1 and carey_alpha2=0; var seqn surveyyr; run;
proc print data=app1; where beta=0 and carey_beta=1; var seqn surveyyr; run; *** THIS IS SOTALOL; OK to EXCLUDE;
proc print data=app1; where beta=1 and carey_beta=0; var seqn surveyyr; run;  
proc print data=app1; where diur_thz=0 and carey_tdiur=1; var seqn surveyyr; run; *** THIS IS METHYCLOTHIAZIDE; 
proc print data=app1; where diur_ksparing=0 and carey_pdiur=1; var seqn surveyyr; run; *** Potassium-Sparing diuretics were being counted; run;
proc print data=app1; where vasod=0 and carey_vasod=1; var seqn surveyyr; run; **** NITROGLYCERIN IS THE DIFFERENCE;

*** ONE MORE ITEM - SWATI KEPT TLD AND TTD AS TWO CLASSES and NDHCCB AND DHCCB AS TWO CLASSES;

*/


/*
****SAVE THE FILE FOR OUTPUTTING TO THE APP;
libname l "C:\Users\pmuntner\Box\j_drive\Delzell\CVD\2022\NHANES_data_platform\Final_code"; run;

data l.final9920_02202023; set final9920; run;

data l.small9920_02202023; set final9920; 
keep Seqn newwt Sdmvstra Sdmvpsu surveyyr ridageyr agecat4 riagendr race_wbaho pregnant nfc_smoker  wtmec2yr 
bmicat diabetes ckd hxmi hxchd hxstroke hxhf hxascvd hxcvd_hf avgsbp avgdbp bpcat bpcatmed 
jnc7htn accahahtn htn_aware htmeds jnc7tx Newgdltx jnc7_control accaha_control control14090 control13080  jnc7_uncontrol accaha_uncontrol 
uncontrol14090 uncontrol13080 num_htn_class rht_jnc7 rht_accaha subpophtn 
esceshhtn escesh7tx escesh_control1 escesh_control2 escesh_uncontrol1 escesh_uncontrol2
ace aldo alpha angioten beta central ccb diur_Ksparing diur_loop diur_thz Renin_inhibitors vasod dhpccb ndhpccb
rht_jnc7thz rht_accahathz n_aht_pills htpills2pl combination;
run;

proc export data=final9920 outfile= "C:\Users\pmuntner\Box\j_drive\Delzell\CVD\2022\NHANES_data_platform\Final_code\NHANES_0220_2023.dta" replace;
run;

*/



















**** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES; **** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES; **** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES;
**** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES; **** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES; **** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES;
**** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES; **** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES; **** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES;
**** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES; **** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES; **** CODING OF ANTIHYPERTENISVE MEDICATION CLASSES;


**** FIRST ITS THE INDIVIDUAL DRUG CLASSES;
**** FIRST ITS THE INDIVIDUAL DRUG CLASSES;
**** FIRST ITS THE INDIVIDUAL DRUG CLASSES;
options macrogen mlogic mprint symbolgen;
*options nomacrogen nomlogic nomprint nosymbolgen;
%let pgm=antihyper_datasets_update_202211_20221122;

ods html close;
ods listing;
libname save "H:\studies\CVD\shared\Amgen Cardiac Collaboration\Users\Lei\LDLR\SAS xpt\update_11_2022\temp";

*****************************************
Notes: This codes include programs to create class variables, 
next step please run antihyer_datasets_update_202211_v3_com_20221122.sas 
**********************************;

%macro rx;
libname R "H:\studies\CVD\shared\Amgen Cardiac Collaboration\REGARDS\NHANES_data\NHANES&yr.";

%if &yr.=1720 %then %do;
data RXQ_RX;set R.p_RXQ_RX&yrl.;run;
%end;

%else %do;
data RXQ_RX;set R.RXQ_RX&yrl.;run;
%end;

proc sort data=RXQ_RX;by seqn;run;
proc sort data=RXQ_RX out=rxqall_id nodupkey;by seqn;run;


%if &yr.=9900 or &yr.=0102 %then %do;
data RXQ_RX3(rename=(RXD240B=RXDDRUG RXD030=RXDUSE));
set RXQ_RX (keep=seqn  RXD030 RXD240B);
if RXD030=2 then take_med=0;
if RXD030 in (7,9,.) then take_med=.;
if RXD030=1 and RXD240B ^in ("55555" "77777" "99999") then take_med=1;
if RXD030=1 and RXD240B in ("55555" "77777" "99999") then take_med=.;
if take_med=. then delete;
run;
%end;
%else %do;
data RXQ_RX3;
set RXQ_RX (keep=seqn RXDUSE  RXDDRUG);
if RXDUSE=2 then take_med=0;
if RXDUSE in (7,9,.) then take_med=.;
if RXDUSE=1 and RXDDRUG ^in ("55555" "77777" "99999") then take_med=1;
if RXDUSE=1 and RXDDRUG in ("55555" "77777" "99999") then take_med=.;
if take_med=. then delete;
run;
%end;

proc sort data=RXQ_RX3 out=RXQ_id nodupkey;by seqn;run;


%let GNN1=BENAZEPRIL;
%let GNN2=CAPTOPRIL;
%let GNN3=ENALAPRIL;
%let GNN4=FOSINOPRIL;
%let GNN5=LISINOPRIL;
%let GNN6=MOEXIPRIL;
%let GNN7=PERINDOPRIL;
%let GNN8=QUINAPRIL;
%let GNN9=RAMIPRIL;
%let GNN10=TRANDOLAPRIL;
%let GNN11=EPLERENONE;
%let GNN12=SPIRONOLACTONE;
%let GNN13=DOXAZOSIN;
%let GNN14=PRAZOSIN;
%let GNN15=TERAZOSIN;
%let GNN16=AZILSARTAN;
%let GNN17=CANDESARTAN;
%let GNN18=EPROSARTAN;
%let GNN19=IRBESARTAN;
%let GNN20=LOSARTAN;
%let GNN21=OLMESARTAN;
%let GNN22=TELMISARTAN;
%let GNN23=VALSARTAN;
%let GNN24=CARVEDILOL;
%let GNN25=LABETALOL;
%let GNN26=ATENOLOL;
%let GNN27=BETAXOLOL;
%let GNN28=BISOPROLOL;
%let GNN29=METOPROLOL;
%let GNN30=NEBIVOLOL;
%let GNN31=NADOLOL;
%let GNN32=PROPRANOLOL;
%let GNN33=TIMOLOL;
%let GNN34=ACEBUTOLOL;
%let GNN35=PENBUTOLOL;
%let GNN36=PINDOLOL;
%let GNN37=AMLODIPINE;
%let GNN38=FELODIPINE;
%let GNN39=ISRADIPINE;
%let GNN40=NICARDIPINE;
%let GNN41=NIFEDIPINE;
%let GNN42=NISOLDIPINE;
%let GNN43=DILTIAZEM;
%let GNN44=VERAPAMIL;
%let GNN45=CLONIDINE;
%let GNN46=GUANABENZ;
%let GNN47=GUANADREL;
%let GNN48=GUANETHIDINE;
%let GNN49=GUANFACINE;
%let GNN50=METHYLDOPA;
%let GNN51=RESERPINE;
%let GNN52=ALISKIREN;
%let GNN53=HYDRALAZINE;
%let GNN54=MINOXIDIL;
%let GNN55=BUMETANIDE;
%let GNN56=FUROSEMIDE;
%let GNN57=TORSEMIDE;
%let GNN58=AMILORIDE;
%let GNN59=TRIAMTERENE;
%let GNN60=CHLORTHALIDONE;
%let GNN61=INDAPAMIDE;
%let GNN62=METOLAZONE;
%let GNN63=BENDROFLUMETHIAZIDE;
%let GNN64=CHLOROTHIAZIDE;
%let GNN65=HYDROCHLOROTHIAZIDE;
%let GNN66=HYDROFLUMETHIAZIDE;
%let GNN67=METHYCLOTHIAZIDE;
%let GNN68=TRICHLORMETHIAZIDE;


data T;
set RXQ_id(keep=seqn);
run;

%do i=1 %to 68;
%if &i.=45 %then %do;
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&&&GNN&i");
if index(upcase(RXDDRUG), "APRACLONIDINE") then delete;
run;
%end;
%else %if &i.=27 %then %do;/*BETAXOLOL*/
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&&&GNN&i") and index(upcase(RXDDRUG),"OPHTHALMIC")=0;
run;
%end;
%else %if &i.=33 %then %do; /*TIMOLOL*/
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&&&GNN&i") and index(upcase(RXDDRUG),"OPHTHALMIC")=0;
if index(upcase(RXDDRUG),"DORZOLAMIDE")and index(upcase(RXDDRUG),"&&&GNN&i") then delete;
run;
%end;
%else %do;
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&&&GNN&i");
run;
%end;

proc sort data=rxx out=rxx_id nodupkey;by seqn;run;

data T;
merge T (in=a) rxx_id(in=b keep=seqn);
by seqn;
if a;
&&&GNN&i=0;
if b then &&&GNN&i=1;
run;

/*proc freq data=t;tables &&&GNN&i;run;*/
%end;

***Find ETHACRYNIC ACID;
%let FG=ETHACRYNIC ACID ;

data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&FG.");
run;

proc sort data=rxx out=rxx_id nodupkey;by seqn;run;

data T;
merge T (in=a) rxx_id(in=b keep=seqn);
by seqn;
if a;
ETHACRYNIC_ACID=0;
if b then ETHACRYNIC_ACID=1;
run;


data T2;
set T;

ACE=0;
Aldo=0;
Alpha=0;
Angioten=0;
Alpha_beta=0;
Beta_cardio_select=0;
Beta_cardio_vasod=0;
Beta_cardio_nonselect=0;
Beta_int_sym=0;
DhpCCB=0;
NdhpCCB=0;
Central=0;
Renin_inhibitors=0;
Vasod=0;
Diur_loop=0;
Diur_Ksparing=0;
Diur_thz_like=0;
Diur_thz_type=0;

if BENAZEPRIL=1 or
CAPTOPRIL=1 or
ENALAPRIL=1 or
FOSINOPRIL=1 or
LISINOPRIL=1 or
MOEXIPRIL=1 or
PERINDOPRIL=1 or
QUINAPRIL=1 or
RAMIPRIL=1 or
TRANDOLAPRIL=1 then ACE=1;

if EPLERENONE=1 or 
SPIRONOLACTONE=1 then Aldo=1;

if DOXAZOSIN=1 or 
PRAZOSIN=1 or 
TERAZOSIN=1 then Alpha=1;

if AZILSARTAN=1 or 
CANDESARTAN=1 or 
EPROSARTAN=1 or 
IRBESARTAN=1 or 
LOSARTAN=1 or 
OLMESARTAN=1 or 
TELMISARTAN=1 or 
VALSARTAN=1 then Angioten=1;

if CARVEDILOL=1 or
LABETALOL=1 then Alpha_beta=1;

if ATENOLOL=1 or 
BETAXOLOL=1 or 
BISOPROLOL=1 or 
METOPROLOL=1 then Beta_cardio_select=1;

if NEBIVOLOL=1 then Beta_cardio_vasod=1;

if NADOLOL=1 or
PROPRANOLOL=1 or 
TIMOLOL=1 then Beta_cardio_nonselect=1;

if ACEBUTOLOL=1 or 
PENBUTOLOL=1 or 
PINDOLOL=1 then Beta_int_sym=1;

if AMLODIPINE=1 or 
FELODIPINE=1 or 
ISRADIPINE=1 or 
NICARDIPINE=1 or 
NIFEDIPINE=1 or 
NISOLDIPINE=1 then DhpCCB=1;

if DILTIAZEM=1 or
VERAPAMIL=1 then NdhpCCB=1;

if CLONIDINE=1 or 
GUANABENZ=1 or 
GUANADREL=1 or 
GUANETHIDINE=1 or 
GUANFACINE=1 or 
METHYLDOPA=1 or 
RESERPINE=1 then Central=1;

if ALISKIREN=1 then Renin_inhibitors=1;

if HYDRALAZINE=1 or 
MINOXIDIL=1 then Vasod=1;

if BUMETANIDE=1 or 
ETHACRYNIC_ACID=1 or 
FUROSEMIDE=1 or 
TORSEMIDE=1 then Diur_loop=1;

if AMILORIDE=1 or 
TRIAMTERENE=1 then Diur_Ksparing=1;

if CHLORTHALIDONE=1 or
INDAPAMIDE=1 or
METOLAZONE=1 then Diur_thz_like=1;

if BENDROFLUMETHIAZIDE=1 or 
CHLOROTHIAZIDE=1 or 
HYDROCHLOROTHIAZIDE=1 or 
HYDROFLUMETHIAZIDE=1 or 
METHYCLOTHIAZIDE=1 or 
TRICHLORMETHIAZIDE=1 then Diur_thz_type=1;

label ACE="ACEI"
		Aldo="Aldosterone receptor antagonist"
		Alpha="Alpha-1 blocker"
		Angioten="ARB"
		Alpha_beta="Beta blocker - Alpha and Beta"
		Beta_cardio_select="Beta blocker - Cardioselective"
		Beta_cardio_vasod="Beta blocker - Cardioselective and vasodilatory"
		Beta_cardio_nonselect="Beta blocker - Non-cardioselective"
		Beta_int_sym="Beta blocker - intrinsic sympathomimetic"
		DhpCCB="Calcium channel blocker - Dihydropyridine"
		NdhpCCB="Calcium channel blocker - Non-dihydropyridine"
		Central="Centrally-acting agent"
		Renin_inhibitors="Direct renin inhibitor"
		Vasod="Direct vasodilator"
		Diur_loop="Loop diuretic"
		Diur_Ksparing="Potassium sparing diuretic"
		Diur_thz_like="Thiazide diuretic - Thiazide-like"
		Diur_thz_type="Thiazide diuretic - Thiazide-type"
;
run;

data T3;
merge rxqall_id(in=a keep=seqn) T2(in=b);
by seqn;
if a;
if b then med_info=1;else med_info=0;
yc="&yr.";
label yc="circle year";
run;

/*proc freq data=T2;tables ACE Aldo Alpha Alpha_beta Angioten Beta_cardio_nonselect Beta_cardio_vasod Beta_int_sym Central 
                           DhpCCB NdhpCCB Diur_Ksparing Diur_loop Diur_thz_like Diur_thz_type Renin_inhibitors Vasod;run;*/
/*data save.seqn_antihyper_v3_single_&yr.(label="Including all seqn with medication infomation: &pgm.");set T3;run;*/
proc compare data=save.seqn_antihyper_v3_single_&yr. compare=T3;run;
%mend;
proc freq data=T2;tables ACE ;run;


%let yr=9900;%let yrl=;%rx;
%let yr=0102;%let yrl=_b;%rx;

%let yr=0910;%let yrl=_f;%rx;
%let yr=1112;%let yrl=_g;%rx;
%let yr=1314;%let yrl=_h;%rx;
%let yr=1516;%let yrl=_i;%rx;
%let yr=1718;%let yrl=_j;%rx;


/*%let yr=9900;%let yrl=;%rx;
%let yr=0102;%let yrl=_b;%rx;*/ *This two has no rxuse and rxdrugs;
%let yr=0304;%let yrl=_c;%rx;
%let yr=0506;%let yrl=_d;%rx;
%let yr=0708;%let yrl=_e;%rx;

%let yr=1720;%let yrl=;%rx;



/*check;
proc freq data=T3;tables ACE Aldo Alpha Alpha_beta Angioten Beta_cardio_nonselect Beta_cardio_vasod Beta_int_sym Central 
                           DhpCCB NdhpCCB Diur_Ksparing Diur_loop Diur_thz_like Diur_thz_type Renin_inhibitors Vasod med_info;run;


%let yr=9900;%let yrl=;
%let yr=1314;%let yrl=_h;
%let yr=1720;%let yrl=;

libname R "H:\studies\CVD\shared\Amgen Cardiac Collaboration\REGARDS\NHANES_data\NHANES&yr.";
%let GNN8=QUINAPRIL;
data cxxx;
set R.RXQ_RX&yrl.(rename=(RXD240B=RXDDRUG RXD030=RXDUSE));
*set R.RXQ_RX&yrl.;
*set R.p_RXQ_RX&yrl.;
*if index(upcase(RXDDRUG),"QUINAPRIL");
if index(upcase(RXDDRUG),"CLONIDINE");

run;
proc sort data=cxxx out=cxxx_id nodupkey;by seqn;run;
proc freq data=save.seqn_antihyper_v3_single_&yr.;tables QUINAPRIL;run;





data com (keep=seqn yc med_info ACE Aldo Alpha Alpha_beta Angioten Beta_cardio_nonselect Beta_cardio_vasod Beta_int_sym Central 
                           DhpCCB NdhpCCB Diur_Ksparing Diur_loop Diur_thz_like Diur_thz_type Renin_inhibitors Vasod TIMOLOL BETAXOLOL);
set save.seqn_antihyper_v3_single_9900 (in=a1)
    save.seqn_antihyper_v3_single_0102 (in=a2)
	save.seqn_antihyper_v3_single_0304 (in=a3)
	save.seqn_antihyper_v3_single_0506 (in=a4)
	save.seqn_antihyper_v3_single_0708 (in=a5)
	save.seqn_antihyper_v3_single_0910 (in=a6)
	save.seqn_antihyper_v3_single_1112 (in=a7)
	save.seqn_antihyper_v3_single_1314 (in=a8)
	save.seqn_antihyper_v3_single_1516 (in=a9)
	save.seqn_antihyper_v3_single_1720 (in=a10)
;
run;
proc freq data=com;tables med_info;run;
proc freq data=com;tables TIMOLOL BETAXOLOL;run;
proc freq data=com;tables ACE Aldo Alpha Alpha_beta Angioten Beta_cardio_nonselect Beta_cardio_vasod Beta_int_sym Central 
                           DhpCCB NdhpCCB Diur_Ksparing Diur_loop Diur_thz_like Diur_thz_type Renin_inhibitors Vasod med_info;run;
*/














**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
**** NOW ITS THE COMBINATION MEDICATION USE;
options macrogen mlogic mprint symbolgen;
*options nomacrogen nomlogic nomprint nosymbolgen;
%let pgm=antihyper_datasets_update_202211_20221122;

ods html close;
ods listing;
libname save "H:\studies\CVD\shared\Amgen Cardiac Collaboration\Users\Lei\LDLR\SAS xpt\update_11_2022\temp";

******Note: add RESERPINE/CHLORTHALIDONE, gut got same dataset with preivous, run the codes for next time;*************;

**************
Notes: This codes include programs 
1.Create combination drug variables
2.Merge class variables and  combination drug variables ( class variables were created by program antihyper_datasets_update_202211_v3_single_20221122
3.Combine year files into a single file
*****************;

******************************************
1.Create combination drug variables;
******************************************;

%macro rx;
libname R "H:\studies\CVD\shared\Amgen Cardiac Collaboration\REGARDS\NHANES_data\NHANES&yr.";

%if &yr.=1720 %then %do;
data RXQ_RX;set R.p_RXQ_RX&yrl.;run;
%end;

%else %do;
data RXQ_RX;set R.RXQ_RX&yrl.;run;
%end;

proc sort data=RXQ_RX;by seqn;run;
proc sort data=RXQ_RX out=rxqall_id nodupkey;by seqn;run;


%if &yr.=9900 or &yr.=0102 %then %do;
data RXQ_RX3(rename=(RXD240B=RXDDRUG RXD030=RXDUSE));
set RXQ_RX (keep=seqn  RXD030 RXD240B);
if RXD030=2 then take_med=0;
if RXD030 in (7,9,.) then take_med=.;
if RXD030=1 and RXD240B ^in ("55555" "77777" "99999") then take_med=1;
if RXD030=1 and RXD240B in ("55555" "77777" "99999") then take_med=.;
if take_med=. then delete;
run;
%end;
%else %do;
data RXQ_RX3;
set RXQ_RX (keep=seqn RXDUSE  RXDDRUG);
if RXDUSE=2 then take_med=0;
if RXDUSE in (7,9,.) then take_med=.;
if RXDUSE=1 and RXDDRUG ^in ("55555" "77777" "99999") then take_med=1;
if RXDUSE=1 and RXDDRUG in ("55555" "77777" "99999") then take_med=.;
if take_med=. then delete;
run;
%end;

proc sort data=RXQ_RX3 out=RXQ_id nodupkey;by seqn;run;


/*%let GNN1=BENAZEPRIL/HYDROCHLOROTHIAZIDE;

%let i=1;
%put &&&GNN&i;

data rxx;
set RXQ_RX3;
*if index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE") and index(upcase(RXDDRUG),"BENAZEPRIL");
*if index(upcase(RXDDRUG),"/") ;
*if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/"));
if index(upcase(RXDDRUG), "APRACLONIDINE");
run;
*/
%let GNN1=BENAZEPRIL/AMLODIPINE;
%let GNN2=PERINDOPRIL/AMLODIPINE;
%let GNN3=TRANDOLAPRIL/VERAPAMIL;
%let GNN4=BENAZEPRIL/HYDROCHLOROTHIAZIDE;
%let GNN5=CAPTOPRIL/HYDROCHLOROTHIAZIDE;
%let GNN6=ENALAPRIL/HYDROCHLOROTHIAZIDE;
%let GNN7=FOSINOPRIL/HYDROCHLOROTHIAZIDE;
%let GNN8=LISINOPRIL/HYDROCHLOROTHIAZIDE;
%let GNN9=MOEXIPRIL/HYDROCHLOROTHIAZIDE;
%let GNN10=QUINAPRIL/HYDROCHLOROTHIAZIDE;
%let GNN11=SPIRONOLACTONE/HYDROCHLOROTHIAZIDE;
%let GNN12=PRAZOSIN/POLYTHIAZIDE;
%let GNN13=OLMESARTAN/AMLODIPINE;
%let GNN14=VALSARTAN/AMLODIPINE;
%let GNN15=TELMISARTAN/AMLODIPINE;
%let GNN16=AZILSARTAN/CHLORTHALIDONE;
%let GNN17=CANDESARTAN/HYDROCHLOROTHIAZIDE;
%let GNN18=EPROSARTAN/HYDROCHLOROTHIAZIDE;
%let GNN19=IRBESARTAN/HYDROCHLOROTHIAZIDE;
%let GNN20=LOSARTAN/HYDROCHLOROTHIAZIDE;
%let GNN21=OLMESARTAN/HYDROCHLOROTHIAZIDE;
%let GNN22=TELMISARTAN/HYDROCHLOROTHIAZIDE;
%let GNN23=VALSARTAN/HYDROCHLOROTHIAZIDE;
%let GNN24=ATENOLOL/CHLORTHALIDONE;
%let GNN25=BISOPROLOL/HYDROCHLOROTHIAZIDE;
%let GNN26=METOPROLOL/HYDROCHLOROTHIAZIDE;
%let GNN27=LABETALOL/HYDROCHLOROTHIAZIDE;
%let GNN28=NADOLOL/BENDROFLUMETHIAZIDE;
%let GNN29=PROPRANOLOL/HYDROCHLOROTHIAZIDE;
%let GNN30=TIMOLOL/HYDROCHLOROTHIAZIDE;
%let GNN31=CLONIDINE/CHLORTHALIDONE;
%let GNN32=DESERPIDINE/HYDROCHLOROTHIAZIDE;
%let GNN33=DESERPIDINE/METHYCLOTHIAZIDE;
%let GNN34=METHYLDOPA/HYDROCHLOROTHIAZIDE;
%let GNN35=RESERPINE/CHLOROTHIAZIDE;
%let GNN36=RESERPINE/HYDROFLUMETHIAZIDE;
%let GNN37=RESERPINE/METHYCLOTHIAZIDE;
%let GNN38=RESERPINE/POLYTHIAZIDE;
%let GNN39=ALISKIREN/VALSARTAN;
%let GNN40=ALISKIREN/HYDROCHLOROTHIAZIDE;
%let GNN41=AMILORIDE/HYDROCHLOROTHIAZIDE;
%let GNN42=TRIAMTERENE/HYDROCHLOROTHIAZIDE;
%let GNN43=RESERPINE/CHLORTHALIDONE;
%let GNN44=HYDRALAZINE/HYDROCHLOROTHIAZIDE;
%let GNN45=OLMESARTAN/AMLODIPINE/HYDROCHLOROTHIAZIDE;
%let GNN46=VALSARTAN/AMLODIPINE/HYDROCHLOROTHIAZIDE;
%let GNN47=HYDRALAZINE/HYDROCHLOROTHIAZIDE/RESERPINE;


%let NGNN1=BENAZEPRIL_AMLODIPINE;
%let NGNN2=PERINDOPRIL_AMLODIPINE;
%let NGNN3=TRANDOLAPRIL_VERAPAMIL;
%let NGNN4=BENAZEPRIL_HCTZ;
%let NGNN5=CAPTOPRIL_HCTZ;
%let NGNN6=ENALAPRIL_HCTZ;
%let NGNN7=FOSINOPRIL_HCTZ;
%let NGNN8=LISINOPRIL_HCTZ;
%let NGNN9=MOEXIPRIL_HCTZ;
%let NGNN10=QUINAPRIL_HCTZ;
%let NGNN11=SPIRONOLACTONE_HCTZ;
%let NGNN12=PRAZOSIN_POLYTHIAZIDE;
%let NGNN13=OLMESARTAN_AMLODIPINE;
%let NGNN14=VALSARTAN_AMLODIPINE;
%let NGNN15=TELMISARTAN_AMLODIPINE;
%let NGNN16=AZILSARTAN_CHLORTHALIDONE;
%let NGNN17=CANDESARTAN_HCTZ;
%let NGNN18=EPROSARTAN_HCTZ;
%let NGNN19=IRBESARTAN_HCTZ;
%let NGNN20=LOSARTAN_HCTZ;
%let NGNN21=OLMESARTAN_HCTZ;
%let NGNN22=TELMISARTAN_HCTZ;
%let NGNN23=VALSARTAN_HCTZ;
%let NGNN24=ATENOLOL_CHLORTHALIDONE;
%let NGNN25=BISOPROLOL_HCTZ;
%let NGNN26=METOPROLOL_HCTZ;
%let NGNN27=LABETALOL_HCTZ;
%let NGNN28=NADOLOL_BENDROFLUMETHIAZIDE;
%let NGNN29=PROPRANOLOL_HCTZ;
%let NGNN30=TIMOLOL_HCTZ;
%let NGNN31=CLONIDINE_CHLORTHALIDONE;
%let NGNN32=DESERPIDINE_HCTZ;
%let NGNN33=DESERPIDINE_METHYCLOTHIAZIDE;
%let NGNN34=METHYLDOPA_HCTZ;
%let NGNN35=RESERPINE_CHLOROTHIAZIDE;
%let NGNN36=RESERPINE_HYDROFLUMETHIAZIDE;
%let NGNN37=RESERPINE_METHYCLOTHIAZIDE;
%let NGNN38=RESERPINE_POLYTHIAZIDE;
%let NGNN39=ALISKIREN_VALSARTAN;
%let NGNN40=ALISKIREN_HCTZ;
%let NGNN41=AMILORIDE_HCTZ;
%let NGNN42=TRIAMTERENE_HCTZ;
%let NGNN43=RESERPINE_CHLORTHALIDONE;
%let NGNN44=HYDRALAZINE_HCTZ;
%let NGNN45=OLMESARTAN_AMLODIPINE_HCTZ;
%let NGNN46=VALSARTAN_AMLODIPINE_HCTZ;
%let NGNN47=HYDRALAZINE_HCTZ_RESERPINE;



data T;
set RXQ_id(keep=seqn);
run;


%do i=1 %to 12;
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/"));
*if index(upcase(RXDDRUG),"TRIAMTERENE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
*if index(upcase(RXDDRUG),"SPIRONOLACTONE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
run;

proc sort data=rxx out=rxx_id nodupkey;by seqn;run;

data T;
merge T (in=a) rxx_id(in=b keep=seqn);
by seqn;
if a;
&&&NGNN&i=0;
if b then &&&NGNN&i=1;
run;
/*proc freq data=t;tables &&&GNN&i;run;*/
%end;


%do i=13 %to 14;
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/")) and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE")=0;
run;

proc sort data=rxx out=rxx_id nodupkey;by seqn;run;

data T;
merge T (in=a) rxx_id(in=b keep=seqn);
by seqn;
if a;
&&&NGNN&i=0;
if b then &&&NGNN&i=1;
run;
/*proc freq data=t;tables &&&GNN&i;run;*/
%end;



%do i=15 %to 43;
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/"));
*if index(upcase(RXDDRUG),"TRIAMTERENE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
*if index(upcase(RXDDRUG),"SPIRONOLACTONE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
run;

proc sort data=rxx out=rxx_id nodupkey;by seqn;run;

data T;
merge T (in=a) rxx_id(in=b keep=seqn);
by seqn;
if a;
&&&NGNN&i=0;
if b then &&&NGNN&i=1;
run;
/*proc freq data=t;tables &&&GNN&i;run;*/
%end;


%do i=44 %to 44;
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/")) and index(upcase(RXDDRUG),"RESERPINE")=0;
*if index(upcase(RXDDRUG),"TRIAMTERENE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
*if index(upcase(RXDDRUG),"SPIRONOLACTONE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
run;

proc sort data=rxx out=rxx_id nodupkey;by seqn;run;

data T;
merge T (in=a) rxx_id(in=b keep=seqn);
by seqn;
if a;
&&&NGNN&i=0;
if b then &&&NGNN&i=1;
run;
/*proc freq data=t;tables &&&GNN&i;run;*/
%end;




%do i=45 %to 47;
data rxx;
set RXQ_RX3;
if index(upcase(RXDDRUG),scan("&&&GNN&i.",3,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/"));
*if index(upcase(RXDDRUG),"OLMESARTAN") and index(upcase(RXDDRUG),"AMLODIPINE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
*if index(upcase(RXDDRUG),"VALSARTAN") and index(upcase(RXDDRUG),"AMLODIPINE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
*if index(upcase(RXDDRUG),"HYDRALAZINE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE") and index(upcase(RXDDRUG),"RESERPINE");
run;

proc sort data=rxx out=rxx_id nodupkey;by seqn;run;

data T;
merge T (in=a) rxx_id(in=b keep=seqn);
by seqn;
if a;
&&&NGNN&i=0;
if b then &&&NGNN&i=1;
run;
/*proc freq data=t;tables &&&GNN&i;run;*/
%end;


data T2;
set T;
ACEI_dihy_CCB=0;
ACEI_non_dihy_CCB=0;
ACEI_thia_diur=0;
Aldo_thia_diur=0;
Alpha_thia_diur=0;
ARB_dihy_CCB=0;
ARB_thia_like=0;
ARB_thia_type=0;
Beta_thia_like=0;
Beta_thia_type=0;
BetaAlpha_thia_type=0;
BetanonCard_thia_type=0;
CenACT_thia_like=0;
CenACT_thia_type=0;
DirRenin_ARB=0;
DirRenin_thia_type=0;
Potass_thia_type=0;
DirVaso_thia_type=0;
 ARBdihy_thia_type=0;
DirVaso_thia_typeC=0;

if BENAZEPRIL_AMLODIPINE=1 or 
PERINDOPRIL_AMLODIPINE=1 then ACEI_dihy_CCB=1;

if TRANDOLAPRIL_VERAPAMIL=1 then ACEI_non_dihy_CCB=1;

if BENAZEPRIL_HCTZ=1 or 
CAPTOPRIL_HCTZ=1 or 
ENALAPRIL_HCTZ=1 or 
FOSINOPRIL_HCTZ=1 or 
LISINOPRIL_HCTZ=1 or 
MOEXIPRIL_HCTZ=1 or 
QUINAPRIL_HCTZ=1  then ACEI_thia_diur=1;

if SPIRONOLACTONE_HCTZ=1 then Aldo_thia_diur=1;

if PRAZOSIN_POLYTHIAZIDE=1 then Alpha_thia_diur=1;

if OLMESARTAN_AMLODIPINE=1 or 
TELMISARTAN_AMLODIPINE=1 or 
VALSARTAN_AMLODIPINE=1 then ARB_dihy_CCB=1;

if AZILSARTAN_CHLORTHALIDONE=1 then ARB_thia_like=1;

if CANDESARTAN_HCTZ=1 or
EPROSARTAN_HCTZ=1 or
IRBESARTAN_HCTZ=1 or
LOSARTAN_HCTZ=1 or
OLMESARTAN_HCTZ=1 or
TELMISARTAN_HCTZ=1 or
VALSARTAN_HCTZ=1 then ARB_thia_type=1;

if ATENOLOL_CHLORTHALIDONE=1 then Beta_thia_like=1;

if BISOPROLOL_HCTZ=1 or
METOPROLOL_HCTZ=1 then Beta_thia_type=1;

if LABETALOL_HCTZ=1 then BetaAlpha_thia_type=1;

if NADOLOL_BENDROFLUMETHIAZIDE=1 or 
PROPRANOLOL_HCTZ=1 or
TIMOLOL_HCTZ=1 then BetanonCard_thia_type=1;

if CLONIDINE_CHLORTHALIDONE=1 or RESERPINE_CHLORTHALIDONE=1 then CenACT_thia_like=1;

if DESERPIDINE_HCTZ=1 or 
DESERPIDINE_METHYCLOTHIAZIDE=1 or 
METHYLDOPA_HCTZ=1 or 
RESERPINE_CHLOROTHIAZIDE=1 or 
RESERPINE_HYDROFLUMETHIAZIDE=1 or 
RESERPINE_METHYCLOTHIAZIDE=1 or 
RESERPINE_POLYTHIAZIDE=1 then CenACT_thia_type=1;

if ALISKIREN_VALSARTAN=1 then DirRenin_ARB=1;

if ALISKIREN_HCTZ then DirRenin_thia_type=1;

if AMILORIDE_HCTZ=1 or
TRIAMTERENE_HCTZ=1 then Potass_thia_type=1;

if HYDRALAZINE_HCTZ=1 then DirVaso_thia_type=1;

if OLMESARTAN_AMLODIPINE_HCTZ=1 or
VALSARTAN_AMLODIPINE_HCTZ=1 then ARBdihy_thia_type=1;

if HYDRALAZINE_HCTZ_RESERPINE=1 then DirVaso_thia_typeC=1;

if ACEI_dihy_CCB=1 or
ACEI_non_dihy_CCB=1 or
ACEI_thia_diur=1 or
Aldo_thia_diur=1 or
Alpha_thia_diur=1 or
ARB_dihy_CCB=1 or
ARB_thia_like=1 or
ARB_thia_type=1 or
Beta_thia_like=1 or
Beta_thia_type=1 or
BetaAlpha_thia_type=1 or
BetanonCard_thia_type=1 or
CenACT_thia_like=1 or
CenACT_thia_type=1 or
DirRenin_ARB=1 or
DirRenin_thia_type=1 or
Potass_thia_type=1 or
DirVaso_thia_type=1 or
 ARBdihy_thia_type=1 or
DirVaso_thia_typeC=1 then combination=1;else combination=0;


label ACEI_dihy_CCB="ACEI/Dihydropyridine CCB"
	ACEI_non_dihy_CCB="ACEI/Non-dihydropyridine CCB"
	ACEI_thia_diur="ACEI/thiazide-type diuretic"
	Aldo_thia_diur="Aldosterone receptor antagonist/thiazide-type diuretic"
	Alpha_thia_diur="Alpha-blocker/thiazide-type diuretic"
	ARB_dihy_CCB="ARB/Dihydropyridine CCB"
	ARB_thia_like="ARB/thiazide-like diuretic"
	ARB_thia_type="ARB/thiazide-type diuretic"
	Beta_thia_like="Beta-blocker - cardioselective/thiazide-like diuretic"
	Beta_thia_type="Beta-blocker - cardioselective/thiazide-type diuretic"
	BetaAlpha_thia_type="Beta blocker - Alpha and Beta/Thiazide-type diuretic"
	BetanonCard_thia_type="Beta-blocker - Non-cardioselective/thiazide-type diuretic"
	CenACT_thia_like="Centrally acting/thiazide-like diuretic"
	CenACT_thia_type="Centrally acting/thiazide-type diuretic"
	DirRenin_ARB="Direct renin inhibitor/ARB"
	DirRenin_thia_type="Direct renin inhibitor/thiazide-type diuretic"
	Potass_thia_type="Potassium-sparing diuretic/thiazide-type diuretic"
	DirVaso_thia_type="Direct vasodilator/thiazide-type diuretic"
	 ARBdihy_thia_type="ARB/Dihydropyridine CCB/thiazide-type diuretic"
	DirVaso_thia_typeC="Direct vasodilator/thiazide-type diuretic/centrally-acting"
;
run;

data T3;
merge rxqall_id(in=a keep=seqn) T2(in=b);
by seqn;
if a;
if b then med_info=1;else med_info=0;
yc="&yr.";
label yc="circle year"
     med_info="Participants have medication information";
run;

/*proc freq data=T3;tables ACEI_dihy_CCB ACEI_non_dihy_CCB ACEI_thia_diur Aldo_thia_diur Alpha_thia_diur ARB_dihy_CCB ARB_thia_like ARB_thia_type Beta_thia_like
	Beta_thia_type BetaAlpha_thia_type BetanonCard_thia_type CenACT_thia_like CenACT_thia_type DirRenin_ARB DirRenin_thia_type Potass_thia_type DirVaso_thia_type
	 ARBdihy_thia_type DirVaso_thia_typeC;run;*/
proc compare data=save.seqn_antihyper_v3_com_&yr. compare=T3;run;
/*data save.seqn_antihyper_v3_com_&yr.(label="Including all seqn with medication infomation: &pgm.");set T3;run;*/

%mend;



%let yr=9900;%let yrl=;%rx;
%let yr=0102;%let yrl=_b;%rx;

%let yr=0910;%let yrl=_f;%rx;
%let yr=1112;%let yrl=_g;%rx;
%let yr=1314;%let yrl=_h;%rx;
%let yr=1516;%let yrl=_i;%rx;
%let yr=1718;%let yrl=_j;%rx;


/*%let yr=9900;%let yrl=;%rx;
%let yr=0102;%let yrl=_b;%rx;*/ *This two has no rxuse and rxdrugs;
%let yr=0304;%let yrl=_c;%rx;
%let yr=0506;%let yrl=_d;%rx;
%let yr=0708;%let yrl=_e;%rx;


%let yr=1720;%let yrl=;%rx;


***************************************************************************************************************
2.Merge class variables and  combination drug variables ( class variables were created by program antihyper_datasets_update_202211_v3_single_20221122
*************************************************************************************************************;


libname csav "H:\studies\CVD\shared\Amgen Cardiac Collaboration\Users\Lei\LDLR\SAS xpt\update_11_2022";

%macro Mcc;
data Mccx;
merge save.seqn_antihyper_v3_com_&yr. (in=a keep=seqn yc ACEI_dihy_CCB ACEI_non_dihy_CCB ACEI_thia_diur Aldo_thia_diur Alpha_thia_diur ARB_dihy_CCB ARB_thia_like ARB_thia_type Beta_thia_like
												Beta_thia_type BetaAlpha_thia_type BetanonCard_thia_type CenACT_thia_like CenACT_thia_type DirRenin_ARB DirRenin_thia_type Potass_thia_type DirVaso_thia_type
												 ARBdihy_thia_type DirVaso_thia_typeC combination med_info rename=(med_info=med_infox yc=ycx))
    
     save.seqn_antihyper_v3_single_&yr. (in=b keep=seqn /*yc*/ ACE Aldo Alpha Alpha_beta Angioten Beta_cardio_select
                                              Beta_cardio_nonselect Beta_cardio_vasod Beta_int_sym Central 
                                           DhpCCB NdhpCCB Diur_Ksparing Diur_loop Diur_thz_like Diur_thz_type Renin_inhibitors Vasod /*med_info*/);
by seqn;
if a*b;
label combination="Used combination drug"
      med_infox="Paticipants who have medication information";
      ;
run;

/*proc compare data=csav.seqn_antihyper_v3_&yr. compare=Mccx;run;*/

data csav.seqn_antihyper_v3_&yr.(compress='binary' label="Include drug class and combination info");set Mccx;run;
/*data x;
set  Mccx;
if med_infox^=med_info or ycx^=yc then flag=1;
run;
proc freq data=x;tables flag;run;*/
%mend;

%let yr=9900;%Mcc;
%let yr=0102;%Mcc;

%let yr=0910;%Mcc;
%let yr=1112;%Mcc;
%let yr=1314;%Mcc;
%let yr=1516;%Mcc;
%let yr=1718;%Mcc;

%let yr=0304;%Mcc;
%let yr=0506;%Mcc;
%let yr=0708;%Mcc;


%let yr=1720;%Mcc;




***************************************************************************************************************
3.Combine year files into a single file
*************************************************************************************************************;


data com (drop=ycx); 
set csav.seqn_antihyper_v3_9900 (in=a1)
    csav.seqn_antihyper_v3_0102(in=a2)
	csav.seqn_antihyper_v3_0304 (in=a3)
	csav.seqn_antihyper_v3_0506(in=a4)
	csav.seqn_antihyper_v3_0708(in=a5)
	csav.seqn_antihyper_v3_0910(in=a6)
	csav.seqn_antihyper_v3_1112(in=a7)
	csav.seqn_antihyper_v3_1314(in=a8)
	csav.seqn_antihyper_v3_1516(in=a9)
	csav.seqn_antihyper_v3_1720(in=a10)
;
if a1 then yc="99-00";
if a2 then yc="01-02";
if a3 then yc="03-04";
if a4 then yc="05-06";
if a5 then yc="07-08";
if a6 then yc="09-10";
if a7 then yc="11-12";
if a8 then yc="13-14";
if a9 then yc="15-16";
if a10 then yc="17-20";
if med_infox=1 then do;
if Alpha_beta=1 or Beta_cardio_select=1 or Beta_cardio_vasod=1 or Beta_cardio_nonselect=1 or Beta_int_sym=1 then Beta=1;else Beta=0;
if DhpCCB=1 or NdhpCCB=1 then CCB=1;else CCB=0;
if Diur_thz_like=1 or Diur_thz_type=1 then Diur_thz=1;else Diur_thz=0;
end;
label Beta="Beta blocker - Alpha and Beta, Beta blocker - Cardioselective, Beta blocker - Cardioselective and vasodilatory, Beta blocker - Non-cardioselective, Beta blocker - intrinsic sympathomimetic"
      CCB="Calcium channel blocker - Dihydropyridine, Calcium channel blocker - Non-dihydropyridine"
	  Diur_thz="Diur_thz_like, Diur_thz_type"
	  yc="Circle years";
run;

/*proc freq data=com;tables Beta CCB Diur_thz med_infox  yc;run;*/
data csav.seqn_antihyper_9900_1720(compress='binary');set com;run;
proc compare data=csav.seqn_antihyper_9900_1720 compare=com;run;




***************************************************************************************************
The following codes are to created new variables:n_single_pills n_combinations n_aht_pills
step1: Create antihypertensive drug aggregate file from 1999-2020
step2: Create combination pill aggregate file from 1999-2020
step3: Create single pill dataset by excluding combination drug from antihypertensive drug aggregate file
step4: Basing on the single pill dataset, Identify classes (for example, ACE) for each participant, and sum the number of classes to the variable n_ single_pills
step5: Basing on the combination pill dataset, identify classes (e.g.ACEI_dihy_CCB) for each participant, and sum the number of classes to the variable n_combination_pills.
step6:n_aht_pills = n_single_pills + n_combination_pills
**********************************;
libname csav "H:\studies\CVD\shared\Amgen Cardiac Collaboration\Users\Lei\LDLR\SAS xpt\update_11_2022";
*****step1: Create antihypertensive drug aggregate file from 1999-2020;

%macro rxc;
libname R "H:\studies\CVD\shared\Amgen Cardiac Collaboration\REGARDS\NHANES_data\NHANES&yr.";

%if &yr.=1720 %then %do;
data RXQ_RX;set R.p_RXQ_RX&yrl.;run;
%end;

%else %do;
data RXQ_RX;set R.RXQ_RX&yrl.;run;
%end;

proc sort data=RXQ_RX;by seqn;run;
proc sort data=RXQ_RX out=rxqall_id nodupkey;by seqn;run;


%if &yr.=9900 or &yr.=0102 %then %do;
data RXQ_RX3(rename=(RXD240B=RXDDRUG RXD030=RXDUSE));
set RXQ_RX (keep=seqn  RXD030 RXD240B);
if RXD030=2 then take_med=0;
if RXD030 in (7,9,.) then take_med=.;
if RXD030=1 and RXD240B ^in ("55555" "77777" "99999") then take_med=1;
if RXD030=1 and RXD240B in ("55555" "77777" "99999") then take_med=.;
if take_med=. then delete;
run;
%end;
%else %do;
data RXQ_RX3;
set RXQ_RX (keep=seqn RXDUSE  RXDDRUG);
if RXDUSE=2 then take_med=0;
if RXDUSE in (7,9,.) then take_med=.;
if RXDUSE=1 and RXDDRUG ^in ("55555" "77777" "99999") then take_med=1;
if RXDUSE=1 and RXDDRUG in ("55555" "77777" "99999") then take_med=.;
if take_med=. then delete;
run;
%end;

proc sort data=RXQ_RX3 out=RXQ_id nodupkey;by seqn;run;


%let GNN1=BENAZEPRIL; %let GNNclass1=ACE;
%let GNN2=CAPTOPRIL;%let GNNclass2=ACE;
%let GNN3=ENALAPRIL;%let GNNclass3=ACE;
%let GNN4=FOSINOPRIL;%let GNNclass4=ACE;
%let GNN5=LISINOPRIL;%let GNNclass5=ACE;
%let GNN6=MOEXIPRIL;%let GNNclass6=ACE;
%let GNN7=PERINDOPRIL;%let GNNclass7=ACE;
%let GNN8=QUINAPRIL;%let GNNclass8=ACE;
%let GNN9=RAMIPRIL;%let GNNclass9=ACE;
%let GNN10=TRANDOLAPRIL;%let GNNclass10=ACE;
%let GNN11=EPLERENONE;%let GNNclass11=Aldo;
%let GNN12=SPIRONOLACTONE;%let GNNclass12=Aldo;
%let GNN13=DOXAZOSIN;%let GNNclass13=Alpha;
%let GNN14=PRAZOSIN;%let GNNclass14=Alpha;
%let GNN15=TERAZOSIN;%let GNNclass15=Alpha;
%let GNN16=AZILSARTAN;%let GNNclass16=Angioten;
%let GNN17=CANDESARTAN;%let GNNclass17=Angioten;
%let GNN18=EPROSARTAN;%let GNNclass18=Angioten;
%let GNN19=IRBESARTAN;%let GNNclass19=Angioten;
%let GNN20=LOSARTAN;%let GNNclass20=Angioten;
%let GNN21=OLMESARTAN;%let GNNclass21=Angioten;
%let GNN22=TELMISARTAN;%let GNNclass22=Angioten;
%let GNN23=VALSARTAN;%let GNNclass23=Angioten;
%let GNN24=CARVEDILOL;%let GNNclass24=Alpha_beta;
%let GNN25=LABETALOL;%let GNNclass25=Alpha_beta;
%let GNN26=ATENOLOL;%let GNNclass26=Beta_cardio_select;
%let GNN27=BETAXOLOL;%let GNNclass27=Beta_cardio_select;
%let GNN28=BISOPROLOL;%let GNNclass28=Beta_cardio_select;
%let GNN29=METOPROLOL;%let GNNclass29=Beta_cardio_select;
%let GNN30=NEBIVOLOL;%let GNNclass30=Beta_cardio_vasod;
%let GNN31=NADOLOL;%let GNNclass31=Beta_cardio_nonselect;
%let GNN32=PROPRANOLOL;%let GNNclass32=Beta_cardio_nonselect;
%let GNN33=TIMOLOL;%let GNNclass33=Beta_cardio_nonselect;
%let GNN34=ACEBUTOLOL;%let GNNclass34=Beta_int_sym;
%let GNN35=PENBUTOLOL;%let GNNclass35=Beta_int_sym;
%let GNN36=PINDOLOL;%let GNNclass36=Beta_int_sym;
%let GNN37=AMLODIPINE;%let GNNclass37=DhpCCB;
%let GNN38=FELODIPINE;%let GNNclass38=DhpCCB;
%let GNN39=ISRADIPINE;%let GNNclass39=DhpCCB;
%let GNN40=NICARDIPINE;%let GNNclass40=DhpCCB;
%let GNN41=NIFEDIPINE;%let GNNclass41=DhpCCB;
%let GNN42=NISOLDIPINE;%let GNNclass42=DhpCCB;
%let GNN43=DILTIAZEM;%let GNNclass43=NdhpCCB;
%let GNN44=VERAPAMIL;%let GNNclass44=NdhpCCB;
%let GNN45=CLONIDINE;%let GNNclass45=Central;
%let GNN46=GUANABENZ;%let GNNclass46=Central;
%let GNN47=GUANADREL;%let GNNclass47=Central;
%let GNN48=GUANETHIDINE;%let GNNclass48=Central;
%let GNN49=GUANFACINE;%let GNNclass49=Central;
%let GNN50=METHYLDOPA;%let GNNclass50=Central;
%let GNN51=RESERPINE;%let GNNclass51=Central;
%let GNN52=ALISKIREN;%let GNNclass52=Renin_inhibitors;
%let GNN53=HYDRALAZINE;%let GNNclass53=Vasod;
%let GNN54=MINOXIDIL;%let GNNclass54=Vasod;
%let GNN55=BUMETANIDE;%let GNNclass55=Diur_loop;
%let GNN56=FUROSEMIDE;%let GNNclass56=Diur_loop;
%let GNN57=TORSEMIDE;%let GNNclass57=Diur_loop;
%let GNN58=AMILORIDE;%let GNNclass58=Diur_Ksparing;
%let GNN59=TRIAMTERENE;%let GNNclass59=Diur_Ksparing;
%let GNN60=CHLORTHALIDONE;%let GNNclass60=Diur_thz_like;
%let GNN61=INDAPAMIDE;%let GNNclass61=Diur_thz_like;
%let GNN62=METOLAZONE;%let GNNclass62=Diur_thz_like;
%let GNN63=BENDROFLUMETHIAZIDE;%let GNNclass63=Diur_thz_type;
%let GNN64=CHLOROTHIAZIDE;%let GNNclass64=Diur_thz_type;
%let GNN65=HYDROCHLOROTHIAZIDE;%let GNNclass65=Diur_thz_type;
%let GNN66=HYDROFLUMETHIAZIDE;%let GNNclass66=Diur_thz_type;
%let GNN67=METHYCLOTHIAZIDE;%let GNNclass67=Diur_thz_type;
%let GNN68=TRICHLORMETHIAZIDE;%let GNNclass68=Diur_thz_type;


%do i=1 %to 68;
%if &i.=45 %then %do;
data rxx_&i;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&&&GNN&i");
if index(upcase(RXDDRUG), "APRACLONIDINE") then delete;
length GNNname $30. GNNclass $30.;;
GNNname="&&&GNN&i";
GNNclass="&&&GNNclass&i";
run;
%end;
%else %if &i.=27 %then %do;/*BETAXOLOL*/
data rxx_&i;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&&&GNN&i") and index(upcase(RXDDRUG),"OPHTHALMIC")=0;
length GNNname $30. GNNclass $30.;;
GNNname="&&&GNN&i";
GNNclass="&&&GNNclass&i";

run;
%end;
%else %if &i.=33 %then %do; /*TIMOLOL*/
data rxx_&i;;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&&&GNN&i") and index(upcase(RXDDRUG),"OPHTHALMIC")=0;
if index(upcase(RXDDRUG),"DORZOLAMIDE")and index(upcase(RXDDRUG),"&&&GNN&i") then delete;
length GNNname $30. GNNclass $30.;;
GNNname="&&&GNN&i";
GNNclass="&&&GNNclass&i";

run;
%end;
%else %do;
data rxx_&i;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&&&GNN&i");
length GNNname $30. GNNclass $30.;;
GNNname="&&&GNN&i";
GNNclass="&&&GNNclass&i";
run;
%end;

/*proc freq data=t;tables &&&GNN&i;run;*/
%end;

***Find ETHACRYNIC ACID;
%let FG=ETHACRYNIC ACID ;
%let i=69;
%let GNNclass69=Diur_loop;

data rxx_&i;
set RXQ_RX3;
if index(upcase(RXDDRUG),"&FG.");
length GNNname $30. GNNclass $30.;;
GNNname="ETHACRYNIC_ACID";
GNNclass="&&&GNNclass&i";
run;

data rxxcom_&yr.;
set rxx_1-rxx_69;
keep seqn RXDDRUG  GNNname GNNclass;
run;
%mend;

/*proc freq data=rxxcom_&yr.;tables GNNname;run;
data test;
set rxxcom_&yr.;
if GNNname in ("BENAZEPRIL" "CAPTOPRIL" "ENALAPRIL" "FOSINOPRIL" "LISINOPRIL" "MOEXIPRIL" "PERINDOPRIL" "QUINAPRIL" "RAMIPRIL" "TRANDOLAPRIL") then ace=1;
*if GNNname in ("EPLERENONE", "SPIRONOLACTONE") ;
if GNNname in ("DOXAZOSIN" "PRAZOSIN" "TERAZOSIN");
run;

data test;
set rxxcom_&yr.;
if GNNclass="Diur_thz_type";
run;
proc sort data=test out=test_id nodupkey;by seqn;run;
proc freq data=save.seqn_antihyper_v3_single_9900;table  ace Aldo alpha Angioten Alpha_beta Beta_cardio_select Beta_cardio_vasod Beta_cardio_nonselect 
           Beta_int_sym DhpCCB NdhpCCB Central Renin_inhibitors Vasod Diur_loop Diur_Ksparing Diur_thz_like Diur_thz_type;run;*/

%let yr=9900;%let yrl=;%rxc;
%let yr=0102;%let yrl=_b;%rxc;

%let yr=0910;%let yrl=_f;%rxc;
%let yr=1112;%let yrl=_g;%rxc;
%let yr=1314;%let yrl=_h;%rxc;
%let yr=1516;%let yrl=_i;%rxc;
%let yr=1718;%let yrl=_j;%rx;


/*%let yr=9900;%let yrl=;%rx;
%let yr=0102;%let yrl=_b;%rx;*/ *This two has no rxuse and rxdrugs;
%let yr=0304;%let yrl=_c;%rxc;
%let yr=0506;%let yrl=_d;%rxc;
%let yr=0708;%let yrl=_e;%rxc;

%let yr=1720;%let yrl=;%rxc;


data antihyper_com;
set RXXCOM_9900 (in=a1)
    RXXCOM_0102 (in=a2)
	RXXCOM_0304 (in=a3)
	RXXCOM_0506 (in=a4)
	RXXCOM_0708 (in=a5)
	RXXCOM_0910 (in=a6)
	RXXCOM_1112 (in=a7)
	RXXCOM_1314 (in=a8)
	RXXCOM_1516 (in=a9)
	RXXCOM_1720 (in=a10)
;
run;

/*data test;
set antihyper_com;;
if GNNclass="Angioten";
run;
proc sort data=test out=test_id nodupkey;by seqn;run;
proc freq data=csav.seqn_antihyper_9900_1720;table  ace Aldo alpha Angioten Alpha_beta Beta_cardio_select Beta_cardio_vasod Beta_cardio_nonselect 
           Beta_int_sym DhpCCB NdhpCCB Central Renin_inhibitors Vasod Diur_loop Diur_Ksparing Diur_thz_like Diur_thz_type;run;*/

*****step2: Create combination pill aggregate file from 1999-2020;		   
%macro rxc2;
%let GNN1=BENAZEPRIL/AMLODIPINE;%let GNNclass1=ACEI_dihy_CCB;
%let GNN2=PERINDOPRIL/AMLODIPINE;%let GNNclass2=ACEI_dihy_CCB;
%let GNN3=TRANDOLAPRIL/VERAPAMIL;%let GNNclass3=ACEI_non_dihy_CCB;
%let GNN4=BENAZEPRIL/HYDROCHLOROTHIAZIDE;%let GNNclass4=ACEI_thia_diur;
%let GNN5=CAPTOPRIL/HYDROCHLOROTHIAZIDE;%let GNNclass5=ACEI_thia_diur;
%let GNN6=ENALAPRIL/HYDROCHLOROTHIAZIDE;%let GNNclass6=ACEI_thia_diur;
%let GNN7=FOSINOPRIL/HYDROCHLOROTHIAZIDE;%let GNNclass7=ACEI_thia_diur;
%let GNN8=LISINOPRIL/HYDROCHLOROTHIAZIDE;%let GNNclass8=ACEI_thia_diur;
%let GNN9=MOEXIPRIL/HYDROCHLOROTHIAZIDE;%let GNNclass9=ACEI_thia_diur;
%let GNN10=QUINAPRIL/HYDROCHLOROTHIAZIDE;%let GNNclass10=ACEI_thia_diur;
%let GNN11=SPIRONOLACTONE/HYDROCHLOROTHIAZIDE;%let GNNclass11=Aldo_thia_diur ;
%let GNN12=PRAZOSIN/POLYTHIAZIDE;%let GNNclass12=Alpha_thia_diur;
%let GNN13=OLMESARTAN/AMLODIPINE;%let GNNclass13=ARB_dihy_CCB;
%let GNN14=VALSARTAN/AMLODIPINE;%let GNNclass14=ARB_dihy_CCB;
%let GNN15=TELMISARTAN/AMLODIPINE;%let GNNclass15=ARB_dihy_CCB;
%let GNN16=AZILSARTAN/CHLORTHALIDONE;%let GNNclass16=ARB_thia_like;
%let GNN17=CANDESARTAN/HYDROCHLOROTHIAZIDE;%let GNNclass17=ARB_thia_type;
%let GNN18=EPROSARTAN/HYDROCHLOROTHIAZIDE;%let GNNclass18=ARB_thia_type;
%let GNN19=IRBESARTAN/HYDROCHLOROTHIAZIDE;%let GNNclass19=ARB_thia_type;
%let GNN20=LOSARTAN/HYDROCHLOROTHIAZIDE;%let GNNclass20=ARB_thia_type;
%let GNN21=OLMESARTAN/HYDROCHLOROTHIAZIDE;%let GNNclass21=ARB_thia_type;
%let GNN22=TELMISARTAN/HYDROCHLOROTHIAZIDE;%let GNNclass22=ARB_thia_type;
%let GNN23=VALSARTAN/HYDROCHLOROTHIAZIDE;%let GNNclass23=ARB_thia_type;
%let GNN24=ATENOLOL/CHLORTHALIDONE;%let GNNclass24=Beta_thia_like;
%let GNN25=BISOPROLOL/HYDROCHLOROTHIAZIDE;%let GNNclass25=Beta_thia_type;
%let GNN26=METOPROLOL/HYDROCHLOROTHIAZIDE;%let GNNclass26=Beta_thia_type;
%let GNN27=LABETALOL/HYDROCHLOROTHIAZIDE;%let GNNclass27=BetaAlpha_thia_type;
%let GNN28=NADOLOL/BENDROFLUMETHIAZIDE;%let GNNclass28=BetanonCard_thia_type;
%let GNN29=PROPRANOLOL/HYDROCHLOROTHIAZIDE;%let GNNclass29=BetanonCard_thia_type;
%let GNN30=TIMOLOL/HYDROCHLOROTHIAZIDE;%let GNNclass30=BetanonCard_thia_type;
%let GNN31=CLONIDINE/CHLORTHALIDONE;%let GNNclass31=CenACT_thia_like;
%let GNN32=DESERPIDINE/HYDROCHLOROTHIAZIDE;%let GNNclass32=CenACT_thia_type;
%let GNN33=DESERPIDINE/METHYCLOTHIAZIDE;%let GNNclass33=CenACT_thia_type;
%let GNN34=METHYLDOPA/HYDROCHLOROTHIAZIDE;%let GNNclass34=CenACT_thia_type;
%let GNN35=RESERPINE/CHLOROTHIAZIDE;%let GNNclass35=CenACT_thia_type;
%let GNN36=RESERPINE/HYDROFLUMETHIAZIDE;%let GNNclass36=CenACT_thia_type;
%let GNN37=RESERPINE/METHYCLOTHIAZIDE;%let GNNclass37=CenACT_thia_type;
%let GNN38=RESERPINE/POLYTHIAZIDE;%let GNNclass38=CenACT_thia_type;
%let GNN39=ALISKIREN/VALSARTAN;%let GNNclass39=DirRenin_ARB;
%let GNN40=ALISKIREN/HYDROCHLOROTHIAZIDE;%let GNNclass40=DirRenin_thia_type;
%let GNN41=AMILORIDE/HYDROCHLOROTHIAZIDE;%let GNNclass41=Potass_thia_type;
%let GNN42=TRIAMTERENE/HYDROCHLOROTHIAZIDE;%let GNNclass42=Potass_thia_type;
%let GNN43=RESERPINE/CHLORTHALIDONE;%let GNNclass43=CenACT_thia_like;
%let GNN44=HYDRALAZINE/HYDROCHLOROTHIAZIDE;%let GNNclass44=DirVaso_thia_type;
%let GNN45=OLMESARTAN/AMLODIPINE/HYDROCHLOROTHIAZIDE;%let GNNclass45=ARBdihy_thia_type;
%let GNN46=VALSARTAN/AMLODIPINE/HYDROCHLOROTHIAZIDE;%let GNNclass46=ARBdihy_thia_type;
%let GNN47=HYDRALAZINE/HYDROCHLOROTHIAZIDE/RESERPINE;%let GNNclass47=DirVaso_thia_typeC;


%let NGNN1=BENAZEPRIL_AMLODIPINE;
%let NGNN2=PERINDOPRIL_AMLODIPINE;
%let NGNN3=TRANDOLAPRIL_VERAPAMIL;
%let NGNN4=BENAZEPRIL_HCTZ;
%let NGNN5=CAPTOPRIL_HCTZ;
%let NGNN6=ENALAPRIL_HCTZ;
%let NGNN7=FOSINOPRIL_HCTZ;
%let NGNN8=LISINOPRIL_HCTZ;
%let NGNN9=MOEXIPRIL_HCTZ;
%let NGNN10=QUINAPRIL_HCTZ;
%let NGNN11=SPIRONOLACTONE_HCTZ;
%let NGNN12=PRAZOSIN_POLYTHIAZIDE;
%let NGNN13=OLMESARTAN_AMLODIPINE;
%let NGNN14=VALSARTAN_AMLODIPINE;
%let NGNN15=TELMISARTAN_AMLODIPINE;
%let NGNN16=AZILSARTAN_CHLORTHALIDONE;
%let NGNN17=CANDESARTAN_HCTZ;
%let NGNN18=EPROSARTAN_HCTZ;
%let NGNN19=IRBESARTAN_HCTZ;
%let NGNN20=LOSARTAN_HCTZ;
%let NGNN21=OLMESARTAN_HCTZ;
%let NGNN22=TELMISARTAN_HCTZ;
%let NGNN23=VALSARTAN_HCTZ;
%let NGNN24=ATENOLOL_CHLORTHALIDONE;
%let NGNN25=BISOPROLOL_HCTZ;
%let NGNN26=METOPROLOL_HCTZ;
%let NGNN27=LABETALOL_HCTZ;
%let NGNN28=NADOLOL_BENDROFLUMETHIAZIDE;
%let NGNN29=PROPRANOLOL_HCTZ;
%let NGNN30=TIMOLOL_HCTZ;
%let NGNN31=CLONIDINE_CHLORTHALIDONE;
%let NGNN32=DESERPIDINE_HCTZ;
%let NGNN33=DESERPIDINE_METHYCLOTHIAZIDE;
%let NGNN34=METHYLDOPA_HCTZ;
%let NGNN35=RESERPINE_CHLOROTHIAZIDE;
%let NGNN36=RESERPINE_HYDROFLUMETHIAZIDE;
%let NGNN37=RESERPINE_METHYCLOTHIAZIDE;
%let NGNN38=RESERPINE_POLYTHIAZIDE;
%let NGNN39=ALISKIREN_VALSARTAN;
%let NGNN40=ALISKIREN_HCTZ;
%let NGNN41=AMILORIDE_HCTZ;
%let NGNN42=TRIAMTERENE_HCTZ;
%let NGNN43=RESERPINE_CHLORTHALIDONE;
%let NGNN44=HYDRALAZINE_HCTZ;
%let NGNN45=OLMESARTAN_AMLODIPINE_HCTZ;
%let NGNN46=VALSARTAN_AMLODIPINE_HCTZ;
%let NGNN47=HYDRALAZINE_HCTZ_RESERPINE;




%do i=1 %to 12;
data rxx2_&i.;
set antihyper_com (keep=seqn RXDDRUG);
if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/"));
*if index(upcase(RXDDRUG),"TRIAMTERENE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
*if index(upcase(RXDDRUG),"SPIRONOLACTONE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
length GNNname $30. GNNclass $30.;;
GNNname="&&&NGNN&i";
GNNclass="&&&GNNclass&i";

run;

%end;


%do i=13 %to 14;
data rxx2_&i.;
set antihyper_com (keep=seqn RXDDRUG);
if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/")) and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE")=0;
length GNNname $30. GNNclass $30.;;
GNNname="&&&NGNN&i";
GNNclass="&&&GNNclass&i";
run;
%end;



%do i=15 %to 43;
data rxx2_&i.;
set antihyper_com (keep=seqn RXDDRUG);
if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/"));
length GNNname $30. GNNclass $30.;;
GNNname="&&&NGNN&i";
GNNclass="&&&GNNclass&i";
run;
%end;


%do i=44 %to 44;
data rxx2_&i.;
set antihyper_com (keep=seqn RXDDRUG);
if index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/")) and index(upcase(RXDDRUG),"RESERPINE")=0;
length GNNname $30. GNNclass $30.;;
GNNname="&&&NGNN&i";
GNNclass="&&&GNNclass&i";
run;

%end;




%do i=45 %to 47;
data rxx2_&i.;
set antihyper_com (keep=seqn RXDDRUG);
if index(upcase(RXDDRUG),scan("&&&GNN&i.",3,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",2,"/")) and index(upcase(RXDDRUG),scan("&&&GNN&i.",1,"/"));
*if index(upcase(RXDDRUG),"OLMESARTAN") and index(upcase(RXDDRUG),"AMLODIPINE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
*if index(upcase(RXDDRUG),"VALSARTAN") and index(upcase(RXDDRUG),"AMLODIPINE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE");
*if index(upcase(RXDDRUG),"HYDRALAZINE") and index(upcase(RXDDRUG),"HYDROCHLOROTHIAZIDE") and index(upcase(RXDDRUG),"RESERPINE");
length GNNname $30. GNNclass $30.;;
GNNname="&&&NGNN&i";
GNNclass="&&&GNNclass&i";
run;

%end;

data com_com;
set rxx2_1-rxx2_47;
keep seqn RXDDRUG  GNNname GNNclass;
run;


%mend;

%rxc2;

/*data test;
set com_com;;
if GNNclass="DirVaso_thia_type";
run;

proc sort data=test out=test_id nodupkey;by seqn;run;
proc freq data=csav.seqn_antihyper_9900_1720;table  ACEI_dihy_CCB ACEI_non_dihy_CCB ACEI_thia_diur 
Aldo_thia_diur Alpha_thia_diur  ARB_dihy_CCB ARB_thia_like ARB_thia_type Beta_thia_like Beta_thia_type 
BetaAlpha_thia_type CenACT_thia_like CenACT_thia_type  DirRenin_ARB DirRenin_thia_type Potass_thia_type DirVaso_thia_type ARBdihy_thia_type DirVaso_thia_typeC;run;


proc freq data=com_com;tables GNNclass;run;*/


*****step3: Create single pill dataset by excluding combination drug from antihypertensive drug aggregate file;
proc sort data=com_com out=com_com_clm nodupkey;by seqn RXDDRUG;run;

proc sort data=antihyper_com;by seqn RXDDRUG;run;

data single_com;
merge antihyper_com(in=a) com_com_clm(in=b keep=seqn RXDDRUG);
by seqn RXDDRUG;
if a*^b;
run;



/*ods html;
proc freq data=single_com;tables RXDDRUG;run;
ods html close;

ods html;
proc freq data=com_com;tables RXDDRUG;run;
ods html close;*/


*****step4: Basing on the single pill dataset, Identify classes (for example, ACE) for each participant, and sum the number of classes to the variable n_ single_pills;


%macro sigrx;
%let varlist=ACE Aldo Alpha Angioten Alpha_beta Beta_cardio_select Beta_cardio_vasod Beta_cardio_nonselect 
           Beta_int_sym DhpCCB NdhpCCB Central Renin_inhibitors Vasod Diur_loop Diur_Ksparing Diur_thz_like Diur_thz_type;

data T;
set csav.seqn_antihyper_9900_1720(keep=seqn med_infox);
run;
%let n=1;
%let var=%scan(&varlist, &n);
%put &var.;
%do %while (&var ne );
data sigrx;
set single_com; *test antihyper_com and got exactly same results with csav.seqn_antihyper_9900_1720;
if GNNclass="&var.";
run;
proc sort data=sigrx out=sigrx_id(keep=seqn) nodupkey;by seqn;run;

data T;
merge T (in=a) sigrx_id(in=b keep=seqn);
by seqn;
if a;
&var.=0;
if b then &var.=1;
if med_infox=0 then &var.=.;
run;
%let n=%eval(&n+1);
 %let var=%scan(&varlist,&n);
%end;

data single_pill;
set T;
run;
%mend;
%sigrx;
/*proc freq data=t;tables ace;run;

proc sort data=single_pill out=t2(keep=seqn ACE Aldo Alpha Angioten Alpha_beta Beta_cardio_select Beta_cardio_vasod Beta_cardio_nonselect 
           Beta_int_sym DhpCCB NdhpCCB Central Renin_inhibitors Vasod Diur_loop Diur_Ksparing Diur_thz_like Diur_thz_type);by seqn;run;
proc sort data=csav.seqn_antihyper_9900_1720 out=t3(keep=seqn ACE Aldo alpha Angioten Alpha_beta Beta_cardio_select Beta_cardio_vasod Beta_cardio_nonselect 
           Beta_int_sym DhpCCB NdhpCCB Central Renin_inhibitors Vasod Diur_loop Diur_Ksparing Diur_thz_like Diur_thz_type);by seqn;run;

		   proc compare data=t2 compare=t3;run;*/

*****step5: Basing on the combination pill dataset, identify classes (e.g.ACEI_dihy_CCB) for each participant, and sum the number of classes to the variable n_combination_pills;
%macro comrx;
%let varlist=ACEI_dihy_CCB ACEI_non_dihy_CCB ACEI_thia_diur 
Aldo_thia_diur Alpha_thia_diur  ARB_dihy_CCB ARB_thia_like ARB_thia_type Beta_thia_like Beta_thia_type 
BetaAlpha_thia_type BetanonCard_thia_type
 CenACT_thia_like CenACT_thia_type  DirRenin_ARB DirRenin_thia_type Potass_thia_type DirVaso_thia_type ARBdihy_thia_type DirVaso_thia_typeC;

data T;
set csav.seqn_antihyper_9900_1720(keep=seqn med_infox);
run;
%let n=1;
%let var=%scan(&varlist, &n);
%put &var.;
%do %while (&var ne );
data comrx;
set com_com;
if GNNclass="&var.";
run;
proc sort data=comrx out=comrx_id(keep=seqn) nodupkey;by seqn;run;

data T;
merge T (in=a) comrx_id(in=b keep=seqn);
by seqn;
if a;
&var.=0;
if b then &var.=1;
if med_infox=0 then &var.=.;
run;
%let n=%eval(&n+1);
 %let var=%scan(&varlist,&n);
%end;

data com_pill;
set T;
run;
%mend;
%comrx;

/*proc sort data=com_pill out=t2(keep=seqn ACEI_dihy_CCB ACEI_non_dihy_CCB ACEI_thia_diur 
Aldo_thia_diur Alpha_thia_diur  ARB_dihy_CCB ARB_thia_like ARB_thia_type Beta_thia_like Beta_thia_type 
BetaAlpha_thia_type BetanonCard_thia_type
CenACT_thia_like CenACT_thia_type  DirRenin_ARB DirRenin_thia_type Potass_thia_type DirVaso_thia_type ARBdihy_thia_type DirVaso_thia_typeC);by seqn;run;
proc sort data=csav.seqn_antihyper_9900_1720 out=t3(keep=seqn ACEI_dihy_CCB ACEI_non_dihy_CCB ACEI_thia_diur 
Aldo_thia_diur Alpha_thia_diur  ARB_dihy_CCB ARB_thia_like ARB_thia_type Beta_thia_like Beta_thia_type 
BetaAlpha_thia_type BetanonCard_thia_type
CenACT_thia_like CenACT_thia_type  DirRenin_ARB DirRenin_thia_type Potass_thia_type DirVaso_thia_type ARBdihy_thia_type DirVaso_thia_typeC);by seqn;run;
proc compare data=t2 compare=t3;run;*/

*****step6:n_aht_pills = n_single_pills + n_combination_pills;
 /*1.If someone is taking a dhpCCB and ndhpCCB as single medications, we will count this as a single pill.

2.       If someone is taking a beta_cardio_nonselect, beta_cardio_select, Beta_int_sym and/or ndhpCCB as a single medications, we will count this as a single pill.

3.       If someone is taking diur_thz_life and diur_thz_type as single medications, we will count this as a single pill.
*/

data tcom;
merge single_pill(in=a) com_pill(in=b);*can use t3, get same results;
by seqn;
if a*b;
if Alpha_beta=1 or Beta_cardio_select=1 or Beta_cardio_vasod=1 or Beta_cardio_nonselect=1 or Beta_int_sym=1 then Beta=1;else Beta=0;
if DhpCCB=1 or NdhpCCB=1 then CCB=1;else CCB=0;
if Diur_thz_like=1 or Diur_thz_type=1 then Diur_thz=1;else Diur_thz=0;
if med_infox=0 then do;Beta=.;ccb=.;Diur_thz=.;end;

n_single_pills=sum (of ACE,Aldo,Alpha,/*Alpha_beta,*/Angioten,/*Beta_cardio_nonselect,Beta_cardio_vasod,Beta_cardio_select,Beta_int_sym,*/Beta,Central,/*DhpCCB,NdhpCCB*/CCB,Diur_Ksparing,
                     Diur_loop,/*Diur_thz_like,Diur_thz_type*/Diur_thz,Renin_inhibitors,Vasod);

n_combinations=sum(of ACEI_dihy_CCB,ACEI_non_dihy_CCB,ACEI_thia_diur,Aldo_thia_diur,Alpha_thia_diur,ARB_dihy_CCB,ARB_thia_like,ARB_thia_type,Beta_thia_like,
                      Beta_thia_type,BetaAlpha_thia_type,BetanonCard_thia_type,CenACT_thia_like,CenACT_thia_type,DirRenin_ARB,DirRenin_thia_type,Potass_thia_type,
                      DirVaso_thia_type,ARBdihy_thia_type,DirVaso_thia_typeC);

n_aht_pills = n_single_pills+n_combinations;

run;

proc freq data=tcom;tables n_single_pills n_combinations n_aht_pills;run;
proc freq data=tcom;tables Beta CCB Diur_thz;run;


data seqn_antihyper_9900_1720;
merge csav.seqn_antihyper_9900_1720(in=a drop=n_single_pills n_combinations n_aht_pills) tcom(in=b keep=seqn n_single_pills n_combinations n_aht_pills);
by seqn;
if a*b;
run;
proc compare data=csav.seqn_antihyper_9900_1720 compare=seqn_antihyper_9900_1720;run;
data csav.seqn_antihyper_9900_1720;
set seqn_antihyper_9900_1720;
run;


************************************END******************************;


 

