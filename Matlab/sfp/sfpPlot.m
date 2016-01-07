function sfpPlot(R)
% Plot the contents of a data structure
%   sfpPlot(R) plot the results [R] of a simulation. This is a polymorphic
%   function that will create the appropriate plot based on the R.TypeID
%   field that is inserted by the functions of the toolbox.
%
% See also cpmSimulate

   try
      if (strcmp(R.TypeID, 'simulation'))
         if (strcmp(R.SubTypeID, 'HAA'))
            plotHAASimulation(R); 
         end
         if (strcmp(R.SubTypeID, 'HAM'))
            plotHAMSimulation(R); 
         end         
      end    
      if (strcmp(R.TypeID, 'la_curve'))
         plotLatentAddition(R); 
      end    
      if (strcmp(R.TypeID, 'sd_curve'))
         plotSDCurve(R); 
      end    
      if (strcmp(R.TypeID, 'ac_curve'))
         plotAccommodationCurve(R); 
      end    
      if (strcmp(R.TypeID, 'te_curve'))
         plotThresholdElectrotonus(R); 
      end    
      if (strcmp(R.TypeID, 'ct_curve'))
         plotCurrentThreshold(R); 
      end    
      if (strcmp(R.TypeID, 'rc_curve'))
         plotRecoveryCurve(R); 
      end    
   catch %#ok<CTCH>
      fprintf('Unsupported data structure\n');
   end
end

function plotRecoveryCurve(R)
   try
      semilogx(R.validation.Tisi, R.validation.Tmean, 'b', ...
               R.validation.Tisi, R.validation.Tmean - R.validation.Tvar, 'b:', ...
               R.validation.Tisi, R.validation.Tmean + R.validation.Tvar, 'b:');
      hold on
   catch  %#ok<CTCH>
   end
   semilogx(R.Tisi*1e3, R.THR, 'k');
   xlabel('T_{isi} [ms]');
   ylabel('Threshold Increase [%]');
   title('Recovery Cycle');
   set(gcf, 'Color', [1 1 1]);
   set(gca, 'Box','off');
   set(gca, 'TickDir','out');
   set(gca, 'Xscale', 'log');
   set(gca, 'XLimMode', 'manual');
   set(gca, 'XLim', [2 200]);
   grid
end

function plotSDCurve(R)
   semilogx(R.Ts*1e3, R.Irel, 'k');
   xlabel('T_{s} [ms]');
   ylabel('Threshold [Rheobase]');
   title('Strength-Duration Curve');
   set(gcf, 'Color', [1 1 1]);
   set(gca, 'Box','off');
   set(gca, 'TickDir','out');
   set(gca, 'Xscale', 'log');
   set(gca, 'XLimMode', 'manual');
   grid   
end

function plotCurrentThreshold(R)
   try
      plot(R.validation.Tavg, R.validation.I, 'b', ...
           R.validation.Tavg - R.validation.Tvar, R.validation.I, 'b:', ...
           R.validation.Tavg + R.validation.Tvar, R.validation.I, 'b:');
      hold on
   catch  %#ok<CTCH>
   end

   plot(R.THR, R.Parameters.Ic*100,  'k.-');
   ylabel('I_{c} [%]');
   xlabel('Threshold Increase [%]');
   title('Current Threshold Relationship');
   set(gcf, 'Color', [1 1 1]);
   set(gca, 'Box','off');
   set(gca, 'TickDir','out');
   grid
end

function plotThresholdElectrotonus(R)
   try
      plot(R.validation.Tisi, R.validation.Tmean, 'b', ...
           R.validation.Tisi, R.validation.Tmean - R.validation.Tvar, 'b:', ...
           R.validation.Tisi, R.validation.Tmean + R.validation.Tvar, 'b:');
      hold on
   catch  %#ok<CTCH>
   end
   plot(R.Tisi*1e3, R.THR, 'k-');
   xlabel('T_{isi} [ms]');
   ylabel('Threshold Reduction [%]');
   title('Threshold Electrotonus');
   set(gcf, 'Color', [1 1 1]);
   set(gca, 'Box','off');
   set(gca, 'TickDir','out');
   %A = axis;
   %axis([A(1) 150 A(3) A(4)]);
   grid
end

function plotAccommodationCurve(R)
   try
      R.Irheo;
      try
         plot(R.validation.Ts, R.validation.Tmean, 'b', ...
              R.validation.Ts, R.validation.Tmean - R.validation.Tvar, 'b:', ...
              R.validation.Ts, R.validation.Tmean + R.validation.Tvar, 'b:');
         hold on
      catch  %#ok<CTCH>
      end
      plot(R.Ts*1e3, R.Ithr/R.Irheo, 'k-');
      xlabel('T_{s} [ms]');
      ylabel('Current Threshold [Irheo]');
      title('Accommodation Curve');
      set(gcf, 'Color', [1 1 1]);
      set(gca, 'Box','off');
      set(gca, 'TickDir','out');
      grid
   catch %#ok<CTCH>
      try
         plot(R.Ts*1e3, R.Ithr*1e9, 'k.-');
         xlabel('T_{s} [ms]');
         ylabel('Current Threshold [nA]');
         title('Accommodation Curve');
         set(gcf, 'Color', [1 1 1]);
         set(gca, 'Box','off');
         set(gca, 'TickDir','out');
         grid      
      catch errmsg
         errmsg %#ok<NOPRT>
      end
   end
end

