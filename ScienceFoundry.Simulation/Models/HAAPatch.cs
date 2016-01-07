using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch.Models
{
  public class HAAPatch : PatchModel
  {
    public HAAPatch(HAAPatchParameters p)
    {
      Ngating = 6;
      a = new double[Ngating];
      b = new double[Ngating];

      eNa = (R*p.Tk / F) * Math.Log(p.NAo / p.NAi);
      eK = (R*p.Tk / F) * Math.Log(p.Ko / p.Ki);

      Cm = p.Cm;
      Cn = p.Cn;
      Ci = p.Ci;
      Ril = p.Ril;

      // Ionic Currents
      p.CopyRateConstants(p.q10m, p.Am, Am);
      p.CopyRateConstants(p.q10h, p.Ah, Ah);
      p.CopyRateConstants(p.q10p, p.Ap, Ap);
      p.CopyRateConstants(p.q10n, p.An, An);
      p.CopyRateConstants(p.q10s, p.As, As);

      p.CopyRateConstants(p.q10m, p.Bm, Bm);
      p.CopyRateConstants(p.q10h, p.Bh, Bh);
      p.CopyRateConstants(p.q10p, p.Bp, Bp);
      p.CopyRateConstants(p.q10n, p.Bn, Bn);
      p.CopyRateConstants(p.q10s, p.Bs, Bs);

      // Conductances
      double area_n = Math.PI*p.dn*p.l;
      double area_i = Math.PI*p.di*p.L;

      gNat_n = (1-p.pNap_n) * p.gNa_n * area_n;
      gNap_n = p.pNap_n * p.gNa_n * area_n;
      gKf_n  = p.gKf_n * area_n;
      gKs_n  = p.gKs_n * area_n;

      gKs_i = p.gKs_i * area_i;
      gL_i = 0; // Temporary value

      // Calculate inter-nodal resting potential
      y0[0] = y0[1] = p.Vr;
      SetupGatingVariables();
      y0[1] = Ril * Iion_n(y0) + p.Vr; 

      // Calculate inter-nodal leak conductance
      SetupGatingVariables();
       gL_i = -(Iion_i(y0) + (y0[1]-y0[0])/Ril)/(y0[1] - eNa);
    }

    public override double Iion_n(double[] y)
    {
      double E = y[0];
      double m = y[2];
      double h = y[3];
      double p = y[4];
      double n = y[5];
      double s = y[6];

      double iNat = gNat_n*m*m*m*h*(E - eNa);
      double iNap = gNap_n*p*p*p*(E-eNa);
      double iKf  = gKf_n*n*n*n*n*(E-eK);
      double iKs  = gKs_n*s*(E-eK);

      return iNat + iNap + iKf + iKs;
    }

    public override double Iion_i(double[] y)
    {
      double E = y[1];
      double s = y[7];

      double iKs = gKs_i*s*(E-eK);
      double iL  = gL_i*(E-eNa);

      return iKs + iL;
    }

    public override void alpha(double[] a, double[] y)
    {
      double En = y[0];
      double Ei = y[1];

      a[0] = type1(En, Am[0], Am[1], Am[2]); 
      a[1] = type2(En, Ah[0], Ah[1], Ah[2]);
      a[2] = type1(En, Ap[0], Ap[1], Ap[2]);
      a[3] = type1(En, An[0], An[1], An[2]);
      a[4] = type1(En, As[0], As[1], As[2]);
      a[5] = type1(Ei, As[0], As[1], As[2]);
    }

    public override void beta(double[] b, double[] y)
    {
      double En = y[0];
      double Ei = y[1];

      b[0] = type2(En, Bm[0], Bm[1], Bm[2]);
      b[1] = type3(En, Bh[0], Bh[1], Bh[2]);
      b[2] = type2(En, Bp[0], Bp[1], Bp[2]);
      b[3] = type2(En, Bn[0], Bn[1], Bn[2]);
      b[4] = type2(En, Bs[0], Bs[1], Bs[2]);
      b[5] = type2(Ei, Bs[0], Bs[1], Bs[2]);
    }

    public const double R = 8.3144;
    public const double F = 96485;

    public readonly double eNa;
    public readonly double eK;
    public readonly double gNat_n;
    public readonly double gNap_n;
    public readonly double gKf_n;
    public readonly double gKs_n;

    public readonly double gKs_i;
    public readonly double gL_i;

    public readonly double[] Am = new double[3];
    public readonly double[] Ah = new double[3];
    public readonly double[] Ap = new double[3];
    public readonly double[] An = new double[3];
    public readonly double[] As = new double[3];

    public readonly double[] Bm = new double[3];
    public readonly double[] Bh = new double[3];
    public readonly double[] Bp = new double[3];
    public readonly double[] Bn = new double[3];
    public readonly double[] Bs = new double[3];
  }
}
