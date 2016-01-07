function [R,APtimes,Tstim, APindex] = tetanic (Isupra,Fstim,Npulses,Y0)
% This script (future function) should simulate a single tetanic sweep.
% Initailly aimed at investigating the model, but also te investigate the
% relation between external potassium concentrations.


%% ==== Do calcultations ====
P = createModel;
M = P.P.Create();

Ts = 100e-6;

preSamp = 10e-3;
SampFreq = 2e-6;
APdelay = 50e-6;
Tperiod = 1/Fstim;
SimDuration = Tperiod*Npulses+2*preSamp;

%dumping info to optstruct
opt.Fstim = Fstim;
opt.SampFreq = SampFreq;
opt.Tperiod = Tperiod;
opt.APdelay = APdelay;


% determining activation threshold
Itest = sfpThreshold([0 Ts+APdelay], ...
    M.Y0, ...
    M, ...
    sfpPulse(Ts, 0));

if nargin < 4
    Y0 = M.Y0;
end


%generating stimulation sequence
Istim = sfpPulseTrain(Ts, Isupra*Itest,Npulses,Tperiod);

%simulating nerve patch response
R = sfpSimulate([-preSamp SimDuration], Y0, P, Istim); %#ok<SAGROW>

%detecting action potentials (AP)
Tstim = ((0:Npulses-1) * Tperiod);
[APtimes] = sfpIdentifyActionPotentials(R,Tstim,opt);
APindex = round((APtimes) / SampFreq);
APtimes = APtimes - preSamp;



