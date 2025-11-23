#!/usr/bin/env wolframscript
(* Analyze Egypt denominators as hypergeometric series *)

Print["=== EGYPT DENOMINATOR ANALYSIS ===\n"];

(* Egypt denominator structure *)
factorialDenom[x_, j_] := 1 + Sum[2^(i-1) * x^i * Factorial[j+i] /
                                   (Factorial[j-i] * Factorial[2*i]), {i, 1, j}];

(* Compute first few *)
Print["Egypt denominators (explicit):"];
Do[
  denom = factorialDenom[x, j];
  coeffs = CoefficientList[denom, x];
  Print["j=", j, ": ", Expand[denom]];
  Print["  Coeffs: ", coeffs];
, {j, 1, 5}];

Print["\n=== HYPERGEOMETRIC MATCHING ===\n"];

(* For j=1: 1+x = 1 + 2F1[1,1;1;-x] shifted? *)
Print["j=1: denom = 1+x"];
Print["  This is 1/(1+x) = Sum[(-x)^k, {k,0,infinity}]"];
Print["  = 2F1[1,1;1;-x]"];
denom1 = 1 + x;
hyp1 = 1 + HypergeometricPFQ[{1}, {}, -x];
Print["  Match: ", Simplify[denom1 - hyp1] == 0];

Print["\nj=2: denom = 1 + 3x + 2x^2"];
Print["  Factored: ", Factor[1 + 3*x + 2*x^2]];
(* Should be (1+x)(1+2x) *)

Print["\nj=3: denom = 1 + 6x + 10x^2 + 4x^3"];
Print["  Factored: ", Factor[1 + 6*x + 10*x^2 + 4*x^3]];

Print["\n=== FACTORIAL RATIO ANALYSIS ===\n"];

(* Look at coefficient of x^i for general j *)
egyptCoeff[j_, i_] := 2^(i-1) * Factorial[j+i] / (Factorial[j-i] * Factorial[2*i]);

Print["Coefficient c[j,i] = 2^(i-1) * (j+i)! / ((j-i)! * (2i)!)"];
Print[""];

(* Build table *)
Print["Table of c[j,i]:"];
Print["     i=1    i=2    i=3    i=4    i=5"];
Do[
  row = Table[egyptCoeff[j, i], {i, 1, Min[j, 5]}];
  Print["j=", j, ": ", row];
, {j, 1, 5}];

Print["\n=== POCHHAMMER REPRESENTATION ===\n"];

(* Try to express in Pochhammer symbols *)
Print["Pochhammer (a)_n = Gamma[a+n]/Gamma[a] = a*(a+1)*...*(a+n-1)"];
Print[""];

Print["Coefficient analysis for i=1:");
Do[
  c = egyptCoeff[j, 1];
  Print["  j=", j, ": c[", j, ",1] = ", c, " = ", N[c]];
, {j, 1, 5}];

Print["\nCoefficient analysis for i=2 (when j>=2):"];
Do[
  c = egyptCoeff[j, 2];
  Print["  j=", j, ": c[", j, ",2] = ", c, " = ", N[c]];
, {j, 2, 5}];

Print["\n=== PATTERN IN NUMERATOR FACTORIALS ===\n"];

Print["(j+i)! / (j-i)! = (j-i+1)*(j-i+2)*...*(j+i)"];
Print["Number of terms: 2i"];
Print["This is Pochhammer (j-i+1)_{2i}"];
Print[""];

Print["Verification for j=3:");
Do[
  numFactorial = Factorial[3+i] / Factorial[3-i];
  pochhammer = Pochhammer[3-i+1, 2*i];
  Print["  i=", i, ": (3+", i, ")!/(3-", i, ")! = ", numFactorial,
        ", Pochhammer = ", pochhammer, ", Match: ", numFactorial == pochhammer];
, {i, 1, 3}];

Print["\n=== GENERALIZED HYPERGEOMETRIC ATTEMPT ===\n"];

Print["General pFq: Sum[(a1)_k*...*(ap)_k / ((b1)_k*...*(bq)_k * k!)] * z^k"];
Print[""];
Print["Egypt has structure: 2^(k-1) * (j-k+1)_{2k} / (2k)!"];
Print["  = 2^(k-1) * (j-k+1)_{2k} / Gamma[2k+1]"];
Print[""];

(* Rewrite with 2x argument *)
Print["Absorb 2^(k-1) into argument:");
Print["  Sum[2^(k-1) * x^k * f(k)] = (1/2) * Sum[(2x)^k * f(k)]"];
Print[""];

Print["For j=1: 1/(1+x)"];
hyp_j1 = HypergeometricPFQ[{1, 1}, {1}, -x];
Print["  2F1[1,1;1;-x] = ", Simplify[hyp_j1]];
Print["  1/(1+x) = ", Expand[1/(1+x)]];
geom1 = Sum[(-x)^k, {k, 0, 5}];
Print["  Geometric (5 terms): ", Expand[geom1]];

Print["\n=== PRODUCT STRUCTURE HYPOTHESIS ===\n"];

Print["Notice: Egypt denominator factors"];
Print["j=1: 1+x = (1+x)"];
Print["j=2: (1+x)(1+2x)"];
Print["j=3: ???"];

denom3_factored = Factor[1 + 6*x + 10*x^2 + 4*x^3];
Print["j=3: ", denom3_factored];

Print["\nHypothesis: Product of linear/quadratic terms?"];
Print["Or: Product of hypergeometric functions?"];

Print["\n=== TESTING APPELL FUNCTION CONNECTION ===\n"];

Print["Appell F1(a,b,b',c;x,y) is 2-variable hypergeometric"];
Print["At diagonal x=y, might reduce to our structure"];
Print["This would explain product/sum patterns"];
Print[""];
Print["[More investigation needed for Appell connection]"];

Print["\n=== CONCLUSION ===\n"];

Print["Key findings:"];
Print["1. Egypt coefficients use Pochhammer (j-i+1)_{2i} / (2i)!"];
Print["2. Denominator for j=1 is simple geometric: 1/(1+x)"];
Print["3. Higher j show product structure (factorization)"];
Print["4. Not a single 2F1, possibly higher pFq or product"];
Print["5. The 2^(i-1) factor can be absorbed into argument (2x)"];
Print[""];
Print["Next: Investigate j=3,4,5 factorizations and look for pattern"];
