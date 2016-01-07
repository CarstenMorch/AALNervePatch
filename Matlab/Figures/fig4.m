% FIGURE Spike Train
%  This figure shows the nerve fibers reaction to a train of stimuli, given
%  at 200Hz at 2 x Activation Threshold. It contains the following
%  sub-plots:
%     A) The membrane potential (Vm)
%     B) Peri-axonal potassium concentration
%     C) Barrett-Barrett (Gbb) conductance

% Determining the activation thresdhold to a 100us pulse.


P = createModel;
M = P.P.Create();
Ts = 100e-6;
Fstim = 200;
Tperiod = 1/Fstim;
Isupra = 2;
Tstimulation = 100;
Tmax = 200;
N = round(Tstimulation*Fstim);




   tic
   fprintf('Determining threshold ... ');
   Itest = sfpThreshold([0 Ts+1e-3], ...
                      M.Y0, ...
                      M, ...
                      sfpPulse(Ts, 0));
   fprintf('done\n');                

   fprintf('Simulating pulse trains ... ');
   Istim = sfpPulseTrain(Ts, Isupra*Itest,N,Tperiod);
   R = sfpSimulate([0 Tmax], M.Y0, P, Istim, 2e-6, 10); 
   fprintf('done [ %.2f ]!\n', toc);


figure(1);
clf;
set(gcf,'Color', [1 1 1]);
subplot(3,1,1);
plot(R.t, R.Vn*1e3,'k');
set(gca,'Box','off');
set(gca,'TickDir','out');
ylabel('Membrane Potential [mV]');
title('A');

subplot(3,1,2);
plot(R.t, R.Ko*1e3,'k');
set(gca,'Box','off');
set(gca,'TickDir','out');
ylabel('Concentration [mM]');
title('B');


subplot(3,1,3);
plot(R.t, 1e9./Rbb(R.u_i, M),'k');
set(gca,'Box','off');
set(gca,'TickDir','out');
ylabel('Conductance [nS]');
xlabel('Time [s]');
title('C');