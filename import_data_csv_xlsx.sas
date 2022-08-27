
*************************************************************************;
*	Import multiple csv and xlsx files to the sas platform in one macro.*;
* 	Parameters:                                                         *;
*   	- path 		- path to the file you want to import               *;
*       - filename 	- name of the file you want to import               *;
*       - extension - file extension (csv or xlsx)                      *;
*       - output 	- name of the sas dataset                           *;
*       - getnames	- yes or no                                         *;
*                                                                       *;
*   You can specify one value in the path parameter that is compatible  *;
*	with all imported files or multiple values - separate for each      *;
*	imported file.                                                      *;
*                                                                       *;
*                                                                       *;
*************************************************************************;

%macro import(path, filename, extension, output, getnames=yes);
	
	%do i=1 %to %sysfunc(countw(&filename.));
	
		proc import datafile= 
					%if %sysfunc(countw(&path., ' ')) eq 1 %then 
						"&path./%scan(&filename. ,&i., ' ').%scan(&extension., &i., ' ')";
					%else 
						"%scan(&path. ,&i., ' ')/%scan(&filename. ,&i., ' ').%scan(&extension., &i., ' ')";
			dbms=%scan(&extension., &i., %str( ))
			out=%scan(&output., &i., %str( ))
			replace;
			getnames=yes;
		run;
		
	%end;
	
%mend import;

%import(
		path= , 
		filename= , 
		extension= ,
		output= ,
		getnames=)