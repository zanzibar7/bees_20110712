%nrm = [1/3,1/8,1/15,1/16,1/6,1/12]'; % normalize frequencies for each stage

% First Season Summer Dynamics 
agemax = 60; % +1 because of matlab indexing
tx=240;
G = zeros(6,agemax);

G(1,1:3)=1; G(2,4:11)=1; G(3,12:26)=1; G(4,27:42)=1;G(5,43:48)=1;G(6,49:agemax)=1;
P0 = 1000;
V0 = 300000 - P0;
R0=0;
N = zeros(agemax,1); % [37.1241;122.3912;355.7533;666.7425;9429.1148;]
N(1:3)=1000;
N(4:11)=1000;
N(12:26)=1000;
N(27:42)=500;
N(43:48)=500;
N(49:agemax)=300;
X = [ V0; P0; R0; N];
res=zeros(6,tx);
R=zeros(1,tx);
v=zeros(1,tx);
p=zeros(1,tx);

numyears = 2;
summerdays = 240;
yeardays = 360;

pop=zeros(6,yeardays*numyears);

for T = 0:(numyears-1)
	 for t=(yeardays*T+1):(yeardays*T+summerdays)
		X = bees(X,t,0);
		res(1:6,t-yeardays*T)=G*X(4:end);
		v(1,t)= X(1);
		p(1,t)=X(2);
		R (1,t)= X(3);
	end
	pop(:,(yeardays*T+1):(yeardays*T+summerdays))=res;
	 
	% First Season Winter Dynamics 
	agemaxwinter=90; 
	W = zeros(5,agemaxwinter);
	W(1,1:3)=1; W(2,4:11)=1; W(3,12:26)=1; W(4,27:42)=1;W(5,43:agemaxwinter)=1;
	restmp=res;
	N = zeros(agemaxwinter,1);
	N(1:3)=res(1,summerdays)/3;
	N(4:11)=res(2,summerdays)/8;
	N(12:26)=res(3,summerdays)/15;
	N(27:42)=res(4,summerdays)/16;
	N(43:agemaxwinter)=res(5,summerdays)/40;
	Y = N;
	clear res;
	res=zeros(6,yeardays-summerdays);
	for t=(yeardays*T+summerdays+1):(yeardays*(T+1))
		Y = winterbees(Y,t);
		res(1:5,(t-(yeardays*T+summerdays)))=W*Y(1:end);
	end 
	pop(:, (yeardays*T+summerdays+1):(yeardays*(T+1))) =res;

	%Second Season Summer Dynamics 
	% restmp=pop;
	N = zeros(agemax,1);
	N(1:3)=pop(1,yeardays*(T+1))/3;
	N(4:11)=pop(2,yeardays*(T+1))/8;
	N(12:26)=pop(3,yeardays*(T+1))/15;
	N(27:42)=pop(4,yeardays*(T+1))/16;
	N(43:48)=pop(5,yeardays*(T+1))/6;
	N(49:agemax)=0;
	P0 = 0;
	V0 = 300000 - P0;
	R0=0;
	X = [ V0; P0; R0; N];
	res=zeros(6,summerdays);
	R=zeros(1,summerdays);
	v=zeros(1,summerdays);
	p=zeros(1,summerdays);

end

createfigure(pop');
