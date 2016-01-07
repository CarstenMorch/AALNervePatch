using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public class PulseTrain : IStimulus
  {
    public PulseTrain()
    {
      Is = 1e-9;
      Ts = 100e-6;
      N = 3;
      Tperiod = 5e-3;
    }

    public PulseTrain(double i, double ts, int n, double tperiod)
    {
      Is = i;
      Ts = ts;
      N = n;
      Tperiod = tperiod;
    }

    public double GetValue(double time)
    {
      double retValue = 0;

      if ((time >= 0) && (time < N * Tperiod))
        retValue = (time % Tperiod) < Ts ? Is : 0;

      return retValue;
    }

    public double Is { get; set; }
    public double Ts { get; set; }
    public int N { get; set; }
    public double Tperiod { get; set; }
  }
}
