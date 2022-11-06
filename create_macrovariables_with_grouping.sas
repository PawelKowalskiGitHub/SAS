*************************************************************************;
*   This is an example of a scheme for creating a series of macro  	*;
*   variables with grouping.						*;
* 	Parameters:                                                     *;
*   	- tablename 	 - table name, with data for macro variables 	*;
*       - sort_variables - list of variables to sort         	   	*;
*									*;
*   The code presented here is just a template with an example to show 	*;
*	how the program works.						*;
*************************************************************************;

*creating a sample dataset; 
data dictionary_table;
   length LIBRARY $50 TABLE $50 VARIABLE $50;
   input LIBRARY $ TABLE $ VARIABLE $;
   datalines;
LIB1 TAB1 COL1
LIB1 TAB1 COL2
LIB1 TAB2 COL1
LIB1 TAB2 COL2
LIB1 TAB3 COL1
LIB2 TAB1 COL1
LIB2 TAB1 COL2
LIB2 TAB1 COL3
LIB2 TAB2 COL1
LIB2 TAB2 COL2
LIB2 TAB2 COL3
LIB2 TAB2 COL4
LIB2 TAB2 COL5
LIB3 TAB1 COL1
LIB3 TAB1 COL2
LIB3 TAB2 COL1
LIB3 TAB3 COL1
LIB3 TAB3 COL2
;
run;


options mprint mlogic symbolgen;
%macro create_macrovariables(tablename, sort_variables);

	proc sort data=&tablename.;
		by &sort_variables.;
	run;

	data _null_;
		retain LIBn 0;
		retain TABn 0;
		retain COLn 0; 
		set &tablename. end=last;
		id = _N_;
		by &sort_variables.;

		if first.library then do;
			libn + 1;
		end;
		if first.table then do;
			tabn + 1;
			COLn = 0;
		end;
		if first.variable then do;
			COLn + 1;
			call symputx(compress("LIB"||put(libn,3.)),LIBRARY,'G');
			call symputx(compress("TAB"||put(tabn,3.)),TABLE,'G');
			call symputx(compress("TAB"||put(tabn,3.)||"COL"||put(COLn,3.)),VARIABLE,'G');
			call symputx(compress("TAB"||put(tabn,3.)||"COLn"),COLn,'G');
		end;
		if last then do;
			call symputx("TABn",tabn,'G');
		end;
	run;
	
	
	%put _user_;
	
%mend create_macrovariables;
%create_macrovariables(
			tablename=dictionary_table,
			sort_variables=LIBRARY TABLE VARIABLE)
	
	
	
