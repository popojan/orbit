#!/usr/bin/env wolframscript
(* Reverse-engineer what Mathematica Sum does with factorial form *)

Print["=== Reverse Engineering Mathematica Sum ===\n"];

(* Factorial form of D(x,k) *)
factorialTerm[x_, k_, i_] := 2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);

factorialSum[x_, k_] := 1 + Sum[factorialTerm[x, k, i], {i, 1, k}];

(* Expected hyperbolic result *)
hyperbolicForm[x_, k_] := 1/2 + Cosh[(1+2*k)*ArcSinh[Sqrt[x/2]]]/(Sqrt[2]*Sqrt[2+x]);

Print["Step 1: Evaluate factorial sum for k=3 symbolically"];
Print["========================================================\n"];

(* Simple case k=3 *)
k = 3;
Print["factorialSum[x, 3] = "];
result3 = factorialSum[x, k];
Print[result3 // TraditionalForm];
Print[];

Print["Step 2: Apply Sum and watch steps"];
Print["===================================\n"];

(* Trace the Sum evaluation *)
Print["Using Trace to see evaluation steps:"];
traced = Trace[
  Sum[factorialTerm[x, 3, i], {i, 1, 3}],
  TraceInternal -> True
];
Print["Number of evaluation steps: ", Length[Flatten[traced]]];
Print[];

Print["Step 3: Try to simplify to closed form"];
Print["========================================\n"];

(* Let Mathematica find closed form *)
closedForm = Sum[factorialTerm[x, k, i], {i, 1, k}] // FullSimplify;
Print["Closed form (symbolic k): "];
Print[closedForm // TraditionalForm];
Print[];

Print["Step 4: Check if it involves Hypergeometric"];
Print["=============================================\n"];

(* Look for hypergeometric structure *)
Print["Converting to Hypergeometric notation:"];
hyperForm = closedForm // FunctionExpand // FullSimplify;
Print[hyperForm // TraditionalForm];
Print[];

(* Check specific values *)
Print["Step 5: Verify against hyperbolic form"];
Print["========================================\n"];

testVals = {{x -> 2, k -> 3}, {x -> 5, k -> 4}, {x -> 10, k -> 5}};

Do[
  {xVal, kVal} = {x, k} /. rule;
  fac = N[factorialSum[xVal, kVal], 30];
  hyp = N[hyperbolicForm[xVal, kVal], 30];
  diff = Abs[fac - hyp];
  Print["x=", xVal, ", k=", kVal, ": diff = ", diff];
, {rule, testVals}];

Print[];
Print["Step 6: Analyze coefficient pattern"];
Print["=====================================\n"];

(* Look at coefficients for different k *)
Print["Coefficients for k=1..5:"];
Do[
  poly = factorialSum[x, kk] // Expand;
  coeffs = CoefficientList[poly, x];
  Print["k=", kk, ": ", coeffs];
, {kk, 1, 5}];

Print[];
Print["Step 7: Try to express as generating function"];
Print["==============================================\n"];

(* See if there's a generating function pattern *)
Print["Looking for pattern in 2^(i-1) * (k+i)!/(k-i)!(2i)!:"];
Do[
  coeff = 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);
  Print["i=", i, ": ", coeff // FullSimplify];
, {i, 1, 5}];

Print[];
Print["=== Analysis Complete ==="];
