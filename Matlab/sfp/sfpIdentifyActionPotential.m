function [APtime] = sfpIdentifyActionPotential(R, APdelay)
% sfpIdentifyActionPotential Test if there is an action potential
%    [AP] = sfpIdentifyActionPotentials(Vm, Tstim, Toffset, Tsample) this function tests
%    if there is an action potential genrated by a stimulation with onset 
%    time [Tstim] given the membrane potential in [Vm]. 
%
%    It is said that there is an action potential if the membrane 
%    depolarization of more than -20mV at a delay of [Toffset] after the
%    onset of the stimulation.
%  
%    The times at which an action potential was present is returned in [AP]
%
%    See also, sfpSimulate
[Vmax, Imax] = max(R.Vn);
sampFreq = round(1/(R.t(2)-R.t(1)));
Idelay = APdelay*sampFreq;
APtime = [];

if (Vmax > -20e-3)
   if (Imax+Idelay) < length(R.Vn)
      if (R.Vn(Imax + Idelay) > -60e-3 && R.m_n(Imax + Idelay) > 0.9);
          APtime = R.t(Imax); 
      end
   end
end