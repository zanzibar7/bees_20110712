function hy = honeycollection(s5,s6) 
	global fa fr fs mS mQ mT ss iQ rs k j m Q omega td; 
    
	fa = 900; % forager round-trip time 
	fr = 0.001; % forager recruitment rate s-1
	fs = fr / 5; % forage resting rate s-1
	mS = 10; % half-maximal search time 
	mQ = 1.5; %  half-maximal forage quality (mol/l)
	mT = 30; % the minimum search time for which tremeble dancing occurs
	ss = 5;% single interaction time 
	iQ = 3.0; % High quality for scaling receiver response 
	rs = 60*20; % receiver storage time 
	k  = 4; % search time coefficient 
	j = 4; % forage quality coefficient 
	m=5; % the steepness of the response to tremble dancing 
	Q  = 3.0; % true nectar quality defined by its sucrose concentration measured in moles per litre since it can be communicated to the receivers
	% initial receiver and forager bees size 
	omega = 0.1; % the maximal recruitment rate due to tremeble dance 
	td = 1; % 

	nt=8; %number of hours that foraging could be going on
	trange = [0:60:3600*nt]; %goes through and counts seconds by the minute
	initial=[0.8*s5+10,0.8*s5+10,1,0,0,0.8*s6];

	if exist("ode45", "file")
		% use this version in matlab
		[t,y] = ode45(@nectarODE_matlab,trange,initial);
	elseif exist("lsode", "file")
		% use this version in octave
		[y,t] = lsode(@nectarODE_octave,initial,trange);
	else
		assert(0,"No ode solver known -- please implement");
	end

	hy=y(end,5); 

end 
