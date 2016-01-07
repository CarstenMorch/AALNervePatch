function [R] = sfpElectrotonus(MP, P)
% Determine electrotonus
%   [R] = sfpElectrotonus(M, P) determines threshold electrotonus
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
   M = MP.P.Create();
   
   Itest = sfpThreshold([0 P.Ts+1e-3], ...
                          M.Y0, ...
                          M, ...
                          sfpPulse(P.Ts, 0));
   Ic = Itest * P.Ic;                    

   R = sfpSimulate([-20e-3 P.Tc+50e-3], M.Y0, MP, sfpPulse(P.Tc, Ic), 10e-6, 20);
end

function [P] = createDefaultParameters()
   P.Ts = 1e-3;
   P.Tc = 100e-3;
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
   try P.Ic; catch %#ok<CTCH>
    error('The parameters [P] does not contains P.Ic'); 
   end
   try P.Verbose; catch %#ok<CTCH>
    P.Verbose = 0;
   end
   
   Pout = P;
end
