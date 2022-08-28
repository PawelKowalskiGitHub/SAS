
*************************************************************************;
*	Map the variables from the input2 table to the input1 table,        *;
*	preserving the input1 column names.                                 *;
* 	Parameters:                                                         *;
*   	- input1 	- the name of the table whose data will be replaced,*;
*					  and the column names will be preserved            *;
*       - input2 	- name of the table whose data will be stored in the*; 
*					  output table                                      *;
*       - output	- name of the output table                          *;
*       - key1		- related variable for input1                       *;
*       - key2		- related variable for input2                       *;
*                                                                       *;
*   Note: the macro works for tables stored in the WORK library!        *;
*   Note: Note: both input tables must have the same number of columns. *;
*                                                                       *;
*************************************************************************;

%macro variable_mapping(input1, input2, output, key1, key2);

	%do i=1 %to 2;
		proc sql noprint;
			select name into :table&i._list separated by " "
			from DICTIONARY.COLUMNS
			where upcase(LIBNAME)="WORK" AND
			upcase(MEMNAME)=upcase("&&input&i.");
		quit;
	%end;

	proc sql;
		create table &output. as	
			select 
				%do j=1 %to %sysfunc(countw(&table2_list,%str( )));
					%if &j. lt %sysfunc(countw(&table2_list,%str( ))) %then
						t2.%scan(&table2_list.,&j,%str( )) as %scan(&table1_list.,&j,%str( )),;
					%else
						t2.%scan(&table2_list.,&j,%str( )) as %scan(&table1_list.,&j,%str( ));
				%end;
			from &input1. t1
			left join &input2. t2
			on t1.&key1.=t2.&key2.
		;
	quit;

%mend variable_mapping;
%variable_mapping(	input1=,
					input2=,
					output=,
					key1=,
					key2= )