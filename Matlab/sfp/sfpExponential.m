function [I] = sfpExponential(Ts, Is)
% Generate a linearly increasing stimulus
%   [I] = sfpRamp(Ts, Is)
I = ScienceFoundry.Simulation.Patch.Exponential(Is, Ts);