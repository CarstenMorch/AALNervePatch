function [R] = fig_h2_thr(R)
% Figure: Conditioned Recovery Curve
% Changes in excitability of the model after firing a single impulse and a
% short train of impulses. The short train of impulses was induced with
% 250Hz and consisted of 1, 2, 3, 5, and 10 pulses. This figure is to be
% compared with FIG 16-12 in the The Axon, page 323.
if nargin < 1
   simulate = 1;
else
   simulate = 0;
end

load sensory_validation;

P.Fstim = 200;
P.Verbose = 0;

P.Ts = 100e-6;
P.Tisi = 1:1:60;
P.Ic = 2;

N = [1 3 5 10 20]*P.Fstim;

if simulate
   for n = 1:length(N)
      fprintf('Estimating recovery cycle [ pulses: %d ] ', N(n));
      Params = createModel;
      P.N = N(n);
      R{n} = sfpConditionedRecoveryCycle(Params.P.Create(), P); %#ok<SAGROW>

      fprintf('done\n');
   end
end

figure(1);
clf;

for n = 1:length(N)
   plot(R{n}.Tisi, R{n}.THR,'k');
   set(gcf,'Color',[1 1 1]);
   hold on
end

set(gca,'Box','off');
set(gca,'TickDir','out');
xlabel('Time [s]');
ylabel('Threshold Increase [%]');
%legend('1s', '3s', '5s');
