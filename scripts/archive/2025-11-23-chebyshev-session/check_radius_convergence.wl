#!/usr/bin/env wolframscript

Print["RADIUS OF CONVERGENCE CHECK"];
Print[StringRepeat["=", 70]];
Print[];

(* AB definition - simplified, NO absolute value *)
AB[k_] := 1/k /; OddQ[k];
AB[k_] := -(1/2)(1/(k+1) + 1/(k-1)) /; EvenQ[k];

(* Closed form *)
GClosed[z_] := ArcTanh[z] + (2*z + (1+z^2)*Log[(z-1)^2]/2 - (1+z^2)*Log[1+z])/(4*z);

Print["Testing z=10 (OUTSIDE radius of convergence):"];
Print[];

Print["Direct sum (should diverge or not converge):"];
partialSums = Table[
  {n, Sum[AB[k]*10^k, {k, 1, n}] // N},
  {n, {5, 10, 15, 20}}
];
Do[Print["  N=", partialSums[[i,1]], ": ", partialSums[[i,2]]], {i, 1, Length[partialSums]}];
Print[];
Print["→ Series DIVERGES for z=10"];
Print[];

Print["Closed form G(10):"];
g10 = GClosed[10];
Print["  Symbolic: ", g10];
Print["  Numerical: ", N[g10]];
Print["  Is complex? ", Im[N[g10]] != 0];
Print[];

Print[StringRepeat["=", 70]];
Print["RADIUS OF CONVERGENCE"];
Print[StringRepeat["=", 70]];
Print[];

Print["For power series Σ a_k z^k, radius R is determined by:"];
Print["  1/R = limsup_{k→∞} |a_k|^{1/k}"];
Print[];

Print["For our series:"];
Print["  Odd k: |AB[2m+1]| = 1/(2m+1) → |a_k|^{1/k} → 1 as k→∞"];
Print["  Even k: |AB[2m]| ~ 1/(2m) → |a_k|^{1/k} → 1 as k→∞"];
Print[];
Print["Therefore: R = 1"];
Print[];
Print["Series converges for |z| < 1, diverges for |z| > 1"];
Print[];

Print[StringRepeat["=", 70]];
Print["VALID RANGE"];
Print[StringRepeat["=", 70]];
Print[];

Print["Closed form G(z) = ArcTanh[z] + ... is valid for |z| < 1"];
Print[];
Print["For |z| ≥ 1:"];
Print["  - ArcTanh[z] becomes complex (for real z > 1)"];
Print["  - Series diverges"];
Print["  - Closed form is analytic continuation, not series sum"];
Print[];

Print["Testing boundary z=1:"];
Print["  lim_{z→1⁻} G(z) = ?"];
Print[];

(* Approach z=1 from below *)
zVals = {0.9, 0.95, 0.99, 0.999, 0.9999};
Do[
  g = N[GClosed[z], 10];
  Print["  z=", z, ": G(z) = ", g];
, {z, zVals}];
Print[];

Print["At z=1: Σ AB[k] = 1/2 (from earlier analysis)"];
Print["But closed form has pole at z=1 → need limit"];
Print[];

Print["DONE!"];
