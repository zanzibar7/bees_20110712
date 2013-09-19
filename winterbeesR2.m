
function nextstate = winterbeesR2(state,date)

% winter season 

agemaxwinter=150; % indexing in matlab starts at 1, so add an extra day

s = zeros(4,agemaxwinter);

s(1,1:3)=1;

s(2,4:11)=1;

s(3,12:26)=1;

s(4,27:agemaxwinter)=1; %  test to combine the all the adult bees into one
% stage 

u=0.0;%precocious prob, prob 0.01 will let the colony collapse faster than the higher prob. such as 0.1/0.2??

v=0.0;% reversed prob. between foragers and nurse bees;

overall_P = 0.9999; % survivorship should be density dependent--since temperature factor 

survivorship = zeros(agemaxwinter,1);
% survivorship (1:3,1) = 0.999;
% survivorship (12:26,1) = 0.999;
survivorship (1:26,1) = 0.99;

 
 survivorship(27:agemaxwinter,1)= (1-u)*overall_P; 


theta = 0.00*ones(agemaxwinter-1,1);% theta = probabilities of development retardation

relativedate = mod(date,360);

R= (0.0000434)*(relativedate)^4.98293*exp(-0.05287*relativedate);

% R= 30; 


Vt = state(1);

Pt = state(2); % Pt for pollen cells at time t.  Formlerly F_t for food at time t.

Ht=state(3);% Ht for honey cells at time t. 

%  Rt=state(4);

Nt = state(5:end);

stage = s*Nt;

A = (diag(1-theta,-1)+diag([0;theta]))*diag(survivorship);

transit=A;

Nt1= transit*Nt;
Nt1(1) = R; 


honeyeaten= min([Ht,stage(4)*(0.022)]);
Ht1= Ht-honeyeaten; % Ht from the nectarODE, the net honey storage at the end of the day. 
% survivorship(27:agemaxwinter) = max(0,(1-u)*overall_P*( 1 - max(0,1- (Ht/(0.022*stage(4))))));
a2 = .005; % fraction of a cell's pollen consumed by a larva in one day
a4 = .028; % fraction of a cell's pollen consumed by a nurse in one day
%a5 = .002; % fraction of a cell's pollen removed by a house bee in one day
polleneaten=a2*stage(2)+a4*stage(4); 
Pt1 = Pt- polleneaten;
% survivorship(4:11) = max(0,0.999*( 1 - max(0,1- Pt/(a2*stage(2)))));


vacated = Nt(26) + polleneaten+honeyeaten;
scavangedcells = Nt(1:26)'*(1-survivorship(1:26));
Vt1 = Vt + vacated - R + scavangedcells;


nextstate = [ Vt1; Pt1; Ht1; R; Nt1 ];

return






