#!/usr/bin/env wolframscript
(* Try generating function approach to prove coefficient recurrence *)

Print["=== GENERATING FUNCTION APPROACH ===\n"];

Print["Strategy: Use generating functions to derive recurrence algebraically\n"];
Print[];

Print["Part 1: Chebyshev generating functions\n"];

Print["Known (Mason & Handscomb):\n"];
Print["  Sum[T_n(y) t^n] = (1-yt)/(1-2yt+t^2)"];
Print["  Sum[U_n(y) t^n] = 1/(1-2yt+t^2)"];
Print["  Sum[(U_n(y)-U_{n-1}(y)) t^n] = (1-t)/(1-2yt+t^2)"];
Print[];

Print["Part 2: For our specific case\n"];

(* For k=4: n=2, m=2 *)
k = 4;
n = Ceiling[k/2];
m = Floor[k/2];

Print["k=", k, " (n=", n, ", m=", m, ")\n"];
Print[];

Print["We need product: T_", n, "(x+1) * [U_", m, "(x+1) - U_", m-1, "(x+1)]\n"];
Print[];

Print["Key insight: This is NOT a generating function problem directly!"];
Print["We're computing a SINGLE polynomial (fixed n, m), not a series.\n"];
Print[];

Print["Part 3: Try convolution formula directly\n"];

(* Get de Moivre coefficients *)
Print["T_", n, "(x+1) via de Moivre:\n"];

tnPoly = ChebyshevT[n, x+1] // Expand;
tnCoeffs = CoefficientList[tnPoly, x];
Print["  T_", n, "(x+1) = ", tnPoly];
Print["  Coefficients: ", tnCoeffs];
Print[];

Print["Delta U_", m, "(x+1):\n"];
deltaUPoly = ChebyshevU[m, x+1] - ChebyshevU[m-1, x+1] // Expand;
deltaUCoeffs = CoefficientList[deltaUPoly, x];
Print["  ΔU_", m, "(x+1) = ", deltaUPoly];
Print["  Coefficients: ", deltaUCoeffs];
Print[];

Print["Part 4: Convolution formula\n"];

Print["c[i] = Sum[tnCoeffs[[ℓ+1]] * deltaUCoeffs[[i-ℓ+1]], {ℓ, 0, i}]\n"];
Print[];

maxDeg = n + m;
productCoeffs = Table[
  Sum[
    If[ell+1 <= Length[tnCoeffs] && i-ell+1 <= Length[deltaUCoeffs] && i-ell >= 0,
      tnCoeffs[[ell+1]] * deltaUCoeffs[[i-ell+1]]
    ,
      0
    ]
  , {ell, 0, i}]
, {i, 0, maxDeg}];

Print["Product coefficients via convolution: ", productCoeffs];
Print[];

Print["Part 5: Try to prove ratio c[i]/c[i-1] algebraically\n"];

Print["Goal: Show c[i]/c[i-1] = 2(k+i)(k-i+1)/((2i)(2i-1))\n"];
Print[];

Print["For i=2:\n"];
i = 2;
c2 = productCoeffs[[i+1]];
c1 = productCoeffs[[i]];
ratio = c2/c1 // Simplify;
expected = 2*(k+i)*(k-i+1)/((2*i)*(2*i-1));

Print["  c[2] = ", c2];
Print["  c[1] = ", c1];
Print["  Ratio = ", ratio];
Print["  Expected = ", expected, " = ", N[expected]];
Print["  Match: ", Simplify[ratio - expected] == 0];
Print[];

Print["Part 6: Symbolic computation with general k\n"];

Print["Let's try k as symbolic...\n"];

ClearAll[kSym];

(* This will be complex, but let's try for small n, m *)
Print["For k=4 symbolic verification:\n"];

(* Use actual k=4 but show structure *)
n4 = 2;
m4 = 2;

tn4 = ChebyshevT[n4, x+1];
deltaU4 = ChebyshevU[m4, x+1] - ChebyshevU[m4-1, x+1];

Print["T_2(x+1) structure:\n"];
Print["  ", tn4 // Expand];
Print["  From de Moivre: Sum[binom(2,2j)*(x²+2x)^j*(x+1)^(2-2j), {j,0,1}]"];
Print["  = binom(2,0)*(x+1)² + binom(2,2)*(x²+2x)"];
Print["  = (x+1)² + (x²+2x)"];
Print["  = x²+2x+1 + x²+2x = 2x²+4x+1"];
Print[];

Print["ΔU_2(x+1) structure:\n"];
Print["  ", deltaU4 // Expand];
Print["  We found c[1] = m(m+1) = 2*3 = 6"];
Print[];

Print["Part 7: Key realization\n"];

Print["The CONVOLUTION of two polynomials with known structures"];
Print["produces coefficients whose RATIOS follow our recurrence.\n"];
Print[];

Print["To prove this algebraically, we need to show:\n"];
Print[];
Print["Sum[T_n(x+1)[ℓ] * ΔU_m(x+1)[i-ℓ]]"];
Print["──────────────────────────────────────"];
Print["Sum[T_n(x+1)[ℓ] * ΔU_m(x+1)[i-1-ℓ]]"];
Print[];
Print["       = 2(k+i)(k-i+1) / ((2i)(2i-1))"];
Print[];

Print["where n = Ceiling[k/2], m = Floor[k/2]\n"];
Print[];

Print["This is a BINOMIAL IDENTITY involving:\n"];
Print["  - de Moivre coefficients of T_n"];
Print["  - Coefficients of ΔU_m (which have c[1] = m(m+1))"];
Print["  - Convolution structure"];
Print[];

Print["=== ASSESSMENT ===\n"];
Print["Generating function approach doesn't directly help because we're"];
Print["dealing with PRODUCT OF TWO SPECIFIC POLYNOMIALS, not series.\n"];
Print[];
Print["What we REALLY need is binomial identity for de Moivre convolution.\n"];
Print[];
Print["User's subnref formula shows mutual recurrence has Pochhammer form,"];
Print["but connection to OUR product T_n * ΔU_m is not yet clear...\n"];
Print[];
Print["Next: Either:");
Print["  1. Direct binomial algebra (intensive but doable)"];
Print["  2. Find literature on T_n * (U_m - U_{m-1}) products"];
Print["  3. Accept 99.9% computational verification as sufficient"];
