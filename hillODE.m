function dy = hillODE(y,t)
% y= [ R, RBar, F, FBar]

   global qds fa fr fs mS mQ mT ss iQ rs k j m Q initial omega tra; 
  

   qds = 1;    % enable quality dependent search time.
  
   ssc = Q/iQ;  % search time scale--the likelihood of a receiver accepting a nectar delivery is affected by nectar quality and experience and genotype of both forager and receiver
   % the foragers have to search longer to find a receiver willing to
   % accept low quality nectar. Q-true nectar quality. iQ-the standard for
   % a high quality nectar 
  
    tra = 0;    % trembling abandonment
    % calculate search time (with default to prevent /0 errors)

    S = ss * (y(2)+y(4)) / (ssc * y(2)); % the expected search time 
    
    d1= S^k + mS^k;
    d2= Q^j + mQ^j;
    % hill function that scale the recruitment and resting rates by mapping
    % nectar quality and search time. j,k as the coeefficients that control
    % the sensityivity of the functions to changes in Q, S
    
    
    % R, Rb F1 F1b F2 F2b ...
    % R--total number of receiver bees available,
    % Rb--population of receivers ready to receive
    % F-the total active forager population,
    % Fb--the population of foragers seeking to unload near the hive entrance 
    
    dy = zeros(length(initial),1);

   
%     if (min(S) > mT && omega ~= 0)        
    dy(1) = omega * (min(S)^m)/(min(S)^m+mT^m); % the receiver population change by the tremble dancing. When the serach time is greater than mt, the receiver population increases as search time increases  
%     else
%         dy(1) = 0;
%     end
%     if tra
%         dy(1) = dy(1) + omega/100 * (1 - y(1)/initial(1));
%     end
    
    dy(2) = ( y(1) - y(2) ) / rs - y(4)/ S ; % the chcange of available receiver bees ready to load = rate of returning from storing- rate of receiving nectar
    
    dy(3) = (fr * y(3) * mS^k / d1* Q^j / d2) - (fs * y(3) * S^k / d1 * mQ^j/ d2);% Forager population change=rate of recruitment-resting rate 
    if y(3) > 1000
	dy(3) = min([0,dy(3)]);
    end
    
    dy(4) = (y(3) - y(4))/fa - y(4)/ S; % the change in the forager population ready to unload the nectar within the hive=rate of arriving at the hive with nectar - rate of finding a receive and commencing unloading  
    
    dy(5) = y(4)/S*70./500.;
end

