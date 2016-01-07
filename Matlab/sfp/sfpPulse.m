function [I] = sfpPulse(Ts, Is)
% Generate a rectangular stimulation pulse
%   [I] = sfpPulse(Ts, Is) a rectangular stimulaion pulse of intensity
%   [Is] and duration [Ts]. 
%
I = ScienceFoundry.Simulation.Patch.Pulse(Is, Ts);