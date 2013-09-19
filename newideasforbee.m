function nextstate = bees(state,date,queenbirthdate)

	% Reference #1 for parameter value for pollen consumption rate (/cell) by bee
	% larva and nurse bees: Modes of honeybees exposure to systemic insecticides:
	% estimated amounts of contaminated pollen and nectar consumed by different
	% categories of bees
	% (http://www.spos.info/images/uploaded/file/Francuski%20rad.pdf) 

	% Reference #2 for foraging efficiency from book: the biology of honey bee.
	% Mark Winston. 

	agemax=53; % indexing in matlab starts at 1, so add an extra day
	% mu = mortality rates
	survivorship = ones(agemax,1)*.98;
	% theta = probabilities of development retardation
	theta = 0*ones(agemax-1,1);
	regularProduction = 500; % should depend on day length, queen health
	maxProduction = 2000-4*(date-queenbirthdate);

	a2 = .004;
	% fraction of a cell's pollen consumed by a larva in one day, parameter value
	% from reference#1, the pollen consumption by one larva for its 7-day
	% development is about 5.4mg, each cell of stored pollen is 0.23g

	a4 = .014;
	% fraction of a cell's pollen consumed by a nurse in one day, the pollen
	% consumption by one nusre bee for its development is 65mg



	% Vt is the number of vacant cells in hive on day t.
	Vt = state(1);

	% Pt for pollen cells on day t.  Formlerly F_t for food at day t.
	Pt = state(2);

	% Nt(a) is the number of bees that are a-1 days old on day t.
	Nt = state(3:end);

	% assert length(Nt) == agemax
	s = zeros(6,agemax);
	s(1,1:3)=1; s(2,4:11)=1; s(3,12:26)=1; s(4,27:39)=1;\
				s(5,40:45)=1; s(6,46:agemax)=1;
	stage = s*Nt;	% useful for nonlinearities.
					% 1=egg,2=larvae,3=pupae,4=nurse,5=forager

	vacated = Nt(26) + min([Pt,a2*stage(2) + a4*(stage(4)+stage(5))]);
	R = min([maxProduction,regularProduction,(stage(4)+stage(5))/2,Vt+vacated]);
	storedfood = min([DailyForage(stage(6),stage(5)),Vt+vacated-R]);
	Pt1 = Pt- min([Pt,a2*stage(2)+a4*(stage(4)+stage(5))]) + storedfood;
	Vt1 = Vt + vacated - R -storedfood;

	if ( stage(2) <= 0 )
		survivorship(4:11) = .98;
	else
		survivorship(4:11) = .98*( 1 - max(0,1- Pt/(a2*stage(2))));
	end

	% there should also be a reduction of nurse survivorship under food
	% shortages, but for the moment, we don't know what the right biology is.

	A = (diag(1-theta,-1)+diag([0;theta]))*diag(survivorship);
	%figure(2);
	%imagesc(A);


	% Nt1 is the number of bess that are a-1 days old on day t+1.
	Nt1= A*Nt;
	Nt1(1) = R; 

	nextstate = [ Vt1; Pt1; Nt1 ];

return

