 function hy = honeycollection(initial) 
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
       %RI=res(5,t);
       

trange = [0:60:3600*8];
       
% H = 2000;
% F = 3000;
% initial = [H,H,1,0,0,F]; 

[y,t] = lsode(@nectarODE,initial',trange);

% figure(1);
% clf;
% plot(t,y(:,1),'r-');
% hold on;
% plot(t,y(:,2),'b-');
% plot(t,y(:,3),'g-');
% plot(t,y(:,4),'k-');
% plot(t,y(:,5),'yo');
% plot(t,y(:,6),'go');
% 
% legend('Total receiver bees','Receiver bees ready to receive','Total forager bees','Forager bees ready to unload','honey collection', 'Totatl Forager Number emerged ')
% % Create ylabel
% 
% xlabel({'time-seconds'},'FontSize',12,'Color',[0.07843 0.1686 0.549]);
% 
% % ylabel({'Number of bees'},'FontSize',12,'Color',[0.07843 0.1686 0.549]);
% 
% % Create title
% 
% title({'Nectar Foraging'},'FontSize',16);

hy=y(end,5); 

    end 



