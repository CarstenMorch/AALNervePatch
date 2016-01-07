% function [R] = fig_Vm_Train_Zoom(R)
% 
% if nargin < 1
%     simulate = 1
% else
%    simulate = 0
% end

T1 = 60;          % start time for zoom window
T2 = 60.2;          %end time for zoom window
P = createModel;
M = P.P.Create();
Ts = 100e-6;        %pulse width
Fstim = 200;        %stimulation frequency
Tperiod = 1/Fstim;  % Period of single stimulation
Isupra = 2;         % stimulation intensity, Multiplum of threshold
Tstimulation = T2;  % Stimulation time?
SampFreq = 1e-6;    % Sampeling frequency 
APdelay = 60e-6;    % dalay for axtion potential detection

%dumping info to optstruct
opt.Fstim = Fstim;
opt.SampFreq = SampFreq;
opt.Tperiod = Tperiod;
opt.APdelay = APdelay;

N = round(Tstimulation*Fstim);

%% Determining threshold
   tic
   fprintf('Determining threshold ... ');
   Itest = sfpThreshold([0 Ts+1e-3], ...
                      M.Y0, ...
                      M, ...
                      sfpPulse(Ts, 0));
   fprintf('done [ %.2f ]!\n', toc);               
%% simulationg tetanic stimulation 
   tic
   fprintf('Simulating pulse trains ... ');
   Istim = sfpPulseTrain(Ts, Isupra*Itest,N,Tperiod);
   Y0 = sfpGetFinalState([0 T1], M.Y0, M, Istim); 
   R = sfpSimulate([T1 T2], Y0, P, Istim, SampFreq, 1); 
   fprintf('done [ %.2f ]!\n', toc);

%% Simulating repeated stimulation
tic
fprintf('finding action potentials ...');
Tstim = (0:round((T2-T1)/Tperiod)-1)*Tperiod; %stimulation times in the zoom window
AP = sfpIdentifyActionPotentials(R,Tstim,opt);
fprintf('done [ %.2f ]!\n', toc);

figure(1);
clf;
set(gcf,'Color', [1 1 1]);
subplot(3,1,1);
plot(R.t, R.Vn*1e3,'k',...
     AP+T1, -90*ones(length(AP),1), 'k.');
set(gca,'Box','off');
set(gca,'TickDir','out');
ylabel('Membrane Potential [mV]');
title('A');
xlim([T1 T2])

subplot(3,1,2);
plot(R.t, R.Ko*1e3,'k');
set(gca,'Box','off');
set(gca,'TickDir','out');
ylabel('Concentration [mM]');
title('B');
xlim([T1 T2])

subplot(3,1,3);
%plot(R.t, R.m_n,'k');
plot(R.t, 1e9./Rbb(R.u_i, M),'k');
set(gca,'Box','off');
set(gca,'TickDir','out');
ylabel('Conductance [nS]');
xlabel('Time [s]');
title('C');
xlim([T1 T2])

% Create rectangle
annotation(gcf,'rectangle',...
    [0.13 0.11 0.055 0.83],...
    'FaceAlpha',0.4,...
    'FaceColor',[0.5 0.5 0.5],...
    'Color','none');

% Create rectangle
annotation(gcf,'rectangle',...
    [0.373 0.11 0.201 0.83],...
    'FaceAlpha',0.4,...
    'FaceColor',[0.5 0.5 0.5],...
    'Color','none');

% Create rectangle
annotation(gcf,'rectangle',...
    [0.762 0.11 0.145 0.83],...
    'FaceAlpha',0.4,...
    'FaceColor',[0.5 0.5 0.5],...
    'Color','none');