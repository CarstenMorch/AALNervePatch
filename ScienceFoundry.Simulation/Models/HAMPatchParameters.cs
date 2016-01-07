using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch.Models
{
  public class HAMPatchParameters : Parameters
  {
    public HAMPatchParameters(double Dum)
    {
      D  = Dum*1e-6;
      di = (-0.468*Dum/(0.018*Dum-1));
      dn = 1e-6*(di + 0.67)/2.72;
      nl = (int) Math.Round(23.13 - 1.89*di + 142.79*Math.Log10(di));
      l  = 1e-6;
      L  = 1e-6*(-91.1 - 20.2*di + 1745.9*Math.Log10(di));
      di = 1e-6 * di;
      Pil = 0.147260607562123; 
      Wpa = 8e-9;
    }

    public override PatchModel Create()
    {
      return new HAMPatch(this);
    }

    public double D;
    public double di;
    public double dn;
    public int    nl;
    public double l;
    public double L;
    public double Pil;
    public double Wpa; // Width of the peri-axonal space

    public double T   = 37;       // Temperature
    public double NAi = 0.009;    // Internal sodium concentration
    public double NAo = 0.1442;   // External sodium concentration
    public double Ki  = 0.155;    // Internal potassium concentration
    public double Ko  = 0.003;    // External potassium concentration
    public double Vr  = -86e-3; // Nodal resting potential
    public double Vi  = -86e-3; // Inter-nodal resting potential
 
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
    public double q10i = 3.0;
    public double q10q = 3.0;
    public double q10u = 3.0;

    // Rate constants
    //                                 A         B        C
    public double[] Am = new double[] {1.86,     -18.4,   10.3}; // alpha_m
    public double[] Ah = new double[] {0.0336,   -111.0,  11};   // alpha_h
    public double[] Ap = new double[] {0.93,     -38.4,   10.3}; // alpha_p
    public double[] An = new double[] {0.00798,  -93.2,   1.1};  // alpha_n
    public double[] As = new double[] {0.00122,  -12.5,   23.6}; // alpha_s
    public double[] Ai = new double[] { 0.00122, -12.5, 23.6 }; // alpha_i
    public double[] Aq = new double[] { 0.00125, -107.3, 12.2 };  // alpha_q
    public double[] Au = new double[] { 0.00125e-2, 5, 0.5 }; // alpha_u
      
    //                                  A         B        C
    public double[] Bm = new double[] { 0.086,    -22.7,   9.16}; // beta_m
    public double[] Bh = new double[] { 2.3,      -28.8,   13.4}; // beta_h
    public double[] Bp = new double[] { 0.043,    -42.7,   9.16}; // beta_p
    public double[] Bn = new double[] { 0.0142,   -76,     10.5}; // beta_n
    public double[] Bs = new double[] { 0.000739, -80.1,   21.8}; // beta_s
    public double[] Bi = new double[] { 0.000739, -80.1, 21.8 }; // beta_i
    public double[] Bq = new double[] { 0.00125, -107.3, 12.2 };  // beta_q
    public double[] Bu = new double[] { 0.00125e-2,  5, 0.5 }; // alpha_u

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
    // Nodal Conductances
    public double gNa_n = 13000;             // 13pS single channel conductance
                                             // ~1000 channels per um^2
    public double pNap_n = 0.025;            // The fraction of sodium channels
                                             // that are persistent 
    public double gKs_n = 5214;
    public double gKi_n = 5214;
    public double gKf_n = 1671;         
    public double gLk_n = 181; 

    public double gKs_i = 0.0152;
    public double gKi_i = 0.0152;
    public double gH_i = 0.07796;
                                             // The inward-rectifying channels in the
                                             // internode.
    public double gH_SNa = 0.03;             // The selectivity of the IR channels for sodium 

    public double gLk_i = 0.1;
  
    public double nGsl = 5; // How many times the conductance of the Smidth-Lanterman
                            // incissures is larger than Gil conductance.

    // Sodium Potassium Pump
    public double Km_Na = 0.1e-3;
    public double Km_K = 4.5e-3;
    public double L_Na = 1e-2;
    public double L_K = 1e-3;

    public int ClampKo = 0;

    #endregion
    #region Electrical Parameters
    public double cn = 0.020;   //F/m^2 nodal capacitance
    public double ci = 0.010;   //F/m^2 internodal capacitance
    public double rho_i = 0.33; //Ohm*m
    public double cm = 0.020;   //F/m^2 myelin capacitance

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

    public double Gil
    {
      get
      {
        return (Math.PI*(Math.Pow(di+Pil*(D-di), 2) - Math.Pow(di, 2)))/(4*rho_i*L);
      }
    }

    public double Area_n
    {
      get
      {
        return Math.PI * dn * l;
      }
    }

    public double Area_i
    {
      get
      {
        return Math.PI * di * L;
      }
    }

    #endregion
  }
}
