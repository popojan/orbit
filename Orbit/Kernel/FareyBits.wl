(* ::Package:: *)

(* FareyBits.wl *)
(* Search algorithms for Farey-complete weight sets *)
(* Authors: Jan Popelka, Claude Opus 4.5 *)
(* Date: January 10, 2026 *)

BeginPackage["Orbit`"];

(* Public symbols *)
FareyBitsSearch::usage =
  "FareyBitsSearch[sum] finds weight sets that sum to the given value and satisfy:
  1. Full resolution: all integers 0..sum achievable as subset sums
  2. Farey(k): all fractions p/q with q ≤ k expressible (where k = max divisor chain from 1)

Options:
  \"Method\" -> \"Greedy\" | \"Divisors\" | \"All\" (default: \"All\")
  \"MaxWeights\" -> n (default: 12, for divisor search)
  \"ReturnAssociation\" -> True | False (default: False)

Returns {greedy, divisorSets} or detailed association.";

FareyLevel::usage =
  "FareyLevel[sum] returns the maximum k such that sum is divisible by all of 1..k.
This is the Farey level supported by weight sets summing to this value.";

IsComplete::usage =
  "IsComplete[weights] returns True if the weight set can produce all integers
from 0 to Total[weights] as subset sums.";

GreedyBits::usage =
  "GreedyBits[targetSum] returns the minimal weight set summing to targetSum
that satisfies the completeness property. Uses greedy/binary-like construction.";

FindDivisorSets::usage =
  "FindDivisorSets[targetSum, maxWeights] finds all weight sets where:
  - All weights are divisors of targetSum
  - Weights sum to targetSum
  - The set is complete (can make all integers 0..sum)
Returns list of solutions sorted by size.";

WeightSetAnalysis::usage =
  "WeightSetAnalysis[weights] returns detailed analysis of a weight set including
combination counts per value, entropy, period, and Farey level.";

Begin["`Private`"];

(* ═══════════════════════════════════════════════════════════════════════════ *)
(*  CORE FUNCTIONS                                                              *)
(* ═══════════════════════════════════════════════════════════════════════════ *)

(* Compute the maximum Farey level supported by a given sum *)
FareyLevel[sum_Integer] := Module[{k = 1},
  While[k < sum && Divisible[sum, k + 1], k++];
  k
]

