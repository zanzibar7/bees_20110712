% treluga, 20120324.
% This code calculates the surface for honey collected based
% on the number of bees involved in collection, and stores
% it in a matrix that we can later use for interpolation.
% This will significantly speed up the model.

% H = stage(5)
% F = stage(6)

% The larger Hn and Fn, the more accurate your interpolation

Hn = 25; Fn = 25;
global hsurfX hsurfY hsurf;

% 
% x and y are the ranges for stage(5) and stage(6).
% The code has a problem if we plug 0 into the ODE's below, so we
% start at 1.  I'm just guessing that 4000 is a large enough
% upper bound, but this may need to be increased.
H = 10.^linspace(1,5,Hn);
F = 10.^linspace(1,5,Fn);
hsurfX=H;
hsurfY=F;
hsurf = zeros(length(H),length(F));
for i=1:1:Hn
	for j=1:1:Fn
		Hi = H(i);
		Fj = F(j);
		predictedhoney = honeycollection( H(i), F(j) );
		hsurf(i,j) = predictedhoney;
	end
end

save hsurfX.data hsurfX -ascii
save hsurfY.data hsurfY -ascii
save hsurf.data hsurf -ascii
