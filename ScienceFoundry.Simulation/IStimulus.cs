using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public interface IStimulus
  {
    double GetValue(double time);

    double Is { get; set; }
    double Ts { get; set; }
  }
}
