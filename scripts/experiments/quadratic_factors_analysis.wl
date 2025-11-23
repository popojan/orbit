#!/usr/bin/env wolframscript
(* Analyze quadratic factors appearing in Egypt denominators *)

Print["=== QUADRATIC FACTOR ANALYSIS ===\n"];

(* Collect unique quadratic+ factors *)
Print["Unique higher-degree factors encountered:\n"];

factors = {
  1 + 4*x + 2*x^2,
  1 + 6*x + 4*x^2,
  1 + 8*x + 4*x^2,
  1 + 12*x + 20*x^2 + 8*x^3,
  1 + 16*x + 40*x^2 + 32*x^3 + 8*x^4
};

Print["P1(x) = ", factors[[1]]];
Print["P2(x) = ", factors[[2]]];
Print["P3(x) = ", factors[[3]]];
Print["P4(x) = ", factors[[4]]];
Print["P5(x) = ", factors[[5]]];

Print["\n=== COEFFICIENT PATTERNS ===\n"];

Do[
  coeffs = CoefficientList[factors[[i]], x];
  Print["P", i, " coeffs: ", coeffs];

  (* Look for pattern in coefficients *)
  Print["  Ratios: "];
  Do[
    If[k < Length[coeffs],
      ratio = N[coeffs[[k+1]]/coeffs[[k]]];
      Print["    c[", k, "]/c[", k-1, "] = ", coeffs[[k+1]], "/", coeffs[[k]], " = ", ratio];
    ];
  , {k, 1, Length[coeffs]-1}];
  Print[""];
, {i, 1, Length[factors]}];

Print["\n=== TRYING PARTIAL FRACTION DECOMPOSITION ===\n"];

Print["For quadratics, try 1/P(x) as partial fractions:\n"];

Do[
  p = factors[[i]];
  decomp = Apart[1/p, x];
  Print["1/(", p, ")"];
  Print["  = ", decomp];
  Print[""];
, {i, 1, 3}];

Print["\n=== ROOT ANALYSIS ===\n"];

Print["Finding roots of quadratic factors:\n"];

Do[
  p = factors[[i]];
  roots = Solve[p == 0, x];
  Print["Roots of ", p, ":"];
  Print["  ", roots];
  Print["  Numerical: ", N[roots, 5]];
  Print[""];
, {i, 1, 3}];

Print["\n=== TESTING HYPERGEOMETRIC RELATIONS ===\n"];

Print["For P1(x) = 1+4x+2x^2:\n"];
p1 = 1 + 4*x + 2*x^2;

(* Try to express 1/p1 as series *)
series1 = Series[1/p1, {x, 0, 10}];
Print["Series expansion: ", Normal[series1]];

(* Extract coefficients *)
coeffList1 = CoefficientList[Normal[series1], x];
Print["Coefficients: ", coeffList1[[1;;8]]];

(* Check if matches hypergeometric *)
Print["\nTesting if sequence matches pFq pattern.."];
Print["Ratio test (consecutive coefficients):"];
Do[
  If[k <= 7 && coeffList1[[k]] != 0,
    ratio = N[coeffList1[[k+1]]/coeffList1[[k]]];
    Print["  a[", k, "]/a[", k-1, "] = ", ratio];
  ];
, {k, 2, 7}];

Print["\n=== LOOKING FOR GENERATING FUNCTION ===\n"];

Print["Hypothesis: Quadratic factors arise from continued fraction"];
Print["or from Chebyshev-type recurrence relation"];
Print[""];

Print["Chebyshev U_n satisfies: U_{n+1} = 2x*U_n - U_{n-1}"];
Print["Egypt might have similar recurrence for its factors"];

Print["\n=== PRODUCT REPRESENTATION ===\n"];

Print["Master hypothesis:"];
Print[""];
Print["  FactorialTerm[x,j] = 1 / PRODUCT[P_k(x)]"];
Print[""];
Print["where each P_k is either:"];
Print["  - Linear: (1+kx) -> hypergeometric 2F1[1,1;1;-kx]");
Print["  - Quadratic+: built from Chebyshev or similar orthogonal polynomials");
Print[""];
Print["The specific factors appearing for each j follow some"];
Print["combinatorial rule (factorial indices?)"];

Print["\n=== EVALUATING GAMMA/BETA CONNECTION ===\n"];

Print["Recall: GammaPalindromicSqrt uses weights"];
Print["  w[i] ~ 1/(Gamma[alpha]*Gamma[beta]) where alpha+beta = const"];
Print[""];
Print["This is Beta function: B(a,b) = Gamma[a]*Gamma[b]/Gamma[a+b]"];
Print[""];
Print["Beta function has integral representation:"];
Print["  B(a,b) = Integral[t^(a-1)*(1-t)^(b-1), {t,0,1}]"];
Print[""];
Print["This integral is related to hypergeometric via:"];
Print["  2F1[a,b;c;z] = Gamma[c]/(Gamma[b]*Gamma[c-b]) *"];
Print["                 Integral[t^(b-1)*(1-t)^(c-b-1)*(1-zt)^(-a), {t,0,1}]"];
Print[""];
Print["-> Gamma palindromes ARE hypergeometric integral representations!");

Print["\n=== CONCLUSION ===\n"];

Print["MASTER FUNCTION STRUCTURE (hypothesis):"];
Print[""];
Print["Egypt FactorialTerm = PRODUCT of specialized 2F1 functions"];
Print["Gamma weights = Beta functions = hypergeometric integrals"];
Print["Chebyshev = direct 2F1 representation (known)"];
Print[""];
Print["All three ARE hypergeometric, but Egypt uses PRODUCT not single pFq"];
Print[""];
Print["Next: Prove palindromic property from hypergeometric parameter symmetry"];
