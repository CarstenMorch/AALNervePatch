function P = SetDefaultParameters (P)

% Default parameters
P.P.rho_i = 0.33; % Ohm*m
P.P.Vr     = -87e-3; % V
P.P.Vi     = -86e-3; % V
P.P.Wpa    = 4e-9;   %m
P.P.Pil    = 0.27;   %????
P.P.gNa_n  = 13000;
P.P.pNap_n = 0.0405;%0.015; % percentage of persistent Na channels
P.P.gKf_n  = 0.1*1671; %1671;
P.P.gKs_n  = 0.75*0.8*5214;
P.P.gKi_n  = 1.4*5214;
P.P.gLk_n  = 20;

Voffset_i = -10; %???
Scaling_i = 1.1;
Slope_i = 0.6;
P.P.nGsl = 5; % SL incisure conductance
Scaling_u = 0.25;

Voffset_h = 17; %15; %????
Scaling_h = 1;
Slope_h =0.8;

% 
P.P.gKs_i  = 0.0152; %0.0152;
P.P.gKi_i  = 0.05;%6.5; %0.0152;
P.P.gH_i   = 0; %?
P.P.gLk_i  = 0.1;
P.P.cm = 0.005;
P.P.ci = 0.01;
P.P.cn = 0.01; %0.01;
P.P.rho_i = 0.33;


P.P.ClampKo = 0;

% Modifying channel kinetics

% Fast Sodium channels
P.P.Am(1) = P.P.Am(1);
P.P.Am(2) = -20.4;
P.P.Am(3) = 10.3;
P.P.Bm(1) = P.P.Bm(1);
P.P.Bm(2) = -25.7;
P.P.Bm(3) = 9.16;

P.P.Au(1) = Scaling_u*P.P.Au(1);
P.P.Bu(1) = Scaling_u*P.P.Bu(1);

P.P.Ah(1) = Scaling_h*P.P.Ah(1);
P.P.Ah(2) = -114+Voffset_h;
P.P.Ah(3) = 11*Slope_h;
P.P.Bh(1) = Scaling_h*P.P.Bh(1);
P.P.Bh(2) = -31.8+Voffset_h;
P.P.Bh(3) = 13.4*Slope_h;

Scaling_n = 1;
P.P.An(1) = Scaling_n * P.P.An(1);
P.P.Bn(1) = Scaling_n * P.P.Bn(1);

Voffset_p = 10;
Scaling_p = 1;
Slope_p =0.8;
P.P.Ap(1) = Scaling_p*0.2*P.P.Ap(1);
P.P.Ap(2) = -27+Voffset_p;
P.P.Ap(3) = Slope_p*9.3;
P.P.Bp(1) = Scaling_p*0.0045*P.P.Bp(1);
P.P.Bp(2) = -34+Voffset_p;
P.P.Bp(3) = Slope_p*10;

% Gating_s = fminsearch(@(x) errf_s(x), [double(P.P.As) double(P.P.Bs)]);
% P.P.As(1) = Gating_s(1); 
% P.P.As(2) = Gating_s(2); 
% P.P.As(3) = Gating_s(3); 
% P.P.Bs(1) = Gating_s(4);  
% P.P.Bs(2) = Gating_s(5); 
% P.P.Bs(3) = Gating_s(6); 

Voffset_s = -20;
Scaling_s = 1;
P.P.As(1) = Scaling_s*6*P.P.As(1); 
P.P.As(2) = -12.5+Voffset_s;
P.P.As(3) = 0.3*11.6; %23.6;
P.P.Bs(1) = Scaling_s*0.4*P.P.Bs(1); 
P.P.Bs(2) = -80.1+Voffset_s;
P.P.Bs(3) = 22.8;


P.P.Ai(1) = Scaling_i*0.00122;
P.P.Ai(2) = -12.5+Voffset_i;
P.P.Ai(3) = Slope_i*23.6;
P.P.Bi(1) = Scaling_i*0.000739; 
P.P.Bi(2) = -80.1+Voffset_i;
P.P.Bi(3) = Slope_i*21.8;