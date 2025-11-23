#!/usr/bin/env wolframscript
(* Test exact equality with numeric values *)

<< Orbit`

Print["=== EXACT EQUALITY TEST ===\n"];

(* Pell solution for sqrt(13) *)
nn = 13;
xval = 649;
yval = 180;
nval = (xval - 1)/yval;

Print["Parameters:"];
Print["  nn = ", nn];
Print["  x = ", xval, ", y = ", yval];
Print["  n = (x-1)/y = ", N[nval, 20], "\n"];

Print["Testing k=1,2,3:\n"];

Do[
  Print["=== k = ", k, " ==="];

  (* Egypt r *)
  r = nval * (1 + Sum[FactorialTerm[xval - 1, j], {j, 1, k}]);

  (* Gamma value *)
  gamma = GammaPalindromicSqrt[nn, nval, k];

  Print["Egypt r:        ", N[r, 20]];
  Print["Gamma:          ", N[gamma, 20]];
  Print["nn/r:           ", N[nn/r, 20]];
  Print["Difference:     ", N[Abs[gamma - r], 20]];
  Print["Relative diff:  ", N[Abs[(gamma - r)/r], 10]];

  If[N[Abs[gamma - r], 20] < 10^-15,
    Print["==> EQUAL: Gamma == r"],
    If[N[Abs[gamma - nn/r], 20] < 10^-15,
      Print["==> EQUAL: Gamma == nn/r"],
      Print["==> DIFFERENT: Neither r nor nn/r"]
    ]
  ];

  Print[""];
, {k, 1, 3}];

Print["=== ALGEBRAIC INVESTIGATION ===\n"];

(* Let's try symbolic simplification for k=1 *)
Print["Symbolic test for general n (not specific value):\n"];

(* Egypt formula for k=1 *)
Print["Egypt formula (k=1):"];
Print["  r = n * (1 + 1/x)"];
Print["  where x comes from Pell solution, and n = (x-1)/y\n"];

Print["Gamma formula (k=1):"];
Print["  Result involves Gamma(1)*Gamma(3) in weight"];
Print["  Gamma(1) = 1, Gamma(3) = 2! = 2"];
Print["  Weight: n^(2-2+2*1) * nn^1 / (1 * 2) = n^2 * nn / 2\n"];

Print["Checking if FactorialTerm has Gamma representation...\n"];

(* Show FactorialTerm structure *)
Do[
  ft = FactorialTerm[xval-1, j];
  Print["FactorialTerm[x-1, ", j, "] = ", N[ft, 15]];
  Print["  Formula: 1 / (1 + Sum[2^(i-1)*x^i*(j+i)!/((j-i)!*(2i)!), {i,1,j}])"];
, {j, 1, 3}];

Print["\n==> Key question: Can factorial series be rewritten using Gamma functions?"];
Print["==> This would establish Chebyshev <-> Gamma connection"];
