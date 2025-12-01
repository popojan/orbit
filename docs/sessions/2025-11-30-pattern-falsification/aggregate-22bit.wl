(* Test: Can we aggregate the 22-bit pattern into fewer bits? *)

signSum[k_] := Module[{count = 0},
  Do[If[CoprimeQ[m-1, k] && CoprimeQ[m, k], count += If[OddQ[m], 1, -1]], {m, 2, k-1}];
  count
];

(* Original 22-bit pattern *)
hierarchicalPattern[primes_] := Module[{omega = Length[primes], pattern = {}},
  Do[AppendTo[pattern, Mod[PowerMod[primes[[i]], -1, primes[[j]]], 2]],
     {i, 1, omega-1}, {j, i+1, omega}];
  Do[Do[
    Module[{Mi}, Do[
      Mi = (Times @@ subset)/subset[[idx]];
      AppendTo[pattern, Mod[PowerMod[Mi, -1, subset[[idx]]], 2]],
      {idx, Length[subset]}]],
    {subset, Subsets[primes, {level}]}],
  {level, 3, omega}];
  Flatten[pattern]
];

(* Aggregations of the 22 bits *)
(* 1. Sum of all bits *)
sumBits[ps_] := Total[hierarchicalPattern[ps]];

(* 2. XOR of all bits *)
xorBits[ps_] := BitXor @@ hierarchicalPattern[ps];

(* 3. Weighted sum *)
weightedSum[ps_] := Module[{bits = hierarchicalPattern[ps]},
  Total[bits * Range[Length[bits]]]
];

(* 4. Polynomial hash: sum of bits * 2^i *)
polyHash[ps_] := Module[{bits = hierarchicalPattern[ps]},
  FromDigits[Reverse[bits], 2]  (* binary number *)
];

(* 5. Split into level-2 (pairwise) and level-3+ (CRT) *)
pairwiseBits[ps_] := Take[hierarchicalPattern[ps], 6];  (* C(4,2) = 6 bits *)
crtBits[ps_] := Drop[hierarchicalPattern[ps], 6];  (* remaining 16 bits *)

(* 6. Sum by level *)
sumPairwise[ps_] := Total[pairwiseBits[ps]];
sumCRT[ps_] := Total[crtBits[ps]];

Print["=== AGGREGATING THE 22-BIT PATTERN ==="];
Print[""];

primes = Select[Range[3, 40], PrimeQ];
products = Subsets[primes, {4}];
Print["Products: ", Length[products]];
Print[""];

(* Test each aggregation *)
testAgg[name_, agg_, modulus_] := Module[{data, grouped, repeated, conflicts = 0},
  data = Table[{ps, Mod[agg[ps], modulus]}, {ps, products}];
  grouped = GroupBy[data, #[[2]] &];
  repeated = Select[grouped, Length[#] >= 2 &];

  Do[
    Module[{reps = group[[All, 1]], ssVals},
      ssVals = signSum[Times @@ #] & /@ reps;
      If[Length[DeleteDuplicates[ssVals]] > 1, conflicts++];
    ],
    {group, Values[repeated]}
  ];

  Print[name, " (mod ", modulus, "): unique=", Length[grouped],
        ", repeated=", Length[repeated], ", conflicts=", conflicts];
  conflicts
];

Print["--- Sum of 22 bits ---"];
testAgg["sumBits", sumBits, 8];
testAgg["sumBits", sumBits, 16];
testAgg["sumBits", sumBits, 32];
Print[""];

Print["--- XOR of 22 bits ---"];
testAgg["xorBits", xorBits, 2];
Print[""];

Print["--- Weighted sum ---"];
testAgg["weightedSum", weightedSum, 64];
testAgg["weightedSum", weightedSum, 128];
testAgg["weightedSum", weightedSum, 256];
Print[""];

Print["--- Split: pairwise (6 bits) + CRT (16 bits) ---"];
testAgg["sumPairwise", sumPairwise, 8];
testAgg["sumCRT", sumCRT, 16];
Print[""];

Print["--- Combination: sumPairwise + sumCRT ---"];
combined1[ps_] := {Mod[sumPairwise[ps], 8], Mod[sumCRT[ps], 16]};
data = Table[{ps, combined1[ps]}, {ps, products}];
grouped = GroupBy[data, #[[2]] &];
repeated = Select[grouped, Length[#] >= 2 &];
conflicts = 0;
Do[
  Module[{reps = group[[All, 1]], ssVals},
    ssVals = signSum[Times @@ #] & /@ reps;
    If[Length[DeleteDuplicates[ssVals]] > 1, conflicts++];
  ],
  {group, Values[repeated]}
];
Print["sumPairwise(mod8) + sumCRT(mod16) = 7 bits: conflicts=", conflicts];
Print[""];

(* What about the actual structure? *)
Print["=== ANALYZING PATTERN STRUCTURE ==="];
Print[""];

(* Show a few examples *)
Print["Example patterns:"];
Do[
  ps = products[[i]];
  bits = hierarchicalPattern[ps];
  Print[ps, " -> ", bits];
  Print["  pairwise (6): ", Take[bits, 6], " sum=", Total[Take[bits, 6]]];
  Print["  CRT (16): ", Drop[bits, 6], " sum=", Total[Drop[bits, 6]]];
  ,
  {i, 1, 5}
];
Print[""];

(* Key insight: which bits matter most? *)
Print["=== WHICH BITS MATTER MOST? ==="];
Print[""];

(* For each bit position, count how often it differs between SS-conflict pairs *)
(* First, find conflicts in the raw 22-bit data *)
data22 = Table[{ps, hierarchicalPattern[ps], signSum[Times @@ ps]}, {ps, products}];

(* Find products with same pattern but different SS *)
grouped22 = GroupBy[data22, #[[2]] &];
repeated22 = Select[grouped22, Length[#] >= 2 &];

conflictPairs = {};
Do[
  Module[{reps = group, ssVals},
    ssVals = #[[3]] & /@ reps;
    If[Length[DeleteDuplicates[ssVals]] > 1,
      (* This is a conflict - store the prime sets *)
      AppendTo[conflictPairs, reps[[All, 1]]];
    ];
  ],
  {group, Values[repeated22]}
];

Print["Found ", Length[conflictPairs], " conflict groups"];

(* But on this small dataset, 22-bit has 0 conflicts, so let's test with floorSqrt *)
Print[""];
Print["Testing: which ModularInverse bits correlate with floorSqrt?"];

(* Check correlation between each bit and floorSqrt value *)
floorSqrtSum[ps_] := Total[Floor[Sqrt[#]] & /@ ps];

Print["Bit correlations with floorSqrtSum:"];
Do[
  vals = Table[{hierarchicalPattern[ps][[bit]], floorSqrtSum[ps]}, {ps, products}];
  grouped = GroupBy[vals, First];
  mean0 = If[KeyExistsQ[grouped, 0], Mean[grouped[0][[All, 2]]], 0];
  mean1 = If[KeyExistsQ[grouped, 1], Mean[grouped[1][[All, 2]]], 0];
  diff = Abs[mean1 - mean0];
  If[diff > 1,
    Print["  Bit ", bit, ": mean(bit=0)=", N[mean0, 3], ", mean(bit=1)=", N[mean1, 3], ", diff=", N[diff, 3]];
  ];
  ,
  {bit, 1, 22}
];
