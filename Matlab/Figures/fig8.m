%this function generates raster plots

clear all
close all


%% ==== Do calcultations ====
% Frequency sweep
Isupra = 1.2;
Freqs = (10.^(1:0.1:3));
Npulses = 100;

fprintf('Simulating pulse trains \n [ ');

for nF = 1:length(Freqs)
    Fstim = Freqs(nF);
    [R,APtimes,Tstim] = tetanic (Isupra,Fstim,Npulses);
    AP{nF} = APtimes;
    fprintf('.');
end
fprintf(' ] \n done!\n');

%% Create figure
figure1 = figure('Color',[1 1 1]);
axes2 = subplot(2,3,1);
set(axes2, 'YScale','log');
box(axes2,'off');
hold(axes2,'all');

for n = 1:length(Freqs)
% plot(AP{n}*Freqs(n),ones(1,length(AP{n}))*Freqs(n),'+k','LineStyle','none','Parent',axes2)
    for spike = 1:length(AP{n})
        line ([AP{n}(spike) AP{n}(spike)]*Freqs(n), [Freqs(n)-0.1*(Freqs(n)) Freqs(n)+0.1*(Freqs(n))],'Color','k','Parent',axes2)
    end
end

xlim([-2 Npulses+1])
ylim([9 1100])
title(['Before Tetanic stimulation. Intensity: ',num2str(Isupra),' (Th)'])
xlabel('Stimulation Number')
ylabel('Frequency (Hz)')

%% ==== Do calcultations ====
% Frequency sweep
clear AP
Isupra = 1.8;
Freqs = (10.^(1:0.1:3));
Npulses = 100;

fprintf('Simulating pulse trains \n [ ');

for nF = 1:length(Freqs)
    Fstim = Freqs(nF);
    [R,APtimes,Tstim] = tetanic (Isupra,Fstim,Npulses);
    AP{nF} = APtimes;
    fprintf('.');
end
fprintf(' ] \n done!\n');

%% Create figure
axes2 = subplot(2,3,4);
set(axes2, 'YScale','log');
box(axes2,'off');
hold(axes2,'all');

for n = 1:length(Freqs)
% plot(AP{n}*Freqs(n),ones(1,length(AP{n}))*Freqs(n),'+k','LineStyle','none','Parent',axes2)
    for spike = 1:length(AP{n})
        line ([AP{n}(spike) AP{n}(spike)]*Freqs(n), [Freqs(n)-0.1*(Freqs(n)) Freqs(n)+0.1*(Freqs(n))],'Color','k','Parent',axes2)
    end
end

xlim([-2 Npulses+1])
ylim([9 1100])
title(['Before Tetanic stimulation. Intensity: ',num2str(Isupra),' (Th)'])
xlabel('Stimulation Number')
ylabel('Frequency (Hz)')

%% conditipning stimulation super threshold
clear Y0
P = createModel;
M = P.P.Create();
Itest = sfpThreshold([0 100e-6+150e-6],M.Y0,M,sfpPulse(100e-6, 0));
Istim = sfpPulseTrain(100e-6, 2*Itest,200*100,1/200);
Y0 = sfpGetFinalState([0 100], M.Y0, M, Istim);%([0 50], M.Y0, M, Istim); 

% Itest = sfpThreshold([0 100e-6+150e-6],M.Y0,M,sfpPulse(100e-6, 0));
% Istim = sfpPulseTrain(100e-6, 0.7*Itest,2000*100,1/2000);  %(100e-6, 2*Itest,200*50,1/200);
% Y0 = sfpGetFinalState([0 100], M.Y0, M, Istim);%([0 50], M.Y0, M, Istim); 


%% ==== Do calcultations ====
% Frequency sweep
clear AP
Isupra = 1.2;
Freqs = (10.^(1:0.1:3));
Npulses = 100;

fprintf('Simulating pulse trains \n [ ');

for nF = 1:length(Freqs)
    Fstim = Freqs(nF);
    [R,APtimes,Tstim] = tetanic (Isupra,Fstim,Npulses,Y0);
    AP{nF} = APtimes;
    fprintf('.');
end
fprintf(' ] \n done!\n');



%% Create axes
axes2 = subplot(2,3,2);
set(axes2, 'YScale','log');
box(axes2,'off');
hold(axes2,'all');

for n = 1:length(Freqs)
% plot(AP{n}*Freqs(n),ones(1,length(AP{n}))*Freqs(n),'+k','LineStyle','none','Parent',axes2)
    for spike = 1:length(AP{n})
        line ([AP{n}(spike) AP{n}(spike)]*Freqs(n), [Freqs(n)-0.1*(Freqs(n)) Freqs(n)+0.1*(Freqs(n))],'Color','k','Parent',axes2)
    end
end

