#!/usr/bin/env wolframscript
(* Visualization of L_M(s) in Complex Plane *)

Print["=== L_M(s) Complex Plane Visualization ===\n"];

(* Define L_M via closed form *)
(* L_M(s) = Zeta[s](Zeta[s]-1) - C(s) *)
(* C(s) = Sum[HarmonicNumber[j-1,s]/j^s, {j,2,Infinity}] *)

(* For visualization, use finite approximation *)
CApprox[s_, jmax_:500] := Sum[HarmonicNumber[j-1, s]/j^s, {j, 2, jmax}];

LM[s_, jmax_:500] := Zeta[s]*(Zeta[s] - 1) - CApprox[s, jmax];

Print["L_M(s) defined via closed form with jmax=500\n"];

(* Test at s=2 *)
testVal = LM[2];
Print["Test: L_M(2) = ", N[testVal, 10]];
Print["Expected: ~0.249...\n"];

(* Region 1: Near the pole at s=1 *)
Print["Generating ComplexPlot near s=1 (pole region)..."];
plot1 = ComplexPlot[LM[s], {s, 0.5 - 0.5*I, 1.5 + 0.5*I},
  PlotLabel -> "L_M(s) near pole s=1",
  ImageSize -> 600,
  ColorFunction -> "CyclicLogAbsArg",
  PlotLegends -> Automatic,
  PlotPoints -> 50
];
Export["visualizations/L_M_near_pole.pdf", plot1];
Print["Saved: visualizations/L_M_near_pole.pdf\n"];

(* Region 2: Critical strip Re(s) ∈ [0,1] *)
Print["Generating ComplexPlot for critical strip..."];
plot2 = ComplexPlot[LM[s], {s, 0 - 30*I, 1 + 30*I},
  PlotLabel -> "L_M(s) in critical strip Re(s) ∈ [0,1]",
  ImageSize -> 600,
  ColorFunction -> "CyclicLogAbsArg",
  PlotLegends -> Automatic,
  PlotPoints -> 50,
  Exclusions -> {Re[s] == 1} (* Avoid pole *)
];
Export["visualizations/L_M_critical_strip.pdf", plot2];
Print["Saved: visualizations/L_M_critical_strip.pdf\n"];

(* Region 3: Critical line Re(s) = 1/2 *)
Print["Plotting |L_M(1/2 + it)| on critical line..."];
tVals = Table[t, {t, 0, 50, 0.5}];
magVals = Table[Abs[LM[1/2 + I*t]], {t, tVals}];
plot3 = ListLinePlot[Transpose[{tVals, magVals}],
  PlotLabel -> "|L_M(1/2 + it)| on critical line",
  AxesLabel -> {"t", "|L_M(1/2+it)|"},
  ImageSize -> 600,
  GridLines -> Automatic
];
Export["visualizations/L_M_critical_line_magnitude.pdf", plot3];
Print["Saved: visualizations/L_M_critical_line_magnitude.pdf\n"];

(* Region 4: Phase plot on critical line *)
Print["Plotting arg(L_M(1/2 + it)) on critical line..."];
phaseVals = Table[Arg[LM[1/2 + I*t]], {t, tVals}];
plot4 = ListLinePlot[Transpose[{tVals, phaseVals}],
  PlotLabel -> "arg(L_M(1/2 + it)) on critical line",
  AxesLabel -> {"t", "Phase (radians)"},
  ImageSize -> 600,
  GridLines -> Automatic
];
Export["visualizations/L_M_critical_line_phase.pdf", plot4];
Print["Saved: visualizations/L_M_critical_line_phase.pdf\n"];

(* Region 5: Schwarz symmetry check *)
Print["Verifying Schwarz symmetry L_M(conj(s)) = conj(L_M(s))..."];
testPoints = {1/2 + 10*I, 1/2 + 20*I, 1/2 + 14.135*I};
Print["Testing at s = 1/2 + it for various t:\n"];
Do[
  s0 = pt;
  val1 = LM[Conjugate[s0]];
  val2 = Conjugate[LM[s0]];
  diff = Abs[val1 - val2];
  Print["  s = ", s0];
  Print["    L_M(conj(s)) = ", N[val1, 6]];
  Print["    conj(L_M(s)) = ", N[val2, 6]];
  Print["    |difference| = ", N[diff, 6]];
  If[diff < 10^-10, Print["    ✓ Schwarz symmetry holds"], Print["    ✗ Discrepancy!"]];
  Print[""];
, {pt, testPoints}];

(* Region 6: Search for zeros near critical line *)
Print["Searching for zeros of L_M(s) near critical line..."];
Print["(This may take a moment...)\n"];

zeroSearch = {};
Do[
  s0 = 1/2 + I*t0;
  Try[
    zero = FindRoot[LM[s] == 0, {s, s0}, WorkingPrecision -> 30];
    zeroVal = s /. zero;
    (* Verify it's actually a zero *)
    residual = Abs[LM[zeroVal]];
    If[residual < 10^-5,
      AppendTo[zeroSearch, zeroVal];
      Print["  Found zero at s = ", N[zeroVal, 8], " (residual: ", N[residual, 3], ")"];
    ];
  ];
, {t0, 5, 50, 5}]; (* Search every 5 units along critical line *)

If[Length[zeroSearch] > 0,
  Print["\nFound ", Length[zeroSearch], " zeros."];
  Print["First few: ", Take[zeroSearch, UpTo[5]]];
,
  Print["\nNo zeros found in searched region."];
];

Print["\n=== Visualization Complete ==="];
Print["Check visualizations/ directory for PDF outputs."];
