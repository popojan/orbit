#!/usr/bin/env wolframscript
(* Trace EXACTLY what Sum does *)

Print["=== Deep Trace of Sum Evaluation ===\n"];

term[x_, k_, i_] := 2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);

Print["We want to understand this transformation:"];
Print["Sum[2^(i-1) * x^i * (k+i)!/((k-i)!(2i)!), {i, 1, k}]"];
Print["→ Cosh[(1+2k)*ArcSinh[√(x/2)]]/(√2√(2+x))"];
Print[];

Print["Step 1: Trace with TraceInternal"];
Print["==================================\n"];

(* Capture all internal steps *)
traced = Trace[
  Sum[term[x, k, i], {i, 1, k}],
  TraceInternal -> True,
  TraceOriginal -> True
];

Print["Total traced expressions: ", Length[Flatten[traced]]];
Print[];

(* Look for specific functions *)
Print["Step 2: Check for specific functions in trace"];
Print["==============================================\n"];

flatTrace = Flatten[traced];

(* Search for key functions *)
hasHyper = Select[flatTrace, Not[FreeQ[#, HypergeometricPFQ]] &];
hasCosh = Select[flatTrace, Not[FreeQ[#, Cosh]] &];
hasGamma = Select[flatTrace, Not[FreeQ[#, Gamma]] &];
hasPoch = Select[flatTrace, Not[FreeQ[#, Pochhammer]] &];

Print["Uses HypergeometricPFQ: ", Length[hasHyper] > 0, " (", Length[hasHyper], " times)"];
Print["Uses Cosh: ", Length[hasCosh] > 0, " (", Length[hasCosh], " times)"];
Print["Uses Gamma: ", Length[hasGamma] > 0, " (", Length[hasGamma], " times)"];
Print["Uses Pochhammer: ", Length[hasPoch] > 0, " (", Length[hasPoch], " times)"];
Print[];

If[Length[hasHyper] > 0,
  Print["Hypergeometric expressions found:"];
  Do[Print[expr], {expr, Take[hasHyper, Min[3, Length[hasHyper]]]}];
  Print[];
];

Print["Step 3: Try evaluating step-by-step manually"];
Print["=============================================\n"];

(* Rewrite using Pochhammer *)
Print["Series can be written as:"];
Print["Sum[2^(i-1) * x^i * Pochhammer[k-i+1, 2i]/(2i)!, {i, 1, k}]"];
Print[];

(* Try recognizing as generalized hypergeometric *)
Print["This looks like a truncated hypergeometric series."];
Print["General form: HypergeometricPFQ[{a1,...,ap}, {b1,...,bq}, z]"];
Print[];

Print["Step 4: Check Mathematica documentation"];
Print["=========================================\n"];

Print["Let's check if this series matches a known identity in DLMF or Abramowitz-Stegun."];
Print[];

Print["The transformation Sum does is likely documented in:"];
Print["- NIST DLMF Chapter 15 (Hypergeometric Function)"];
Print["- NIST DLMF Chapter 4 (Elementary Functions - hyperbolic)"];
Print["- Gradshteyn & Ryzhik (Table of Integrals)"];
Print[];

Print["Step 5: Reverse check - expand hyperbolic form"];
Print["===============================================\n"];

hypForm[x_, k_] := Cosh[(1+2*k)*ArcSinh[Sqrt[x/2]]]/(Sqrt[2]*Sqrt[2+x]);

Print["Let's try Series expansion of hyperbolic form around x=0:"];
Do[
  series = Normal[Series[hypForm[x, kval], {x, 0, kval}]];
  Print["k=", kval, ": ", series // TraditionalForm];
, {kval, 1, 3}];

Print[];
Print["Compare with factorial sums:"];
Do[
  facSum = Sum[term[x, kval, i], {i, 1, kval}];
  Print["k=", kval, ": ", facSum // Expand // TraditionalForm];
, {kval, 1, 3}];

Print[];
Print["=== Key Insight Needed ==="];
Print["We need to find the identity that connects:"];
Print["Sum[2^(i-1) * x^i * Pochhammer[k-i+1, 2i]/(2i)!, {i, 1, k}]"];
Print["with"];
Print["Cosh[(1+2k)*ArcSinh[√(x/2)]]/(√2√(2+x))"];
