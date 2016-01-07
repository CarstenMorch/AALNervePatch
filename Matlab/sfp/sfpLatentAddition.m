function [R] = cpmLatentAddition(M, P)
% Determine the latent-addition curve
%   [R] = cpmLatentAddition(M, P) determines one latent accommodation
%   curve for the model [M]. The parameters [P] is a struct that contains;
%   [Ts] the duration of the test and conditioning pulse, [P.Tisi] a vector
%   containing the inter-stimulus-intervals for the latent addition
%   determination, and [P.Ic] the intensity of the conditioning current
%   (-1.0 -> 1.0).
%
% See also cpmPlot

    if nargin < 1
       error('The function needs a model to test [ cpmLatentAddition(M) ]');
    elseif nargin < 2
       P = createDefaultParameters();
    end
    P = validateParameters(P);

    % Estimate the threshold of the conditioned pulse
    R.TypeID = 'la_curve';
    R.Parameters = P;

    R.Itest = sfpThreshold([0 P.Ts+1e-3], ...
                           M.Y0, ...
                           M, ...
                           sfpPulse(P.Ts, 0));
    R.Ic = R.Itest * P.Ic;                    
    R.Tisi = P.Tisi;

    R.I = findThreshold(M, R.Ic, P.Ts, P.Tisi);
    
    % Estimate the latent addition curves
    for m = 1:length(P.Tisi)
       R.THR(m) = 100*(R.I(m)-R.Itest)/R.Itest;
    end    
end

function [Ithr] = findThreshold(M, Ic, Ts, Tisi)
   Ithr = zeros(length(Tisi), 1);
   Yn = M.Y0;
   Y0 = M.Y0;
   T1 = Tisi(1);
   
   for n = 1:length(Tisi)
      Istim = sfpConditionedPulse(Ts, 0, Ts, Ic, Tisi(n));

      if (T1 < Tisi(n))
         Y0 = sfpGetFinalState([T1 Tisi(n)], Yn, M, Istim);
         
         Yn = Y0;
         T1 = Tisi(n);
      end
      
      Ithr(n) = sfpThreshold([Tisi(n) Tisi(n)+Ts+1e-3], Y0, M, Istim);      
   end
end

function [P] = createDefaultParameters()
   P.Ts = 60e-6;
   P.Tisi = (-0.2:0.05:0.5)*1e-3;
   P.Ic = 0.9;
   P.Verbose = 0;
end

function Pout = validateParameters(P)
   try P.Ts; catch %#ok<CTCH>
    error('The parameters [P] does not contains P.Ts'); 
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
   Pout = P;
end
