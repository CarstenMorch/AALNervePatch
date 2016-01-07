function [AP] = sfpIsActivated(tspan, y0, M, Is)
% sfpIsActivated Check if a model is activated by a stimulus
%   [AP] = sfpIsActivated(tspan, y0, M, Is)
engine = ScienceFoundry.Simulation.Patch.ModelSolver;
engine.Model = M;
engine.H = 2e-6;
engine.T1 = tspan(1);
engine.T2 = tspan(2);

AP = engine.IsActivated(y0, Is);
