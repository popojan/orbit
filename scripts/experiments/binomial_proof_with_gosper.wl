#!/usr/bin/env wolframscript
(* Direct binomial proof using Gosper/Zeilberger methods *)

Print["=== BINOMIAL PROOF WITH GOSPER ===\n"];

(* Load Gosper package *)
If[FileExistsQ["personal/gosper.m"],
  Get["personal/gosper.m"];
  Print["Gosper package loaded ✓\n"];
,
  Print["ERROR: gosper.m not found!\n"];
  Exit[1];
];

Print["Goal: Prove convolution ratio for T_n(x+1) * [U_m(x+1) - U_{m-1}(x+1)]\n"];
Print["      equals 2(k+i)(k-i+1)/((2i)(2i-1))\n"];
Print[];

Print["Strategy:\n"];
Print["1. Express T_n and ΔU_m coefficients via de Moivre\n"];
Print["2. Write convolution explicitly\n"];
Print["3. Use FactorialSimplify to simplify ratio\n"];
Print["4. Apply Zeilberger if needed\n"];
Print[];

Print["Part 1: Test FactorialSimplify on simple Pochhammer expressions\n"];

(* Test if FS works *)
testExpr = Pochhammer[k-i+1, 2*i] / Pochhammer[k-i+2, 2*i-2];
Print["Test: Pochhammer ratio simplification\n"];
Print["Input:  ", testExpr];
Print["Output: ", FS[testExpr]];
Print[];

(* Our factorial recurrence *)
Print["Part 2: Verify factorial recurrence with FactorialSimplify\n"];

factorialRatio = (2^(i-1) * Pochhammer[k-i+1, 2*i] / Factorial[2*i]) /
                 (2^(i-2) * Pochhammer[k-i+2, 2*i-2] / Factorial[2*i-2]);

