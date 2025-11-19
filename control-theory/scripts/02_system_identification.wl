#!/usr/bin/env wolframscript
(* System Identification from Step Response Data - WOLFRAM APPROACH *)

Print["=== System Identification: FOPDT Model ===\n"];

(* Load data *)
data = Import["control-theory/data/synthetic_step_response.csv", "CSV", "HeaderLines" -> 1];
time = data[[All, 1]];
input = data[[All, 2]];
outputNoisy = data[[All, 4]];  (* Use noisy measurements *)

Print["Loaded ", Length[time], " data points"];
Print[""];

(* ===================================== *)
(* Method: Fit FOPDT model to step data *)
(* ===================================== *)

(* FOPDT step response: y(t) = K*(1 - Exp[-(t-tau)/T]) for t >= tau *)
fopdt StepModel[t_, K_, tau_, T_] := If[t < tau,
    0,
    K * (1 - Exp[-(t - tau)/T])
];

(* Nonlinear fit to noisy data *)
Print["Fitting FOPDT model: G(s) = K*Exp[-tau*s]/(T*s+1)"];
Print["This may take a moment..."];

fit = NonlinearModelFit[
    Transpose[{time, outputNoisy}],
    fopdt StepModel[t, K, tau, T],
    {
        {K, 2.0},   (* Initial guess *)
        {tau, 0.5},
        {T, 3.0}
    },
    t,
    Method -> "NMinimize"
];

(* Extract identified parameters *)
K_id = K /. fit["BestFitParameters"];
tau_id = tau /. fit["BestFitParameters"];
T_id = T /. fit["BestFitParameters"];

Print[""];
Print["=== Identified Parameters ==="];
Print["K   = ", K_id];
Print["tau = ", tau_id, " s"];
Print["T   = ", T_id, " s"];
Print[""];

(* Compare with true values *)
Print["True values:"];
Print["K   = 2.0"];
Print["tau = 0.5 s"];
Print["T   = 3.0 s"];
Print[""];

(* Fit quality *)
Print["R² = ", fit["RSquared"]];
Print[""];

(* ============================== *)
(* Construct identified model *)
(* ============================== *)

G_identified[s_] := K_id * Exp[-tau_id * s] / (T_id * s + 1);

Print["Identified transfer function (symbolic):"];
Print["G(s) = ", G_identified[s]];
Print[""];

(* Export for LaTeX *)
Print["LaTeX form:"];
Print[TeXForm[G_identified[s]]];
Print[""];

(* ============================== *)
(* Validation plot *)
(* ============================== *)

yFitted = fopdt StepModel[#, K_id, tau_id, T_id] & /@ time;

plot = ListPlot[
    {
        Transpose[{time, outputNoisy}],
        Transpose[{time, yFitted}]
    },
    PlotStyle -> {{Red, PointSize[0.005]}, {Blue, Thick}},
    PlotLegends -> {"Measured data", "Identified model"},
    Joined -> {False, True},
    AxesLabel -> {"Time [s]", "Output"},
    PlotLabel -> "System Identification: FOPDT Model Fit",
    GridLines -> Automatic,
    ImageSize -> Large
];

Export["control-theory/visualizations/system_identification.png", plot, ImageResolution -> 150];
Print["✓ Validation plot saved"];
Print[""];

(* ============================== *)
(* Model validation statistics *)
(* ============================== *)

residuals = outputNoisy - yFitted;
rmse = Sqrt[Mean[residuals^2]];
mae = Mean[Abs[residuals]];

Print["=== Model Validation ==="];
Print["RMSE = ", rmse];
Print["MAE  = ", mae];
Print[""];

Print["✓ System identification complete!");
Print[""];

(* ============================== *)
(* WOLFRAM ADVANTAGE SUMMARY *)
(* ============================== *)

Print["=" <> StringRepeat["=", 60]];
Print["WOLFRAM ADVANTAGES for System Identification:"];
Print["=" <> StringRepeat["=", 60]];
Print["✓ NonlinearModelFit - built-in, handles constraints"];
Print["✓ Symbolic transfer function G(s) = K*Exp[-tau*s]/.."];
Print["✓ Native delay support (no Pade approximation needed)"];
Print["✓ LaTeX export: TeXForm[G[s]] → copy to paper"];
Print["✓ One-liner plots with legends"];
Print["✓ Built-in fit statistics (R², residuals, etc.)"];
Print["=" <> StringRepeat["=", 60]];
