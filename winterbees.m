function nextstate = winterbees(state,date)
% winter season 
agemaxwinter=90; % indexing in matlab starts at 1, so add an extra day
%tx=200;
s = zeros(5,agemaxwinter);

s(1,1:3)=1;

s(2,4:11)=1;

s(3,12:26)=1;

s(4,27:42)=1;

s(5,43:agemaxwinter)=1;

u=0.0;%precocious prob, prob 0.01 will let the colony collapse faster than the higher prob. such as 0.1/0.2??
v=0.0;% reversed prob. between foragers and nurse bees;

overall_P = .95;
survivorship = ones(agemaxwinter,1)*overall_P;
survivorship(27:42,1)= (1-u)*overall_P;
survivorship(43:agemaxwinter,1)= (1-v)*1;

% theta = probabilities of development retardation
theta = 0.00*ones(agemaxwinter-1,1);

%regularProduction = 1000.; % should depend on day length, queen health
relativedate = mod(date,360);

 if (relativedate<240)
    R= (0.0000434)*(date)^4.98*exp(-0.05674*(date));
else
    R= 50;
end
% elseif date>600
%     R= (0.0000434)*(date+300)^4.98*exp(-0.05674*(date+300));

% %%%%%%%% Current conditions %%%%%%%%
% 
% 
Nt = state(1:end);
% 
% % assert length(Nt) == agemax
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
E = eye(agemaxwinter);
stage = s*Nt;
% 
%   
% 
% if ( stage(2) <= 0 )
% 
% 	survivorship(4:11) = .99;
% 
% else
% 
% 	survivorship(4:11) = .99*( 1 - max(0,1- Pt/(a2*stage(2))));

% end
% 


A = (diag(1-theta,-1)+diag([0;theta]))*diag(survivorship);

% B=zeros(agemax);
% B(49,27:42)=u*ones(1,16);

% C=zeros(agemax);
% C(27,49:agemax)= v*ones(1,12);
% transit=A+B+C;
transit=A;



Nt1= transit*Nt;

Nt1(1) = R; 

nextstate = Nt1;

return



