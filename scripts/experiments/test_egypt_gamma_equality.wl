#!/usr/bin/env wolframscript
(* Test exact relationship between EgyptSqrt and GammaPalindromicSqrt *)

<< Orbit`

Print["=== TESTING EGYPT vs GAMMA RELATIONSHIP ===\n"];

(* For sqrt(13) *)
nn = 13;
sol = PellSolution[13];
Print["Pell solution: ", sol];

x_val = x /. sol;
y_val = y /. sol;
n_val = (x_val - 1)/y_val;

Print["x = ", x_val];
Print["y = ", y_val];
Print["n = (x-1)/y = ", N[n_val, 15], "\n"];

Print["=== COMPARING COMPONENTS ===\n"];

Do[
  Print["--- k = ", k, " ---"];

  (* Egypt method components *)
  egyptFull = EgyptSqrt[nn, {x_val, y_val}, k];

  (* Extract r directly *)
  r = n_val * (1 + Sum[FactorialTerm[x_val - 1, j], {j, 1, k}]);

  Print["Egypt interval: ", N[egyptFull, 15]];
  Print["Egypt r value:  ", N[r, 15]];
  Print["Egypt nn/r:     ", N[nn/r, 15]];

  (* Gamma method *)
  gamma = GammaPalindromicSqrt[nn, n_val, k];
  Print["Gamma value:    ", N[gamma, 15]];

  (* Test equalities *)
  Print["\nTesting:"];
  Print["  Gamma == r:     ", N[Abs[gamma - r], 10] < 10^-50];
  Print["  Gamma == nn/r:  ", N[Abs[gamma - nn/r], 10] < 10^-50];

  Print["  Actual diff Gamma - r:     ", N[gamma - r, 10]];
  Print["  Actual diff Gamma - nn/r:  ", N[gamma - nn/r, 10]];

  Print[""];
, {k, 1, 3}];

Print["=== ALGEBRAIC COMPARISON ===\n"];

Print["Egypt formula:"];
Print["  r = (x-1)/y * (1 + Sum[FactorialTerm[x-1, j], {j,1,k}])"];
Print["  where FactorialTerm uses factorial series\n"];

Print["Gamma formula:"];
Print["  (nn/n) * ((1+k)*n^2 - (3+5k)*nn + recon) / (n^2 - 3nn)"];
Print["  where recon uses Gamma palindromic weights\n"];

Print["Question: Is there algebraic equivalence?"];
Print["  FactorialTerm <==> Gamma weights?"];
Print["  Chebyshev <==> Beta function?\n"];

(* Try to show relationship for k=1 explicitly *)
Print["=== EXPLICIT k=1 case ===\n"];

k = 1;

Print["Egypt side:"];
ft1 = FactorialTerm[x_val - 1, 1];
Print["  FactorialTerm[x-1, 1] = ", N[ft1, 15]];
r1 = n_val * (1 + ft1);
Print["  r = n*(1 + ft1) = ", N[r1, 15]];

Print["\nGamma side:"];
(* Reconstruct for k=1 *)
lim1 = 1 + 1/2 (1 - (-1)^1) + Floor[1/2];
Print["  limit = ", lim1];

w1 = (n_val^(2 - 2*1 + 2*Ceiling[1/2]) * nn^1) / (Gamma[-1 + 2*1] * Gamma[4 - 2*1 + 1]);
Print["  w[1] = ", N[w1, 15]];

num1 = (-24 + 16*1^2*(1 + 1) + 4*1*(1 + 1)*(2 + 1) - 1*(24 + 1*(7 + 1))) / (-1 + 4*1^2);
Print["  numerator coeff = ", num1];

recon1 = nn * w1 * num1 / w1;
Print["  recon = ", N[recon1, 15]];

gamma1 = (nn/n_val) * ((1 + 1)*n_val^2 - (3 + 5*1)*nn + recon1) / (n_val^2 - 3*nn);
Print["  gamma result = ", N[gamma1, 15]];

Print["\nComparison:");
Print["  r1 = ", N[r1, 15]];
Print["  gamma1 = ", N[gamma1, 15]];
Print["  Equal? ", N[Abs[r1 - gamma1], 10] < 10^-50];
