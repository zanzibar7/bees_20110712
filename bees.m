function nextstate = bees(state,date)
% 
agemax=60; % indexing in matlab starts at 1, so add an extra day

global s1 s2 s3 s4 s5 s6; 
s = zeros(6,agemax);

s(1,1:3)=1;

s(2,4:11)=1;

s(3,12:26)=1;

s(4,27:42)=1;

s(5,43:48)=1;

s(6,49:agemax)=1;
% s(1,1:3)=1;
% 
% s(2,4:9)=1;
% 
% s(3,10:23)=1;
% 
% s(4,24:34)=1;
% 
% s(5,35:44)=1;
% 
% s(6,45:agemax)=1;


% useful for nonlinearities.

				% 1=egg,2=larvae,3=pupae,4=nurse,5=house,6=forager

% normal developmental cycle.

% mu = mortality rates

u=0.0;%precocious prob, prob 0.01 will let the colony collapse faster than the higher prob. such as 0.1/0.2??

v=0.0;% reversed prob. between foragers and nurse bees;

survivorship = zeros(agemax,1);
survivorship(1:3)= s1;
% survivorship(4:11)= s2;

survivorship(12:26)= s3;
survivorship(27:42)= s4;
survivorship(43:48)= s5;
% survivorship(24:34,1)= (1-u)*s6;

survivorship(49:agemax,1)= (1-v)*s6;
% survivorship(45:agemax,1)= (1-v)*.0;

% theta = probabilities of development retardation

theta = 0.00*ones(agemax-1,1);

%regularProduction = 1000.; % should depend on day length, queen health

%maxProduction = 2000.-0.5*(date-queenbirthdate);
relativedate = mod(date,360);
maxProduction= (0.0000434)*(relativedate)^4.98293*exp(-0.05287*relativedate);

%%%%%%%%%%%%%%%%%%%%%%%%consumption rate for pollen&honey %%%%%%%%%%%%%%%%%


a1 = .0; %  a cellful of pollen weighs~~0.23g

a2 = .005; % fraction of a cell's pollen consumed by a larva in one day

a3 = .0;

a4 = .028; % fraction of a cell's pollen consumed by a nurse in one day

a5 = .002; % fraction of a cell's pollen removed by a house bee in one day

h1=0; % fraction of a cell's honey consumed by a bee in one day, a cellflu of honey weighs~~0.5g

% h2=0.02378;
h2=0; 

h3=0;

% h4=0.1;
h4=0.05; 

h5=0.036;

%h6=0.2286; 

h6=0; 

foragingsuccess  = 0.09; % number of cells of pollen collected by a forager in 1 day. Should depend on things.

%foragingsuccess  = f(date) ?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% Current conditions %%%%%%%%

Vt = state(1);

Pt = state(2); % Pt for pollen cells at time t.  Formlerly F_t for food at time t.

Ht=state(3);% Ht for honey cells at time t. 

Nt = state(5:end);

% assert length(Nt) == agemax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% E = eye(agemax);

stage = s*Nt;

foodeaten =  min([Pt,a2*stage(2)+a4*stage(4)+a5*stage(5)]); % pollen consumption 

honeyeaten= min([Ht,h2*stage(2)+h4*stage(4)+h5*stage(5)+h6*stage(6)]); % honey consumption 

scavangedcells = Nt(1:26)'*(1-survivorship(1:26));

vacated = Nt(26) + foodeaten+honeyeaten;

R = min([maxProduction,stage(4)*0.5,Vt+vacated+scavangedcells]);

% R = min([maxProduction,Vt+vacated+scavangedcells]);

%[R,maxProduction,regularProduction,stage(4)/2,Vt+vacated+scavangedcells]

storedfood = min([foragingsuccess*stage(6),Vt+vacated+scavangedcells-R]);


%%%%%%%Honey collection time --around 150days--field season%%%%%%%%%%%%%%%%%%%%%%


 initial=[0.8*stage(5)+10,0.8*stage(5)+10,1,0,0,0.8*stage(6)]';
% HB= 0.5* stage(5);
% FB= 0.5* stage(6);
% storedhoney=honeystore(HB,FB); % nectar forage DDE model 
storedhoney= honeycollection(initial);
Ht1= Ht-honeyeaten+storedhoney; % Ht from the nectarODE, the net honey storage at the end of the day. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
Pt1 = Pt- foodeaten + storedfood;

Vt1 = Vt +vacated - R -storedfood-storedhoney+ scavangedcells;

  
% if ( stage(2) <= 0 )
% 
% 	survivorship(4:11) = .99;
% 
% else

	

% end

% there should also be a reduction of nurse survivorship under food

% shortages, but for the moment, we don't know what the right biology is.


survivorship(4:11) = s2*( 1 - max(0,1- Pt/(a2*stage(2))));

A = (diag(1-theta,-1)+diag([0;theta]))*diag(survivorship);

B=zeros(agemax);

B(49,27:42)=u*ones(1,16);

C=zeros(agemax);

C(27,49:agemax)= v*ones(1,12);

transit=A+B+C;

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

%

%break



Nt1= transit*Nt;

%Nt1(49) = 0.
Nt1(1) = R; 



nextstate = [ Vt1; Pt1; Ht1; R; Nt1 ];



%[date,R,storedfood,Vt1-Vt,sum(stage(1:3))+Vt+Pt]



return







