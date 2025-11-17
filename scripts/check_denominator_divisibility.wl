#!/usr/bin/env wolframscript
(*
Check hypothesis: when numerator NOT divisible by n, is denominator divisible?
*)

Print["=" * 70];
Print["DENOMINATOR DIVISIBILITY CHECK"];
Print["=" * 70];
Print[];

term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
(ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

partialSum[x_, k_] := 1 + Sum[term[x, j], {j, 1, k}]

CheckDenominators[n_, x_, y_, kMax_:10] := Module[{},
Print["n = ", n, ", x = ", x];
Print[];
Print["k\tTotal\tNum mod n\tDen mod n\tNum div?\tDen div?\tE_k num mod n"];
Print["-" * 80];

Do[
Module[{totalTerms, sk, skNum, skDen, numMod, denMod, numDiv, denDiv, fullExpr, ekMod},
totalTerms = k + 1;
sk = partialSum[x - 1, k];

If[Head[sk] === Rational,
skNum = Numerator[sk];
skDen = Denominator[sk];
numMod = Mod[skNum, n];
denMod = Mod[skDen, n];
numDiv = (numMod == 0);
denDiv = (denMod == 0);

fullExpr = (x - 1)/y * sk;
If[Head[fullExpr] === Rational,
ekMod = Mod[Numerator[fullExpr], n];
Print[k, "\t", totalTerms, "\t", numMod, "\t\t", denMod, "\t\t", numDiv, "\t", denDiv, "\t", ekMod];
,
Print[k, "\t", totalTerms, "\t", numMod, "\t\t", denMod, "\t\t", numDiv, "\t", denDiv, "\t", "?"];
];
,
Print[k, "\t", totalTerms, "\t", "?", "\t\t", "?", "\t\t", "?", "\t", "?", "\t", "?"];
];
],
{k, 1, kMax}
];

Print[];

(* Summary *)
Module[{results, numDivCount, denDivCount, bothCount, neitherCount},
results = Table[
Module[{sk, numDiv, denDiv},
sk = partialSum[x - 1, k];
If[Head[sk] === Rational,
numDiv = Divisible[Numerator[sk], n];
denDiv = Divisible[Denominator[sk], n];
{numDiv, denDiv}
,
{False, False}
]
],
{k, 1, kMax}
];

numDivCount = Count[results, {True, _}];
denDivCount = Count[results, {_, True}];
bothCount = Count[results, {True, True}];
neitherCount = Count[results, {False, False}];

Print["SUMMARY:"];
Print["  Numerator divisible: ", numDivCount, " / ", kMax];
Print["  Denominator divisible: ", denDivCount, " / ", kMax];
Print["  Both divisible: ", bothCount, " / ", kMax];
Print["  Neither divisible: ", neitherCount, " / ", kMax];
Print[];

(* Check if XOR holds *)
xorCount = Count[results, {True, False}] + Count[results, {False, True}];
Print["  XOR (exactly one divisible): ", xorCount, " / ", kMax];
Print["  Hypothesis verified? ", xorCount == kMax];
Print[];
];
];

(* Test n=13 *)
Print["=" * 70];
Print["n=13"];
Print["=" * 70];
Print[];
CheckDenominators[13, 649, 180, 10];

(* Test n=61 *)
Print["=" * 70];
Print["n=61"];
Print["=" * 70];
Print[];
CheckDenominators[61, 1766319049, 226153980, 10];

Print["=" * 70];