(* Check completeness using the greedy criterion *)
(* If sorted weights w1 ≤ w2 ≤ ... ≤ wn, complete iff each wi ≤ 1 + sum(w1..wi-1) *)
IsComplete[weights_List] := Module[{sorted = Sort[weights], n, cumsum},
  n = Length[sorted];
  If[n == 0, Return[True]];
  cumsum = Prepend[Accumulate[sorted], 0];
  AllTrue[Range[n], sorted[[#]] <= 1 + cumsum[[#]] &]
]

(* Check completeness exactly by computing all subset sums *)
isCompleteExact[weights_List] := Module[{sums},
  sums = Union[Total /@ Subsets[weights]];
  sums === Range[0, Total[weights]]
]

(* ═══════════════════════════════════════════════════════════════════════════ *)
(*  GREEDY ALGORITHM                                                            *)
(* ═══════════════════════════════════════════════════════════════════════════ *)

GreedyBits[targetSum_Integer] := Module[{weights = {}, reachable = 0, newWeight},
  While[Total[weights] < targetSum,
    newWeight = Min[reachable + 1, targetSum - Total[weights]];
    AppendTo[weights, newWeight];
    reachable += newWeight;
  ];
  weights
]

(* ═══════════════════════════════════════════════════════════════════════════ *)
(*  DIVISOR-CONSTRAINED SEARCH                                                  *)
(* ═══════════════════════════════════════════════════════════════════════════ *)

FindDivisorSets[targetSum_Integer, maxWeights_Integer: 12] := Module[
  {divisors, results, search},

  divisors = Most[Divisors[targetSum]]; (* exclude sum itself *)
  results = {};

  (* Recursive search with pruning *)
  search[chosen_, remainingSum_, minIdx_, reachable_] := Module[{d, newReachable},
    (* Base case: found valid set *)
    If[remainingSum == 0,
      If[IsComplete[chosen], AppendTo[results, Sort[chosen]]];
      Return[]
    ];

    (* Pruning *)
    If[Length[chosen] >= maxWeights, Return[]];
    If[remainingSum < 0, Return[]];

    (* Try adding each remaining divisor *)
    Do[
      d = divisors[[i]];
      If[d > remainingSum, Break[]];
      If[d > reachable + 1, Continue[]];
      newReachable = reachable + d;
      search[Append[chosen, d], remainingSum - d, i + 1, newReachable],
      {i, minIdx, Length[divisors]}
    ];
  ];

  search[{}, targetSum, 1, 0];
  SortBy[Union[results], {Length, Total}]
]

(* ═══════════════════════════════════════════════════════════════════════════ *)
(*  WEIGHT SET ANALYSIS                                                         *)
(* ═══════════════════════════════════════════════════════════════════════════ *)

WeightSetAnalysis[weights_List] := Module[
  {sum, combos, entropy, allDivide},

  sum = Total[weights];
  combos = Table[Count[Total /@ Subsets[weights], s], {s, 0, sum - 1}];
  entropy = Total[Log2 /@ Select[combos, # > 1 &]];
  allDivide = AllTrue[weights, Divisible[sum, #] &];

  <|
    "weights" -> weights,
    "count" -> Length[weights],
    "sum" -> sum,
    "fareyLevel" -> FareyLevel[sum],
    "isComplete" -> IsComplete[weights],
    "totalMasks" -> 2^Length[weights],
    "usedMasks" -> Total[combos],
    "combosPerValue" -> combos,
    "minCombos" -> Min[combos],
    "maxCombos" -> Max[combos],
    "extraBitsPerCycle" -> N[entropy],
    "periodCycles" -> LCM @@ combos,
    "allWeightsDivideSum" -> allDivide,
    "efficiency" -> N[100 * Log2[Total[combos]] / Length[weights]]
  |>
]

(* ═══════════════════════════════════════════════════════════════════════════ *)
(*  MAIN SEARCH FUNCTION                                                        *)
(* ═══════════════════════════════════════════════════════════════════════════ *)

Options[FareyBitsSearch] = {
  "Method" -> "All",
  "MaxWeights" -> 12,
  "ReturnAssociation" -> False
};

FareyBitsSearch[targetSum_Integer, opts:OptionsPattern[]] := Module[
  {method, maxW, k, greedy, divisorSets, result},

  method = OptionValue["Method"];
  maxW = OptionValue["MaxWeights"];
  k = FareyLevel[targetSum];

  (* Greedy solution *)
  greedy = If[method === "Divisors", {}, GreedyBits[targetSum]];

  (* Divisor-constrained solutions *)
  divisorSets = If[method === "Greedy", {},
    If[DivisorSigma[0, targetSum] <= 50 && targetSum <= 5000,
      FindDivisorSets[targetSum, maxW],
      {} (* too many divisors *)
    ]
  ];

  If[OptionValue["ReturnAssociation"],
    <|
      "sum" -> targetSum,
      "fareyLevel" -> k,
      "divisors" -> Divisors[targetSum],
      "greedy" -> greedy,
      "greedyCount" -> Length[greedy],
      "greedyAnalysis" -> If[greedy =!= {}, WeightSetAnalysis[greedy], <||>],
      "divisorSets" -> divisorSets,
      "divisorSetCount" -> Length[divisorSets],
      "smallestDivisorSet" -> If[divisorSets =!= {}, First[divisorSets], {}],
      "smallestDivisorAnalysis" -> If[divisorSets =!= {}, WeightSetAnalysis[First[divisorSets]], <||>]
    |>,
    (* Default: return just the solutions *)
    <|"greedy" -> greedy, "divisorSets" -> divisorSets|>
  ]
]

End[];
EndPackage[];
