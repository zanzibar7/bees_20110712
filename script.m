agemax = 53; % +1 because of matlab indexing
G = zeros(5,agemax);
G(1,1:3)=1; G(2,4:11)=1; G(3,12:26)=1; G(4,27:45)=1; G(5,46:agemax)=1;
P0 = 500;
V0 = 10000 - P0;
N = zeros(agemax,1);
N(1:3)=1000/(3-1+1); % eggs
N(4:11)=1000/(11-4+1); % larvae
N(12:26)=1000/(26-12+1); % pupae
N(27:45)=2000/(45-27+1); % nurse bees
N(46:agemax)=2000/(agemax-46+1); % foragers
disp(sum(N))
X = [ V0; P0; N ];
% figure(2); clf;
figure(1); clf;
% subplot(2,1,1);
% plot(G*X(3:end),'o-');
% hold on;
% subplot(2,1,2);
% plot(0,X(1),'r+');
% plot(0,X(2),'go');
% hold on;
tx=100;
res=zeros(5,tx);
v=zeros(1,tx);
p=zeros(1,tx);
for t=1:tx
    X = bees(X,t,0);

    res(1:5,t)=G*X(3:end);
    v(1,t)= X(1);
    p(1,t)=X(2);
%     figure(1);
%     subplot(3,1,1);
%     plot(G*X(3:end),'o-');
%     hold on;
%     subplot(3,1,2);
%     plot(t,X(1),'r+');
%     plot(t,X(2),'go');
%     legend('vacant', 'pollen');
%     hold on;
%      G*X(3:end)
%     pause;
end
subplot(2,1,1);
plot(res(1,1:t),'b+-');
hold on;
plot(res(2,1:t),'g-');
plot(res(3,1:t),'r-');
plot(res(4,1:t),'m-');
plot(res(5,1:t),'y-');
legend('Egg','Larva','Pupa','In-hive Bee','Forager');
subplot(2,1,2);
plot(v(1,1:t),'r+');
hold on;
plot(p(1,1:t),'go');
legend('vacant', 'pollen');
