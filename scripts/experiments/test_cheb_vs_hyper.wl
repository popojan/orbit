#!/usr/bin/env wolframscript

<< Orbit`

Print["Testing ChebyshevTerm vs Hypergeometric2F1...\n"];

(* Test case from user *)
x = 13;
k = 3;

cheb = ChebyshevTerm[x, k];
hyper = Hypergeometric2F1[1, 1, 1, -k*x];

Print["x = ", x, ", k = ", k];
Print["ChebyshevTerm[", x, ", ", k, "] = ", N[cheb, 10]];
Print["Hypergeometric2F1[1,1,1,-k*x] where k*x = ", k*x];
Print["  = Hypergeometric2F1[1,1,1,", -k*x, "]"];
Print["  = ", N[hyper, 10]];
Print["Equal? ", Abs[N[cheb] - N[hyper]] < 10^-10];
Print[];

(* Test FactorialTerm *)
fact = FactorialTerm[x, k];
Print["FactorialTerm[", x, ", ", k, "] = ", N[fact, 10]];
Print["ChebyshevTerm == FactorialTerm? ", Abs[N[cheb] - N[fact]] < 10^-10];
Print[];

(* Test the actual Egypt factor: 1/(1+kx) *)
Print["Testing individual Egypt factors:\n"];
egyptFactor[x_, k_] := 1/(1 + k*x);

Do[
  ef = egyptFactor[x, j];
  hyp = Hypergeometric2F1[1, 1, 1, -j*x];
  Print["j=", j, ": 1/(1+", j, "*", x, ") = ", N[ef, 8],
        ", ₂F₁[1,1,1;-", j*x, "] = ", N[hyp, 8],
        ", equal? ", Abs[ef - hyp] < 10^-10];
, {j, 1, 3}];

Print["\nDONE!"];
