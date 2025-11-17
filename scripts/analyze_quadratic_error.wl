#!/usr/bin/env wolframscript
(*
Analyze quadratic error: difference between approximation and actual sqrt
Check if denominator is divisible by n^2
*)

Print["=" * 70];
Print["QUADRATIC ERROR ANALYSIS"];
Print["=" * 70];
Print[];

term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
(ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

partialSum[x_, k_] := 1 + Sum[term[x, j], {j, 1, k}]

AnalyzeError[n_, x_, y_, kMax_:8] := Module[{sqrtN},
sqrtN = Sqrt[n];

Print["n = ", n, ", x = ", x, ", y = ", y];
Print["sqrt(n) = ", N[sqrtN, 20]];
Print[];

Print["k\tTotal\tApproximation\t\tError\t\tError^2\t\tError^2 den mod n^2"];
Print["-" * 90];

Do[
Module[{totalTerms, sk, approx, err, err2, err2Num, err2Den, denMod},
totalTerms = k + 1;
sk = partialSum[x - 1, k];

If[Head[sk] === Rational,
approx = (x - 1)/y * sk;

If[Head[approx] === Rational,
(* Error = approximation - sqrt(n) *)
err = approx - sqrtN;
err2 = err^2;

(* Try to get rational form *)
If[Head[err2] === Power && err2[[1]] === Plus,
(* It's (a + b*sqrt(n))^2 form, need to rationalize *)
Module[{rat},
rat = (approx^2 - n);  (* This should be rational *)
If[Head[rat] === Rational,
err2Num = Numerator[rat];
err2Den = Denominator[rat];
denMod = Mod[err2Den, n^2];
Print[k, "\t", totalTerms, "\t", N[approx, 10], "\t", N[err, 10], "\t",
"num:", err2Num, "\t", "den:", err2Den, "\tden mod n^2:", denMod];
,
Print[k, "\t", totalTerms, "\t", N[approx, 10], "\t", N[err, 10], "\t", "?"];
];
];
,
Print[k, "\t", totalTerms, "\t", N[approx, 10], "\t", N[err, 10], "\t", "?"];
];
];
];
],
{k, 1, kMax}
];

Print[];

(* Alternatively: look at (approx - sqrt(n))*(approx + sqrt(n)) = approx^2 - n *)
Print["Alternative: approx^2 - n (should be rational):"];
Print["k\tTotal\tNumerator\tDenominator\tDen mod n^2\tDen div by n^2?"];
Print["-" * 80];

Do[
Module[{totalTerms, sk, approx, diff, num, den, denMod, denDiv},
totalTerms = k + 1;
sk = partialSum[x - 1, k];

If[Head[sk] === Rational,
approx = (x - 1)/y * sk;

If[Head[approx] === Rational,
diff = approx^2 - n;

If[Head[diff] === Rational,
num = Numerator[diff];
den = Denominator[diff];
denMod = Mod[den, n^2];
denDiv = Divisible[den, n^2];
Print[k, "\t", totalTerms, "\t", num, "\t", den, "\t", denMod, "\t\t", denDiv];
,
Print[k, "\t", totalTerms, "\t", "?", "\t\t", "?", "\t\t", "?", "\t\t", "?"];
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
AnalyzeError[13, 649, 180, 8];

(* Test n=61 *)
Print["=" * 70];
Print["n=61"];
Print["=" * 70];
Print[];
AnalyzeError[61, 1766319049, 226153980, 6];

Print["=" * 70];
