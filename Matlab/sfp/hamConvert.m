function [R] = haaConvert(r, Is)
% Convert the results of a simulation
%   [data] = haaUnpack(r, Is)

R.TypeID = 'simulation';
R.SubTypeID = 'HAM';
data = double(r);

% Unpack the results
R.Is = Is;
R.t   = data(1,:);
R.Vn  = data(2,:);
R.Vi  = data(3,:);
R.Ko  = data(4,:);
R.m_n = data(5,:);
R.h_n = data(6,:);
R.p_n = data(7,:);
R.n_n = data(8,:);
R.s_n = data(9,:);
R.i_n = data(10,:);
R.s_i = data(11,:);
R.q_i = data(12,:);
R.i_i = data(13,:);
R.u_i = data(14,:);
