*************************************************************************;
*	This program shows a simple example of mapping variables using 	*;
*	a HASH table.  							*;
*                                                                       *;
*   In the example, the master table containing state abbreviations 	*;
*	values in State variable is mapped. State abbreviations values 	*;
*	will be replaced with the full state name from the data table  	*;
*	to be mapped.                                                   *;
*                                                                       *;
*************************************************************************;

*Master table - this table will be mapped;
data master;
	length ID 8 STATE $2;
	input ID STATE $;
	datalines;
	1 CA
	2 MS 
	3 OH 
	4 TX 
	5 FL
	;
run;

*Table with data to be mapped;
data map_table;
	length ID 8 SHORT $2 STATE_NAME $32;
	input ID SHORT $ STATE_NAME $;
	datalines;
	1 CA California
	2 MS Mississippi
	3 OH Ohio
	4 TX Texas
	5 FL Florida
	;
run;

*Mapping;
data WORK.MASTER;
	length ID 8 STATE $32;
	if 0 then set work.map_table;
	if _N_ = 1 then do;		
		declare hash Map(dataset: 'map_table', multidata: 'y', duplicate: 'r');
		Map.definekey('SHORT');
		Map.definedata('STATE_NAME');
		Map.definedone();		
	end;
	set WORK.MASTER;	
	if Map.add() = 0;
	if Map.find(key: STATE) = 0;
	STATE = STATE_NAME;
	drop SHORT STATE_NAME;
run;















