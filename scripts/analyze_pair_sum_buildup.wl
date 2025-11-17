#!/usr/bin/env wolframscript
(*
Analyze how partial sums build up using pair sum structure
term[x,2m] + term[x,2m+1] = (2+x) / poly_m(x)
*)

Print["=" * 70];
Print["PAIR SUM BUILDUP ANALYSIS"];
Print["=" * 70];
Print[];

term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
(ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

(* Pair sum for even/odd consecutive terms *)
pairSum[x_, m_] := term[x, 2*m] + term[x, 2*m + 1]

AnalyzePairBuildup[n_, x_, y_] := Module[{},
Print["n = ", n, ", x = ", x];
Print["x mod n = ", Mod[x, n]];
Print["2+x mod n = ", Mod[2+x, n]];
Print[];

(* Show individual terms and pairs *)
Print["Individual terms mod n:"];
Print["k\tterm[x-1,k] numerator mod n"];
Print["-" * 50];
Do[
Module[{t, num, numMod},
t = term[x - 1, k];
If[Head[t] === Rational,
num = Numerator[t];
numMod = Mod[num, n];
Print[k, "\t", numMod];
,
Print[k, "\t", "?"];
];
],
{k, 1, 8}
];
Print[];

(* Show pair sums *)
Print["Pair sums (term[x-1,2m] + term[x-1,2m+1]):"];
Print["m\tPair sum numerator\tNumerator mod n\tEquals (2+x)?"];
Print["-" * 70];
Do[
Module[{ps, num, numMod},
ps = pairSum[x - 1, m];
If[Head[ps] === Rational,
num = Numerator[ps];
numMod = Mod[num, n];
Print[m, "\t", num, "\t", numMod, "\t\t", numMod == Mod[2+x, n]];
,
Print[m, "\t", "?", "\t\t", "?", "\t\t", "?"];
];
],
{m, 1, 4}
];
Print[];

(* Build up partial sums showing structure *)
Print["Partial sum structure:"];
Print["k\tTotal\tS_k = ... \tS_k num mod n"];
Print["-" * 70];

Module[{s},
(* k=1: just 1 + term[1] *)
s = 1 + term[x - 1, 1];
If[Head[s] === Rational,
Print[1, "\t", 2, "\t", "1 + t[1]", "\t\t", Mod[Numerator[s], n]];
];

(* k=2: 1 + term[1] + term[2] *)
s = 1 + term[x - 1, 1] + term[x - 1, 2];
If[Head[s] === Rational,
Print[2, "\t", 3, "\t", "1 + t[1] + t[2]", "\t", Mod[Numerator[s], n]];
];

(* k=3: 1 + (term[1] + term[2]) + term[3] *)
s = 1 + term[x - 1, 1] + term[x - 1, 2] + term[x - 1, 3];
If[Head[s] === Rational,
Print[3, "\t", 4, "\t", "1 + pair(1) + t[3]", "\t", Mod[Numerator[s], n]];
];

(* k=4: 1 + pair(1) + (term[3] + term[4]) *)
s = 1 + Sum[term[x - 1, j], {j, 1, 4}];
If[Head[s] === Rational,
Print[4, "\t", 5, "\t", "1 + pair(1) + pair(1.5)", "\t", Mod[Numerator[s], n]];
];

(* k=5: 1 + pair(1) + pair(2) + term[5] *)
s = 1 + Sum[term[x - 1, j], {j, 1, 5}];
If[Head[s] === Rational,
Print[5, "\t", 6, "\t", "1 + p(1) + p(2) + t[5]", "\t", Mod[Numerator[s], n]];
];

(* k=6: 1 + pair(1) + pair(2) + (term[5] + term[6]) *)
s = 1 + Sum[term[x - 1, j], {j, 1, 6}];
If[Head[s] === Rational,
Print[6, "\t", 7, "\t", "1 + p(1) + p(2) + p(2.5)", "\t", Mod[Numerator[s], n]];
];
];

Print[];
];

(* Test n=13 *)
Print["=" * 70];
Print["n=13"];
Print["=" * 70];
Print[];
AnalyzePairBuildup[13, 649, 180];

(* Test n=61 *)
Print["=" * 70];
Print["n=61"];
Print["=" * 70];
Print[];
AnalyzePairBuildup[61, 1766319049, 226153980];

Print["=" * 70];