Print["Factorial form ratio c[i]/c[i-1]:\n"];
Print["  ", factorialRatio];
Print["Simplified: ", FS[factorialRatio] // Simplify];
Print["Expected:   ", 2*(k+i)*(k-i+1)/((2*i)*(2*i-1))];
Print[];

(* Check if they match *)
diff = Simplify[FS[factorialRatio] - 2*(k+i)*(k-i+1)/((2*i)*(2*i-1))];
Print["Match: ", diff == 0];
Print[];

Print["Part 3: Analyze Chebyshev coefficient structure\n"];

(* For specific k=4, get symbolic expressions *)
k_val = 4;
n_val = 2;
m_val = 2;

Print["k=", k_val, " (n=", n_val, ", m=", m_val, ")\n"];

(* T_n coefficients from de Moivre *)
Print["T_", n_val, "(x+1) via de Moivre formula:\n"];

(* T_n(y) = Sum[Binomial[n,2j] * (y²-1)^j * y^(n-2j), {j, 0, Floor[n/2]}] *)
(* For y = x+1: y²-1 = x²+2x = x(x+2) *)

tn_deMoivre = Sum[
  Binomial[n_val, 2*j] * (x*(x+2))^j * (x+1)^(n_val - 2*j)
, {j, 0, Floor[n_val/2]}] // Expand;

Print["  ", tn_deMoivre];
tn_coeffs = CoefficientList[tn_deMoivre, x];
Print["  Coefficients: ", tn_coeffs];
Print[];

(* U_m coefficients *)
Print["U_", m_val, "(x+1) via de Moivre:\n"];

(* U_n(y) = Sum[Binomial[n+1,2k+1] * (y²-1)^k * y^(n-2k), {k, 0, Floor[n/2]}] *)
um_deMoivre = Sum[
  Binomial[m_val+1, 2*k+1] * (x*(x+2))^k * (x+1)^(m_val - 2*k)
, {k, 0, Floor[m_val/2]}] // Expand;

Print["  ", um_deMoivre];
Print[];

Print["U_", m_val-1, "(x+1) via de Moivre:\n"];
umm1_deMoivre = Sum[
  Binomial[m_val, 2*k+1] * (x*(x+2))^k * (x+1)^(m_val-1 - 2*k)
, {k, 0, Floor[(m_val-1)/2]}] // Expand;

Print["  ", umm1_deMoivre];
Print[];

deltaU_deMoivre = Expand[um_deMoivre - umm1_deMoivre];
Print["ΔU_", m_val, "(x+1) = ", deltaU_deMoivre];
deltaU_coeffs = CoefficientList[deltaU_deMoivre, x];
Print["  Coefficients: ", deltaU_coeffs];
Print[];

Print["Part 4: Convolution and ratio computation\n"];

(* Compute c[1] and c[2] via convolution *)
i1 = 1;
c1_conv = Sum[
  If[ell+1 <= Length[tn_coeffs] && i1-ell+1 <= Length[deltaU_coeffs] && i1-ell >= 0,
    tn_coeffs[[ell+1]] * deltaU_coeffs[[i1-ell+1]]
  ,
    0
  ]
, {ell, 0, i1}];

Print["c[1] via convolution: ", c1_conv];

i2 = 2;
c2_conv = Sum[
  If[ell+1 <= Length[tn_coeffs] && i2-ell+1 <= Length[deltaU_coeffs] && i2-ell >= 0,
    tn_coeffs[[ell+1]] * deltaU_coeffs[[i2-ell+1]]
  ,
    0
  ]
, {ell, 0, i2}];

Print["c[2] via convolution: ", c2_conv];
Print[];

ratio_conv = c2_conv / c1_conv;
expected_ratio = 2*(k_val+i2)*(k_val-i2+1)/((2*i2)*(2*i2-1));

Print["Ratio c[2]/c[1]: ", ratio_conv, " = ", N[ratio_conv]];
Print["Expected:        ", expected_ratio, " = ", N[expected_ratio]];
Print["Match: ", ratio_conv == expected_ratio];
Print[];

Print["Part 5: Symbolic approach - general k, i\n"];

Print["Challenge: Prove for GENERAL k, i that convolution ratio equals formula.\n"];
Print[];

Print["This requires proving binomial identity:\n"];
Print["  Sum[T_n[ℓ] * ΔU_m[i-ℓ], {ℓ}] / Sum[T_n[ℓ] * ΔU_m[i-1-ℓ], {ℓ}]\n"];
Print["  = 2(k+i)(k-i+1) / ((2i)(2i-1))\n"];
Print[];

Print["where T_n, ΔU_m coefficients come from de Moivre formulas.\n"];
Print[];

Print["Part 6: Attempt Zeilberger approach\n"];

Print["Idea: Express as double sum and apply Zeil to find recurrence.\n"];
Print[];

(* This would require careful setup of the summand *)
(* For now, document the approach *)

Print["Summand structure (schematic):\n"];
Print["  F[i, ℓ] = T_n[ℓ] * ΔU_m[i-ℓ]\n"];
Print["  c[i] = Sum[F[i, ℓ], {ℓ, 0, min(n, i)}]\n"];
Print[];

Print["To apply Zeil:\n"];
Print["  1. Express T_n[ℓ] via binomial coefficients\n"];
Print["  2. Express ΔU_m[i-ℓ] via binomial coefficients\n"];
Print["  3. Find recurrence for c[i]\n"];
Print["  4. Verify it matches our expected recurrence\n"];
Print[];

Print["This is DOABLE but requires:\n"];
Print["  - Explicit binomial formulas for coefficients\n"];
Print["  - Careful bookkeeping of indices\n"];
Print["  - Multiple Zeil applications\n"];
Print[];

Print["=== NEXT STEPS ===\n"];
Print["1. Extract explicit binomial formulas for T_n[ℓ] and ΔU_m[i]\n"];
Print["2. Set up proper summand for Zeilberger\n"];
Print["3. Apply Zeil to derive recurrence\n"];
Print["4. Compare with expected recurrence\n"];
Print[];
Print["Estimated effort: 2-4 hours of careful algebra\n"];
