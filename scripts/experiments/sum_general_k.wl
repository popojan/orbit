#!/usr/bin/env wolframscript
(* Analyze Sum with general symbolic k *)

Print["=== Sum with General k ===\n"];

(* Define the term *)
term[x_, k_, i_] := 2^(i-1) * x^i * Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);

Print["Step 1: Try Sum with symbolic k (THIS IS THE KEY!)"];
Print["====================================================\n"];

(* This is what we want Mathematica to evaluate *)
Print["Attempting: Sum[2^(i-1) * x^i * (k+i)!/((k-i)!(2i)!), {i, 1, k}]\n"];

(* Try different approaches *)

Print["Approach A: Direct Sum"];
Print["-----------------------"];
resultA = Sum[term[x, k, i], {i, 1, k}];
Print["Result: ", resultA // InputForm];
Print["Simplified: ", resultA // FullSimplify // TraditionalForm];
Print[];

Print["Approach B: Sum with assumptions k > 0"];
Print["---------------------------------------"];
resultB = Assuming[k > 0 && k \[Element] Integers,
  Sum[term[x, k, i], {i, 1, k}] // FullSimplify
];
Print["Result: ", resultB // InputForm];
Print[];

Print["Approach C: Try to recognize as Hypergeometric"];
Print["-----------------------------------------------"];
(* The series looks like it might be Hypergeometric2F1 or similar *)

(* General form: Hypergeometric2F1[a, b, c, z] = Sum[(Pochhammer[a,n] Pochhammer[b,n])/(Pochhammer[c,n] n!), {n, 0, Infinity}] *)

Print["The factorial term (k+i)!/(k-i)!(2i)! can be rewritten..."];
Print["Let's check the pattern:"];
Do[
  val = Factorial[k+i]/(Factorial[k-i] * Factorial[2*i]);
  Print["i=", i, ": (k+", i, ")!/(k-", i, ")!(", 2*i, ")! = ", val // InputForm];
, {i, 1, 3}];
Print[];

Print["Approach D: Use Pochhammer notation"];
Print["------------------------------------"];
(* Pochhammer[a, n] = a(a+1)(a+2)...(a+n-1) = Gamma[a+n]/Gamma[a] *)
(* So (k+i)!/(k-i)! = Pochhammer[k-i+1, 2i] *)

Do[
  fac = Factorial[k+i]/Factorial[k-i];
  poch = Pochhammer[k-i+1, 2*i];
  Print["i=", i, ": (k+i)!/(k-i)! = Pochhammer[k-i+1, 2i] = ",
    fac == poch // FullSimplify];
, {i, 1, 3}];
Print[];

Print["So our series is:"];
Print["Sum[2^(i-1) * x^i * Pochhammer[k-i+1, 2i]/(2i)!, {i, 1, k}]"];
Print[];

Print["Approach E: Check if Sum outputs Hypergeometric"];
Print["------------------------------------------------"];
(* Let's see if Mathematica recognizes it as hypergeometric *)
hyperCheck = Sum[term[x, k, i], {i, 1, k}];
Print["Does it contain HypergeometricPFQ? ",
  Not[FreeQ[hyperCheck, HypergeometricPFQ]]];
Print["Does it contain Hypergeometric2F1? ",
  Not[FreeQ[hyperCheck, Hypergeometric2F1]]];
Print[];

Print["Step 2: Compare structure with hyperbolic form"];
Print["===============================================\n"];

hypForm[x_, k_] := 1/2 + Cosh[(1+2*k)*ArcSinh[Sqrt[x/2]]]/(Sqrt[2]*Sqrt[2+x]);

Print["Hyperbolic form for k=3:"];
Print[hypForm[x, 3] // Expand // TraditionalForm];
Print[];

Print["Factorial sum for k=3:"];
facSum3 = 1 + Sum[term[x, 3, i], {i, 1, 3}];
Print[facSum3 // Expand // TraditionalForm];
Print[];

Print["Are they equal?"];
Print[FullSimplify[hypForm[x, 3] - facSum3] == 0];

Print[];
Print["=== Analysis Complete ==="];
