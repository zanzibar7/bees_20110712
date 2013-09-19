function nextstate = bees(state,date)% bee model in the field season 

agemax=60; % indexing in matlab starts at 1, so add an extra day

global mt1 mt2 mt3 mt4 mt5 mt6; %% mortality rate for each stage of bees 


%%%%%%%%%%%%%%%%%%%%%%%% Parameter Set %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%pollen consumption rate for each stage of bees%%%%%%%%%%%%%%%%%%
a1 = .0; %  a cellful of pollen weighs~~0.23g
a2 = .005; % fraction of a cell's pollen consumed by a larva in one day
a3 = .0;
a4 = .028; % fraction of a cell's pollen consumed by a nurse in one da
a5 = .002; % fraction of a cell's pollen removed by a house bee in one day

%%%%%%%%%honey consumption rate for each stage of bees %%%%%%%%%%%%%%%%%%%%5
h1=0; % fraction of a cell's honey consumed by a bee in one day, a cellful of honey weighs~~0.5g
% h2=0.02378;
h2=0; 
h3=0;
% h4=0.1;
h4=0.05; 
h5=0.036;
%h6=0.2286; 
h6=0; 

%%%%%%%%%%%%%%%%%Pollen foraging Parameter (avarage value for empirical data)
foragingsuccess  = 0.09; % number of cells of pollen collected by a forager in 1 day. Should depend on things.
%foragingsuccess  = f(date) ?


%%%%%%%%%%%%%% Stage Structure for field season bees-normal cycle %%%%%%%
s = zeros(6,agemax);
s(1,1:3)=1;
s(2,4:11)=1;
s(3,12:26)=1;
s(4,27:42)=1;
s(5,43:48)=1;
s(6,49:agemax)=1;
% useful for nonlinearities.1=egg,2=larvae,3=pupae,4=nurse,5=house,6=forager

%%%%%%%%%%%%%%%%%%%%%Abnormal developmental cycle.(precocious+delayed
%%%%%%%%%%%%%%%%%%%%%development in bees)
u=0.0;%precocious prob
v=0.0;% reversed prob. between foragers and house bees;
theta = 0.00*ones(agemax-1,1); % theta = probabilities of development retardation





%%%%%%%%%%%%%%%%%%%%%%%Hive Dynamics%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Empty Cell+Pollen Cells + Honey Cells+Brood Cells =Hive Space%%%%%%%%

% Queen reproduction potential %%%empirical function 
relativedate = mod(date,360);
maxProduction= (0.0000434)*(relativedate)^4.98293*exp(-0.05287*relativedate);

%%%%%%%% Current conditions in bee hive %%%%%%%%
Vt = state(1); % vacant cells 
Pt = state(2); % Pt for pollen cells at time t.  Formlerly F_t for food at time t.
Ht=state(3);% Ht for honey cells at time t. 
Nt = state(5:end);% bee number at time t 


%%%%%%%%%%%% Dynamics in the bee hive %%%%%%%%%%%%%%%%%%%%%%
% bee dynamics% 
stage = s*Nt; % 6 stages 
survivorship = zeros(agemax,1);
survivorship(1:3)= mt1; 
survivorship(4:11) = mt2*( 1 - max(0,1- Pt/(a2*stage(2))));% the larval survivorship is determined by the intrinsic mortality and the food availability mainly pollen 
survivorship(12:26)= mt3; % the brood survivorship is more static, will not affected by the food availability 
survivorship(27:42)= mt4* ( 1 - max(0,1- Pt/(a4*stage(4))-Ht/(h4*stage(4)))); % the nurse bee survivorship depends on the intrinsic mortality and the honey +pollen availability
% there should also be a reduction of nurse survivorship under food
% shortages, but for the moment, we don't know what the right biology is.
survivorship(43:48)= mt5* ( 1 - max(0,1- Ht/(h5*stage(5)))); % the house bee survivorship also depends on the honey storage 
survivorship(49:agemax,1)= (1-v)*mt6;

A = (diag(1-theta,-1)+diag([0;theta]))*diag(survivorship);
B=zeros(agemax);% the delayed development of adult bees 
B(49,27:42)=u*ones(1,16);
C=zeros(agemax);
C(27,49:agemax)= v*ones(1,12); % the precicous development of adult bees 
transit=A+B+C; 
Nt1= transit*Nt; % structured dynamics for bees 

%Food, Empty Cell, Egg dynamics 
foodeaten =  min([Pt,a2*stage(2)+a4*stage(4)+a5*stage(5)]); % pollen consumption 
honeyeaten= min([Ht,h2*stage(2)+h4*stage(4)+h5*stage(5)+h6*stage(6)]); % honey consumption 

scavangedcells = Nt(1:26)'*(1-survivorship(1:26));% The removal of dead brood, hygenic behavior 
vacated = Nt(26) + foodeaten+honeyeaten;% Empty Cells due to the cleaned food cells and adult emergence 

R = min([maxProduction,stage(4)*5,Vt+vacated+scavangedcells]);% Egg input 
storedfood = min([foragingsuccess*stage(6),Vt+vacated+scavangedcells-R]);% pollen input depends on the available cells in the hive, the foraging collection efficiency of the pollen forager---assumption for pollen foraging behavior

%%%%%%%Nectar Input--around 150days--field season%%%%%%%%%%%%%%%%%%%%%%
% base on the nectar foraging mechanism proposed by Tom Seeley

storedhoney= honeycollection(stage(5),stage(6)); % Nectar Input by the nectar foraging ODE model 

%%%%%%%%%Pollen, Honey, Cells net input%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pt1 = Pt- foodeaten + storedfood; % The net pollen storage at the end of the day 
Ht1= Ht-honeyeaten+storedhoney; % The net honey storage at the end of the day. 
Vt1 = Vt +vacated - R -storedfood-storedhoney+ scavangedcells; % The net vacant cells 
Nt1(1) = R; 


nextstate = [ Vt1; Pt1; Ht1; R; Nt1 ];  

return

% p is the probability for the accelerated behavior--precocious

% foraging--the nurse bee stage have a certain probability to jump directly

% into the forager stage.

%figure(2);

%imagesc(A);

%figure(3);

%subplot(2,1,1)

%spy(transit)

%subplot(2,1,2)

%plot(sum(transit),'o-')

%break

%[date,R,storedfood,Vt1-Vt,sum(stage(1:3))+Vt+Pt]

