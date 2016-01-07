function [M] = hamDefaultParameters(D)
% Create the default model parameters
%   [P] = hamDefaultParameters(D) this function creates the default
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
% NET.addAssembly('C:\libs\ScienceFoundry.Simulation.Patch.dll');
try
    M.P = ScienceFoundry.Simulation.Patch.Models.HAMPatchParameters(D);
catch
    %path_str =  'C:\Users\cdahl\Documents\2013source\patch_model\ScienceFoundry.Simulation\ScienceFoundry.Simulation\bin\Debug\ScienceFoundry.Simulation.Patch.dll';
    %path_str =  'C:\Source\SF\simpatch\ScienceFoundry.Simulation\ScienceFoundry.Simulation\bin\Release\ScienceFoundry.Simulation.Patch.dll';
    path_str = 'C:\Source\SF\simpatch\trunk\ScienceFoundry.Simulation\ScienceFoundry.Simulation\bin\Debug\ScienceFoundry.Simulation.Patch.dll';
    %path_str =  'c:\libs\ScienceFoundry.Simulation.Patch.dll';

    NET.addAssembly(path_str);
    M.P = ScienceFoundry.Simulation.Patch.Models.HAMPatchParameters(D);    
end
    
M.Convert= @hamConvert;
