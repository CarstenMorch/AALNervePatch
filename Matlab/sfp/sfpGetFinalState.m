function [R] = sfpGetFinalState(tspan, y0, M, Is, h)
% Simulate the response of the nerve fiber
%   [R] = sfpSimulate(tspan, y0, M, Is) this will simulate the reaction of
%   a nerve fiber model [M] to a stimulation current [Is] in the time span
%   [tspan] where [tspan] is a 1x2 vector of [tstart tend]. The simulation
%   is based on an initial state vector of the model [y0].
%
%   It returns the results of the simulation in a structure [R] that can be
%   visually inspected with the cpmPlot function.
%
%   For information about how to construct a stimulation function Is please
%   refer to cpmPulse.
%
% See also cpmPlot, cpmCreateModel, cpmPulse
if nargin < 5
   h = 2e-6;
end

engine = ScienceFoundry.Simulation.Patch.ModelSolver;
engine.T1 = tspan(1);
engine.T2 = tspan(2);
engine.H = h;
engine.Model = M;

R = engine.GetFinalState(y0, Is);
