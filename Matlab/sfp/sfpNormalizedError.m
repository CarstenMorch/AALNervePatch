function [e] = cpmNormalizedError(xt, yt, x, ymean, yvar)
% Calculate the normalized error
%   [e] = cpmNormalizedError(xt, yt, x, xmean, xvar) this function calculates
%   the normalized error in the model predictions in [yt] from the
%   validation data in [x], [ymean] and [yvar]. 
%
%   The validation data consists of the mean [xmean] and variance [xvar]
%   that the model prediction should approach.
%
% See also cpmOptimize 
mean_ref = interp1(x, ymean, xt);
var_ref = interp1(x, yvar, xt);

e = abs(yt - mean_ref) ./ var_ref;

if 1 == 0
figure(1);
clf;
plot(xt, yt,'b*',...
     x, ymean, 'r',...
     x, ymean - yvar,'r:',...
     x, ymean + yvar,'r:',...
     xt, mean_ref, 'k*');
end
