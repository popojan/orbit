#!/usr/bin/env wolframscript
(* Direct binomial proof attempt *)

Print["=== DIRECT BINOMIAL PROOF ATTEMPT ===\n"];

Print["Goal: Prove algebraically that convolution ratio equals recurrence formula\n"];
Print[];

Print["Part 1: de Moivre formulas (shifted to x+1)\n"];

Print["T_n(y) = Sum[binom(n,2j) * (y²-1)^j * y^(n-2j), {j, 0, Floor[n/2]}]\n"];
Print["For y = x+1:\n"];
Print["  y² - 1 = (x+1)² - 1 = x² + 2x = x(x+2)\n"];
Print["  T_n(x+1) = Sum[binom(n,2j) * [x(x+2)]^j * (x+1)^(n-2j), {j, 0, Floor[n/2]}]\n"];
Print[];

Print["U_n(y) = Sum[binom(n+1,2k+1) * (y²-1)^k * y^(n-2k), {k, 0, Floor[n/2]}]\n"];
Print["For y = x+1:\n"];
Print["  U_n(x+1) = Sum[binom(n+1,2k+1) * [x(x+2)]^k * (x+1)^(n-2k), {k, 0, Floor[n/2]}]\n"];
Print[];

Print["Part 2: Coefficient extraction strategy\n"];

Print["T_n(x+1)[ℓ] = coefficient of x^ℓ in T_n(x+1)\n"];
Print["ΔU_m(x+1)[i] = coefficient of x^i in [U_m(x+1) - U_{m-1}(x+1)]\n"];
Print[];

Print["We know:\n"];
Print["  - ΔU_m(x+1)[0] = 1 (constant term)\n"];
Print["  - ΔU_m(x+1)[1] = m(m+1) = Pochhammer[m,2]\n"];
Print["  - Higher coefficients have complex structure\n"];
Print[];

Print["Part 3: Try symbolic manipulation for small n, m\n"];

(* n=2, m=2 case *)
n = 2;
m = 2;
k_val = 4;

Print["Example: n=", n, ", m=", m, " (k=", k_val, ")\n"];

(* T_2(x+1) from de Moivre *)
Print["T_2(x+1) via de Moivre:\n"];
Print["  j=0: binom(2,0) * (x+1)² = 1 * (x² + 2x + 1) = x² + 2x + 1\n"];
Print["  j=1: binom(2,2) * x(x+2) * (x+1)⁰ = 1 * (x² + 2x) * 1 = x² + 2x\n"];
Print["  Sum = 2x² + 4x + 1\n"];
Print["  Coefficients: [1, 4, 2]\n"];
Print[];

(* ΔU_2(x+1) structure *)
Print["ΔU_2(x+1) = U_2(x+1) - U_1(x+1):\n"];
Print["  U_2(x+1) via de Moivre:\n"];
Print["    k=0: binom(3,1) * (x+1)² = 3(x² + 2x + 1) = 3x² + 6x + 3\n"];
Print["    k=1: binom(3,3) * x(x+2) * (x+1)⁰ = 1 * (x² + 2x) = x² + 2x\n"];
Print["    Sum = 4x² + 8x + 3\n"];
Print["  U_1(x+1) = 2(x+1) = 2x + 2\n"];
Print["  ΔU_2(x+1) = (4x² + 8x + 3) - (2x + 2) = 4x² + 6x + 1\n"];
Print["  Coefficients: [1, 6, 4]\n"];
Print[];

Print["Part 4: Convolution for i=1, i=2\n"];

tn_coeffs = {1, 4, 2};
du_coeffs = {1, 6, 4};

Print["c[1] = tn[0]*du[1] + tn[1]*du[0]\n"];
Print["     = ", tn_coeffs[[1]], "*", du_coeffs[[2]], " + ",
      tn_coeffs[[2]], "*", du_coeffs[[1]]];
Print["     = ", tn_coeffs[[1]]*du_coeffs[[2]], " + ", tn_coeffs[[2]]*du_coeffs[[1]],
      " = ", tn_coeffs[[1]]*du_coeffs[[2]] + tn_coeffs[[2]]*du_coeffs[[1]]];
Print[];

Print["c[2] = tn[0]*du[2] + tn[1]*du[1] + tn[2]*du[0]\n"];
Print["     = ", tn_coeffs[[1]], "*", du_coeffs[[3]], " + ",
      tn_coeffs[[2]], "*", du_coeffs[[2]], " + ",
      tn_coeffs[[3]], "*", du_coeffs[[1]]];
Print["     = ", tn_coeffs[[1]]*du_coeffs[[3]], " + ",
      tn_coeffs[[2]]*du_coeffs[[2]], " + ",
      tn_coeffs[[3]]*du_coeffs[[1]],
      " = ", tn_coeffs[[1]]*du_coeffs[[3]] + tn_coeffs[[2]]*du_coeffs[[2]] + tn_coeffs[[3]]*du_coeffs[[1]]];
Print[];

c1 = tn_coeffs[[1]]*du_coeffs[[2]] + tn_coeffs[[2]]*du_coeffs[[1]];
c2 = tn_coeffs[[1]]*du_coeffs[[3]] + tn_coeffs[[2]]*du_coeffs[[2]] + tn_coeffs[[3]]*du_coeffs[[1]];

Print["Ratio: c[2]/c[1] = ", c2, "/", c1, " = ", c2/c1];
Print["Expected: 2(k+2)(k-1)/((2*2)(2*2-1)) = 2*6*3/(4*3) = 36/12 = 3 ✓\n"];
Print[];

Print["Part 5: Pattern observation\n"];

Print["Key observation:\n"];
Print["  - T_n coeffs from de Moivre: depend on binom(n, 2j) and powers of x(x+2)\n"];
Print["  - ΔU_m coeffs: c[1] = m(m+1), higher coeffs from de Moivre difference\n"];
Print["  - Convolution mixes these structures\n"];
Print[];

Print["To prove ratio = 2(k+i)(k-i+1)/((2i)(2i-1)):\n"];
Print["  Need to show sum of products simplifies to this expression\n"];
Print["  This requires binomial coefficient identities + Pochhammer algebra\n"];
Print[];

Print["Part 6: Attempt general proof outline\n"];

Print["Strategy:\n"];
Print["1. Express T_n coefficients via de Moivre (binomial + powers)\n"];
Print["2. Express ΔU_m coefficients via de Moivre difference\n"];
Print["3. Write convolution sum explicitly:\n"];
Print["   c[i] = Sum[T_n[ℓ] * ΔU_m[i-ℓ], {ℓ, 0, min(n, i)}]\n"];
Print["4. Factor out common terms, simplify ratio\n"];
Print["5. Apply binomial identities (Gosper, Zeilberger, ...)\n"];
Print[];

Print["This is FEASIBLE but INTENSIVE (estimated 2-4 hours of algebra)\n"];
Print[];

Print["=== ASSESSMENT ===\n"];
Print["The mutual recurrence exploration showed Pochhammer structure exists,\n"];
Print["but doesn't provide direct shortcut to our proof.\n"];
Print[];
Print["Options:\n"];
Print["  A. Complete direct binomial derivation (2-4h, use gosper.m)\n"];
Print["  B. Accept 99.9% confidence (factorial proven + 49 verifications)\n"];
Print["  C. Search literature for T_n * (U_m - U_{m-1}) product identities\n"];
Print[];
Print["User approved unlimited time/tokens, so option A is viable if desired."];
