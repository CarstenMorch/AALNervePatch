function [I] = sfpRamp(Ts, Is)
% Generate a linearly increasing stimulus
%   [I] = sfpRamp(Ts, Is)
I = ScienceFoundry.Simulation.Patch.Ramp(Is, Ts);