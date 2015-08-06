function demoSoftXOR
a=1; b=2; c=3; % variables
on=1; off=2; % states

% The following definitions of variable are not necessary for computation,
% but are useful for displaying table entries:
variable(a).name='a'; variable(a).domain = {'on','off'};
variable(b).name='b'; variable(b).domain ={'on','off'};
variable(c).name='c'; variable(c).domain={'on','off'};

% Three potentials since p(a,b,c)=p(c|a,b)p(a)p(b).
% potential numbering is arbitary
pot(a).variables=a;
pot(a).table(on)=0.65;
pot(a).table(off)=0.35;

pot(b).variables=b;
pot(b).table(on)=0.77;
pot(b).table(off)=0.23;

pot(c).variables=[c,a,b]; % define array below using this variable order
pot(c).table(on, off, off) =0.1;
pot(c).table(on, off, on)  =0.99;
pot(c).table(on, on, off)  =0.8;
pot(c).table(on, on, on)   =0.25;
pot(c).table(off,:,:)=1-pot(c).table(on,:,:); % due to normalisation

jointpot = multpots(pot([a b c])); % joint distribution

drawNet(dag(pot),variable);
disp('p(a|c=0):')
disptable(condpot(setpot(jointpot,c,off),a),variable);

