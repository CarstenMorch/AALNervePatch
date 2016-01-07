function [R, r] = sfpSimulate(tspan, y0, P, Is, h, skip)
% Simulate the response of the nerve fiber
%   [R] = sfpSimulate(tspan, y0, P, Is) this will simulate the reaction of
%   a nerve fiber model [P] to a stimulation current [Is] in the time span
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
if nargin < 6
   skip = 1;
end
if nargin < 5
   h = 2e-6;
end

engine = ScienceFoundry.Simulation.Patch.ModelSolver;
engine.T1 = tspan(1);
engine.T2 = tspan(2);
engine.H = h;
engine.Skip = skip;
engine.Model = P.P.Create();

r = engine.Simulate(y0, Is);
R = P.Convert(r, Is);
R.tspan = tspan*1e3;
