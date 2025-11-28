(* Build lookup table for ω=4 *)

Print["=== Building ω=4 lookup table ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
signSum2[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

(* Collect ω=4 data with all patterns *)
Print["Computing ω=4 cases...\n"];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    k = p1 p2 p3 p4;
    ss4 = signSum[k];

    (* All 6 pairs *)
    ss12 = signSum2[p1, p2]; ss13 = signSum2[p1, p3]; ss14 = signSum2[p1, p4];
    ss23 = signSum2[p2, p3]; ss24 = signSum2[p2, p4]; ss34 = signSum2[p3, p4];
    pairPattern = {ss12, ss13, ss14, ss23, ss24, ss34};
    sumPairs = Total[pairPattern];

    (* All 4 triples *)
    ss123 = signSum[p1 p2 p3]; ss124 = signSum[p1 p2 p4];
    ss134 = signSum[p1 p3 p4]; ss234 = signSum[p2 p3 p4];
    triplePattern = {ss123, ss124, ss134, ss234};
    sumTriples = Total[triplePattern];

    (* b-vector (CRT parities) *)
    c1 = p2 p3 p4 * PowerMod[p2 p3 p4, -1, p1];
    c2 = p1 p3 p4 * PowerMod[p1 p3 p4, -1, p2];
    c3 = p1 p2 p4 * PowerMod[p1 p2 p4, -1, p3];
    c4 = p1 p2 p3 * PowerMod[p1 p2 p3, -1, p4];
    bPattern = Mod[{c1, c2, c3, c4}, 2];

    (* Correction from additive formula *)
    correction = ss4 - sumTriples + sumPairs;

    AppendTo[data4, <|
      "p" -> {p1, p2, p3, p4}, "k" -> k, "ss4" -> ss4,
      "pairPattern" -> pairPattern, "sumPairs" -> sumPairs,
      "triplePattern" -> triplePattern, "sumTriples" -> sumTriples,
      "bPattern" -> bPattern, "correction" -> correction
    |>]
  ],
  {p1, Prime[Range[2, 6]]},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 10]]},
  {p4, Prime[Range[5, 12]]}
];

Print["Total ω=4 cases: ", Length[data4], "\n"];

(* Test: Is correction constant for each b-pattern? *)
Print["=== Correction by b-pattern only ===\n"];
byB = GroupBy[data4, #["bPattern"] &];
constantByB = True;
Do[
  corrs = Union[#["correction"] & /@ byB[b]];
  If[Length[corrs] > 1, constantByB = False];
  Print["b = ", b, ": corrections = ", corrs, " (", Length[byB[b]], " cases)"],
  {b, Sort[Keys[byB]]}
];
Print["\nConstant by b alone? ", constantByB];

(* Test: Is correction constant for (sumPairs, sumTriples)? *)
Print["\n=== Correction by (sumPairs, sumTriples) ===\n"];
bySums = GroupBy[data4, {#["sumPairs"], #["sumTriples"]} &];
constantBySums = True;
Do[
  corrs = Union[#["correction"] & /@ bySums[key]];
  If[Length[corrs] > 1, constantBySums = False];
  If[Length[bySums[key]] >= 2,
    Print["(sumP, sumT) = ", key, ": corrs = ", corrs, " (", Length[bySums[key]], " cases)"]
  ],
  {key, Sort[Keys[bySums]]}
];
Print["\nConstant by (sumPairs, sumTriples)? ", constantBySums];

(* Test: Is correction constant for (b-pattern, number of 1s in pairPattern)? *)
Print["\n=== Correction by (b, #{pairs=1}) ===\n"];
byBAndPairCount = GroupBy[data4, {#["bPattern"], Count[#["pairPattern"], 1]} &];
constantByBP = True;
Do[
  corrs = Union[#["correction"] & /@ byBAndPairCount[key]];
  If[Length[corrs] > 1, constantByBP = False],
  {key, Keys[byBAndPairCount]}
];
Print["Constant by (b, #{pairs=1})? ", constantByBP];

(* Test: Is correction constant for (b-pattern, sumTriples)? *)
Print["\n=== Correction by (b, sumTriples) ===\n"];
byBAndSumT = GroupBy[data4, {#["bPattern"], #["sumTriples"]} &];
constantByBT = True;
Do[
  corrs = Union[#["correction"] & /@ byBAndSumT[key]];
  If[Length[corrs] > 1, constantByBT = False],
  {key, Keys[byBAndSumT]}
];
Print["Constant by (b, sumTriples)? ", constantByBT];

(* Test: Is correction constant for (b, sumPairs)? *)
Print["\n=== Correction by (b, sumPairs) ===\n"];
byBAndSumP = GroupBy[data4, {#["bPattern"], #["sumPairs"]} &];
constantByBP2 = True;
numConstant = 0;
Do[
  corrs = Union[#["correction"] & /@ byBAndSumP[key]];
  If[Length[corrs] == 1, numConstant++, constantByBP2 = False],
  {key, Keys[byBAndSumP]}
];
Print["Constant by (b, sumPairs)? ", constantByBP2];
Print["Constant patterns: ", numConstant, " / ", Length[Keys[byBAndSumP]]];

(* Test the full combination *)
Print["\n=== Correction by (b, sumPairs, sumTriples) ===\n"];
byFull = GroupBy[data4, {#["bPattern"], #["sumPairs"], #["sumTriples"]} &];
constantFull = True;
numConstantFull = 0;
Do[
  corrs = Union[#["correction"] & /@ byFull[key]];
  If[Length[corrs] == 1, numConstantFull++, constantFull = False],
  {key, Keys[byFull]}
];
Print["Constant by (b, sumPairs, sumTriples)? ", constantFull];
Print["Constant patterns: ", numConstantFull, " / ", Length[Keys[byFull]]];

If[constantFull,
  Print["\n=== LOOKUP TABLE ===\n"];
  Print["Format: (b, sumPairs, sumTriples) -> correction\n"];
  sortedKeys = SortBy[Keys[byFull], {#[[2]], #[[3]], #[[1]]} &];
  Do[
    corr = First[Union[#["correction"] & /@ byFull[key]]];
    {b, sp, st} = key;
    Print["b=", b, " sumP=", sp, " sumT=", st, " → c=", corr],
    {key, sortedKeys}
  ]
];

(* Maybe simpler: just b and #{1s in b}? *)
Print["\n=== Simpler: correction by (#{1s in b}, sumTriples - sumPairs) ===\n"];
bySimple = GroupBy[data4, {Total[#["bPattern"]], #["sumTriples"] - #["sumPairs"]} &];
constantSimple = True;
Do[
  corrs = Union[#["correction"] & /@ bySimple[key]];
  If[Length[corrs] > 1, constantSimple = False];
  Print[key, " → ", corrs, " (", Length[bySimple[key]], " cases)"],
  {key, Sort[Keys[bySimple]]}
];
Print["\nConstant by simple? ", constantSimple];
