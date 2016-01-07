function [R] = sfpAccommodationCurve(M, P)
% Determine the accommodation curve
%   [R] = sfpAccommodationCurve(M, P) determine the accommodation curve to
%   linearly increasing stimuli for the model [M]. If given the function
%   expects the parameter [P] struct to contain the following fields: Ts a
%   vector containing the stimulus intensities for determine the curve for
%   and Verbose, whether to show progress information or not.
%
%   The model will return the result in [R] this structure can be visualized 
%   with the cpmPlot function.
%
% See also cpmPlot

    if nargin < 1
       error('The function needs a model to test [ cpmAccommodationCurve(M) ]');
    elseif nargin < 2
       P = createDefaultParameters();
    end
    P = validateParameters(P);

    % Estimate the threshold of the conditioned pulse
    R.TypeID = 'ac_curve';
    R.Parameters = P;
    R.Ts = P.Ts;
    
    for n = 1:length(R.Ts)
        R.Ithr(n) = findThreshold(M, R.Ts(n));
        printProgress(n, P);
    end        
end 

function printProgress(m, P)
   Ncalc = length(P.Ts);
   Ncurrent = m;
   
   if P.Verbose
      fprintf('Progress [ %.2f complete ] \n', 100*Ncurrent/Ncalc);
   end
end

function [Ithr] = findThreshold(M, Ts)
  Istim = sfpRamp(Ts, 0);
  Ithr = sfpThreshold([0 Ts+1e-3], M.Y0, M, Istim);      
end    

function [P] = createDefaultParameters()
   P.Ts = [1 12.5 25 50 75 100 200]*1e-3;
   P.Verbose = 1;
end

function Pout = validateParameters(P)
   try P.Ts; catch %#ok<CTCH>
    error('The parameters [P] does not contains P.Ts'); 
   end
   try P.Verbose; catch %#ok<CTCH>
    P.Verbose = 0;
   end
   Pout = P;
end
