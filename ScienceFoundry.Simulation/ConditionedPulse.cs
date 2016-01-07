using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public class ConditionedPulse : IStimulus
  {
    public ConditionedPulse()
    {

    }

    public ConditionedPulse(double Is, double Ts, double Ic, double Tc, double Tisi)
    {
      this.Is = Is;
      this.Ts = Ts;
      this.Ic = Ic;
      this.Tc = Tc;
      this.Tisi = Tisi;
    }

    public double GetValue(double time)
    {
      double retValue = 0;

      if ((time >= 0) && (time < Tc))
        retValue += Ic;

      if ((time - Tisi >= 0) && (time - Tisi < Ts))
        retValue += Is;

      return retValue;
    }

    public double Is { get; set; }
    public double Ts { get; set; }
    public double Ic { get; set; }
    public double Tc { get; set; }

    public double Tisi { get; set; }
  }
}
