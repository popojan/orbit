#!/usr/bin/env wolframscript
(* Generate synthetic data from FOPDT (First-Order Plus Dead Time) system *)

Print["=== Synthetic System Data Generation ===\n"];

(* System parameters - typical industrial process (e.g., temperature control) *)
K = 2.0;      (* DC gain *)
tau = 0.5;    (* Dead time [s] *)
T = 3.0;      (* Time constant [s] *)

Print["True system (unknown to identification):"];
Print["G(s) = ", K, " * Exp[-", tau, "*s] / (", T, "*s + 1)"];
Print[""];

(* Transfer function in Laplace domain *)
G[s_] := K * Exp[-tau*s] / (T*s + 1);

(* Time domain response to step input (using inverse Laplace) *)
(* For step input u(t) = 1, output is: *)
StepResponse[t_] := If[t < tau,
    0,  (* Dead time - no response yet *)
    K * (1 - Exp[-(t - tau)/T])  (* First-order response after delay *)
];

(* Generate time series with measurement noise *)
dt = 0.1;  (* Sampling time [s] *)
tMax = 20.0;  (* Simulation time [s] *)
timePoints = Range[0, tMax, dt];

(* Clean output *)
yClean = StepResponse /@ timePoints;

(* Add measurement noise (±5% of final value) *)
SeedRandom[42];  (* Reproducible *)
noiseLevel = 0.05 * K;
noise = RandomVariate[NormalDistribution[0, noiseLevel], Length[timePoints]];
yNoisy = yClean + noise;

(* Input signal (step at t=0) *)
uInput = Table[1.0, {Length[timePoints]}];

(* Package data *)
data = Transpose[{timePoints, uInput, yClean, yNoisy}];

Print["Generated ", Length[data], " samples from t=0 to t=", tMax, " s"];
Print["Sampling time: ", dt, " s"];
Print["Noise level: ±", noiseLevel // N, " (±5% of steady-state)"];
Print[""];

(* Export to CSV *)
dataFile = "control-theory/data/synthetic_step_response.csv";
Export[dataFile,
    Prepend[data, {"time", "input", "output_clean", "output_noisy"}],
    "CSV"
];
Print["Data exported to: ", dataFile];
Print[""];

(* Visualization *)
Print["Generating plot..."];
plot = ListPlot[
    {
        Transpose[{timePoints, yClean}],
        Transpose[{timePoints, yNoisy}]
    },
    Joined -> {True, False},
    PlotStyle -> {Blue, {Red, PointSize[0.005]}},
    PlotLegends -> {"True response (no noise)", "Measured (with noise)"},
    AxesLabel -> {"Time [s]", "Output"},
    PlotLabel -> "Step Response: FOPDT System",
    GridLines -> Automatic,
    ImageSize -> Large
];

plotFile = "control-theory/visualizations/step_response.png";
Export[plotFile, plot, ImageResolution -> 150];
Print["Plot saved to: ", plotFile];
Print[""];

(* Summary statistics *)
Print["=== Summary ==="];
Print["Steady-state value: ", K];
Print["Time to reach 63.2% (1 time constant): ", tau + T, " s"];
Print["Time to reach 95%: ", tau + 3*T, " s"];
Print[""];

Print["✓ Synthetic data generation complete!"];
