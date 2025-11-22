#!/usr/bin/env wolframscript
(* Compare three representations of FactorialTerm *)

<< Orbit`

Print["Comparing three forms of FactorialTerm...\n"];

z = 13;
k = 3;

(* 1. Original factorial form *)
factorial = Sum[2^(i-1) * z^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), {i, 1, k}];
factorialTerm = 1/(1 + factorial);

(* 2. Chebyshev form *)
chebTerm = ChebyshevTerm[z, k];

(* 3. Hyperbolic simplified form *)
hyperbolic = 1/(1/2 + Cosh[(1 + 2*k)*ArcSinh[Sqrt[z]/Sqrt[2]]]/(Sqrt[2]*Sqrt[2 + z]));

Print["z = ", z, ", k = ", k, "\n"];

Print["1. FACTORIAL FORM:"];
Print["   1/(1 + Sum[2^(i-1) * z^i * (k+i)! / ((k-i)! * (2i)!)])"];
Print["   = ", N[factorialTerm, 15]];
Print[];

Print["2. CHEBYSHEV FORM:"];
Print["   1/(ChebyshevT[⌈k/2⌉, z+1] * (ChebyshevU[⌊k/2⌋, z+1] - ChebyshevU[⌊k/2⌋-1, z+1]))"];
Print["   = ", N[chebTerm, 15]];
Print[];

Print["3. HYPERBOLIC FORM:"];
Print["   1/(1/2 + Cosh[(1+2k)·ArcSinh[√z/√2]] / (√2·√(2+z)))"];
Print["   = ", N[hyperbolic, 15]];
Print[];

Print["All three match? ",
  Abs[factorialTerm - chebTerm] < 10^-10 &&
  Abs[factorialTerm - hyperbolic] < 10^-10];
Print[];

(* Compare properties *)
Print["COMPARISON:\n"];

Print["FACTORIAL FORM:"];
Print["  ✓ Elementary (no special functions)"];
Print["  ✓ Direct computation from first principles"];
Print["  ✓ Easy to implement"];
Print["  ✗ Summation required (k terms)"];
Print["  ✗ Factorials grow fast"];
Print[];

Print["CHEBYSHEV FORM:"];
Print["  ✓ Compact notation"];
Print["  ✓ Connects to approximation theory"];
Print["  ✓ Well-studied orthogonal polynomials"];
Print["  ✓ Fast evaluation (recurrence relations)"];
Print["  ✗ Requires Chebyshev polynomial library"];
Print[];

Print["HYPERBOLIC FORM:"];
Print["  ✓ Single closed expression"];
Print["  ✓ No summation needed"];
Print["  ✓ Connects to hyperbolic geometry"];
Print["  ✗ Less intuitive"];
Print["  ✗ Requires Cosh, ArcSinh"];
Print["  ✓ Novel (not in literature)"];
Print[];

(* Expression complexity *)
Print["COMPLEXITY METRICS:\n"];

factorial = Sum[2^(i-1) * z^i * Factorial[k+i] / (Factorial[k-i] * Factorial[2*i]), {i, 1, k}];
Print["Factorial: ", LeafCount[factorial], " symbols"];

chebExpr = ChebyshevT[Ceiling[k/2], z+1] *
           (ChebyshevU[Floor[k/2], z+1] - ChebyshevU[Floor[k/2]-1, z+1]);
Print["Chebyshev: ", LeafCount[chebExpr], " symbols"];

hypExpr = 1/2 + Cosh[(1 + 2*k)*ArcSinh[Sqrt[z]/Sqrt[2]]]/(Sqrt[2]*Sqrt[2 + z]);
Print["Hyperbolic: ", LeafCount[hypExpr], " symbols"];
Print[];

Print["DONE!"];
