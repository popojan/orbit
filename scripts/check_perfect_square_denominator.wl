#!/usr/bin/env wolframscript
(*
Check if denominator of (n - approx^2) is a perfect square divisible by n^2
*)

Print["=" * 70];
Print["PERFECT SQUARE DENOMINATOR CHECK"];
Print["=" * 70];
Print[];

term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
(ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

partialSum[x_, k_] := 1 + Sum[term[x, j], {j, 1, k}]

CheckSquareDenominator[n_, x_, y_, kMax_:10] := Module[{},
Print["n = ", n, ", x = ", x, ", y = ", y];
Print[];

Print["For n - approx^2:"];
Print["k\tTotal\tNumerator\tDenominator\tSqrt(den)\tPerfect sq?\tDen mod n^2\tDiv by n^2?"];
Print["-" * 100];

Do[
Module[{totalTerms, sk, approx, diff, num, den, sqrtDen, isPerfSq, denMod, divByN2},
totalTerms = k + 1;
sk = partialSum[x - 1, k];

If[Head[sk] === Rational,
approx = (x - 1)/y * sk;

If[Head[approx] === Rational,
diff = n - approx^2;

If[Head[diff] === Rational,
num = Numerator[diff];
den = Denominator[diff];
sqrtDen = Sqrt[den];
isPerfSq = IntegerQ[sqrtDen];
denMod = Mod[den, n^2];
divByN2 = Divisible[den, n^2];

Print[k, "\t", totalTerms, "\t", num, "\t", den, "\t",
If[isPerfSq, sqrtDen, "no"], "\t\t",
isPerfSq, "\t", denMod, "\t\t", divByN2];

(* If perfect square, check what the sqrt is *)
If[isPerfSq,
Module[{s, sModN, sModX, sModY},
s = sqrtDen;
sModN = Mod[s, n];
sModX = Mod[s, x];
sModY = Mod[s, y];
Print["    sqrt(den) = ", s];
Print["      mod n = ", sModN];
Print["      mod x = ", sModX];
Print["      mod y = ", sModY];
Print["      equals y? ", s == y];
If[k > 1,
Module[{prevSk, prevApprox, prevDiff, prevDen, prevSqrt},
prevSk = partialSum[x - 1, k - 1];
prevApprox = (x - 1)/y * prevSk;
prevDiff = n - prevApprox^2;
prevDen = Denominator[prevDiff];
prevSqrt = Sqrt[prevDen];
If[IntegerQ[prevSqrt],
Print["      ratio to prev sqrt(den) = ", N[s / prevSqrt]];
];
];
];
];
];
,
Print[k, "\t", totalTerms, "\t", "?", "\t\t", "?", "\t\t", "?", "\t\t", "?", "\t\t", "?", "\t\t", "?"];
];
];
];
],
{k, 1, kMax}
];

Print[];
];

(* Test n=13 *)
Print["=" * 70];
Print["n=13"];
Print["=" * 70];
Print[];
CheckSquareDenominator[13, 649, 180, 8];

(* Test n=61 *)
Print["=" * 70];
Print["n=61"];
Print["=" * 70];
Print[];
CheckSquareDenominator[61, 1766319049, 226153980, 6];

Print["=" * 70];
