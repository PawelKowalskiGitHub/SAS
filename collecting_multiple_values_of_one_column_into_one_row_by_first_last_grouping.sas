*************************************************************************;
*	This is an example of collecting multiple values of one column into *;
*	one row by first/last grouping										*;
*	In this example we want to collect the values from the SYS_ID 		*;
*	column for all rows that have the same values in the columns 		*;
*	colA-colD into 														*;
*	one row.															*;
*************************************************************************;



data TABLE;
	infile datalines delimiter=',';
	input id colA $ colB $ colC $ colD $ SYS_ID;
	datalines;
1,	A1,B1,C1,D1,1
2,	A2,B2,C2,D2,1
3,	A1,B1,C1,D1,2
4,	A2,B2,C2,D2,2
5,	A3,B3,C3,D3,1
6,	A1,B1,C1,D1,3
7,	A4,B4,C4,D4,1
8,	A5,B5,C5,D5,2
9,	A6,B6,C6,D6,2
10,	A3,B3,C3,D3,2
11,	A1,B1,C1,D2,1
;
run;
		
proc sort data=table out=table; by colA colB colC colD; run;
data want;
	set table;
	by colA colB colC colD;
	retain flag_out;
	length flag_out $100;
	flag_out = catx(',',strip(flag_out),strip(SYS_ID));
	if first.colD then flag_out = strip(SYS_ID);
	if last.colD then output;
	rename flag_out=SYS_ID;
	drop SYS_ID;
run;
		
		
		
		
		

