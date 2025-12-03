(* Spacing Variance Analysis for Chebyshev B(n,k) values *)
(* Session: 2025-12-03 RMT-Chebyshev Connection *)

(* === Basic definitions === *)
beta[n_] := (n - Cot[Pi/n])/(4 n);
B[n_, k_] := 1 + beta[n] Cos[(2 k - 1) Pi/n];
betaInf = (Pi - 1)/(4 Pi);

(* === Key identity: B(n,k) = B(n, n-k+1) (degeneracy) === *)
(* Only n/2 unique B values for each n *)

(* === Arcsine spacing distribution === *)
(* theta uniform on [0,pi], spacing s = sin(theta) *)
(* P_arc(s) = (2/pi) / sqrt(1-s^2) for s in [0,1] *)

pArcsine[s_] := (2/Pi) / Sqrt[1 - s^2];

(* Mean and variance *)
meanArc = Integrate[s * pArcsine[s], {s, 0, 1}];  (* = 2/Pi *)
s2Arc = Integrate[s^2 * pArcsine[s], {s, 0, 1}];  (* = 1/2 *)
varArc = s2Arc - meanArc^2;  (* = 1/2 - 4/Pi^2 *)

(* Normalized variance (mean -> 1) *)
varArcNorm = varArc / meanArc^2;  (* = (Pi^2 - 8)/8 *)

Print["Arcsine spacing variance (normalized): ", Simplify[varArcNorm]];
Print["  = ", N[varArcNorm, 10]];

(* === GUE Wigner surmise === *)
pGUE[s_] := (32/Pi^2) s^2 Exp[-4 s^2/Pi];

(* GUE has mean 1 by construction *)
varGUE = 3 Pi/8 - 1;  (* Exact result *)

Print["GUE variance: 3*Pi/8 - 1 = ", N[varGUE, 10]];

(* === GOE Wigner surmise === *)
pGOE[s_] := (Pi/2) s Exp[-Pi s^2/4];

varGOE = 4/Pi - 1;  (* Exact result *)

Print["GOE variance: 4/Pi - 1 = ", N[varGOE, 10]];

(* === Comparison table === *)
Print["\n=== Variance Comparison ==="];
Print["Poisson:  Var = 1.000"];
Print["GOE:      Var = ", N[varGOE, 4]];
Print["Arcsine:  Var = ", N[varArcNorm, 4]];
Print["GUE:      Var = ", N[varGUE, 4]];

(* === Curious near-miss with Euler-Mascheroni gamma === *)
ratio2 = (varGUE / varArcNorm)^2;
Print["\n=== Gamma Connection ==="];
Print["(Var_GUE / Var_arcsine)^2 = ", N[ratio2, 10]];
Print["Euler-Mascheroni gamma = ", N[EulerGamma, 10]];
Print["Difference: ", N[(ratio2 - EulerGamma)/EulerGamma * 100, 4], "%"];

(* Near-miss: gamma + 3/847 *)
Print["\nNear-miss: gamma + 3/847 = ", N[EulerGamma + 3/847, 10]];
Print["Error: ", N[(ratio2 - EulerGamma - 3/847)/ratio2 * 10^6, 4], " ppm"];
Print["Note: 847 = 7 * 11^2 (pyramid numbers!)"];
