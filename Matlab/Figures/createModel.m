function [P] = createModel(D)
% hamCreateModel Create a model (version 1)
if nargin < 1
    D = 14;
end

P = hamDefaultParameters(D); % input: fiber diameter [µm]

P = SetDefaultParameters (P); % Default parameters


