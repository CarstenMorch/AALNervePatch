function [ StimInt ] = sfpThresholdRamp( Ts, APdelay, M, P )
StimInt = 0;
dStimInt = 1e-9;
APtime = [];
while dStimInt>1e-12
while isempty(APtime)
    StimInt = StimInt+dStimInt;
    Istim = sfpRamp(Ts, StimInt);
    R = sfpSimulate([-1e-4 Ts+5e-4], M.Y0, P, Istim);
    [APtime] = sfpIdentifyActionPotential(R, APdelay);
end
dStimInt = dStimInt/2;

while ~isempty(APtime)
    StimInt = StimInt-dStimInt;
    Istim = sfpRamp(Ts, StimInt);
    R = sfpSimulate([-1e-4 Ts+5e-4], M.Y0, P, Istim);
    [APtime] = sfpIdentifyActionPotential(R, APdelay);
end
    dStimInt = dStimInt/2;
end
end

