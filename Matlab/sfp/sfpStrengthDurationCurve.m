function [R] = sfpStrengthDurationCurve(M, P)
% Determine the strength-duration time constant
%   [R] = sfpStrengthDurationCurve(M, P) determines the strength
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

R.TypeID = 'sd_curve';
R.Parameters = P;
R.Ts = P.Ts;
R.I = zeros(size(P.Ts));
R.Irel = zeros(size(P.Ts));
R.Rsd = sfpStrengthDuration(M, P);

for n = 1:length(P.Ts)
   R.I(n) = sfpThreshold([0 P.Ts(n)+1e-3], M.Y0, M, sfpPulse(P.Ts(n), 0));
   R.Irel(n) = R.I(n)/R.Rsd.Irheo;
end

end

function [P] = createDefaultParameters()
   P.Ts = (0.05:0.05:1)*1e-3;
   P.T1 = 0.2e-3;
   P.T2 = 1e-3; 
end

function validateParameters(P)
   try P.Ts; catch %#ok<CTCH>
      error('The parameters [P] does not contains P.Ts'); 
   end
   try P.T1; catch %#ok<CTCH>
      error('The parameters [P] does not contains P.T1'); 
   end
   try P.T2; catch %#ok<CTCH>
      error('The parameters [P] does not contains P.T2'); 
   end   
end

