*************************************************************************;
*	The following code shows usage and differences basic procedures *;
*	for Descriptive statistics in SAS:				*;
*		- PROC FREQ						*;
*		- PROC SUMMARY						*;
*		- PROC MEANS						*;
*		- PROC UNIVARIATE					*;
*		- PROC TABULATE						*;
*		- PROC REPORT						*;
*									*;
*	The usage was shown on the example of the CARS data set from 	*;
*	the sashelp library.						*;
*************************************************************************;

*-- For simplicity, we load a set of data from the SASHELP library to WORK and create macro variable with the name of our dataset;
data WORK.CARS;
	set SASHELP.CARS;
run;
%let dataset = WORK.CARS;

*-- At the beginning, let's see the attributes of our data set --*;
proc contents data=CARS varnum nodetails; 
run;


*************************************************************************;
*				PROC FREQ				*;
*									*;
*	PROC FREQ is a procedure which helps to summarize categorical	*;
*	variable. It's not just limited to counts, proc freq also 	*; 
*	produces plots and tests for association between two 		*;
*	categorical variab.						*;
*************************************************************************;

*-- Let's create a frequency table to find out how many models each car brand contains --*;
title 'Number of car models per brand';
proc freq data=&dataset.;
	tables make / NOCUM NOCOL NOPERCENT;
run;
 
*-- We can create a 2-way frequency table that will show us the numbers by car make and type --*;
title 'Number of car models per brand and type';
proc freq data=&dataset.;
	tables Type*make / NOCUM NOCOL NOPERCENT NOROW;
run;

*-- We can present the same statement in the form of a simple list instead of a table. --*;
*In addition, we will add the nlevels option, which will show how many unique values there are in each variable listed in the TABLES statement.;
proc freq data=&dataset. nlevels;
	tables Type*make / NOCUM NOCOL NOPERCENT NOROW LIST;
run;

*-- Using proc freq we can visualize the data. For example, we can see the count of models of each type --*;
* The results are presented in a narrow form and observations that have a count of zero are omitted.;
title 'Distribution of car models by types';
proc freq data=&dataset.;
	tables Type / plots=freqplot(orient=vertical type=dotplot) NOCUM NOCOL NOPERCENT NOROW;
run;










