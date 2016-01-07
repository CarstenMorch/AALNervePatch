using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public abstract class PatchModel
  {
    #region Model

    public virtual void dydt(double[] dydt, double t, double[] y, IStimulus stimulus)
    {
      double En = y[0];
      double Ei = y[1];

      alpha(a, y);
      beta(b, y);

      dydt[0] = -(Iion_n(y) - stimulus.GetValue(t) - (Ei - En) / Ril) / (Cn + Cm);
      dydt[1] = -(Iion_i(y) + (Ei - En) / Ril - Cm * dydt[0]) / Ci;

      for (int n = 0; n < Ngating; ++n)
        dydt[n + 2] = a[n] * (1 - y[n + 2]) - b[n] * y[n + 2]; 
    }

    protected virtual void SetupGatingVariables()
    {
      alpha(a, y0);
      beta(b, y0);

      for (int n = 0; n < Ngating; ++n)
        y0[n + 2] = a[n] / (a[n] + b[n]);
    }

    public double[] Y0
    {
      get
      {
        double[] retValue = new double[y0.Length];

        for (int i = 0; i < y0.Length; ++i)
          retValue[i] = y0[i];

        return retValue;
      }
    }

    public abstract double Iion_n(double[] y);

    public abstract double Iion_i(double[] y);

    public abstract void alpha(double[] a, double[] y);

    public abstract void beta(double[] b, double[] y);

    #endregion
    #region Rate constants

    public double type1(double E, double A, double B, double C)
    {
      double retValue = 0;
      E = 1e3*E;

      if (Math.Abs(E-B) > 1e-3)
        retValue = (A*(E-B))/(1 - Math.Exp((B-E)/C));
      else
        retValue = A*C;

      return retValue;
    }

    public double type2(double E, double A, double B, double C)
    {
      double retValue = 0;
      E = 1e3 * E;

      if (Math.Abs(B - E) > 1e-3)
        retValue = (A * (B - E)) / (1 - Math.Exp((E - B) / C));
      else
        retValue = A * C;

      return retValue;
    }

    public double type3(double E, double A, double B, double C)
    {
      E = 1e3 * E;
      return A / (1 + Math.Exp((B - E) / C));
    }

    public double type4(double E, double A, double B, double C)
    {
      E = 1e3 * E;
      return A * Math.Exp((E - B) / C);
    }

    public double type5(double E, double A, double B, double C)
    {
      E = 1e3 * E;
      return A / Math.Exp((E - B) / C);
    }

    #endregion
    #region Model parameters

    public double Cn;
    public double Cm;
    public double Ci;
    public double Ril;

    public double[] a;
    public double[] b;
    protected int Ngating;

    protected double[] y0 = new double[8];

    #endregion
  }
}
