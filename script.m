agemax = 53; % +1 because of matlab indexing

G = zeros(5,agemax);
G(1,1:3)=1; G(2,4:11)=1; G(3,12:26)=1; G(4,27:45)=1; G(5,46:agemax)=1;

P0 = 500;
V0 = 3125 - P0;
N = zeros(agemax,1);
N(1:3)=50;
N(4:11)=20;
N(12:26)=60;
N(27:45)=50;
N(46:agemax)=50;
X = [ V0; P0; N ];
figure(2); clf;
figure(1); clf;
subplot(2,1,1);
plot(G*X(3:end),'o-');
hold on;
subplot(2,1,2);
plot(0,X(1),'r+');
plot(0,X(2),'go');
hold on;
for t=1:100
	X = bees(X,t,0);
	figure(1);
	subplot(2,1,1);
	plot(G*X(3:end),'o-');
	hold on;
	subplot(2,1,2);
	plot(t,X(1),'r+');
	plot(t,X(2),'go');
	legend('vacant', 'pollen');
	hold on;
	G*X(3:end)
	pause;
end



