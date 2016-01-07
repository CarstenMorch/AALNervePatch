using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public class Ramp : IStimulus
  {
    public Ramp()
    {

    }

    public Ramp(double Is, double Ts)
    {
      this.Is = Is;
      this.Ts = Ts;
    }

    public double GetValue(double time)
    {
      return (time >= 0) && (time < Ts) ? Is*(time/Ts) : 0;
    }

    public double Is { get; set; }
    public double Ts { get; set; }
  }
}
