function [T] = sfpThreshold(tspan, y0, M, Is)
% Estimate the activation threshold
%   [T] = sfpThreshold(tspan, y0, M, Is) this will determine the activation
%   threshold of the nerve fiber model [M] to a stimulation current [Is] 
%   where the presence of an action potential is assumed to be within the 
%   the time span [tspan] where [tspan] is a 1x2 vector of [tstart tend]. 
%   The simulation is based on an initial state vector of the model [y0].
%
%   For information about how to construct a stimulation function Is please
%   refer to cpmPulse.
%
% See also cpmCreateModel, cpmPulse
engine = ScienceFoundry.Simulation.Patch.ModelSolver;
engine.Model = M;
engine.H = 2e-6;
engine.T1 = tspan(1);
engine.T2 = tspan(2);

T = engine.EstimateThreshold(y0, Is);

if (T > 1)
   T = NaN;
end
