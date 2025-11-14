#!/usr/bin/env wolframscript
(* Track UNREDUCED valuations as per the document formulas *)

(* Compute unreduced denominator for partial sum up to k *)
UnreducedDenominator[k_] := Module[{oddTerms},
  oddTerms = Table[2*j + 1, {j, 1, k}];
  2 * LCM @@ oddTerms
]

(* Compute unreduced numerator for partial sum up to k *)
UnreducedNumerator[k_] := Module[{D},
  D = UnreducedDenominator[k];
  Sum[(-1)^j * j! * (D/2) / (2*j + 1), {j, 1, k}]
]

(* Track valuations using unreduced form *)
TrackUnreducedValuations[kMax_, p_] := Module[{data},
  Print["Tracking unreduced valuations for p=", p, " up to k=", kMax];
  data = Table[
    Module[{D, N, nuD, nuN, diff, twoKplus1},
      twoKplus1 = 2*k + 1;
      D = UnreducedDenominator[k];
      N = UnreducedNumerator[k];
      nuD = IntegerExponent[D, p];
      nuN = IntegerExponent[N, p];
      diff = nuD - nuN;
      {k, twoKplus1, nuD, nuN, diff}
    },
    {k, 1, kMax}
  ];
  data
]

(* Extract jump points *)
ExtractJumps[data_] := Module[{jumps},
  jumps = {data[[1]]};  (* Always include first *)
  Do[
    If[data[[i, 3]] > data[[i-1, 3]],  (* ν_p(D) increased *)
      AppendTo[jumps, data[[i]]]
    ],
    {i, 2, Length[data]}
  ];
  jumps
]

(* Analyze for a prime *)
Print["=== Testing p=3 with unreduced tracking ==="];
data3 = TrackUnreducedValuations[20, 3];

Print["\nAll terms (k, 2k+1, ν_3(D), ν_3(N), diff):"];
Print["k\t2k+1\tν_3(D)\tν_3(N)\tDiff"];
Print[StringRiffle[#, "\t"]& /@ data3];

jumps3 = ExtractJumps[data3];
Print["\nJump points where ν_3(D) increases:"];
Print["k\t2k+1\tν_3(D)\tν_3(N)\tDiff"];
Print[StringRiffle[#, "\t"]& /@ jumps3];

(* Verify all differences are 1 *)
Print["\nAll differences equal 1? ", AllTrue[data3[[All, 5]], # == 1 &]];

(* Now do it for larger range to get more jumps *)
Print["\n=== Extending to k=400 for p=3 ==="];
data3Large = TrackUnreducedValuations[400, 3];
jumps3Large = ExtractJumps[data3Large];

Print["Jump points (k-values): ", jumps3Large[[All, 1]]];
Print["ν_3(D) sequence: ", jumps3Large[[All, 3]]];
Print["ν_3(N) sequence: ", jumps3Large[[All, 4]]];
Print["Differences: ", jumps3Large[[All, 5]]];

(* Try to find patterns *)
kValues = jumps3Large[[All, 1]];
Print["\nTrying FindSequenceFunction on k-values..."];
formula = FindSequenceFunction[kValues, n];
Print["Formula for k_n: ", formula];
Print["Verification: ", Table[formula, {n, 1, Length[kValues]}]];
Print["Match? ", Table[formula, {n, 1, Length[kValues]}] == kValues];

(* Check if k-values follow (p^n - 1)/2 pattern *)
Print["\nExpected k-values if 2k+1 = 3^n: ", Table[(3^n - 1)/2, {n, 1, 10}]];
