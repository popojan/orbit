#!/usr/bin/env wolframscript

Print["1/k STRUCTURE - PART 2: KEY INSIGHTS"];
Print[StringRepeat["=", 70]];
Print[];

Print[StringRepeat["=", 70]];
Print["INSIGHT 1: ODD-k SUM IS LEIBNIZ FORMULA"];
Print[StringRepeat["=", 70]];
Print[];

Print["AB[2m+1] = 1/(2m+1) for odd k"];
Print[];
Print["Sum of odd terms:"];
Print["  Σ_{m=0}^∞ 1/(2m+1) = 1 + 1/3 + 1/5 + 1/7 + ..."];
Print["  This is the Leibniz formula for π/4!"];
Print[];

oddPartialSums = Table[
  {n, N[Sum[1/(2*m+1), {m, 0, n}], 10]},
  {n, {10, 50, 100, 500, 1000}}
];

Print["Partial sums:"];
Do[
  Print["  n=", oddPartialSums[[i,1]], ": ", oddPartialSums[[i,2]], 
        " (error from π/4: ", Abs[oddPartialSums[[i,2]] - N[Pi/4, 10]], ")"];
, {i, 1, Length[oddPartialSums]}];
Print[];
Print["π/4 = ", N[Pi/4, 10]];
Print[];

Print[StringRepeat["=", 70]];
Print["INSIGHT 2: ANALYTICAL CONTINUATION TO REAL k"];
Print[StringRepeat["=", 70]];
Print[];

Print["Define AB(x) for real x:"];
Print["  AB(x) = (1/2)[∫ sin(x*θ) dθ - ∫ sin(x*θ)cos(θ) dθ]"];
Print[];

(* Compute symbolically *)
ABcont[x_] := (1/2)*(
  Integrate[Sin[x*theta], {theta, 0, Pi}] - 
  Integrate[Sin[x*theta]*Cos[theta], {theta, 0, Pi}]
);

Print["Symbolic form:"];
abSym = ABcont[x] // FullSimplify;
Print["  AB(x) = ", abSym];
Print[];

Print["Evaluating at integer and half-integer k:"];
vals = Table[
  {k, ABcont[k] // N},
  {k, 1, 10, 0.5}
];
Print["k\tAB(k)"];
Print[StringRepeat["-", 40]];
Do[Print[vals[[i,1]], "\t", vals[[i,2]]], {i, 1, Length[vals]}];
Print[];

Print[StringRepeat["=", 70]];
Print["INSIGHT 3: CONNECTION TO DIRICHLET ETA FUNCTION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Dirichlet eta function: η(s) = Σ_{n=1}^∞ (-1)^(n+1)/n^s"];
Print["For s=1: η(1) = ln(2) = ", N[Log[2], 10]];
Print[];

Print["Our alternating sum (from earlier): Σ (-1)^k AB[k]"];
Print["This is NOT η(1) because AB[k] has different sign pattern"];
Print[];

(* Separate odd/even *)
Print["Separating into odd and even k:"];
oddSum = Sum[1/(2*m+1), {m, 0, 100}] // N;
evenSum = Sum[-(1/(2*m+2) + 1/(2*m))/(2), {m, 1, 100}] // N;
Print["  Odd sum (m=0..100): ", oddSum];
Print["  Even sum (m=1..100): ", evenSum];
Print["  Total: ", oddSum + evenSum];
Print[];

Print[StringRepeat["=", 70]];
Print["INSIGHT 4: RELATION TO CATALAN'S CONSTANT?"];
Print[StringRepeat["=", 70]];
Print[];

Print["Catalan's constant: G = Σ_{n=0}^∞ (-1)^n/(2n+1)^2 = ", N[Catalan, 10]];
Print[];

Print["Our series is linear (1/k), not quadratic (1/k^2)"];
Print["But weighted versions might connect..."];
Print[];

(* Try weighted sum *)
weighted = Sum[AB[k]/k, {k, 1, 50}] // N;
Print["Trying: Σ AB[k]/k = ", weighted];
Print["Catalan/2 = ", N[Catalan/2, 10]];
Print["π^2/24 = ", N[Pi^2/24, 10]];
Print[];

Print[StringRepeat["=", 70]];
Print["INSIGHT 5: EULER SUM CONNECTION"];
Print[StringRepeat["=", 70]];
Print[];

Print["Euler sums: S(p,q) = Σ_{n=1}^∞ (H_n^(p))/n^q"];
Print["where H_n^(p) = Σ_{k=1}^n 1/k^p"];
Print[];

Print["Our AB[k] structure suggests connection to p=1, q=0"];
Print["But this diverges..."];
Print[];

Print["More promising: Look at"];
Print["  F(x) = Σ AB[k] x^k / k  (Polylogarithm-like)"];
Print[];

polylog_like = Sum[AB[k] * (1/2)^k / k, {k, 1, 50}] // N;
Print["F(1/2) = ", polylog_like];
Print["Compare to Li_2(1/2) = ", N[PolyLog[2, 1/2], 10]];
Print[];

Print["DONE!"];
