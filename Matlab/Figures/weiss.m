function [I] = weiss(t,C,R)
%WEISS This function calculates the strength-duration curve based on Weiss's law
%   [I] = weiss(t,Tsd,R) this function returns the excitation thresholds [I] for
%   the stimulus durations in [t], based on Weiss's law and the chronaxie [C] and
%   rheobase [R]
%I = R * (1 + C./t);
I = R*(t + C) ./ t;
