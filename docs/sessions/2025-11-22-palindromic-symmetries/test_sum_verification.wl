#!/usr/bin/env wolframscript

<< Orbit`

Print["Verifying sum vs FactorialTerm relationship...\n"];

x = 13;
k = 3;

(* Symbolic form for the SUM *)
symbolicForm = -1/2 * (Sqrt[2 + x] - Sqrt[2]*Cosh[(1 + 2*k)*ArcSinh[Sqrt[x]/Sqrt[2]]]) / Sqrt[2 + x];

(* Explicit sum *)
factSum = Sum[2^(i-1) * x^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), {i, 1, k}];

(* Functions from Orbit paclet *)
factTerm = FactorialTerm[x, k];
chebTerm = ChebyshevTerm[x, k];

Print["x = ", x, ", k = ", k];
Print[];
Print["Symbolic form (hyperbolic) = ", N[symbolicForm, 12]];
Print["Explicit sum              = ", factSum];
Print["Match? ", Abs[symbolicForm - factSum] < 10^-10];
Print[];
Print["FactorialTerm[13, 3] = ", N[factTerm, 15]];
Print["ChebyshevTerm[13, 3] = ", N[chebTerm, 15]];
Print["1/(1 + sum)          = ", N[1/(1 + factSum), 15]];
Print[];
Print["FactorialTerm == ChebyshevTerm? ", Abs[factTerm - chebTerm] < 10^-10];
Print["FactorialTerm == 1/(1+sum)?     ", Abs[factTerm - 1/(1+factSum)] < 10^-10];
Print[];
Print["Sum value: ", factSum];
Print["1 + sum  : ", 1 + factSum];
Print["1/(1+sum): ", 1/(1 + factSum)];
Print[];

Print["DONE!"];
