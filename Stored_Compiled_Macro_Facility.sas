libname mlib "/home/u59174447/My_Projects";

options mcompilenote=all;

options mstored sasmstore=mlib;
%macro simple_macro / store source des='Description.';
   %put This is macro body.;
%mend simple_macro;

proc catalog cat=mlib.sasmacr;
     contents;
quit;

%simple_macro
%copy simple_macro / source;

%sysmstoreclear;
libname mlib clear;
