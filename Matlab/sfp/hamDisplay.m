function [R] = hamDisplay(M)
% hamDisplay Display the characteristics for a HAM model
%   hamDisplay(M)

% Gating charecteristics
%   m, h, p, n, s, q, u
R = analyzeModel(M);
displayResult(R, M);

end

function displayResult(R, M)
   y0 = M.Y0;
   lines = [y0(1) y0(2)]*1e3;
   % Rate constants
   figure(1);
   clf;
   set(gcf,'Color', [1 1 1]);
   subplot(2,4,1);
   plotRate(R.Vn*1e3, R.alpha_m, R.beta_m, lines, 'Rate (m)');
   subplot(2,4,2);
   plotRate(R.Vn*1e3, R.alpha_h, R.beta_h, lines, 'Rate (h)');
   subplot(2,4,3);
   plotRate(R.Vn*1e3, R.alpha_p, R.beta_p, lines, 'Rate (p)');
   subplot(2,4,4);
   plotRate(R.Vn*1e3, R.alpha_n, R.beta_n, lines, 'Rate (n)');
   subplot(2,4,5);
   plotRate(R.Vn*1e3, R.alpha_s, R.beta_s, lines, 'Rate (s)');
   subplot(2,4,6);
   plotRate(R.Vn*1e3, R.alpha_q, R.beta_q, lines, 'Rate (q)');
   subplot(2,4,7);
   plotRate(R.Vn*1e3, R.alpha_i, R.beta_i, lines, 'Rate (i)');
   subplot(2,4,8);
   plotRate(R.Ko*1e3, R.alpha_u, R.beta_u, y0(3)*1e3, 'Rate (u)');

   figure(2);
   clf;
   set(gcf,'Color', [1 1 1]);
   subplot(2,4,1);
   plotVar(R.Vn*1e3, R.m_inf, lines, 'm_{inf}');
   subplot(2,4,2);
   plotVar(R.Vn*1e3, R.h_inf, lines, 'h_{inf}');
   subplot(2,4,3);
   plotVar(R.Vn*1e3, R.p_inf, lines, 'p_{inf}');
   subplot(2,4,4);
   plotVar(R.Vn*1e3, R.n_inf, lines, 'n_{inf}');
   subplot(2,4,5);
   plotVar(R.Vn*1e3, R.s_inf, lines, 's_{inf}');
   subplot(2,4,6);
   plotVar(R.Vn*1e3, R.q_inf, lines, 'q_{inf}');
   subplot(2,4,7);
   plotVar(R.Vn*1e3, R.i_inf, lines, 'i_{inf}');
   subplot(2,4,8);
   plotVar(R.Ko*1e3, R.u_inf, y0(3)*1e3, 'u_{inf}');
   
   figure(3);
   clf;
   set(gcf,'Color', [1 1 1]);
   subplot(2,4,1);
   plotVar(R.Vn*1e3, R.m_tau, lines, 'm_{tau}');
   subplot(2,4,2);
   plotVar(R.Vn*1e3, R.h_tau, lines, 'h_{tau}');
   subplot(2,4,3);
   plotVar(R.Vn*1e3, R.p_tau, lines, 'p_{tau}');
   subplot(2,4,4);
   plotVar(R.Vn*1e3, R.n_tau, lines, 'n_{tau}');
   subplot(2,4,5);
   plotVar(R.Vn*1e3, R.s_tau, lines, 's_{tau}');
   subplot(2,4,6);
   plotVar(R.Vn*1e3, R.q_tau, lines, 'q_{tau}');
   subplot(2,4,7);
   plotVar(R.Vn*1e3, R.i_tau, lines, 'i_{tau}');
   subplot(2,4,8);
   plotVar(R.Ko*1e3, R.u_tau, y0(3)*1e3, 'u_{tau}');   
end

function plotRate(x, a, b, lines, str)
   mx = max([max(a) max(b)]);
   mn = min([min(a) min(b)]);
   
   plot(x, a, 'b', x, b, 'r');
   hold on
   
   for n = 1:length(lines)
      plot([lines(n) lines(n)],[mn mx],'m');
   end
   
   title(str);
   set(gca,'Box','off');
   set(gca,'TickDir','out');
   grid
