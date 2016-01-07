%% Creates figure 3 showing increased hyperpolerization after repeated 
% stimulation. 

P = createModel;
M = P.P.Create();
Ts = 100e-6;
Fstim = 200;
Tperiod = 1/Fstim;
Isupra = 2;
N = 1;
Tstimulation = (N)/Fstim;
Tmax = 0.2;


tic
fprintf('Determining threshold ... ');
Itest = sfpThreshold([0 Ts+1e-3], ...
    M.Y0, ...
    M, ...
    sfpPulse(Ts, 0));
fprintf('done\n');




figure(1);
clf;
set(gcf,'Color', [1 1 1]);

Ns = [1 7 14];
Labels = {'A', 'B', 'C'};
for n = 1:length(Ns);
    N = Ns(n);
    fprintf('Simulating pulse trains ... ');
    Istim = sfpPulseTrain(Ts, Isupra*Itest,N,Tperiod);
    R = sfpSimulate([-0.01 Tmax], M.Y0, P, Istim, 2e-6, 10);
    fprintf('done [ %.2f ]!\n', toc);
    
    subplot(3,1,n);
    plot(R.t, R.Vn*1e3,'k');
    hold on
    plot([-0.01 Tmax],[-87 -87],'--k');
    ylim([-92 -77]);
    xlim([-0.01 Tmax]);
    set(gca,'Box','off');
    set(gca,'TickDir','out');
    if n == 2;
        ylabel('Membrane Potential [mV]');
    end
    
    title(Labels{n});
end
xlabel('Time [s]');