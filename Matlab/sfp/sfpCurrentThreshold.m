function [R] = sfpCurrentThreshold(M, P)
% Determine the current threshold relationship
%   [R] = sfpCurrentThreshold(M, P) determines the current threshold
%   relationship for the model [M].
%
%   The parameters [P] is a struct that contains [P.Ts] the duration of the
%   test pulse, [P.Tc] the duration of the conditioning current, [P.Ic] a
%   vector containing the intensities (in fractions -1.0 -> 1.0) of the
%   conditioning current that should be tested when determining the current
%   threshold relationship.
%
% See also cpmPlot

   if nargin < 1
      error('The function needs a model to test [ sfpCurrentThreshold(M) ]');
   elseif nargin < 2
      P = createDefaultParameters();
   end
   P = validateParameters(P);

   % Estimate the threshold of the conditioned pulse
   R.TypeID = 'ct_curve';
   R.Parameters = P;

   R.Itest = sfpThreshold([0 P.Ts+1e-3], ...
                          M.Y0, ...
                          M, ...
                          sfpPulse(P.Ts, 0));
   R.Ic = R.Itest * P.Ic;                    

   % Estimate the current-threshold relationship
   for n = 1:length(R.Ic)
       R.I(n) = findThreshold(M, R.Ic(n), P);
       R.THR(n) = 100*(R.Itest - R.I(n))/R.Itest;

      printProgress(n, P);
   end

end

function printProgress(n, P)
   Ncalc = length(P.Ic);
   Ncurrent = n;
   
   if P.Verbose
      fprintf('Progress [ %.2f complete ] \n', 100*Ncurrent/Ncalc);
   end
end

function [Ithr] = findThreshold(M, Ic, P)
   Istim = sfpConditionedPulse(P.Ts, 0, P.Tc, Ic, P.Tc-P.Ts);
   Y0 = sfpGetFinalState([0 P.Tc-P.Ts], M.Y0, M, sfpPulse(P.Tc, Ic), 10e-6);
   Ithr = sfpThreshold([P.Tc-P.Ts P.Tc+1e-3], Y0, M, Istim);
end    

function [P] = createDefaultParameters()
   P.Ts = 1e-3;
   P.Tc = 200e-3;
   P.Ic = -1:0.2:0.6;
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
