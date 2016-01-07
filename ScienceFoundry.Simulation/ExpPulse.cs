using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public class ExpPulse : IStimulus
  {
    public ExpPulse()
    {
       Is = 0;
       Ts = 0;
       Tau = 1;
    }

    public double GetValue(double time)
    {
       if ((time >= 0) && (time < Ts))
          return Is * (Math.Exp(time/Tau)-1) / (Math.Exp(Ts/Tau)-1);
       else
          return 0;
    }

    public double Is { get; set; }
    public double Ts { get; set; }
    public double Tau { get; set; }
  }
}