xlim([-2 Npulses+1])
ylim([9 1100])
title(['After Tetanic stimulation. Intensity: ',num2str(Isupra),' (Th)'])
xlabel('Stimulation Number')
ylabel('Frequency (Hz)')

%% ==== Do calcultations ====
% Frequency sweep
clear AP
Isupra = 1.8;
Freqs = (10.^(1:0.1:3));
Npulses = 100;

fprintf('Simulating pulse trains \n [ ');

for nF = 1:length(Freqs)
    Fstim = Freqs(nF);
    [R,APtimes,Tstim] = tetanic (Isupra,Fstim,Npulses,Y0);
    AP{nF} = APtimes;
    fprintf('.');
end
fprintf(' ] \n done!\n');



%% Create axes
axes2 = subplot(2,3,5);
set(axes2, 'YScale','log');
box(axes2,'off');
hold(axes2,'all');

for n = 1:length(Freqs)
% plot(AP{n}*Freqs(n),ones(1,length(AP{n}))*Freqs(n),'+k','LineStyle','none','Parent',axes2)
    for spike = 1:length(AP{n})
        line ([AP{n}(spike) AP{n}(spike)]*Freqs(n), [Freqs(n)-0.1*(Freqs(n)) Freqs(n)+0.1*(Freqs(n))],'Color','k','Parent',axes2)
    end
end

xlim([-2 Npulses+1])
ylim([9 1100])
title(['After Tetanic stimulation. Intensity: ',num2str(Isupra),' (Th)'])
xlabel('Stimulation Number')
ylabel('Frequency (Hz)')

%% conditipning stimulation
clear Y0
P = createModel;
M = P.P.Create();
Itest = sfpThreshold([0 100e-6+150e-6],M.Y0,M,sfpPulse(100e-6, 0));
Istim = sfpPulseTrain(100e-6, 0.7*Itest,2000*100,1/2000);  %(100e-6, 2*Itest,200*50,1/200);
Y0 = sfpGetFinalState([0 100], M.Y0, M, Istim);%([0 50], M.Y0, M, Istim); 


%% ==== Do calcultations ====
% Frequency sweep
clear AP
Isupra = 1.2;
Freqs = (10.^(1:0.1:3));
Npulses = 100;

fprintf('Simulating pulse trains \n [ ');

for nF = 1:length(Freqs)
    Fstim = Freqs(nF);
    [R,APtimes,Tstim] = tetanic (Isupra,Fstim,Npulses,Y0);
    AP{nF} = APtimes;
    fprintf('.');
end
fprintf(' ] \n done!\n');



%% Create axes
axes2 = subplot(2,3,3);
set(axes2, 'YScale','log');
box(axes2,'off');
hold(axes2,'all');

for n = 1:length(Freqs)
% plot(AP{n}*Freqs(n),ones(1,length(AP{n}))*Freqs(n),'+k','LineStyle','none','Parent',axes2)
    for spike = 1:length(AP{n})
        line ([AP{n}(spike) AP{n}(spike)]*Freqs(n), [Freqs(n)-0.1*(Freqs(n)) Freqs(n)+0.1*(Freqs(n))],'Color','k','Parent',axes2)
    end
end

xlim([-2 Npulses+1])
ylim([9 1100])
title(['After High Frequency stimulation. Intensity: ',num2str(Isupra),' (Th)'])
xlabel('Stimulation Number')
ylabel('Frequency (Hz)')

%% ==== Do calcultations ====
% Frequency sweep
clear AP
Isupra = 1.8;
Freqs = (10.^(1:0.1:3));
Npulses = 100;

fprintf('Simulating pulse trains \n [ ');

for nF = 1:length(Freqs)
    Fstim = Freqs(nF);
    [R,APtimes,Tstim] = tetanic (Isupra,Fstim,Npulses,Y0);
    AP{nF} = APtimes;
    fprintf('.');
end
fprintf(' ] \n done!\n');



%% Create axes
axes2 = subplot(2,3,6);
set(axes2, 'YScale','log');
box(axes2,'off');
hold(axes2,'all');

for n = 1:length(Freqs)
% plot(AP{n}*Freqs(n),ones(1,length(AP{n}))*Freqs(n),'+k','LineStyle','none','Parent',axes2)
    for spike = 1:length(AP{n})
        line ([AP{n}(spike) AP{n}(spike)]*Freqs(n), [Freqs(n)-0.1*(Freqs(n)) Freqs(n)+0.1*(Freqs(n))],'Color','k','Parent',axes2)
    end
end

xlim([-2 Npulses+1])
ylim([9 1100])
title(['After High Frequency stimulation. Intensity: ',num2str(Isupra),' (Th)'])
xlabel('Stimulation Number')
ylabel('Frequency (Hz)')