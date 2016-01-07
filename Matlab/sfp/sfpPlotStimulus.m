function [t,I] = sfpPlotStimulus(T, Istim)
% sfpPlotStimulus Plot the output from a stimulus

Trange = T(2)-T(1);
t = T(1):Trange/500:T(2);
I = zeros(1, length(t));

for n = 1:length(t)
    I(n) = Istim.GetValue(t(n));
end

figure(1);
clf;
plot(t,I);
set(gca,'TickDir','out');