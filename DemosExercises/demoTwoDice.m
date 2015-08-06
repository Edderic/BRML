function demoTwoDice
%DEMOCLOUSEAU inspector clouseau example
s1=1; s2=2; t=3; % Variable order is arbitary

% define states, starting from 1.
one=1; two=2; three=3; four=4; five=5; six=6;
seven=7; eight=7; nine=7; ten=7; eleven=7; twelve=7; thirteen=7; fourteen=7;
fifteen=7; sixteen=7; seventeen=7; eighteen=7; nineteen=7; twenty=7;
twentyone=7; twentytwo=7; twentythree=7; twentyfour=24;

% The following definitions of variable are not necessary for computation,
% but are useful for displaying table entries:
variable(s1).name='s1'; variable(s1).domain = {'one','two','three', 'four', 'five', 'six'};
variable(s2).name='s2'; variable(s2).domain ={'one','two','three', 'four', 'five', 'six'};
variable(t).name='t'; variable(t).domain={'two','three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve' };

% Three potentials since p(s1,s2,t)=p(t|s1,s2)p(s1)p(s2).
% potential numbering is arbitary
pot(s1).variables=s1;
pot(s1).table(one)=0.16666;
pot(s1).table(two)=0.16666;
pot(s1).table(three)=0.16666;
pot(s1).table(four)=0.16666;
pot(s1).table(five)=0.16666;
pot(s1).table(six)=0.16666;

pot(s2).variables=s2;
pot(s2).table(one)=0.16666;
pot(s2).table(two)=0.16666;
pot(s2).table(three)=0.16666;
pot(s2).table(four)=0.16666;
pot(s2).table(five)=0.16666;
pot(s2).table(six)=0.16666;

pot(t).variables=[t,s1,s2]; % define array below using this variable order
pot(t).table(2 , 1 , 1)=1;

pot(t).table(3 , 1 , 2)=1;
pot(t).table(3 , 2 , 1)=1;

pot(t).table(4 , 1 , 3)=1;
pot(t).table(4 , 3 , 1)=1;
pot(t).table(4 , 2 , 2)=1;

pot(t).table(5 , 1 , 4)=1;
pot(t).table(5 , 4 , 1)=1;
pot(t).table(5 , 2 , 3)=1;
pot(t).table(5 , 3 , 2)=1;

pot(t).table(6 , 1 , 5)=1;
pot(t).table(6 , 5 , 1)=1;
pot(t).table(6 , 2 , 4)=1;
pot(t).table(6 , 4 , 2)=1;
pot(t).table(6 , 3 , 3)=1;

pot(t).table(7 , 1 , 6)=1;
pot(t).table(7 , 6 , 1)=1;
pot(t).table(7 , 2 , 5)=1;
pot(t).table(7 , 5 , 2)=1;
pot(t).table(7 , 3 , 4)=1;
pot(t).table(7 , 4 , 3)=1;

pot(t).table(8 , 2 , 6)=1;
pot(t).table(8 , 6 , 2)=1;
pot(t).table(8 , 3 , 5)=1;
pot(t).table(8 , 5 , 3)=1;
pot(t).table(8 , 4 , 4)=1;

pot(t).table(9 , 3 , 6)=1;
pot(t).table(9 , 6 , 3)=1;
pot(t).table(9 , 4 , 5)=1;
pot(t).table(9 , 5 , 4)=1;

pot(t).table(10, 6, 4)=1;
pot(t).table(10, 4, 6)=1;
pot(t).table(10, 5, 5)=1;

pot(t).table(11, 6, 5)=1;
pot(t).table(11, 5, 6)=1;

pot(t).table(12, 6, 6)=1;

jointpot = multpots(pot([s1 s2 t])); % joint distribution

drawNet(dag(pot),variable);
disp('p(s1,s2|t=9):')
disptable(condpot(setpot(jointpot,t,9),[s1,s2]),variable);
