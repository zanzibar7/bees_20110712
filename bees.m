function nextstate = bees(state,date,queenbirthdate)
agemax=53; % indexing in matlab starts at 1, so add an extra day

% mu = mortality rates
survivorship = ones(agemax,1)*.95;
% theta = probabilities of development retardation
theta = 0*ones(agemax-1,1);
regularProduction = 500.; % should depend on day length, queen health
maxProduction = 2000.-1*(date-queenbirthdate);
a2 = .05; % fraction of a cell's pollen consumed by a larva in one day
a4 = .05; % fraction of a cell's pollen consumed by a nurse in one day
foragingsuccess  = 5.; % number of cells of pollen collected by a forager in 1 day. Should depend on things.


Vt = state(1);
Pt = state(2); % Pt for pollen cells at time t.  Formlerly F_t for food at time t.
Nt = state(3:end);

% assert length(Nt) == agemax

s = zeros(5,agemax);
s(1,1:3)=1; s(2,4:11)=1; s(3,12:26)=1; s(4,27:45)=1; s(5,46:agemax)=1;
stage = s*Nt;	% useful for nonlinearities.
				% 1=egg,2=larvae,3=pupae,4=nurse,5=forager

vacated = Nt(26) + min([Pt,a2*stage(2) + a4*stage(4)]);
R = min([maxProduction,regularProduction,stage(4)/2,Vt+vacated]);
storedfood = min([foragingsuccess*stage(5),Vt+vacated-R]);
Pt1 = Pt- min([Pt,a2*stage(2)+a4*stage(4)]) + storedfood;
Vt1 = Vt + vacated - R -storedfood;

if ( stage(2) <= 0 )
	survivorship(4:11) = .95
else
	survivorship(4:11) = .95*( 1 - max(0,1- Pt/(a2*stage(2))));
end

% there should also be a reduction of nurse survivorship under food
% shortages, but for the moment, we don't know what the right biology is.

A = (diag(1-theta,-1)+diag([0;theta]))*diag(survivorship);
%figure(2);
%imagesc(A);


Nt1= A*Nt;
Nt1(1) = R; 

nextstate = [ Vt1; Pt1; Nt1 ];
return
