function [I] = sfpExpPulse(Ts, Is, Tau)
% Generate a linearly increasing stimulus
%   [I] = sfpRamp(Ts, Is)
I = ScienceFoundry.Simulation.Patch.ExpPulse;
I.Is = Is;
I.Ts = Ts;
I.Tau = Tau;