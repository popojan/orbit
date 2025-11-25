#!/usr/bin/env wolframscript
(* Debug k=5 mismatch *)

Print["=== DEBUGGING k=5 MISMATCH ===\n"];

k = 5;
n = Ceiling[k/2];  (* n=3 *)
m = Floor[k/2];    (* m=2 *)

Print["k=", k, ", n=", n, ", m=", m, "\n"];

(* Ground truth: direct expansion *)
tn = ChebyshevT[n, x+1] // Expand;
um = ChebyshevU[m, x+1] // Expand;
umPrev = ChebyshevU[m-1, x+1] // Expand;
deltaU = um - umPrev // Expand;

product = tn * deltaU // Expand;
factForm = 1 + Sum[2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]), {i, 1, k}] // Expand;

Print["Ground truth (direct expansion):"];
Print["T_", n, "(x+1) = ", tn];
Print["U_", m, "(x+1) - U_", m-1, "(x+1) = ", deltaU];
Print["Product = ", product];
Print["Factorial form = ", factForm];
Print[];

prodCoeffs = CoefficientList[product, x];
factCoeffs = CoefficientList[factForm, x];

Print["Coefficients comparison:"];
Do[
  Print["  [x^", i, "]: product=", prodCoeffs[[i+1]], ", factorial=", factCoeffs[[i+1]],
        ", match=", prodCoeffs[[i+1]] == factCoeffs[[i+1]]];
, {i, 0, k}];

Print["\n=== CONCLUSION ==="];
If[prodCoeffs == factCoeffs,
  Print["Direct expansion: PERFECT MATCH \[CheckedBox]"];
  Print["Bug is in my coefficient extraction formulas, not in the identity itself!"];
,
  Print["ERROR: Direct expansion doesn't match! Identity may be wrong!"];
];
