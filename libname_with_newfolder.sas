*************************************************************************;
*	Create a SAS engine library with the creation of a new folder 		*;
*	containing name of the library and creation datetime in the name.	*;
* 	Parameters:                                                         *;
*   	- libname 	- the name of the library to create		            *;
*       - pathname 	- the physical name of the SAS library         	    *;
*                                                                       *;
*   The name of the created folder will be in the following format: 	*;
*	libname_DD-MM-YYYY_hhmmss											*;
*                                                                       *;
*************************************************************************;

%macro libname_with_newfolder(libname, pathname);

	*creating macrovariable with todays date;
	%let datetime = %sysfunc(datetime(),datetime21.2);
		
	data _null_;
		length dt_name $100;
		datetime = input("&datetime",datetime21.2);
		date = datepart(datetime);
		time = compress(put(timepart(datetime),time8.),':');
		dt_name = cats(put(date,DDMMYYD10.),'_',time);
		call symputx('timestamp',dt_name,'G');
		format date DDMMYYD10.;
	run;
	
	%let catalog_name = &libname._&timestamp.;	
	
	options dlcreatedir;
	libname &libname. BASE "&pathname./&catalog_name.";
	options nodlcreatedir;
	
%mend libname_with_newfolder;
%libname_with_newfolder(libname=RRR,
						pathname=/home/u59174447/My_Projects/SAS_codes/RODO_ERR)