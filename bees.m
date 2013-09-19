function nextstate = bees(state,date,queenbirthdate)
% 
agemax=60; % indexing in matlab starts at 1, so add an extra day

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

survivorship = ones(agemax,1)*.99;

survivorship(27:42,1)= (1-u)*.99;
% survivorship(24:34,1)= (1-u)*.98;

survivorship(49:agemax,1)= (1-v)*.85;
% survivorship(45:agemax,1)= (1-v)*.0;

% theta = probabilities of development retardation

theta = 0.00*ones(agemax-1,1);

%regularProduction = 1000.; % should depend on day length, queen health

%maxProduction = 2000.-0.5*(date-queenbirthdate);
relativedate = mod(date,360);
maxProduction= (0.0000434)*(relativedate)^4.98*exp(-0.05674*relativedate);

a1 = .0;

a2 = .005; % fraction of a cell's pollen consumed by a larva in one day

a3 = .0;

a4 = .028; % fraction of a cell's pollen consumed by a nurse in one day

a5 = .002; % fraction of a cell's pollen removed by a house bee in one day

foragingsuccess  = 0.5; % number of cells of pollen collected by a forager in 1 day. Should depend on things.

%foragingsuccess  = f(date) ?



%%%%%%%% Current conditions %%%%%%%%

Vt = state(1);

Pt = state(2); % Pt for pollen cells at time t.  Formlerly F_t for food at time t.

Nt = state(4:end);

% assert length(Nt) == agemax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



E = eye(agemax);

stage = s*Nt;

foodeaten =  min([Pt,a2*stage(2)+a4*stage(4)+a5*stage(5)]);

scavangedcells = Nt(1:26)'*(1-survivorship(1:26));

vacated = Nt(26) + foodeaten;

R = min([maxProduction,stage(4)*2,Vt+vacated+scavangedcells]);

%[R,maxProduction,regularProduction,stage(4)/2,Vt+vacated+scavangedcells]

storedfood = min([foragingsuccess*stage(6),Vt+vacated+scavangedcells-R]);


Pt1 = Pt- foodeaten + storedfood;

Vt1 = Vt +vacated - R -storedfood + scavangedcells;

  

if ( stage(2) <= 0 )

	survivorship(4:11) = .99;

else

	survivorship(4:11) = .99*( 1 - max(0,1- Pt/(a2*stage(2))));

end





% there should also be a reduction of nurse survivorship under food

% shortages, but for the moment, we don't know what the right biology is.



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



nextstate = [ Vt1; Pt1; R; Nt1 ];



%[date,R,storedfood,Vt1-Vt,sum(stage(1:3))+Vt+Pt]



return




