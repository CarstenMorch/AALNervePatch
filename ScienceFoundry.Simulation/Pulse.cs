using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public class Pulse : IStimulus
  {
    public Pulse()
    {
      Is = 0;
      Ts = 0;
    }

    public Pulse(double i, double t)
    {
      Is = i;
      Ts = t;
    }

    public double GetValue(double time)
    {
      return (time >= 0) && (time < Ts) ? Is : 0;
    }

    public double Is { get; set; }
    public double Ts { get; set; }
  }
}
