using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch.Models
{
  public class HAMPatch : PatchModel
  {
    public HAMPatch(HAMPatchParameters p)
    {
      Ngating = 10;
      a = new double[Ngating];
      b = new double[Ngating];
      y0 = new double[Ngating + 3];

      eNa = (R*p.Tk / F) * Math.Log(p.NAo / p.NAi);
      eK = (R*p.Tk / F) * Math.Log(p.Ko / p.Ki);

      Cm = p.Cm;
      Cn = p.Cn;
      Ci = p.Ci;
      Ril = 1/p.Gil;
      gSL = (1 / Ril) * p.nGsl;

      Ko = p.Ko;
      Ki = p.Ki;
      NAi = p.NAi;
      NAo = p.NAo;
      Tk = p.Tk;
      ClampKo = p.ClampKo;
      L = p.L;

      // Ionic Currents
      p.CopyRateConstants(p.q10m, p.Am, Am);
      p.CopyRateConstants(p.q10h, p.Ah, Ah);
      p.CopyRateConstants(p.q10p, p.Ap, Ap);
      p.CopyRateConstants(p.q10n, p.An, An);
      p.CopyRateConstants(p.q10s, p.As, As);
      p.CopyRateConstants(p.q10i, p.Ai, Ai);
      p.CopyRateConstants(p.q10q, p.Aq, Aq);
      p.CopyRateConstants(p.q10u, p.Au, Au);

      p.CopyRateConstants(p.q10m, p.Bm, Bm);
      p.CopyRateConstants(p.q10h, p.Bh, Bh);
      p.CopyRateConstants(p.q10p, p.Bp, Bp);
      p.CopyRateConstants(p.q10n, p.Bn, Bn);
      p.CopyRateConstants(p.q10s, p.Bs, Bs);
      p.CopyRateConstants(p.q10i, p.Bi, Bi);
      p.CopyRateConstants(p.q10q, p.Bq, Bq);
      p.CopyRateConstants(p.q10u, p.Bu, Bu);

      // Conductances
      Vi = CircleArea(p.di) * p.L;
      Vpa = (CircleArea(p.di+p.Wpa)-CircleArea(p.di))* p.L;
      Apa = p.di * Math.PI * p.L;

      gNat_n = (1-p.pNap_n) * p.gNa_n * p.Area_n;
      gNap_n = p.pNap_n * p.gNa_n * p.Area_n;
      gKf_n  = p.gKf_n * p.Area_n;
      gKs_n  = p.gKs_n * p.Area_n;
      gKi_n = p.gKi_n * p.Area_n;
      gLk_n = p.gLk_n * p.Area_n;

      gKs_i = p.gKs_i * p.Area_i;
      gKi_i = p.gKi_i * p.Area_i;
      gH_Na_i = p.gH_i * p.Area_i * p.gH_SNa;
      gH_K_i = p.gH_i * p.Area_i * (1-p.gH_SNa);
      gLk_i = p.gLk_i * p.Area_i;

      // Calculate inter-nodal resting potential
      En = y0[0] = p.Vr;
      Ei = y0[1] = p.Vi;
      y0[2] = Ko;

      SetupGatingVariables();
      double Rbb = getRbb(y0);
      iPump_n = -(Iion_n(y0) - (Ei - En) / Rbb);
     
      //Ei = y0[1] = Ril * Iion_n(y0) + p.Vr; 

      // Calculate inter-nodal leak conductance
      SetupGatingVariables();
      iPump_i = -Iion_i(y0) - (y0[1]-y0[0])/Rbb;

      // Calculate the value of the sodium potassium pump that will keep the
      // potassium concentration of the peri-axonal space stable at rest
      Km_K = p.Km_K;
      Km_Na = p.Km_Na;
      L_K = p.L_K;
      L_Na = p.L_Na;
      Jmax = 1;

      // We now calculate the Jmax that will keep the peri-axonal potassium
      // concentration stable at rest.
      double Jk_pa = jK_i(y0);
      Jmax = -Jk_pa / jPump(y0);
    }

    private double CircleArea(double diameter)
    {
      return Math.PI * (diameter/2) * (diameter/2);
    }

    protected override void SetupGatingVariables()
    {
      alpha(a, y0);
      beta(b, y0);

      for (int n = 0; n < Ngating; ++n)
        y0[n + 3] = a[n] / (a[n] + b[n]);
    }

    public double[] gating_inf(double[] y)
    {
      double[] g = new double[Ngating];

      alpha(a, y);
      beta(b, y);

      for (int n = 0; n < Ngating; ++n)
        g[n] = a[n] / (a[n] + b[n]);

      return g;
    }

    public double[] gating_tau(double[] y)
    {
      double[] g = new double[Ngating];

      alpha(a, y);
      beta(b, y);

      for (int n = 0; n < Ngating; ++n)
        g[n] = 1 / (a[n] + b[n]);

      return g;
    }

    public override void dydt(double[] dydt, double t, double[] y, IStimulus stimulus)
    {
      double En = y[0];
      double Ei = y[1];
      double Rbb = getRbb(y);

      alpha(a, y);
      beta(b, y);

      dydt[0] = -(Iion_n(y) - stimulus.GetValue(t) - (Ei - En) / Rbb) / (Cn + Cm);
      dydt[1] = -(Iion_i(y) + (Ei - En) / Rbb - Cm * dydt[0]) / Ci;

      if (ClampKo == 1)
        dydt[2] = 0;
      else
        dydt[2] = (jK_i(y) + jPump(y))/Vpa;

      for (int n = 0; n < Ngating; ++n)
        dydt[n + 3] = a[n] * (1 - y[n + 3]) - b[n] * y[n + 3];
    }

    public double getRbb(double[] y)
    {
      double u = y[12];
      return 1 / ((1 / Ril) + u * gSL);
    }

    public double get_eKi(double[] y)
    {
      double Ko_i = y[2];
      return (R * Tk / F) * Math.Log(Ko_i / Ki);
    }

    public override double Iion_n(double[] y)
    {
      double E = y[0];
      double m = y[3];
      double h = y[4];
      double p = y[5];
      double n = y[6];
      double s = y[7];
      double i = y[8];

      double iNat = gNat_n*m*m*m*h*(E - eNa);
      double iNap = gNap_n*p*p*p*(E-eNa);
      double iKf  = gKf_n*n*n*n*n*(E-eK);
      double iKs  = gKs_n*s*(E-eK);
      double iKi = gKi_n * i * (E - eK);
      double iLk = gLk_n * (E - En);

      return iNat + iNap + iKf + iKs + iKi + iLk + iPump_n;
    }

    public override double Iion_i(double[] y)
    {
      double E = y[1];
      double s = y[9];
      double q = y[10];
      double i = y[11];
      double eK_i = get_eKi(y);

      double iKs = gKs_i * s * (E - eK_i);
      double iH = gH_K_i * q * (E - eK_i) + gH_Na_i * q * (E - eNa);
      double iKi = gKi_i * i * (E - eK_i);
      double iLk = gLk_i * (E - Ei);
      
      return iKs + iH + iLk + iPump_i;
    }

    public double jPump(double[] y)
    {
      double Ko_i = y[2];
      double k1 = 1 + (Km_Na + L_Na * Ki)/NAi;
      double k2 = 1 + (Km_K + L_K * NAo) / Ko_i;

      //return Jmax; // *(1 / (k1 * k1 * k1)) * (1 / (k2 * k2));
      return Jmax *(1 / (k1 * k1 * k1)) * (1 / (k2 * k2));
    }

    public double jK_i(double[] y)
    {
      double E = y[1];
      double s = y[9];
      double q = y[10];
      double i = y[11];
      double eK_i = get_eKi(y);

      double iKs = gKs_i * s * (E - eK_i);
      double iHk = gH_K_i * q * (E - eK_i);
      double iKi = gKi_i * i * (E - eK_i);

      return (iKs + iHk + iKi)/F;
    }

    public override void alpha(double[] a, double[] y)
    {
      double En = y[0];
      double Ei = y[1];
      double Ko_i = y[2];

      a[0] = type1(En, Am[0], Am[1], Am[2]); 
      a[1] = type2(En, Ah[0], Ah[1], Ah[2]);
      a[2] = type1(En, Ap[0], Ap[1], Ap[2]);
      a[3] = type1(En, An[0], An[1], An[2]);
      a[4] = type1(En, As[0], As[1], As[2]);
      a[5] = type1(En, Ai[0], Ai[1], Ai[2]);

      a[6] = type1(Ei, As[0], As[1], As[2]);
      a[7] = type5(Ei, Aq[0], Aq[1], Aq[2]);
      a[8] = type1(Ei, Ai[0], Ai[1], Ai[2]);

      a[9] = type1(Ko_i, Au[0], Au[1], Au[2]);
    }

    public override void beta(double[] b, double[] y)
    {
      double En = y[0];
      double Ei = y[1];
      double Ko_i = y[2];

      b[0] = type2(En, Bm[0], Bm[1], Bm[2]);
      b[1] = type3(En, Bh[0], Bh[1], Bh[2]);
      b[2] = type2(En, Bp[0], Bp[1], Bp[2]);
      b[3] = type2(En, Bn[0], Bn[1], Bn[2]);
      b[4] = type2(En, Bs[0], Bs[1], Bs[2]);
      b[5] = type2(En, Bi[0], Bi[1], Bi[2]);

      b[6] = type2(Ei, Bs[0], Bs[1], Bs[2]);
      b[7] = type4(Ei, Bq[0], Bq[1], Bq[2]);
      b[8] = type2(Ei, Bi[0], Bi[1], Bi[2]);

      b[9] = type2(Ko_i, Bu[0], Bu[1], Bu[2]);
    }

    public const double R = 8.3144;
    public const double F = 96485;

    public readonly double En; // Nodal resting potential
    public readonly double Ei; // Inter-nodal resting potential
    public readonly double eNa;
    public readonly double eK;

    public readonly double Ko;
    public readonly double Ki;
    public readonly double NAo;
    public readonly double NAi;

    public readonly double Tk;

    public readonly double gNat_n;
    public readonly double gNap_n;
    public readonly double gKf_n;
    public readonly double gKs_n;
    public readonly double gKi_n;
    public readonly double gLk_n;
    public readonly double iPump_n = 0;

    public readonly double gKs_i;
    public readonly double gKi_i;
    public readonly double gH_Na_i;
    public readonly double gH_K_i;
    public readonly double gLk_i;
    public readonly double iPump_i = 0;

    public readonly double gSL; // Maximal conductance of the S/L insisures

    public readonly double Vpa; // Volume of the peri-axonal space
    public readonly double Vi;  // Volume of the inter-node
    public readonly double L;   

    // Sodium Potassium Pump
    public readonly double Km_Na = 0;
    public readonly double Km_K = 0;
    public readonly double L_Na = 0;
    public readonly double L_K = 0;
    public readonly double Jmax = 0;
    public readonly int ClampKo = 0;

    public readonly double[] Am = new double[3];
    public readonly double[] Ah = new double[3];
    public readonly double[] Ap = new double[3];
    public readonly double[] An = new double[3];
    public readonly double[] As = new double[3];
    public readonly double[] Ai = new double[3];
    public readonly double[] Aq = new double[3];
    public readonly double[] Au = new double[3];

    public readonly double[] Bm = new double[3];
    public readonly double[] Bh = new double[3];
    public readonly double[] Bp = new double[3];
    public readonly double[] Bn = new double[3];
    public readonly double[] Bs = new double[3];
    public readonly double[] Bi = new double[3];
    public readonly double[] Bq = new double[3];
    public readonly double[] Bu = new double[3];
    public double Apa;
  }
}
