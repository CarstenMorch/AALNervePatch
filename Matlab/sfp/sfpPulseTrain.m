function [I] = sfpPulseTrain(Ts, Is, N, Tperiod)
% Generate a rectangular stimulation pulse
%   [I] = sfpPulseTrain(Ts, Is, N, Tperiod) 
I = ScienceFoundry.Simulation.Patch.PulseTrain(Is, Ts, N, Tperiod);