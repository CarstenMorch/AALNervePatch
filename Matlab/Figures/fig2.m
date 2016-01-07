function fig2(figno)
% FIGURE Validation plots
% This figure contains the main validation of the model, which consists of
% curves for strength-duration curves, threshold electrotonus, and recovery
% curve. These curves are overlaid on experimental data from sensory nerve
% fibers.
if nargin < 1
   figno = 1;
end

load sensory_validation
P = createModel;
M = P.P.Create();

white = [1 1 1];
ecolor = white*0.85;

figure(figno);
clf;
set(gcf,'Color', white);

subplot(3,1,1);

% Plot experimental range
Rsd = sfpStrengthDurationCurve(M);

xsd = Rsd.Ts;
ysd_min = weiss(xsd, 150e-6, 1);
ysd_max = weiss(xsd, 50e-6, 1);
ysd_mean = abs(ysd_min + ysd_max)/2;
ysd_var = abs(ysd_min - ysd_max)/2;
experimental_area(1e3*xsd,ysd_mean,ysd_var, ecolor);

hold on
sfpPlot(Rsd);
title('A');

% Threshold Electrotonus
subplot(3,1,2);

% Plot Experimental range
xte = [-20 0 validation.TE{1}.Tisi]; 
yte_mean = [0 0 validation.TE{1}.Tmean];
yte_var = [0 0 validation.TE{1}.Tvar];
experimental_area(xte,yte_mean,yte_var, ecolor);

Pte.Ts = validation.TE{1}.Ts;
Pte.Ic = validation.TE{1}.Ic;
Pte.Tc = validation.TE{1}.Tc;
Pte.Tisi = sort([min(validation.TE{1}.Tisi):6:max(validation.TE{1}.Tisi) 99 100])*1e-3;
Rte = sfpThresholdElectrotonus(M, Pte);
Rte.Tisi = [-20e-3 0 Rte.Tisi];
Rte.THR = [0 0 Rte.THR];
hold on
sfpPlot(Rte);
A = axis;
A(1) = -20;
A(2) = 120;
axis(A);
title('B');

% Recovery Cycle
subplot(3,1,3);

%Plot experimental range
xrc = [validation.RC.Tisi]; 
yrc_mean = [validation.RC.Tmean];
yrc_var = [validation.RC.Tvar];
experimental_area(xrc,yrc_mean,yrc_var, ecolor);
hold on

Tmin = min(validation.RC.Tisi);
Tmax = max(validation.RC.Tisi);
Prc.Ts = validation.RC.Ts;
Prc.Tisi = logspace(log10(Tmin), log10(Tmax), 40)*1e-3;
Prc.Ic = validation.RC.Isupra;

Rrc = sfpRecoveryCycle(M, Prc);
sfpPlot(Rrc);
title('C');
