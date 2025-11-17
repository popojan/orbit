#!/usr/bin/env wolframscript
(*
Analyze structure of partial sums S_k = 1 + Sum[term(x-1,j), {j,1,k}]
to understand TOTAL-EVEN divisibility mechanism
*)

Print["=" * 70];
Print["PARTIAL SUMS MOD n ANALYSIS"];
Print["=" * 70];
Print[];

term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
(ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

(* Partial sum with k terms AFTER the leading 1 *)
partialSum[x_, k_] := 1 + Sum[term[x, j], {j, 1, k}]

(* Analyze partial sums for given n *)
AnalyzePartialSums[n_, x_, y_, kMax_:10] := Module[{data},
Print["n = ", n, ", x = ", x, ", y = ", y];
Print["x mod n = ", Mod[x, n], If[Mod[x,n] == n-1, " (x \[Congruent] -1)", ""]];
Print["x+1 mod n = ", Mod[x+1, n]];
Print["2+x mod n = ", Mod[2+x, n]];
Print[];

Print["Analysis of S_k = 1 + Sum[term(x-1,j), {j,1,k}]:"];
Print[];
Print["k\tTotal\tParity\tS_k numerator\tS_k num mod n\tE_k num mod n\tDivisible?"];
Print["-" * 80];

Do[
Module[{totalTerms, parity, sk, skNum, skMod, fullExpr, ekNum, ekMod, divisible},
totalTerms = k + 1;
parity = If[EvenQ[totalTerms], "EVEN", "ODD"];

sk = partialSum[x - 1, k];

If[Head[sk] === Rational,
skNum = Numerator[sk];
skMod = Mod[skNum, n];

fullExpr = (x - 1)/y * sk;
If[Head[fullExpr] === Rational,
ekNum = Numerator[fullExpr];
ekMod = Mod[ekNum, n];
divisible = (ekMod == 0);

Print[k, "\t", totalTerms, "\t", parity, "\t", skNum, "\t", skMod, "\t\t", ekMod, "\t\t", divisible];
,
Print[k, "\t", totalTerms, "\t", parity, "\t", skNum, "\t", skMod, "\t\t", "?", "\t\t", "?"];
];
,
Print[k, "\t", totalTerms, "\t", parity, "\t", "?", "\t\t", "?", "\t\t", "?", "\t\t", "?"];
];
],
{k, 1, kMax}
];

Print[];
];

(* Test n=13 *)
Print["=" * 70];
Print["n=13 (fundamental case)"];
Print["=" * 70];
Print[];
AnalyzePartialSums[13, 649, 180, 10];

(* Test n=61 *)
Print["=" * 70];
Print["n=61 (touchstone case)"];
Print["=" * 70];
Print[];
AnalyzePartialSums[61, 1766319049, 226153980, 10];

Print["=" * 70];
