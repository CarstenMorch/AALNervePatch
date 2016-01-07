function [R] = sfpGetStimulus(R, Istim)
% sfpGetsStimulus gets the output from a stimulus and places it in the
% result struct, R


R.I = zeros(1, length(R.t));

for n = 1:length(R.t)
    R.I(n) = Istim.GetValue(R.t(n));
end

