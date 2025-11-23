#!/usr/bin/env wolframscript
(* Explore connection between Gamma weights and FactorialTerm *)

<< Orbit`

Print["=== GAMMA vs FACTORIAL CONNECTION ===\n"];

(* Pell solution *)
nn = 13;
xval = 649;
yval = 180;
nval = N[(xval - 1)/yval, 30];

Print["Setup: nn=", nn, ", n=", nval, "\n"];

Print["=== k=1 DETAILED BREAKDOWN ===\n"];

k = 1;

Print["--- Egypt side ---"];
ft1 = FactorialTerm[xval - 1, 1];
Print["FactorialTerm[x-1, 1] = ", N[ft1, 20]];

(* FactorialTerm formula for j=1:
   1 / (1 + Sum[2^(i-1)*x^i*(j+i)!/((j-i)!*(2i)!), {i,1,j}])
   For j=1: 1 / (1 + 2^0 * x^1 * 2!/(0! * 2!))
          = 1 / (1 + 1 * x * 1)
          = 1 / (1 + x)
*)
Print["For j=1: FT = 1/(1+x) where x = ", xval-1];
ft1_formula = 1/(1 + (xval-1));
Print["Direct formula: ", N[ft1_formula, 20]];
Print["Match: ", Abs[ft1 - ft1_formula] < 10^-15];

r_egypt = nval * (1 + ft1);
Print["r = n*(1 + FT[1]) = ", N[r_egypt, 20], "\n"];

Print["--- Gamma side ---"];

(* For k=1, limit = 2 *)
lim = 1 + 1/2 (1 - (-1)^k) + Floor[k/2];
Print["limit = ", lim];

(* Weights for i=1,2 *)
w = Table[
  (nval^(2 - 2*i + 2*Ceiling[k/2]) * nn^i) / (Gamma[-1 + 2*i] * Gamma[4 - 2*i + k]),
  {i, 1, lim}
];

Print["Weights:"];
Do[Print["  w[", i, "] = ", N[w[[i]], 20]], {i, 1, lim}];

(* Numerator coefficients *)
nums = Table[
  (-24 + 16*i^2*(1 + k) + 4*i*(1 + k)*(2 + k) - k*(24 + k*(7 + k))) / (-1 + 4*i^2),
  {i, 1, lim}
];

Print["Numerator coeffs:"];
Do[Print["  num[", i, "] = ", nums[[i]]], {i, 1, lim}];

recon = nn * Sum[w[[i]] * nums[[i]], {i, 1, lim}] / Sum[w[[i]], {i, 1, lim}];
Print["reconstruct = ", N[recon, 20]];

gamma_result = (nn/nval) * ((1 + k)*nval^2 - (3 + 5*k)*nn + recon) / (nval^2 - 3*nn);
Print["gamma = ", N[gamma_result, 20]];

Print["\n--- Comparison ---"];
Print["r_egypt = ", N[r_egypt, 20]];
Print["gamma   = ", N[gamma_result, 20]];
Print["Equal? ", Abs[r_egypt - gamma_result] < 10^-15, "\n"];

Print["=== LOOKING FOR ALGEBRAIC IDENTITY ===\n"];

Print["Factorial side uses: (j+i)! / ((j-i)! * (2i)!)"];
Print["This can be written as: Gamma(j+i+1) / (Gamma(j-i+1) * Gamma(2i+1))\n"];

Print["Gamma side uses: 1 / (Gamma(a) * Gamma(b)) where a+b = const\n"];

Print["Question: Is there transformation between these?"];
Print["  FactorialTerm summation <=> Gamma palindromic weights?"];
Print["  Binomial coefficients <=> Beta function ratios?\n"];

Print["=== CHEBYSHEV CONNECTION ===\n"];

Print["We know: FactorialTerm[x,j] ≈ ChebyshevTerm[x,j] (conjecture)"];
Print["ChebyshevTerm uses Chebyshev polynomials T_n, U_n"];
Print["These can be written via hypergeometric 2F1"];
Print["Hypergeometric functions contain Gamma ratios!\n"];

Print["Hypothesis:"];
Print["  FactorialTerm -> Chebyshev -> Hypergeometric -> Gamma"];
Print["  This would connect factorial series to Gamma weights"];
Print["  Palindrome in Gamma <=> symmetry in Chebyshev"];
