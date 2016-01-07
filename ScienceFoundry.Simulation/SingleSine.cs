using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public class SingleSine : IStimulus
  {
    public SingleSine()
    {
       Is = 0;
       Ts = 0;
       N = 1;
    }

    public double GetValue(double time)
    {
       if ((time >= 0) && (time < Ts))
          return Is * Math.Sin(2 * N * Math.PI * time / (Ts * N));
       else
          return 0;
    }

    public double Is { get; set; }
    public double Ts { get; set; }
    public int N { get; set; }
  }
}
