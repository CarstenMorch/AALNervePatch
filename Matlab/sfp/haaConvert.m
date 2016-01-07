function [R] = haaConvert(r, Is)
% Convert the results of a simulation
%   [data] = haaUnpack(r, Is)

R.TypeID = 'simulation';
R.SubTypeID = 'HAA';
data = double(r);

% Unpack the results
R.Is = Is;
R.t   = data(1,:);
R.Vn  = data(2,:);
R.Vi  = data(3,:);
R.m_n = data(4,:);
R.h_n = data(5,:);
R.p_n = data(6,:);
R.n_n = data(7,:);
R.s_n = data(8,:);
R.s_i = data(9,:);      
