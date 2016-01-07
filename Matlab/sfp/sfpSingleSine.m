function [I] = sfpSingleSine(Ts, Is)
% Generate a linearly increasing stimulus
%   [I] = sfpRamp(Ts, Is)
I = ScienceFoundry.Simulation.Patch.SingleSine;
I.Is = Is;
I.Ts = Ts;
I.N = 1;