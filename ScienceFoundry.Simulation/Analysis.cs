using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public class AnalysisParameters
  {
    public AnalysisParameters(double[] y0)
    {
      this.y0 = y0;
      T1 = 0;
      T2 = 1e-3;
    }

    public double T1 { get; set; }
    public double T2 { get; set; }
    public double[] y0 { get; set; }
  }

  public class Analysis
  {
    public static double Threshold(AnalysisParameters P, PatchModel M, IStimulus Is)
    {
      var solver = new ModelSolver()
      {
        Model = M,
        H = 2e-6,
        T1 = P.T1,
        T2 = P.T2
      };

      return solver.EstimateThreshold(P.y0, Is);     
    }
  }
}
