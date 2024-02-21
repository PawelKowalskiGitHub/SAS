*************************************************************************;
*	Code that compares two tables. The result is a data set with an 	*;
*	additional column informing which table the record comes from.		*;
*	Two versions of the code - 4GL and SQL version. 					*;
* 	Parameters:                                                         *;
*	- table1 	- first table             							 	*;
*	- table2 	- second table             								*;
* 	- key    	- variable to join tables               				*;
*************************************************************************;

*4GL way;
%macro find_common_and_separate_part(table1, table2, key);

proc sort data=&table1.; by &key.; run; 
proc sort data=&table2.; by &key.; run;

data comparison;
	length comparison $100;
	merge &table1. (in=t1) &table2. (in=t2); 
	by &key.;
	%sysfunc(scan(&table1.,2,.))=t1;
	%sysfunc(scan(&table2.,2,.))=t2;
	if %sysfunc(scan(&table1.,2,.)) = 1 and %sysfunc(scan(&table2.,2,.)) = 1 then comparison = "%sysfunc(scan(&table1.,2,.)) and %sysfunc(scan(&table2.,2,.))";
	else if %sysfunc(scan(&table1.,2,.)) = 1 then comparison = "%sysfunc(scan(&table1.,2,.))";
	else if %sysfunc(scan(&table2.,2,.)) = 1 then comparison = "%sysfunc(scan(&table1.,2,.))";
	drop %sysfunc(scan(&table1.,2,.)) %sysfunc(scan(&table2.,2,.));
run;

%mend find_common_and_separate_part;

%find_common_and_separate_part(work.master,work.sample,name);



*SQL way;
%macro find_common_and_separate_part(table1, table2, key);
proc sql noprint;
select name into :aaamaster_col1-
from dictionary.columns
where upcase(libname)=upcase("%sysfunc(scan(&table1.,1,.))")
	and upcase(memname)=upcase("%sysfunc(scan(&table1.,2,.))")
;
select name into :aaasample_col1-
from dictionary.columns 
where upcase(libname)=upcase("%sysfunc(scan(&table2.,1,.))")
	and upcase(memname)=upcase("%sysfunc(scan(&table2.,2,.))")
;
quit;
%let sqlstop = &sqlobs.;

%macro concat_colnames;
%do i=1 %to &sqlstop.;
	cat(t1.&&master_col&i., t2.&&sample_col&i.) as &&master_col&i.
	%if &i. ne &sqlstop. %then ,;
%end;
%mend concat_colnames;

proc sql;
create table comparison as
select
	%concat_colnames,
	case 	when t1.&key. is not null and t2.&key. is not null then 'master and sample'
			when t1.&key. is not null then 'master'
			when t2.&key. is not null then 'sample' 
			else ''
			end as comparison
from &table1. t1
full join &table2. t2
on t1.&key.=t2.&key.
;
quit;

%mend find_common_and_separate_part;
%find_common_and_separate_part(work.master,work.sample,name);

