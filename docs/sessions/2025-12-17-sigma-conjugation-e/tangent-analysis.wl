(* Tangent Direction Analysis for e-Spiral *)
(* g(t) = -16 π e t / (K_{2t-1}(-1/2) K_{2t+1}(-1/2)) *)

g[t_] := -16 Pi E t / (BesselK[2t-1, -1/2] BesselK[2t+1, -1/2]);

(* Derivative *)
gPrime[t_] := D[g[s], s] /. s -> t;

(* Tangent angle: arctan(Im[g']/Re[g']) *)
tangentAngle[t_] := ArcTan[Re[gPrime[t]], Im[gPrime[t]]] * 180 / Pi;

(* === Tangent at t = 0 === *)
Print["=== Tangent at t = 0 ==="];
g0Prime = Limit[gPrime[t], t -> 0];
Print["g'(0) = ", N[g0Prime, 10]];
Print["Angle at t=0: ", N[tangentAngle[0.001], 5], "°"];

(* === Tangent at real-axis crossings t = (2k+1)/4 === *)
Print["\n=== Tangent at crossings t = (2k+1)/4 ==="];
Do[
  tCross = (2 k + 1)/4;
  angle = tangentAngle[tCross];
  Print["k = ", k, " (t = ", N[tCross, 4], "): angle = ", N[angle, 5], "°"];
, {k, 0, 20, 5}];

(* === Ratio Im[g']/Re[g'] for large t === *)
Print["\n=== Im[g']/Re[g'] ratio for large t ==="];
Do[
  ratio = Im[gPrime[t]] / Re[gPrime[t]];
  Print["t = ", t, ": ratio = ", N[ratio, 8]];
, {t, {100, 200, 500, 1000}}];
Print["Target: -1/2 = -0.5 (?)"];

(* === Conclusion === *)
Print["\n=== Key Findings ==="];
Print["• Tangent at t=0: ~128°"];
Print["• Tangent at crossings → 180° as k → ∞"];
Print["• Ratio Im/Re → 0 (not -1/2)"];
Print["• Curve does NOT close smoothly at origin"];
