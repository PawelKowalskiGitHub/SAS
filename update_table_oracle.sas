
*************************************************************************;
*	Update a table with proc sql. It can be used for pass-through	*;
*	to the Oracle database.						*;
* 	Parameters:                                                     *;
*   	- master_table 		- main table that is updated.           *;
*       - transaction_table 	- table that contains the changes to    *;
*				be applied to the master table.         *;
*       - var_list		- list of variables that are updated in *;
*				the master table.                       *;
*       - key1			- related variable for master_table     *;
*       - key2			- related variable for transaction_table*;
*                                                                       *;
*   NOTE: if a variable exists in the transaction table but does not	*;
*		  exist in master, it will not be in output.		*;
*                                                                       *;
*************************************************************************;	

%macro update_table(master_table, transaction_table,var_list,key1,key2);

	proc sql;
		UPDATE &master_table. t1
		set 
		%do j=1 %to %sysfunc(countw(%superq(var_list),%str( )));
			%if &j ne %sysfunc(countw(%superq(var_list),%str( ))) %then %do;
				%scan(%superQ(var_list),&j,%str( )) = (SELECT %scan(%superQ(var_list),&j,%str( ))
		                 FROM &transaction_table. t2
		                 WHERE t1.&key1. = t2.&key2.),
		    %end;
		    %else %do;
				%scan(%superQ(var_list),&j,%str( )) = (SELECT %scan(%superQ(var_list),&j,%str( ))
		                 FROM &transaction_table. t2
		                 WHERE t1.&key1. = t2.&key2.)
		    %end;		                 
		%end;
		where &key1. in (select &key2. 
							from &transaction_table.)
		;
	quit;
	
%mend update_table;
%update_table(	master_table=,
				transaction_table=,
		 		var_list=,
				key1=,
				key2=)
