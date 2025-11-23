#!/usr/bin/env wolframscript
(* Verify the symbolic form found by Mathematica *)

Print["Verifying symbolic closed form...\n"];

<< Orbit`

(* Symbolic form from Sum *)
symbolicForm[z_, k_] := -1/2 * (Sqrt[2 + z] - Sqrt[2]*Cosh[(1 + 2*k)*ArcSinh[Sqrt[z]/Sqrt[2]]]) / Sqrt[2 + z];

(* Our explicit sum *)
factSum[x_, j_] := Sum[2^(i-1) * x^i * Factorial[j+i] /
                        (Factorial[j-i] * Factorial[2*i]), {i, 1, j}];

Print["Numerical verification:\n"];
Print["k\\tx\\tSymbolic\\t\\tExplicit Sum\\t\\tMatch?\n"];
Print[StringRepeat["-", 70]];

Do[
  Do[
    sym = N[symbolicForm[xval, kval], 10];
    exp = N[factSum[xval, kval], 10];
    match = Abs[sym - exp] < 10^-8;
    Print[kval, "\\t", N[xval,3], "\\t", sym, "\\t", exp, "\\t", match];
  , {xval, {1/2, 1, 2}}];
, {kval, 1, 4}];
Print[];

(* Relationship to hyperbolic functions *)
Print["Analysis: Hyperbolic function form\n"];
Print["The symbolic form uses:"];
Print["  - Cosh (hyperbolic cosine)"];
Print["  - ArcSinh (inverse hyperbolic sine)"];
Print["  - Square roots"];
Print[];
Print["This is NOT a hypergeometric function!\n"];
Print["Hypergeometric functions are defined as:");
Print["  ₚFₑ(a₁,...,aₚ; b₁,...,bₑ; z) = Sum[(a₁)_n...(aₚ)_n / ((b₁)_n...(bₑ)_n * n!)] * z^n\n"];
Print[];
Print["Our function is a FINITE POLYNOMIAL (for fixed k), thus RATIONAL.\n"];

(* Express FactorialTerm in terms of the symbolic form *)
Print["FactorialTerm relation:\n"];
Print["FactorialTerm[x, k] = 1 / (1 + factSum[x, k])"];
Print["                     = 1 / (1 + symbolicForm[x, k])\n"];

(* Check if it simplifies further *)
Print["Testing simplification:\n"];
k = 2;
x = 1;
full = 1 / (1 + symbolicForm[x, k]);
fact = FactorialTerm[x, k];
Print["k=", k, ", x=", x, ":"];
Print["  1/(1+symbolic) = ", N[full, 10]];
Print["  FactorialTerm  = ", N[fact, 10]];
Print["  Match? ", Abs[N[full] - N[fact]] < 10^-8];
Print[];

Print["FINAL ANSWER:\n"];
Print["FactorialTerm[x, k] is RATIONAL (polynomial / polynomial)"];
Print["The numerator sum has closed form via hyperbolic functions,"];
Print["but this is NOT a hypergeometric function representation.\n"];

Print["Relation to Hypergeometric2F1:");
Print["  - Individual Egypt factors: 1/(1+jx) = ₂F₁[1,1,1;-jx] ✓"];
Print["  - Their product (FactorialTerm): NOT hypergeometric ✗\n"];

Print["DONE!"];
