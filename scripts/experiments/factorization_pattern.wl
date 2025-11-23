#!/usr/bin/env wolframscript
(* Find factorization pattern in Egypt denominators *)

Print["=== EGYPT DENOMINATOR FACTORIZATION ===\n"];

factorialDenom[x_, j_] := 1 + Sum[2^(i-1) * x^i * Factorial[j+i] /
                                   (Factorial[j-i] * Factorial[2*i]), {i, 1, j}];

Print["Complete factorizations:"];
Do[
  denom = factorialDenom[x, j];
  factored = Factor[denom];
  Print["j=", j, ": ", factored];
, {j, 1, 7}];

Print["\n=== IDENTIFYING COMMON FACTORS ===\n"];

(* Extract factors for each j *)
factors = Table[Factor[factorialDenom[x, j]], {j, 1, 5}];

Print["j=1: ", factors[[1]]];
Print["j=2: ", factors[[2]]];
Print["j=3: ", factors[[3]]];
Print["j=4: ", factors[[4]]];
Print["j=5: ", factors[[5]]];

Print["\n=== TESTING LINEAR FACTOR PATTERN ===\n"];

(* Check if (1+kx) divides denom[j] *)
Print["Testing which (1+kx) divide each denominator:\n"];

Do[
  denom = factorialDenom[x, j];
  Print["j=", j, ":"];
  Do[
    quotient = Simplify[denom / (1 + k*x)];
    (* Check if quotient is polynomial *)
    isPoly = PolynomialQ[quotient, x];
    If[isPoly,
      Print["  (1+", k, "x) divides, quotient = ", Factor[quotient]]
    ];
  , {k, 1, 5}];
, {j, 1, 5}];

Print["\n=== RECURSIVE STRUCTURE ===\n"];

Print["Looking for pattern: denom[j] = (1+ax) * denom[j-1] * ... ?"];
Print[""];

(* Check if denom[j] contains denom[j-1] as factor *)
Do[
  denom_j = factorialDenom[x, j];
  denom_jm1 = factorialDenom[x, j-1];
  quotient = Simplify[denom_j / denom_jm1];
  Print["denom[", j, "] / denom[", j-1, "] = ", Factor[quotient]];
, {j, 2, 5}];

Print["\n=== HYPERGEOMETRIC IDENTIFICATION ===\n"];

Print["For each factor, try to identify as hypergeometric:\n"];

Print["Factor (1+x):"];
Print["  1/(1+x) = 2F1[1,1;1;-x] = Sum[(-x)^k, k>=0]"];

Print["\nFactor (1+2x):"];
Print["  1/(1+2x) = 2F1[1,1;1;-2x] = Sum[(-2x)^k, k>=0]"];

Print["\nFactor (1+4x+2x^2):"];
prod1 = Expand[(1 + Sqrt[2]*x)*(1 - Sqrt[2]*x)];
Print["  Roots: x = +/- 1/sqrt(2)"];
Print["  (1+sqrt(2)x)(1-sqrt(2)x) = ", prod1];
Print["  Not simple rational factorization"];

Print["\n=== PATTERN IN POWERS OF 2 ===\n"];

Print["Notice coefficients in denominators:"];
Print["j=1: {1, 1}           - sum: ", 1+1];
Print["j=2: {1, 3, 2}        - sum: ", 1+3+2];
Print["j=3: {1, 6, 10, 4}    - sum: ", 1+6+10+4];
Print["j=4: {1, 10, 30, 28, 8} - sum: ", 1+10+30+28+8];

Print["\nEvaluate at x=1:"];
Do[
  val = factorialDenom[1, j];
  Print["  denom[", j, ", x=1] = ", val, " = ", FactorInteger[val]];
, {j, 1, 5}];

Print["\n=== GENERATING FUNCTION APPROACH ===\n"];

Print["Consider generating function:"];
Print["  G(x,t) = Sum[t^j * (Egypt_denom[x,j]), j>=0]"];
Print[""];
Print["Might be expressible as product or hypergeometric in TWO variables"];
Print["(Appell function or generalization)"];

Print["\n=== KEY OBSERVATION ===\n"];

Print["Egypt denominator for j=1: 1+x"];
Print["  -> 1/denom = 1/(1+x) = 2F1[1,1;1;-x]"];
Print[""];
Print["For j>1: Product structure emerges"];
Print["  -> 1/denom = PRODUCT of simpler terms"];
Print["  -> Each term might be hypergeometric"];
Print[""];
Print["HYPOTHESIS: Master function is PRODUCT of 2F1's, not single pFq"];
