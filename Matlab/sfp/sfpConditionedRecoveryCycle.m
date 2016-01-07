function [R] = sfpConditionedRecoveryCycle(M, P)
% Determine the recovery cycle
%   [R] = cpmRecoveryCycle(M, P) determines the recovery cycle for the
%   model [M]. The parameters [P] is a struct that contains the following
%   fields; [Ts] the duration of the test and conditioning pulse, [P.Tisi] 
%   a vector containing the inter-stimulus-intervals, [P.Ic] the intensity
%   of the conditioning current (1.0 -> inf).
%
% See also cpmPlot

   if nargin < 1
      error('The function needs a model to test [ cpmAccommodationCurve(M) ]');
   elseif nargin < 2
      P = createDefaultParameters();
   end
   P = validateParameters(P);

    R.TypeID = 'rc_curve';
    R.Parameters = P;

    R.Itest = sfpThreshold([0 P.Ts+1e-3], ...
                           M.Y0, ...
                           M, ...
                           sfpPulse(P.Ts, 0));
    R.Ic = R.Itest * P.Ic;                    
    R.Tisi = P.Tisi;
    R.Tdelay = (P.N-1)*(1/P.Fstim);
    R.N = P.N;
    R.Fstim = P.Fstim;
    
    Y0 = getStates(M, R.Ic, P.Ts, R.Tisi+R.Tdelay, R.N, 1/R.Fstim);
    
    % Estimate the recovery curve
    for m = 1:length(R.Tisi)
       R.I(m) = findThreshold(M, Y0{m}, P.Ts);
       R.THR(m) = 100*(R.I(m)-R.Itest)/R.Itest;
    end        
end    

function [Y0] = getStates(M, Ic, Ts, Tisi, N, Tperiod)
   T1 = 0;
   Yn = M.Y0;
   
   for n = 1:length(Tisi)
      Y0{n} = sfpGetFinalState([T1 Tisi(n)], Yn, M, sfpPulseTrain(Ts, Ic, N, Tperiod)); %#ok<AGROW>
      
      T1 = Tisi(n);
      Yn = Y0{n};
   end
end

function [Ithr] = findThreshold(M, Y0, Ts)
  Ithr = sfpThreshold([0 Ts+1e-3], Y0, M, sfpPulse(Ts, 0));      
end    

% function [Ithr] = findThreshold(M, Ic, Ts, Tisi)
%   Rsim = sfpGetFinalState([0 Tisi], M.Y0, M, sfpPulse(Ts, Ic));  
%   Ithr = sfpThreshold([0 Ts+1e-3], Rsim, M, sfpPulse(Ts, 0));      
% end    

function [P] = createDefaultParameters()
   P.Ts = 1e-3;
   P.Tisi = [3 4 6 8 10 14 16 18 20 22 24 28 34 40 50 60 70 80 90 100]*1e-3;
   P.Ic = 5;
   P.N = 3;
   P.Fstim = 250;
   P.Verbose = 0;
end

function Pout = validateParameters(P)
   try P.Ts; catch %#ok<CTCH>
    error('The parameters [P] does not contain P.Ts'); 
   end
   try P.Tisi; catch %#ok<CTCH>
    error('The parameters [P] does not contain P.Tisi'); 
   end
   try P.Ic; catch %#ok<CTCH>
    error('The parameters [P] does not contain P.Ic'); 
   end
   try P.N; catch %#ok<CTCH>
    error('The parameters [P] does not contain P.N');
   end
   try P.Fstim; catch %#ok<CTCH>
    error('The parameters [P] does not contain P.Fstim');
   end
   try P.Verbose; catch %#ok<CTCH>
    P.Verbose = 0;
   end
   Pout = P;
end
