function [R] = sfpAnalyse(P, validation)
   % sfpAnalyse Analyse the characteristics of a model
   %   sfpAnalyse(P, validation, opt)
   if nargin < 2
      load motor_validation
   end
   
   
   M = P.P.Create();
   hamDisplay(M);
   allplots = 1;
   
   % Action Potential Shape
   tic
   R.Rap = displayActionPotential(P);
   fprintf('Action Potential: %.1fms\n',toc*1e3);

   if allplots
   % SD-Time constant
   Psd.T1 = validation.SD.T1;
   Psd.T2 = validation.SD.T2;
   tic
   R.Rsd = sfpStrengthDuration(M, Psd);
   fprintf('Strength-Duration: %.1fms\n',toc*1e3);
   R.Rsd.sdError = 100*(R.Rsd.Tsd-validation.SD.SDmean)/validation.SD.SDmean;
   fprintf('SD Time Constant: [Actional: %.1fus, Expected: %.1fus, Error: %.2f]\n', R.Rsd.Tsd*1e6, validation.SD.SDmean*1e6, R.Rsd.sdError);
   
   figure(5);
   clf;
   
   % Recovery Curve
   subplot(2,2,4);

   tic;
   Tmin = min(validation.RC.Tisi);
   Tmax = max(validation.RC.Tisi);
   Prc.Ts = validation.RC.Ts;
   Prc.Tisi = logspace(log10(Tmin), log10(Tmax), 40)*1e-3;
   Prc.Ic = validation.RC.Isupra;
   
   R.Rrc = sfpRecoveryCycle(M, Prc);
   R.Rrc.validation = validation.RC;
   sfpPlot(R.Rrc);
   fprintf('Recovery Curve: %.1fms\n',toc*1e3);  
   
   % Latent Addition
   subplot(2,2,1);
   
   tic
   for n = 1:1;%length(validation.LA)
      Pla.Ts = validation.LA{1}.Ts;
      Pla.Tisi = (-0.2:0.05:0.5)*1e-3;
      Pla.Ic = validation.LA{n}.Ic;
      R.Rla{n} = sfpLatentAddition(M, Pla);
      R.Rla{n}.validation = validation.LA{n};
      hold on
      sfpPlot(R.Rla{n});
   end   
   grid
   fprintf('Latent Addition: %.1fms\n',toc*1e3);
      
   % Current Threshold Relationship
   P.Ts = validation.CT.Ts;
   P.Tc = validation.CT.Tc;
   P.Ic = validation.CT.I/100;
   
   tic
   R.Rct = sfpCurrentThreshold(M, P);
   fprintf('Current Threshold: %.1fms\n',toc*1e3);
   R.Rct.validation = validation.CT;

   subplot(2,2,2);
   sfpPlot(R.Rct);
   
   % Threshold Electrotonus
   subplot(2,2,3);
   
   tic
   for n = 1:1 %length(validation.TE)
      Pte.Ts = validation.TE{n}.Ts;
      Pte.Ic = validation.TE{n}.Ic;
      Pte.Tc = validation.TE{n}.Tc;
      Pte.Tisi = sort([min(validation.TE{n}.Tisi):6:max(validation.TE{n}.Tisi) 99 100 ])*1e-3;
      R.Rte{n} = sfpThresholdElectrotonus(M, Pte);
      R.Rte{n}.validation = validation.TE{n};
      hold on
      sfpPlot(R.Rte{n});
      grid
   end   
   grid
   fprintf('Threshold Electotonus: %.1fms\n',toc*1e3);  
   
   
   % Electrotonus
   tic
   for n = 1:1 %2;%length(validation.TE)
      figure(n + 5);
      clf;
      Pe.Ts = validation.TE{n}.Ts;
      Pe.Ic = validation.TE{n}.Ic;
      Pe.Tc = validation.TE{n}.Tc;
      R.Re{n} = sfpElectrotonus(P, Pe);
      hold on
      sfpPlot(R.Re{n});
   end   
   grid
   fprintf('Electotonus: %.1fms\n',toc*1e3);  
   
   %Resting state
%    figure(8);
%    clf;
%    Pe.Ts = validation.TE{n}.Ts;
%    Pe.Ic = 0;
%    Pe.Tc = validation.TE{n}.Tc;
%    R.Re{n} = sfpElectrotonus(P, Pe);
%    hold on
%    sfpPlot(R.Re{n});   
   
   end
end

function [R] = displayActionPotential(P)
   M = P.P.Create();
   Ts = 10e-6;

   Itest = sfpThreshold([0 Ts+1e-3], ...
                      M.Y0, ...
                      M, ...
                      sfpPulse(Ts, 0));
   Istim = sfpPulse(Ts, 1.2*Itest);

   R.Rshort = sfpSimulate([0 100e-3], M.Y0, P, Istim);

   figure(4);
   clf;
   sfpPlot(R.Rshort);
   
%    y0 = sfpGetFinalState([0 1e-3], M.Y0, P.P.Create(), Istim);
%    R.Rlong = sfpSimulate([1e-3 100e-3], y0, P, Istim, 10e-6, 10);
%    
%    figure(2);
%    clf;
%    sfpPlot(R.Rlong);
end
