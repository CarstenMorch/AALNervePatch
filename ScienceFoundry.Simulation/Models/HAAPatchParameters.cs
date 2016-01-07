using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch.Models
{
  public class HAAPatchParameters : Parameters
  {
    public HAAPatchParameters(double Dum)
    {
      D  = Dum*1e-6;
      di = (-0.468*Dum/(0.018*Dum-1));
      dn = 1e-6*(di + 0.67)/2.72;
      nl = (int) Math.Round(23.13 - 1.89*di + 142.79*Math.Log10(di));
      l  = 2e-6;
      L  = 1e-6*(-91.1 - 20.2*di + 1745.9*Math.Log10(di));
      di = 1e-6 * di;
      Pil = 0.147260607562123; 
    }

    public override PatchModel Create()
    {
      return new HAAPatch(this);
    }

    public double D;
    public double di;
    public double dn;
    public int nl;
    public double l;
    public double L;
    public double Pil;

    public double T   = 37;       // Temperature
    public double NAi = 0.009;    // Internal sodium concentration
    public double NAo = 0.1442;   // External sodium concentration
    public double Ki  = 0.155;    // Internal potassium concentration
    public double Ko  = 0.003;    // External potassium concentration
    public double Vr  = -83.5e-3; // Nodal resting potential

    public double Tk
    {
      get
      {
        return T + 273.15; 
      }
    }

    #region Rate constants
    /* Q10 Factors
     The Q10 factors are used to scale the rate contants with temperature, so
     the values that have been determined at ~20 Celcius can be used to
     simulate nerve fibers at a body temperature of 37 Celcius. The rate
     contants are scaled by multiplying the rate constant alpha(V) with the
     Q10(T). Q10(T) is calculated as:

        Q10(T) = q^((T-20)/10);

     where q is the corresponding Q10 factor given below for a specific gating
     variable. 
     */
    public double q10m = 2.2;
    public double q10h = 2.9;
    public double q10p = 2.2;
    public double q10n = 3.0;
    public double q10s = 3.0;

    // Rate constants
    //                                  A         B        C
    public double[] Am = new double[]  {1.86,     -18.4,   10.3}; // alpha_m
    public double[] Ah = new double[]  {0.0336,   -111.0,  11};   // alpha_h
    public double[] Ap = new double[]  {0.93,     -38.4,   10.3}; // alpha_p
    public double[] An = new double[]  {0.00798,  -93.2,   1.1};  // alpha_n
    public double[] As = new double[]  {0.00122,  -12.5,   16.9}; // alpha_s
      
    //                                  A         B        C
    public double[] Bm = new double[] { 0.086,    -22.7,   9.16}; // beta_m
    public double[] Bh = new double[] { 2.3,      -28.8,   13.4}; // beta_h
    public double[] Bp = new double[] { 0.043,    -42.7,   9.16}; // beta_p
    public double[] Bn = new double[] { 0.0142,   -76,     10.5}; // beta_n
    public double[] Bs = new double[] { 0.000739, -80.1,   12.6}; // beta_s

    public void CopyRateConstants(double q, double[] src, double[] dst)
    {
      dst[0] = 1e3 * Q10(q) * src[0]; //1e3 is to make it in s instead of ms
      dst[1] = src[1];
      dst[2] = src[2];
    }

    public double Q10(double q)
    {
      return Math.Pow(q, (T-20)/10);
    }

    #endregion
    #region Ionic conductances

    // Conductances per unit area
    public double gNa_n = 13e-12*1000*1e12;  // 13pS single channel conductance
                                             // ~1000 channels per um^2
    public double pNap_n = 0.01;             // The fraction of sodium channels
                                             // that are persistent
 
    public double gKs_n = 8e-12*100*1e12;    // 8pS single channel conductance
                                             // ~100 channels per um^2
    public double gKf_n = 15*(2/1.4);        // 15nS conductance for a 1.4pF 
                                             // capacitive load. Hence, conductance
                                             // gKf per unit area:
                                             //
                                             //   gKf = 15nS*(cn/1.4pF)

    public double gKs_i = 0.002872263650871 * (8e-12 * 100 * 1e12);
                                          // The slow potassium conductance in 
                                          // the internode is currently unknown
                                          // and is consequently a free
                                          // parameter. Its value is important
    // in order to reproduce threshold
    #endregion
    #region Electrical Parameters
    private const double cn = 0.020;   //F/m^2 nodal capacitance
    private const double ci = 0.010;   //F/m^2 internodal capacitance
    private const double rho_i = 0.33; //Ohm*m
    private const double cm = 0.001;   //F/m^2 myelin capacitance

    public double Cm
    {
      get
      {
        double tmp = 0;
        double dy = (D-di)/(2*nl);
        double y = di;

        for (int n = 0; n < 2*nl; ++n)
        {
          tmp = tmp + 1/(cm*Math.PI*y*L);
          y = y + dy;
        }

        return 1/tmp;
      }
    }

    public double Cn
    {
      get
      {
        return cn*Math.PI*dn*l;
      }
    }

    public double Ci
    {
      get
      {
        return ci*Math.PI*di*L;
      }
    }

    public double Ril
    {
      get
      {
        return 1/((Math.PI*(Math.Pow(di+Pil*(D-di), 2) - Math.Pow(di, 2))/(4*rho_i*L)));
      }
    }

    #endregion
  }
}
