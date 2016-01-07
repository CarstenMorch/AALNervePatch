function [R] = sfpStrengthDuration(M, P)
% Determine the strength-duration time constant
%   [R] = sfpStrengthDuration(M, P) determines the strength
%   duration time constant for the model [M] given the parameters [P].
%
%   The parameters [P] is a struct that contains the members [P.T1] and
%   [P.T2] that is the two pulse durations for which the threshold is
%   determined in order to estimate the strength duration time constant
%   with Weiss's law.
%
% See also cpmCreateModel

if nargin < 1
   error('The function needs a model to test [ cpmStrengthDuration(M) ]');
elseif nargin < 2
   P = createDefaultParameters();
end
validateParameters(P);

I1 = sfpThreshold([0 P.T1+1e-3], M.Y0, M, sfpPulse(P.T1, 0));
I2 = sfpThreshold([0 P.T1+1e-3], M.Y0, M, sfpPulse(P.T2, 0));

R.TypeID = 'Tsd';
R.Parameters = P;
R.Tsd = (I2-I1)/(I1/P.T2 - I2/P.T1);
R.Irheo = I1/(1 + R.Tsd/P.T1);
R.I = [I1 I2];
end

function [P] = createDefaultParameters()
   P.T1 = 0.2e-3;
   P.T2 = 1e-3;
end

function validateParameters(P)
   try P.T1; catch %#ok<CTCH>
      error('The parameters [P] does not contains P.T1'); 
   end
   try P.T2; catch %#ok<CTCH>
      error('The parameters [P] does not contains P.T2'); 
   end
end

