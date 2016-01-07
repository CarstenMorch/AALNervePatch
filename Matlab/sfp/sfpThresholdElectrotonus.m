function [R] = sfpThresholdElectrotonus(M, P)
% Determine threshold electrotonus
%   [R] = sfpThresholdElectrotonus(M, P) determines threshold electrotonus
%   for the model [M]. The parameters [P] is a struct that contains;
%   [P.Ts] the duration of the test and conditioning pulse, [P.Tisi] a vector
%   containing the inter-stimulus-intervals for the latent addition
%   determination, [P.Ic] the intensity of the conditioning current
%   (-1.0 -> 1.0), and [P.Tc] the duration of the conditiong current.
%
% See also cpmPlot

if nargin < 1
   error('The function needs a model to test [ cpmThresholdElectrotonus(M) ]');
elseif nargin < 2
   P = createDefaultParameters();
end
P = validateParameters(P);

% Estimate the threshold of the conditioned pulse
R.TypeID = 'te_curve';
R.Parameters = P;

R.Itest = sfpThreshold([0 P.Ts+1e-3], ...
                       M.Y0, ...
                       M, ...
                       sfpPulse(P.Ts, 0));
R.Ic = R.Itest * P.Ic;                    
R.Tisi = P.Tisi;

if (checkConditioning(M, R.Ic, P.Tc, max(P.Tisi) + P.Ts + 1e-3))
   R.I = findThreshold(M, R.Ic, P.Ts, P.Tc, P.Tisi);
else
   R.I = zeros(1, length(P.Tisi));
end

   % Estimate the threshold electrotonus
for m = 1:length(P.Tisi)
   R.THR(m) = 100*(R.Itest-R.I(m))/R.Itest;
end    

end

function [OK] = checkConditioning(M, Ic, Tc, Tmax)
   Icond = sfpPulse(Tc, Ic);
   OK = ~sfpIsActivated([0 Tmax], M.Y0, M, Icond);
end

function [Ithr] = findThreshold(M, Ic, Ts, Tc, Tisi)
   Ithr = zeros(length(Tisi), 1);
   Yn = M.Y0;
   Y0 = M.Y0;
   T1 = 0;
   
   for n = 1:length(Tisi)
      if (T1 < Tisi(n))
         Y0 = sfpGetFinalState([T1 Tisi(n)], Yn, M, sfpPulse(Tc, Ic), 10e-6);
         
         T1 = Tisi(n);
         Yn = Y0;
      end
      
      Istim = sfpConditionedPulse(Ts, 0, Tc, Ic, Tisi(n));
      %Y0 = sfpGetFinalState([0 Tisi(n)], M.Y0, M, sfpPulse(Tc, Ic), 10e-6);   
      Ithr(n) = sfpThreshold([Tisi(n) Tisi(n)+Ts+1e-3], Y0, M, Istim);      
   end
end

function [P] = createDefaultParameters()
   P.Ts = 1e-3;
   P.Tc = 100e-3;
   P.Tisi = [0 5 10 15 20 25 30 35 40 45 50 60 70 80 99 100 110 120 130 140 150]*1e-3;
   P.Ic = 0.4;
   P.Verbose = 0;
end

function Pout = validateParameters(P)
   try P.Ts; catch %#ok<CTCH>
    error('The parameters [P] does not contains P.Ts'); 
   end
   try P.Tc; catch %#ok<CTCH>
    error('The parameters [P] does not contains P.Tc'); 
   end
   try P.Tisi; catch %#ok<CTCH>
    error('The parameters [P] does not contains P.Tisi'); 
   end
   try P.Ic; catch %#ok<CTCH>
    error('The parameters [P] does not contains P.Ic'); 
   end
   try P.Verbose; catch %#ok<CTCH>
    P.Verbose = 0;
   end
   if (sum(sort(P.Tisi) == P.Tisi) ~= length(P.Tisi))
      error('P.Tisi is not sorted')
   end
   if (P.Tisi(1) ~= min(P.Tisi))
      error('P.Tisi is not in ascending order');
   end
   if (min(P.Tisi) < 0)
      error('The algorithm cannot handle negative Tisi');
   end
   
   Pout = P;
end