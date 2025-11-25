#!/usr/bin/env wolframscript
(* Trace FullSimplify to see how it proves the identity *)
(* This will reveal the algebraic steps needed *)

Print["=== TRACE FULLSIMPLIFY STEPS ===\n"];

(* De Moivre formulas *)
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

(* Test for k=4 *)
k = 4;
n = Ceiling[k/2]; (* n=2 *)
m = Floor[k/2];   (* m=2 *)

Print["Testing k=", k, " (n=", n, ", m=", m, ")\n"];

(* Compute Chebyshev form *)
tn = tnDeMoivre[n, x+1];
um = unDeMoivre[m, x+1];
umm1 = unDeMoivre[m-1, x+1];
deltaU = Expand[um - umm1];

product = Expand[tn * deltaU];

Print["T_", n, "(x+1) = ", tn];
Print["DeltaU_", m, "(x+1) = ", deltaU];
Print["Product = ", product];
Print[];

(* Compute factorial form *)
factorialForm = 1 + Sum[
  2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]),
  {i, 1, k}
] // Expand;

Print["Factorial form = ", factorialForm];
Print[];

(* Compute difference *)
diff = product - factorialForm;
Print["Difference (before simplification) = ", diff];
Print[];

(* Try different simplification strategies *)
Print["Strategy 1: Expand"];
s1 = Expand[diff];
Print["  Result: ", s1];
Print[];

Print["Strategy 2: Simplify"];
s2 = Simplify[diff];
Print["  Result: ", s2];
Print[];

Print["Strategy 3: FullSimplify"];
s3 = FullSimplify[diff];
Print["  Result: ", s3];
Print[];

(* Now try to understand coefficient by coefficient *)
Print["Coefficient-by-coefficient analysis:\n"];

Do[
  prodCoeff = Coefficient[product, x, i];
  facCoeff = If[i == 0, 1, 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i])];

  Print["[x^", i, "]"];
  Print["  Product: ", prodCoeff];
  Print["  Factorial: ", facCoeff];
  Print["  Difference: ", prodCoeff - facCoeff];
  Print["  Simplified: ", FullSimplify[prodCoeff - facCoeff]];
  Print[];
, {i, 0, k}];

(* Try to understand the pattern *)
Print["Pattern analysis:\n"];

(* Extract T_n coefficients *)
tnCoeffs = CoefficientList[tn, x];
deltaUCoeffs = CoefficientList[deltaU, x];

Print["T_", n, " coefficients: ", tnCoeffs];
Print["DeltaU_", m, " coefficients: ", deltaUCoeffs];
Print[];

(* For each power of x in product, show convolution *)
Do[
  Print["[x^", i, "] via convolution:"];

  conv = Sum[
    If[ell <= Length[tnCoeffs]-1 && (i-ell) <= Length[deltaUCoeffs]-1,
      Module[{a, b},
        a = tnCoeffs[[ell+1]];
        b = deltaUCoeffs[[i-ell+1]];
        Print["  + [x^", ell, " in T_n] * [x^", i-ell, " in DeltaU] = ", a, " * ", b, " = ", a*b];
        a * b
      ]
    ,
      0
    ]
  , {ell, 0, i}];

  facCoeff = If[i == 0, 1, 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i])];

  Print["  Sum = ", conv];
  Print["  Factorial form = ", facCoeff];
  Print["  Match: ", conv == facCoeff];
  Print[];
, {i, 0, k}];

Print["=== CONCLUSION ===\n"];
Print["The coefficients match via elementary convolution."];
Print["Key question: Can we prove the convolution sum simplifies to factorial form?"];