function plotLatentAddition(R)
   try
      plot(R.validation.Tisi, R.validation.Tmean, 'b', ...
           R.validation.Tisi, R.validation.Tmean - R.validation.Tvar, 'b:', ...
           R.validation.Tisi, R.validation.Tmean + R.validation.Tvar, 'b:');
      hold on
   catch %#ok<CTCH>
   end
   plot(R.Tisi*1e3, R.THR, 'k-');
     
   xlabel('T_{isi} [ms]');
   ylabel('Threshold Increase [%]');
   title('Latent Addition');
   set(gcf, 'Color', [1 1 1]);
   set(gca, 'Box','off');
   set(gca, 'TickDir','out');
   grid
end

function plotHAASimulation(R)
    try
        clf;
        set(gcf,'Color', [1 1 1]);

        subplot(2,1,1);
        plot(R.t*1e3, R.Vn*1e3,'b', R.t*1e3, R.Vi*1e3, 'r');
        legend('V_n', 'V_i','Location','EastOutside');
        ylabel('Voltage [mV]');
        title('Membrane Potentials');
        set(gca,'TickDir','out'),
        set(gca,'Box','off');
        A = axis;
        A = [R.tspan(1) R.tspan(2) A(3) A(4)];
        axis(A);

        subplot(4,1,3);
        plot(R.t*1e3, R.m_n, 'b',...
             R.t*1e3, R.h_n, 'r',...
             R.t*1e3, R.p_n, 'g',...
             R.t*1e3, R.n_n, 'm',...
             R.t*1e3, R.s_n, 'k',...
             R.t*1e3, R.s_i, 'c');
        legend('m_n','h_n','p_n','n_n','s_n','s_i','Location','EastOutside');
        ylabel('Gate Probability');
        title('Gating Variables');
        set(gca,'TickDir','out'),
        set(gca,'Box','off');    
        A = axis;
        A = [R.tspan(1) R.tspan(2) 0 1];
        axis(A);
        
        Istim = zeros(1, length(R.t));
        for n = 1:length(R.t)
            Istim(n) = R.Is.GetValue(R.t(n));
        end
        
        subplot(4,1,4);
        plot(R.t*1e3, Istim*1e9,'k');
        legend('I_s','Location','EastOutside');
        ylabel('Current [nA]');
        xlabel('Time [ms]');
        title('Stimulation');
        set(gca,'TickDir','out'),
        set(gca,'Box','off');    
        A = axis;
        A = [R.tspan(1) R.tspan(2) A(3) A(4)];
        axis(A);
        
    catch errcode
        disp(errcode);
    end
end

function plotHAMSimulation(R)
    try
        clf;
        set(gcf,'Color', [1 1 1]);

        subplot(4,1,1);
        plot(R.t*1e3, R.Vn*1e3,'b', R.t*1e3, R.Vi*1e3, 'r');
        legend('V_n', 'V_i','Location','EastOutside');
        ylabel('Voltage [mV]');
        title('Membrane Potentials');
        set(gca,'TickDir','out'),
        set(gca,'Box','off');
        A = axis;
        A = [R.tspan(1) R.tspan(2) A(3) A(4)];
        axis(A);

        subplot(4,1,2);
        plot(R.t*1e3, R.m_n, 'b',...
             R.t*1e3, R.h_n, 'r',...
             R.t*1e3, R.p_n, 'g',...
             R.t*1e3, R.n_n, 'm',...
             R.t*1e3, R.s_n, 'k',...
             R.t*1e3, R.i_n, 'c');
        legend('m_n','h_n','p_n','n_n','s_n','i_n', 'Location','EastOutside');
        ylabel('Gate Probability');
        title('Nodal Gating Variables');
        set(gca,'TickDir','out'),
        set(gca,'Box','off');    
        A = axis;
        A = [R.tspan(1) R.tspan(2) 0 1];
        axis(A);
 
        subplot(4,1,3);
        plot(R.t*1e3, R.s_i, 'k',...
             R.t*1e3, R.q_i, 'r',...
             R.t*1e3, R.u_i, 'm',...
             R.t*1e3, R.i_i, 'c');
        legend('s_i','q_i','u_i','i_i', 'Location','EastOutside');
        ylabel('Gate Probability');
        title('Internodal Gating Variables');
        set(gca,'TickDir','out'),
        set(gca,'Box','off');    
        A = axis;
        A = [R.tspan(1) R.tspan(2) 0 A(4)];
        axis(A);
        
        subplot(4,1,4);
        plot(R.t*1e3, R.Ko*1e3, 'k');
        ylabel('Potassium Concentation [mMol]');
        legend('K_o','Location','EastOutside');
        set(gca,'TickDir','out'),
        set(gca,'Box','off');
        A = axis;
        A = [R.tspan(1) R.tspan(2) A(3) A(4)];
        axis(A);

%         Istim = zeros(1, length(R.t));
%         for n = 1:length(R.t)
%             Istim(n) = R.Is.GetValue(R.t(n));
%         end
%         
%         subplot(4,1,4);
%         plot(R.t*1e3, Istim*1e9,'k');
%         legend('I_s','Location','EastOutside');
%         ylabel('Current [nA]');
%         xlabel('Time [ms]');
%         title('Stimulation');
%         set(gca,'TickDir','out'),
%         set(gca,'Box','off');    
%         A = axis;
%         A = [R.tspan(1) R.tspan(2) A(3) A(4)];
%         axis(A);
        
    catch errcode
        disp(errcode);
    end
end