end

function plotVar(x, y, lines, str)
   mx = max(y);
   mn = min(y);
   
   plot(x, y, 'b');
   hold on
   
   for n = 1:length(lines)
      plot([lines(n) lines(n)],[mn mx],'m');
   end
   
   title(str);
   set(gca,'Box','off');
   set(gca,'TickDir','out');
   grid
end

function [R] = analyzeModel(M)
   R.Vn = (-150:2.5:50)*1e-3;
   R.Ko = (1:0.25:10)*1e-3;


   R.alpha_m = zeros(1, length(R.Vn));
   R.alpha_h = zeros(1, length(R.Vn));
   R.alpha_p = zeros(1, length(R.Vn));
   R.alpha_n = zeros(1, length(R.Vn));
   R.alpha_s = zeros(1, length(R.Vn));
   R.alpha_q = zeros(1, length(R.Vn));
   R.alpha_i = zeros(1, length(R.Vn));


   R.beta_m = zeros(1, length(R.Vn));
   R.beta_h = zeros(1, length(R.Vn));
   R.beta_p = zeros(1, length(R.Vn));
   R.beta_n = zeros(1, length(R.Vn));
   R.beta_s = zeros(1, length(R.Vn));
   R.beta_q = zeros(1, length(R.Vn));
   R.beta_i = zeros(1, length(R.Vn));

   y = M.Y0;

   for n = 1:length(R.Vn)
      y(1) = R.Vn(n);
      y(2) = R.Vn(n);
      y(3) = 3e-3;
      M.alpha(M.a, y);
      M.beta(M.b, y);

      R.alpha_m(n) = M.a(1);
      R.alpha_h(n) = M.a(2);
      R.alpha_p(n) = M.a(3);
      R.alpha_n(n) = M.a(4);
      R.alpha_s(n) = M.a(5);
      R.alpha_i(n) = M.a(6);
      R.alpha_q(n) = M.a(8);

      R.beta_m(n) = M.b(1);
      R.beta_h(n) = M.b(2);
      R.beta_p(n) = M.b(3);
      R.beta_n(n) = M.b(4);
      R.beta_s(n) = M.b(5);
      R.beta_i(n) = M.b(6);
      R.beta_q(n) = M.b(8);
   end

   R.m_inf = R.alpha_m ./ (R.alpha_m + R.beta_m);
   R.h_inf = R.alpha_h ./ (R.alpha_h + R.beta_h);
   R.p_inf = R.alpha_p ./ (R.alpha_p + R.beta_p);
   R.n_inf = R.alpha_n ./ (R.alpha_n + R.beta_n);
   R.s_inf = R.alpha_s ./ (R.alpha_s + R.beta_s);
   R.i_inf = R.alpha_i ./ (R.alpha_i + R.beta_i);
   R.q_inf = R.alpha_q ./ (R.alpha_q + R.beta_q);

   R.m_tau = 1 ./ (R.alpha_m + R.beta_m);
   R.h_tau = 1 ./ (R.alpha_h + R.beta_h);
   R.p_tau = 1 ./ (R.alpha_p + R.beta_p);
   R.n_tau = 1 ./ (R.alpha_n + R.beta_n);
   R.s_tau = 1 ./ (R.alpha_s + R.beta_s);
   R.i_tau = 1 ./ (R.alpha_i + R.beta_i);
   R.q_tau = 1 ./ (R.alpha_q + R.beta_q);


   R.alpha_u = zeros(1, length(R.Ko));
   R.beta_u = zeros(1, length(R.Ko));

   for n = 1:length(R.Ko)
      y(1) = 83e-3;
      y(2) = 83e-3;
      y(3) = R.Ko(n);
      M.alpha(M.a, y);
      M.beta(M.b, y);

      R.alpha_u(n) = M.a(10);
      R.beta_u(n) = M.b(10);   
   end

   R.u_inf = R.alpha_u ./ (R.alpha_u + R.beta_u);
   R.u_tau = 1 ./ (R.alpha_u + R.beta_u);
end
