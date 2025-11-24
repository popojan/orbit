#!/usr/bin/env wolframscript
(* Identify the exact hypergeometric function *)

Print["=== Identify Hypergeometric Function ===\n"];

term[x_, k_, i_] := 2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);

Print["Step 1: Get Sum result and look for Hypergeometric"];
Print["====================================================\n"];

result = Sum[term[x, k, i], {i, 1, k}];
Print["Sum result: ", result // InputForm];
Print[];

Print["Step 2: Try FunctionExpand to reveal hypergeometric"];
Print["=====================================================\n"];

expanded = result // FunctionExpand;
Print["After FunctionExpand: ", expanded // InputForm];
Print[];

Print["Step 3: Express series as Hypergeometric directly"];
Print["===================================================\n"];

(* Try to recognize the series pattern *)
(* General hypergeometric: HypergeometricPFQ[{a_list}, {b_list}, z]
   = Sum[(Pochhammer[a1,n]...Pochhammer[ap,n])/(Pochhammer[b1,n]...Pochhammer[bq,n]) * z^n/n!, {n,0,∞}]
*)

Print["Our series: Sum[2^(i-1) * x^i * (k+i)!/((k-i)!(2i)!), {i, 1, k}]"];
Print[];
Print["Rewrite with Pochhammer:");
Print["(k+i)!/(k-i)! = Pochhammer[k-i+1, 2i] = Pochhammer[k+1-i, 2i]"];
Print[];
Print["So: Sum[2^(i-1) * x^i * Pochhammer[k+1-i, 2i]/(2i)!, {i, 1, k}]"];
Print[];

Print["Factor out x and 2^(i-1):"];
Print["= x * Sum[2^(i-1) * x^(i-1) * Pochhammer[k+1-i, 2i]/(2i)!, {i, 1, k}]"];
Print["= x * Sum[(2x)^(i-1)/2 * Pochhammer[k+1-i, 2i]/(2i)!, {i, 1, k}]"];
Print[];

Print["Step 4: Try using GeneratingFunction"];
Print["======================================\n"];

(* See if Mathematica can give us generating function *)
gf = GeneratingFunction[
  2^(i-1) * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]),
  i, x
];
Print["GeneratingFunction attempt: ", gf // InputForm];
Print[];

Print["Step 5: Check SPECIFIC hypergeometric forms"];
Print["=============================================\n"];

(* Common hypergeometric that appears with factorials *)

Print["Trying Hypergeometric2F1[a, b, c, z]:"];
(* This is often Sum[Pochhammer[a,n]*Pochhammer[b,n]/Pochhammer[c,n] * z^n/n!] *)

Print[];
Print["Our series involves:"];
Print["- Numerator: Pochhammer[k+1-i, 2i] ~ rising factorial"];
Print["- Denominator: (2i)! ~ falling factorial"];
Print["- Argument: involves x and 2^(i-1)"];
Print[];

Print["Step 6: Ask Mathematica to convert TO Hypergeometric"];
Print["======================================================\n"];

(* Force conversion *)
Print["Attempting ToHypergeometric:"];

(* This might not exist as function, let's try Through *)
converted = result;
Print["Result already IS in closed form: ", Not[FreeQ[converted, Sum]]];
Print[];

If[FreeQ[converted, Sum],
  Print["Sum already evaluated to closed form."];
  Print["The fact that it gives Cosh[...] means Mathematica KNOWS the identity!"];
  ,
  Print["Sum did not evaluate."];
];

Print[];
Print["Step 7: Literature search hints"];
Print["================================\n"];

Print["Based on trace, Sum uses:"];
Print["1. HypergeometricPFQ → series is recognized as generalized hypergeometric"];
Print["2. Transformation to Cosh/ArcSinh → hyperbolic function identity"];
Print[];

Print["This identity should be in:"];
Print["- NIST DLMF §15 (Hypergeometric) + §4 (Elementary)"];
Print["- Abramowitz & Stegun"];
Print["- Gradshteyn & Ryzhik"];
Print["- Possibly Prudnikov, Brychkov, Marichev (Integrals and Series)"];
Print[];

Print["Search terms:"];
Print["- 'Hypergeometric sum hyperbolic'"];
Print["- 'Cosh ArcSinh factorial'"];
Print["- 'Pochhammer factorial Cosh'"];
Print["- 'Generalized hypergeometric elementary'"];

Print[];
Print["=== Next Step ==="];
Print["Search DLMF and literature for this specific pattern"];
