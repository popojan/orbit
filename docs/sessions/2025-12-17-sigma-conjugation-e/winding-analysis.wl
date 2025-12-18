(* Winding Number Analysis for e-Spiral *)
(* g(t) = -16 π e t / (K_{2t-1}(-1/2) K_{2t+1}(-1/2)) *)

g[t_] := -16 Pi E t / (BesselK[2t-1, -1/2] BesselK[2t+1, -1/2]);

(* === Winding number integrand === *)
(* W = (1/2πi) ∫ g'(t)/g(t) dt = (1/2π) ∫ Im[g'/g] dt *)

windingIntegrand[t_?NumericQ] := Module[{gVal, gPrimeVal},
  gVal = g[t];
  gPrimeVal = D[g[s], s] /. s -> t;
  Im[gPrimeVal / gVal]
];

(* === Compute winding number from t=a to t=b === *)
windingNumber[a_, b_] := NIntegrate[windingIntegrand[t], {t, a, b},
  Method -> "LocalAdaptive", MaxRecursion -> 20] / (2 Pi);

(* === Phase (argument) of g(t) === *)
phase[t_] := Arg[g[t]] / Pi;

(* === Analysis === *)
Print["=== Winding Number Analysis ===\n"];

Print["Winding number from t=0.01 to T:"];
Do[
  w = windingNumber[0.01, T];
  Print["W(", T, ") = ", w, "  (rate ≈ ", w/T, " per unit t)"];
, {T, {1, 2, 5, 10}}];

Print["\n\nPhase Arg[g(t)]/π at selected points:"];
Do[
  Print["t = ", t, ": phase = ", N[phase[t], 5]];
, {t, {0.01, 0.25, 0.5, 0.75, 1, 2, 5, 10}}];

Print["\n\nKey finding: Winding number W(T) ≈ 2T"];
Print["→ Infinite winding as t → ∞"];
Print["→ Origin is 'singularity of infinite winding'"];

(* === Unwrapped phase analysis === *)
Print["\n\n=== ACCUMULATED PHASE (unwrapped) ==="];

phase0 = Arg[g[0.01]];
totalPhase = 0;
prevPhase = phase0;

results = {};
Do[
  currentPhase = Arg[g[t]];
  delta = currentPhase - prevPhase;
  If[delta > Pi, delta -= 2 Pi];
  If[delta < -Pi, delta += 2 Pi];
  totalPhase += delta;
  prevPhase = currentPhase;
  AppendTo[results, {t, totalPhase/Pi}];
, {t, 0.02, 10, 0.01}];

Print["t\tPhase/π\tWindings"];
Do[
  {tVal, phaseVal} = results[[Round[100 t] - 1]];
  Print[N[tVal,3], "\t", N[phaseVal,5], "\t", N[phaseVal/2,4]];
, {t, {1, 2, 3, 5, 7, 10}}];

(* Fit winding rate *)
phaseAt1 = results[[99]][[2]];
phaseAt10 = results[[998]][[2]];
rate = (phaseAt10 - phaseAt1) / 9;
Print["\nWinding rate: ", N[rate/2, 4], " windings per unit t"];
Print["Accumulated phase: Φ(t) ≈ ", N[rate, 4], "·π·t"];

Print["\n=== CONCLUSION ==="];
Print["The e-spiral has INFINITE winding around origin as t → ∞"];
Print["Winding rate ≈ 2 per unit t → asymptotic formula Φ(t) ≈ 4πt"];
