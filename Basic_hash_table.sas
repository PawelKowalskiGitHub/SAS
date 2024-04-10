*Basic example;
DATA A;
input Name $1. Salary Age PIN;
Cards;
A 200 20 40
B 300 30 60
C 400 40 80
D 500 50 100
E 600 60 120
F 700 70 140
;
Run;

DATA B;
input Name $1. Salary Grade $2. BIN;
Cards;
A 200 AA 20
G 800 GG 80
H 900 HH 90
I 1000 II 100
F 700 FF 70
;
Run;

data want;
    if 0 then set a b;
    declare hash h1(dataset:'B');
    h1.definekey('Name');
    h1.definedata(all:'Y');
    h1.definedone();

    do until(LR);
        set a end=LR;
        if h1.find(key:Name) = 0 then output;
    end;
    stop;
run;

data want2;
    if 0 then set a b (drop=grade);
    declare hash h1(dataset:'B');
    h1.definekey('Name');
    h1.definedata('BIN');
    h1.definedone();

    set a end=LR;
    if h1.find(key:Name) = 0 then output;
run;
