function [J] = sfpPump(Ko)
% sfpPump Pump Flux Density
%   [J] = sfpPump(Ko)
Km_Na = 0.1e-3;
Km_K = 4.5e-3;
L_Na = 1e-2;
L_K = 1e-3;
JK_max = -(2/3)*0.7e-7;
Ki = 0.155;
NAi = 0.009;
NAo = 0.1442;

J = zeros(1, length(Ko));

for n = 1:length(Ko)
   f1 = 1/((1+(Km_Na+L_Na*Ki)/NAi)^3);
   f2 = 1/((1+(Km_K+L_K*NAo)/Ko(n))^2);
   J(n) = JK_max * f1*f2;
end