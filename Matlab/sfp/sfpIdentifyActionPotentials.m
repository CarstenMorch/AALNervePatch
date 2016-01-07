function [AP] = sfpIdentifyActionPotentials(R, Tstim, opt)
% sfpIdentifyActionPotential Test if there is an action potential
%    [AP] = sfpIdentifyActionPotentials(Vm, Tstim, Toffset, Tsample) this function tests
%    if there is an action potential genrated by a stimulation with onset 
%    time [Tstim] given the membrane potential in [Vm]. 
%
%    It is said that there is an action potential if the membrane 
%    depolarization of more than -40mV at a delay of [Toffset] after the
%    onset of the stimulation.
%  
%    The times at which an action potential was present is returned in [AP]
%
%    See also, sfpSimulate
AP = [];
% [Vmax, Imax] = max(R.Vn);
Ioffset = opt.APdelay/opt.SampFreq;
% APtime = [];
%Ioffset = round(Toffset/Tsample);

for n = 1:length(Tstim)
    idx = round((Tstim(n)/opt.SampFreq):((Tstim(n)+opt.Tperiod)/opt.SampFreq)-1)+1; 
    retval = isAP(R.Vn(idx), R.m_n(idx), Ioffset);
    if retval
        AP = [AP Tstim(n)]; %#ok<AGROW>
    end   
end

function [retValue] = isAP(Vm, n_m, Ioffset)
retValue = 0;
[Vmax, Imax] = max(Vm);
i = round(Imax + Ioffset);
if (Vmax > -25e-3)
   if i < length(Vm)
      if (Vm(i) > -60e-3) && n_m(i) > 0.9          
          retValue = 1;
      end
 
   end
end
% [Vmax, Imax] = max(R.Vn);
% sampFreq = round(1/(R.t(2)-R.t(1)));
% Idelay = APdelay*sampFreq;
% APtime = [];
% 
% if (Vmax > -20e-3)
%    if (Imax+Idelay) < length(R.Vn)
%       if (R.Vn(Imax + Idelay) > -60e-3 && R.m_n(Imax + Idelay) > 0.9);
%           APtime = R.t(Imax); 
%       end
%    end
% end