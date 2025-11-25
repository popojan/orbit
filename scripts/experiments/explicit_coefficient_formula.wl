#!/usr/bin/env wolframscript
(* Derive explicit formula for T_n(x+1) and DeltaU_m(x+1) coefficients *)
(* Then prove convolution equals factorial form *)

Print["=== EXPLICIT COEFFICIENT FORMULAS ===\n"];

(* Helper: coefficient of x^p in (x+a)^q *)
coeffXpowerP[a_, q_, p_] := If[p <= q, Binomial[q, p] * a^(q-p), 0];

(* Helper: coefficient of x^p in (x^2 + 2x)^j = x^j * (x+2)^j *)
(* This is coefficient of x^p in x^j * Sum[Binomial[j,s] * x^s * 2^(j-s), {s,0,j}] *)
(* = coefficient of x^p in Sum[Binomial[j,s] * x^(j+s) * 2^(j-s), {s,0,j}] *)
(* Need j+s = p, so s = p-j *)
coeffXSquarePlus2X[j_, p_] := Module[{s},
  s = p - j;
  If[s >= 0 && s <= j,
    Binomial[j, s] * 2^(j-s)
  ,
    0
  ]
];

(* Explicit formula for [x^ell] in T_n(x+1) *)
(* T_n(x+1) = Sum[Binomial[n,2j] * (x(x+2))^j * (x+1)^(n-2j), {j,0,Floor[n/2]}] *)
coeffTn[n_, ell_] := Module[{sum},
  sum = Sum[
    Binomial[n, 2*j] *
    Sum[
      (* coefficient of x^(ell-t) in (x(x+2))^j times coefficient of x^t in (x+1)^(n-2j) *)
      coeffXSquarePlus2X[j, ell-t] * coeffXpowerP[1, n-2*j, t]
    , {t, 0, ell}]
  , {j, 0, Floor[n/2]}];
  sum
];

(* Explicit formula for [x^ell] in U_m(x+1) *)
coeffUn[m_, ell_] := Module[{sum},
  If[m == -1, Return[0]];
  If[m == 0, Return[If[ell == 0, 1, 0]]];
  sum = Sum[
    Binomial[m+1, 2*k+1] *
    Sum[
      coeffXSquarePlus2X[k, ell-t] * coeffXpowerP[1, m-2*k, t]
    , {t, 0, ell}]
  , {k, 0, Floor[m/2]}];
  sum
];

(* DeltaU_m(x+1) = U_m(x+1) - U_{m-1}(x+1) *)
coeffDeltaU[m_, ell_] := coeffUn[m, ell] - coeffUn[m-1, ell];

Print["Part 1: Verify formulas for k=4 (n=2, m=2)\n"];

k = 4;
n = 2;
m = 2;

Print["T_", n, "(x+1) coefficients:"];
tnCoeffsFormula = Table[coeffTn[n, ell], {ell, 0, n}];
Print["  Formula: ", tnCoeffsFormula];

(* Verify against Mathematica *)
tnMath = Expand[ChebyshevT[n, x+1]];
tnCoeffsMath = CoefficientList[tnMath, x];
Print["  Mathematica: ", tnCoeffsMath];
Print["  Match: ", tnCoeffsFormula == tnCoeffsMath];
Print[];

Print["DeltaU_", m, "(x+1) coefficients:"];
deltaUCoeffsFormula = Table[coeffDeltaU[m, ell], {ell, 0, m}];
Print["  Formula: ", deltaUCoeffsFormula];

umMath = Expand[ChebyshevU[m, x+1]];
umm1Math = Expand[ChebyshevU[m-1, x+1]];
deltaUMath = Expand[umMath - umm1Math];
deltaUCoeffsMath = CoefficientList[deltaUMath, x];
Print["  Mathematica: ", deltaUCoeffsMath];
Print["  Match: ", deltaUCoeffsFormula == deltaUCoeffsMath];
Print[];

Print["Part 2: Compute convolution and verify\n"];

Do[
  conv = Sum[
    coeffTn[n, ell] * coeffDeltaU[m, i-ell]
  , {ell, 0, i}];

  facCoeff = If[i == 0, 1, 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i])];

  Print["[x^", i, "]:"];
  Print["  Convolution: ", conv];
  Print["  Factorial: ", facCoeff];
  Print["  Match: ", conv == facCoeff];
  Print[];
, {i, 0, k}];

Print["Part 3: Try to simplify convolution formula symbolically\n"];

(* For specific i, try to simplify the sum *)
i = 2;
Print["For i=", i, ", k=", k, " (n=", n, ", m=", m, "):\n"];

convExplicit = Sum[
  coeffTn[n, ell] * coeffDeltaU[m, i-ell]
, {ell, 0, i}];

Print["Convolution sum = ", convExplicit];

facCoeff = 2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);
Print["Factorial form = ", facCoeff];

diff = convExplicit - facCoeff;
Print["Difference = ", diff];
Print["Simplified = ", FullSimplify[diff]];
Print[];

Print["=== KEY INSIGHT ===\n"];
Print["The explicit formulas work, but algebraic simplification is complex."];
Print["Next step: Use generating functions or recurrence relations?"];
