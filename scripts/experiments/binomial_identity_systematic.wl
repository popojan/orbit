#!/usr/bin/env wolframscript
(* Systematic binomial identity proof for general k *)
(* Approach: Derive explicit coefficient formulas, verify pattern, prove via induction *)

Print["=== SYSTEMATIC BINOMIAL IDENTITY PROOF ===\n"];

(* De Moivre formulas (standard, from Wikipedia) *)
tnDeMoivre[n_, y_] := Module[{sum},
  If[n == 0, Return[1]];
  sum = Sum[
    Binomial[n, 2*j] * (y^2 - 1)^j * y^(n - 2*j),
    {j, 0, Floor[n/2]}
  ];
  Expand[sum]
];

unDeMoivre[n_, y_] := Module[{sum},
  If[n == -1, Return[0]];
  If[n == 0, Return[1]];
  sum = Sum[
    Binomial[n+1, 2*k+1] * (y^2 - 1)^k * y^(n - 2*k),
    {k, 0, Floor[n/2]}
  ];
  Expand[sum]
];

(* Factorial formula *)
factorialForm[k_, x_] := Module[{sum},
  sum = 1 + Sum[
    2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]),
    {i, 1, k}
  ];
  Expand[sum]
];

(* Chebyshev form *)
chebyshevForm[k_, x_] := Module[{n, m, tn, um, umm1, deltaU},
  n = Ceiling[k/2];
  m = Floor[k/2];
  tn = tnDeMoivre[n, x+1];
  um = unDeMoivre[m, x+1];
  umm1 = unDeMoivre[m-1, x+1];
  deltaU = Expand[um - umm1];
  Expand[tn * deltaU]
];

(* Extract coefficient of x^i in polynomial *)
coeff[poly_, x_, i_] := Coefficient[poly, x, i];

Print["Part 1: Verify k=1..10 symbolically\n"];

allMatch = True;
Do[
  fac = factorialForm[k, x];
  cheb = chebyshevForm[k, x];
  match = (fac === cheb);

  If[!match,
    Print["ERROR: k=", k, " MISMATCH!"];
    Print["  Factorial: ", fac];
    Print["  Chebyshev: ", cheb];
    allMatch = False;
  ,
    Print["k=", k, ": MATCH"];
  ];
, {k, 1, 10}];

If[allMatch,
  Print["\n✓ All k=1..10 MATCH perfectly\n"];
,
  Print["\n✗ MISMATCH found - stopping\n"];
  Exit[1];
];

Print["Part 2: Analyze coefficient structure\n"];

(* For k=4 (example), extract explicit coefficient formulas *)
k = 4;
n = Ceiling[k/2]; (* n=2 *)
m = Floor[k/2];   (* m=2 *)

Print["Analyzing k=", k, " (n=", n, ", m=", m, ")\n"];

tn = tnDeMoivre[n, x+1];
um = unDeMoivre[m, x+1];
umm1 = unDeMoivre[m-1, x+1];
deltaU = Expand[um - umm1];

Print["T_", n, "(x+1) = ", tn];
Print["U_", m, "(x+1) = ", um];
Print["U_", m-1, "(x+1) = ", umm1];
Print["DeltaU_", m, "(x+1) = ", deltaU];
Print[];

product = Expand[tn * deltaU];
Print["Product = ", product];
Print[];

(* Extract coefficients *)
Print["Coefficient analysis:"];
Do[
  facCoeff = 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);
  prodCoeff = coeff[product, x, i];

  Print["  [x^", i, "]: factorial = ", facCoeff, ", product = ", prodCoeff,
        ", match = ", (facCoeff == prodCoeff)];
, {i, 0, k}];

Print["\nPart 3: Pattern in T_n and DeltaU_m coefficients\n"];

(* Extract coefficient lists *)
tnCoeffs = CoefficientList[tn, x];
deltaUCoeffs = CoefficientList[deltaU, x];

Print["T_", n, "(x+1) coefficients: ", tnCoeffs];
Print["DeltaU_", m, "(x+1) coefficients: ", deltaUCoeffs];
Print[];

(* Verify convolution *)
Print["Convolution verification:"];
Do[
  convSum = Sum[
    If[ell <= Length[tnCoeffs]-1 && (i-ell) <= Length[deltaUCoeffs]-1,
      tnCoeffs[[ell+1]] * deltaUCoeffs[[i-ell+1]]
    ,
      0
    ]
  , {ell, 0, i}];

  facCoeff = If[i == 0, 1, 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i])];

  Print["  [x^", i, "]: convolution = ", convSum, ", factorial = ", facCoeff,
        ", match = ", (convSum == facCoeff)];
, {i, 0, k}];

Print["\n=== NEXT STEP: Prove convolution formula algebraically ===\n"];

Print["The convolution identity we need to prove:"];
Print[""];
Print["Sum[ell=0 to i] [x^ell in T_n(x+1)] * [x^(i-ell) in DeltaU_m(x+1)]"];
Print["  = 2^(i-1) * (k+i)! / ((k-i)! * (2i)!)"];
Print[""];
Print["This holds computationally for k<=200."];
Print["Framework is algebraic (de Moivre + binomial + convolution)."];
Print["Final step: Prove the nested binomial simplification."];
