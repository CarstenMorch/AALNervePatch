using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ScienceFoundry.Simulation.Patch
{
  public class ModelSolver
  {
    public ModelSolver()
    {
      Setup();
    }

    public double[,] Simulate(double[] y0, IStimulus stimulus)
    {
      Initialize(y0);
      double[,] retValue = new double[y.Length + 1, Nsave];
      int ns = skip;
      int p = 0;

      try
      {
        for (int n = 0; n < N; ++n)
        {
          if (ns == skip)
          {
            if (p < Nsave)
            {
              retValue[0, p] = t1 + n * h;

              for (int k = 0; k < y.Length; ++k)
                retValue[k + 1, p] = y[k];
            }
            p = p + 1;
            ns = 0;
          }
          ++ns;

          Integrate(t1 + n * h, stimulus);
        }
      }
      catch { }

      return retValue;
    }

    public double[] GetFinalState(double[] y0, IStimulus stimulus)
    {
      Initialize(y0);
      double[] retValue = new double[y.Length];

      try
      {
        for (int n = 0; n < N; ++n)
          Integrate(t1 + n * h, stimulus);

        for (int n = 0; n < y.Length; ++n)
          retValue[n] = y[n];
      }
      catch { }

      return retValue;
    }

    public bool IsActivated(double[] y0, IStimulus stimulus)
    {
      bool retValue = false;

      try
      {
        Initialize(y0);

        for (int n = 0; n < N; ++n)
        {
          Integrate(t1 + n * h, stimulus);

          if (y[0] > 0)
          {
            retValue = true;
            break;
          }
        }
      }
      catch { }

      return retValue;
    }

    public bool IsActivated(double[] y0, IStimulus stimulus, double Is)
    {
      stimulus.Is = Is;
      return IsActivated(y0, stimulus);
    }

    #region Threshold Estimation

    public double EstimateThreshold(double[] y0, IStimulus stimulus)
    {
      const int max_iter = 200;
      int count = 0;
      double I1 = 0;
      double I2 = 1e-9;

      try
      {
        while (!IsActivated(y0, stimulus, I2))
        {
          I1 = I2;
          I2 = 2 * I2;
          ++count;

          if (count > max_iter)
            break;
        }

        while (Math.Abs(I2 - I1) > 1e-12)
        {
          double Itest = (I2 - I1) / 2 + I1;

          if (IsActivated(y0, stimulus, Itest))
            I2 = Itest;
          else
            I1 = Itest;

          ++count;
          if (count > max_iter)
            break;
        }
      }
      catch { }

      return I2;
    }

    #endregion

    private void Integrate(double t, IStimulus stimulus)
    {
      model.dydt(dydt, t, y, stimulus);

      for (int n = 0; n < y.Length; ++n)
      {
        y[n] += h * dydt[n];

        if (y[n] > 1)
          y[n] = 1;
        if (y[n] < -1)
          y[n] = -1;
      }
    }

    private void Initialize(double[] y0)
    {
      y = new double[y0.Length];

      for (int i = 0; i < y0.Length; ++i)
        y[i] = y0[i];

      dydt = new double[y.Length];
    }

    private void Setup()
    {
      Nsave = (int)Math.Round((t2 - t1) / (skip * h));
      N = (int)Math.Round((t2 - t1) / h);
    }

    #region Properties 

    public double H
    {
      get 
      { 
        return h; 
      }
      set 
      { 
        h = value; 
        Setup(); 
      }
    }

    public double T1
    {
      get
      {
        return t1;
      }
      set
      {
        t1 = value;
        Setup();
      }
    }

    public double T2
    {
      get
      {
        return t2;
      }
      set
      {
        t2 = value;
        Setup();
      }
    }

    public int Skip
    {
      get
      {
        return skip;
      }
      set
      {
        skip = value;
        Setup();
      }
    }

    public int SimulationPoints
    {
      get
      {
        return N;
      }
    }

    public int StoragePoints
    {
      get
      {
        return Nsave;
      }
    }

    public PatchModel Model
    {
      get
      {
        return model;
      }
      set
      {
        model = value;
      }
    }

    #endregion
    #region Variables

    private double h = 1e-6;
    private double t1 = 0;
    private double t2 = 1e-3;
    private int skip = 1;
    private int Nsave;
    private int N;
    private PatchModel model;

    private double[] y;
    private double[] dydt;

    #endregion
  }
}
