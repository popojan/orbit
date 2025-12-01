(* Falsification Test for 22-bit Pattern Hypothesis *)
(* Date: 2025-11-30 *)

hierarchicalPattern[primes_] := Module[{omega = Length[primes], pattern = {}},
  (* Level 2: pairwise inverse parities *)
  Do[AppendTo[pattern, Mod[PowerMod[primes[[i]], -1, primes[[j]]], 2]],
     {i, 1, omega-1}, {j, i+1, omega}];
  (* Levels 3 to omega: CRT parities *)
  Do[Do[
    Module[{Mi}, Do[
      Mi = (Times @@ subset)/subset[[idx]];
      AppendTo[pattern, Mod[PowerMod[Mi, -1, subset[[idx]]], 2]],
      {idx, Length[subset]}]],
    {subset, Subsets[primes, {level}]}],
  {level, 3, omega}];
  Flatten[pattern]
];

signSum[k_] := Module[{count = 0},
  Do[If[CoprimeQ[m-1, k] && CoprimeQ[m, k], count += If[OddQ[m], 1, -1]], {m, 2, k-1}];
  count
];

(* Test with 21 primes *)
primes = Select[Range[3, 80], PrimeQ];
products = Subsets[primes, {4}];

data = Table[{ps, hierarchicalPattern[ps], signSum[Times @@ ps]}, {ps, products}];
grouped = GroupBy[data, #[[2]] &];
repeated = Select[grouped, Length[#] >= 2 &];

conflicts = {};
Do[
  Module[{reps = group[[All, 1]], ssVals},
    ssVals = signSum[Times @@ #] & /@ reps;
    If[Length[DeleteDuplicates[ssVals]] > 1,
      AppendTo[conflicts, {group[[1, 2]], reps, ssVals}];
    ];
  ],
  {group, Values[repeated]}
];

Print["Products: ", Length[products]];
Print["Unique patterns: ", Length[grouped]];
Print["Repeated patterns: ", Length[repeated]];
Print["CONFLICTS: ", Length[conflicts]];
