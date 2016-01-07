function [E, Ec, R] = sfpErrorFunc(M, validation)
% sfpErrorFunc Calculate the error function for a model
%   [E] = sfpErrorFunc(M, validation)

% SD Time Constant
%tic
E = 0;

Psd.T1 = validation.SD.T1;
Psd.T2 = validation.SD.T2;
R.Rsd = sfpStrengthDuration(M, Psd);
Ec.Esd = abs(R.Rsd.Tsd-validation.SD.SDmean)/validation.SD.SDvar;
E = E + 0.25*Ec.Esd;

% Latent Addition
% vLA = validation.LA{1};
% Pla.Ts = vLA.Ts;
% Pla.Tisi = [-0.2 -0.1 0.1 0.2 0.4]*1e-3;
% Pla.Ic = vLA.Ic;
% R.Rla = sfpLatentAddition(M, Pla);
% R.Rla.validation = vLA;
% Ec.Ela = sfpNormalizedError(Pla.Tisi*1e3, R.Rla.THR, vLA.Tisi, vLA.Tmean, vLA.Tvar);
% 
% E = E + nanmean(Ec.Ela);

% Current Threshold Relationship
% P.Ts = validation.CT.Ts;
% P.Tc = validation.CT.Tc;
% P.Ic = [-1 -0.5 0.25 0.5];
% 
% R.Rct = sfpCurrentThreshold(M, P);
% R.Rct.validation = validation.CT;
% Ec.Ect = sfpNormalizedError(P.Ic*100, R.Rct.THR, validation.CT.I, validation.CT.Tmean, validation.CT.Tvar);
% E = E + nanmean(Ec.Ect);


% Threshold Electrotonus

%-- Depolarizing
Pte_d.Ts = validation.TE{1}.Ts;
Pte_d.Ic = validation.TE{1}.Ic;
Pte_d.Tc = validation.TE{1}.Tc;
Pte_d.Tisi = [10 20 30 50 65 75 80 95]*1e-3;
R.Rte_d = sfpThresholdElectrotonus(M, Pte_d);
R.Rte_d.validation = validation.TE{1};
Ec.Ete_d = sfpNormalizedError(Pte_d.Tisi*1e3, R.Rte_d.THR, validation.TE{1}.Tisi, validation.TE{1}.Tmean, validation.TE{1}.Tvar);
E = E + nanmean(Ec.Ete_d);

%-- Hyperpolarizing
% Pte_h.Ts = validation.TE{2}.Ts;
% Pte_h.Ic = validation.TE{2}.Ic;
% Pte_h.Tc = validation.TE{2}.Tc;
% Pte_h.Tisi = [40 99]*1e-3;
% R.Rte_h = sfpThresholdElectrotonus(M, Pte_h);
% R.Rte_h.validation = validation.TE{2};
% Ec.Ete_h = sfpNormalizedError(Pte_h.Tisi*1e3, R.Rte_h.THR, validation.TE{2}.Tisi, validation.TE{2}.Tmean, validation.TE{2}.Tvar);
% E = E + nanmean(Ec.Ete_h);

% Recovery Cycle
Tmin = min(validation.RC.Tisi);
Tmax = max(validation.RC.Tisi);
Prc.Ts = validation.RC.Ts;
Prc.Tisi = logspace(log10(Tmin), log10(Tmax), 10)*1e-3;
Prc.Tisi = Prc.Tisi(1:length(Prc.Tisi)-1);
Prc.Ic = validation.RC.Isupra;

R.Rrc = sfpRecoveryCycle(M, Prc);
R.Rrc.validation = validation.RC;
Ec.Erc = sfpNormalizedError(Prc.Tisi*1e3, R.Rrc.THR, validation.RC.Tisi, validation.RC.Tmean, validation.RC.Tvar);   
E = E + 2*nanmean(Ec.Erc);

%fprintf('Calculation Time: %.1fms\n', toc*1e3);
