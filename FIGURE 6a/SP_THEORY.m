function h_out = SP_THEORY(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa)
% SP_THEORY  : Theory of Shorstest Path Protocol
% OP: Outage Probability
OP_LT = zeros(length(alpha), length(PdB));
for k = 1 : length(alpha)
for aa = 1:length(PdB)
    OP_LT(k,aa) = SPfunc(PdB(aa),IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha(k),kappa);
end
end
%
OP_LT
%
h_out = semilogy(alpha, OP_LT,'b-'); grid on;hold on;
end
%
function out = SPfunc(PdB,IdB,LL,KK,PL,RR,xB,yB,xE,yE,eta,alpha,kappa)
% PdB       : Transmit power of beacons
% IdB       : Interference Constraints
% KK        : Number of eavesdroppers
% LL        : a vectors including the number of intermediate nodes on each path
% PL        : Path-Loss
% RR        : Target Rate
% xB, yB    : co-ordinates of Beacons
% xP, yP    : co-ordinates of Primary Users
% xE, yE    : co-ordinates of Eavesdopper
% eta       : energy harvesting efficiency
% alpha     : fraction of time for energy harvesting
% Num_Trial : Number of Trials
% From dB to Watt


PP          = 10.^(PdB/10);
II          = 10.^(IdB/10);
% Define kappa
kp          = eta*alpha/(1-alpha);
% Select shortest path, Lmin is the number of hops
Lmin        = min(LL) + 1;
% Define rho
rho         = 2^(Lmin*RR/(1 - alpha)) - 1;
% OP: Outage Probability
OUT         = 1;
%
if (kappa <= 1/rho)
    for bb = 1 : Lmin
    % Parameter of data links: Lambda_D and Omega_D
    LD     = (1/Lmin)^PL;
    % Parameter of energy harvesting links: Lambda_B and Omega_B
    LB     = sqrt(((bb-1)/Lmin - xB)^2 + yB^2)^PL;
    OMB    = LB/PP/kp;
    % Parameter of eavesdopping links: Lambda_E and Omega_E
    LE     = sqrt(((bb-1)/Lmin - xE)^2 + yE^2)^PL;
    OME    = LE*rho/(1-kappa*rho);
    %
    hs     = 0;    
        gt1    = LD*2*sqrt(OMB*rho/LD/(1-kappa*rho))*besselk(1,2*sqrt(OMB*LD*rho/(1-kappa*rho)));   
   for kk = 1 : KK
        gt3    = nchoosek(KK,kk)*(-1)^kk*LD*2*sqrt(OMB*rho/(1-kappa*rho)/(LD+kk*OME*(1-kappa*rho)/rho))*besselk(1,2*sqrt(OMB/(1-kappa*rho)*(LD*rho + kk*OME*(1-kappa*rho))));
        hs     =  hs + gt3;
   end         
    hs = hs + gt1;
    OUT    = OUT*hs;
    end  
out = 1 - OUT;
else
    out =  1;
end
end





