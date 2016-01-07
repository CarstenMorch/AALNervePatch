function [M] = haaDefaultParameters(D)
% Create the default model parameters
%   [P] = haaDefaultParameters(D) this function creates the default
%   parameter set for the spaced clamped patch model as a function of nerve
%   fiber diameter.
%
%   A model can be constructed by passing [P] to the cpmCreateModel
%   function. If one whish to optimize the model in order to fit to a set
%   of experimental data then this function can be used by a starting
%   point by using it to create a full parameter set and then modifying the
%   parameters that are being optimized prior to passing them to the
%   cpmCreateModel function.
%
NET.addAssembly('C:\libs\ScienceFoundry.Simulation.Patch.dll');
M.P = ScienceFoundry.Simulation.Patch.Models.HAAPatchParameters(D);
M.Convert= @hamConvert;
