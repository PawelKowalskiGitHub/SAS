*************************************************************************;
*    									*;
*   Three ways to easily create macrolists (a list of values in a 	*;
*	macro variable)							*;
* 				                                 	*;
*************************************************************************;

*creating a sample dataset; 
data dictionary_table;
   length COLUMN1 $50 COLUMN2 $50 COLUMN3 $50;
   input COLUMN1 $ COLUMN2 $ COLUMN3 $;
   datalines;
row11 row12 row13
row21 row22 row23
row31 row32 row33
row41 row42 row43
row51 row52 row52
;
run;

%let var = COLUMN1; *defining variable to store in macrolist;
%let macroname = mlist; *defining name of the macrolist;

*sql method;
proc sql noprint;
	select &var.
		into :&macroname. separated by ' '
	from work.dictionary_table
	;
quit;
%put MACROLIST: &&&macroname.;

*data step method;
data _null_;
	set work.dictionary_table;
	length &macroname. $200;
	&macroname.=strip(&macroname.) || ' ' || strip(&var.);
	retain &macroname.;
	call symputx("&macroname.",&macroname.);
run;
%put MACROLIST: &&&macroname.;

%let &macroname. =;
data _null_;
	set work.dictionary_table;
 	call symputx("&macroname.",trim(resolve('&&&macroname.'))||' '||trim(&var.));
run;
%put MACROLIST: &&&macroname.;


