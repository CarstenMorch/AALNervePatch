function [I] = sfpConditionedPulse(Ts, Is, Tc, Ic, Tisi)
% Generate a conditioned rectangular pulse
%   [I] = sfpConditionedPulse(Ts, Is, Tc, Ic, Tisi)
I = ScienceFoundry.Simulation.Patch.ConditionedPulse(Is, Ts, Ic, Tc, Tisi);