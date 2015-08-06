function demoHamburgerKJ
% hamburger_eater=1; kreuzfeld_jacob=2;
hamburger_eater=1; kreuzfeld_jacob=2; hgk=3; % variables
true=1; false=2; % states

% The following definitions of variable are not necessary for computation,
% but are useful for displaying table entries:
variable(hamburger_eater).name='hamburger_eater';
variable(hamburger_eater).domain = {'true', 'false'};

variable(kreuzfeld_jacob).name='kreuzfeld_jacob';
variable(kreuzfeld_jacob).domain ={'true', 'false'};

variable(hgk).name='hgk';
variable(hgk).domain ={'true'};

% Two potentials since p(kj, h)=p(h|kj)p(kj).
% potential numbering is arbitary
pot(kreuzfeld_jacob).variables=kreuzfeld_jacob;
pot(kreuzfeld_jacob).table(true)=0.00001;
pot(kreuzfeld_jacob).table(false)=0.99999;

pot(hamburger_eater).variables=hamburger_eater;
pot(hamburger_eater).table(true) = 0.5;
pot(hamburger_eater).table(false) = 0.5;

pot(hgk).variables=[hgk, hamburger_eater, kreuzfeld_jacob];
pot(hgk).table(true,true,true) = 0.1;
pot(hgk).table(true,false,true) = 0.1;
pot(hgk).table(true,false,false) = 0.0;
pot(hgk).table(true,false,false) = 0.0;
pot(hgk).table(false,:,:) = pot(hgk).table(true,:,:);

jointpot = multpots(pot([hgk kreuzfeld_jacob])); % joint distribution

drawNet(dag(pot),variable);
disp('p(kreuzfeld_jacob|hamburger_eater):')
disptable(condpot(setpot(jointpot, hgk, true),kreuzfeld_jacob),variable);
