(* ω=4: Recursive inclusion-exclusion structure *)

Print["=== ω=4: Inclusion-Exclusion / Recursive Structure ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* ε_ij = 1 if p_i^{-1} mod p_j is even *)
epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

(* For ω=3, we found:
   ss₃ = 11 - 4*(#inversions + #1s_in_b)

   Equivalently, using pairs:
   ss₃ = ss₁₂ + ss₁₃ + ss₂₃ + correction
   where correction = 4*(2 - #inversions) - 4*#1s_in_b

   Let's see if ω=4 follows similar pattern *)

Print["Computing ω=4 cases with full subsystem info...\n"];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    primes = {p1, p2, p3, p4};
    k = p1 p2 p3 p4;
    ss4 = signSum[k];

    (* All 6 pairs *)
    ss12 = signSum[p1 p2]; ss13 = signSum[p1 p3]; ss14 = signSum[p1 p4];
    ss23 = signSum[p2 p3]; ss24 = signSum[p2 p4]; ss34 = signSum[p3 p4];
    allPairs = {ss12, ss13, ss14, ss23, ss24, ss34};
    sumPairs = Total[allPairs];

    (* All 4 triples *)
    ss123 = signSum[p1 p2 p3]; ss124 = signSum[p1 p2 p4];
    ss134 = signSum[p1 p3 p4]; ss234 = signSum[p2 p3 p4];
    allTriples = {ss123, ss124, ss134, ss234};
    sumTriples = Total[allTriples];

    (* All 6 ε values *)
    e12 = epsilon[p1, p2]; e13 = epsilon[p1, p3]; e14 = epsilon[p1, p4];
    e23 = epsilon[p2, p3]; e24 = epsilon[p2, p4]; e34 = epsilon[p3, p4];
    epsPattern = {e12, e13, e14, e23, e24, e34};
    numInv = Total[epsPattern];

    (* b-vector for ω=4 *)
    c1 = p2 p3 p4 * PowerMod[p2 p3 p4, -1, p1];
    c2 = p1 p3 p4 * PowerMod[p1 p3 p4, -1, p2];
    c3 = p1 p2 p4 * PowerMod[p1 p2 p4, -1, p3];
    c4 = p1 p2 p3 * PowerMod[p1 p2 p3, -1, p4];
    b4 = Mod[{c1, c2, c3, c4}, 2];
    numB4 = Total[b4];

    (* b-vectors for each triple *)
    b123 = Module[{cc1, cc2, cc3},
      cc1 = p2 p3 * PowerMod[p2 p3, -1, p1];
      cc2 = p1 p3 * PowerMod[p1 p3, -1, p2];
      cc3 = p1 p2 * PowerMod[p1 p2, -1, p3];
      Mod[{cc1, cc2, cc3}, 2]
    ];
    b124 = Module[{cc1, cc2, cc4},
      cc1 = p2 p4 * PowerMod[p2 p4, -1, p1];
      cc2 = p1 p4 * PowerMod[p1 p4, -1, p2];
      cc4 = p1 p2 * PowerMod[p1 p2, -1, p4];
      Mod[{cc1, cc2, cc4}, 2]
    ];
    b134 = Module[{cc1, cc3, cc4},
      cc1 = p3 p4 * PowerMod[p3 p4, -1, p1];
      cc3 = p1 p4 * PowerMod[p1 p4, -1, p3];
      cc4 = p1 p3 * PowerMod[p1 p3, -1, p4];
      Mod[{cc1, cc3, cc4}, 2]
    ];
    b234 = Module[{cc2, cc3, cc4},
      cc2 = p3 p4 * PowerMod[p3 p4, -1, p2];
      cc3 = p2 p4 * PowerMod[p2 p4, -1, p3];
      cc4 = p2 p3 * PowerMod[p2 p3, -1, p4];
      Mod[{cc2, cc3, cc4}, 2]
    ];

    (* Using ω=3 formula: ss₃ = 11 - 4*(#inv + #b) *)
    (* Verify the triples follow this formula *)
    numInv123 = e12 + e13 + e23;
    numInv124 = e12 + e14 + e24;
    numInv134 = e13 + e14 + e34;
    numInv234 = e23 + e24 + e34;

    pred123 = 11 - 4*(numInv123 + Total[b123]);
    pred124 = 11 - 4*(numInv124 + Total[b124]);
    pred134 = 11 - 4*(numInv134 + Total[b134]);
    pred234 = 11 - 4*(numInv234 + Total[b234]);

    (* The "new" inversions and b-bits specific to the 4th element *)
    newInv4 = e14 + e24 + e34;  (* inversions involving p4 *)

    AppendTo[data4, <|
      "p" -> primes, "ss4" -> ss4,
      "sumPairs" -> sumPairs, "sumTriples" -> sumTriples,
      "eps" -> epsPattern, "numInv" -> numInv,
      "b4" -> b4, "numB4" -> numB4,
      "newInv4" -> newInv4,
      "tripleB" -> {Total[b123], Total[b124], Total[b134], Total[b234]},
      "tripleInv" -> {numInv123, numInv124, numInv134, numInv234}
    |>]
  ],
  {p1, Prime[Range[2, 6]]},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 10]]},
  {p4, Prime[Range[5, 12]]}
];

Print["Total cases: ", Length[data4], "\n"];

(* Try: ss₄ = f(sumTriples) + g(sumPairs) + h(numInv, numB4, ...) *)
Print["=== Analyzing structure ===\n"];

(* First: what's the "excess" beyond inclusion-exclusion? *)
(* Naive: ss₄ = sumTriples - sumPairs + (something) *)
Print["ss₄ - (sumTriples - sumPairs):\n"];
byExcess = GroupBy[data4, (#["ss4"] - #["sumTriples"] + #["sumPairs"]) &];
Print["Excess values: ", Sort[Keys[byExcess]]];
Print["Range: ", {Min[Keys[byExcess]], Max[Keys[byExcess]]}];
Print[""];

(* Is excess determined by (numInv, numB4)? *)
Print["=== Excess by (numInv, numB4) ===\n"];
byInvB = GroupBy[data4, {#["numInv"], #["numB4"]} &];
Do[
  excess = Union[(#["ss4"] - #["sumTriples"] + #["sumPairs"]) & /@ byInvB[key]];
  Print[key, " → excess ∈ ", excess, " (", Length[byInvB[key]], " cases)"],
  {key, Sort[Keys[byInvB]]}
];

(* Is excess determined by (newInv4, b4[4])? *)
Print["\n=== Excess by (newInv4, b4[4]) ===\n"];
byNew = GroupBy[data4, {#["newInv4"], #["b4"][[4]]} &];
Do[
  excess = Union[(#["ss4"] - #["sumTriples"] + #["sumPairs"]) & /@ byNew[key]];
  Print[key, " → excess ∈ ", excess, " (", Length[byNew[key]], " cases)"],
  {key, Sort[Keys[byNew]]}
];

(* For ω=3: correction = 4*(2 - #inv) - 4*#b = 8 - 4*(#inv + #b)
   So ss₃ = ss₁₂ + ss₁₃ + ss₂₃ + 8 - 4*(#inv + #b)
        = sum_pairs + 8 - 4*(#inv + #b)

   For ω=4: Maybe:
   ss₄ = sumTriples - sumPairs + C - 4*(#something + #something_else)? *)

Print["\n=== Testing: excess = C - 4*(numInv + numB4) ===\n"];
Print["(Looking for linear relationship)\n"];

(* Compute what C would need to be *)
computedC = Map[
  #["ss4"] - #["sumTriples"] + #["sumPairs"] + 4*(#["numInv"] + #["numB4"]) &,
  data4
];
Print["Implied C values: ", Sort[Union[computedC]]];

(* Maybe include sum of triple b-values? *)
Print["\n=== Testing with triple b-sums ===\n"];
triplesBSum = Map[Total[#["tripleB"]] &, data4];
triplesInvSum = Map[Total[#["tripleInv"]] &, data4];

computedC2 = MapThread[
  #1["ss4"] - #1["sumTriples"] + #1["sumPairs"] + 4*#1["numInv"] &,
  {data4}
];
byC2 = GatherBy[Transpose[{computedC2, data4}], First];
Print["C values (without numB4): ", Sort[Union[computedC2]]];

(* The relationship might be:
   excess = C - f(inversions) - g(b-pattern)
   where f and g count different things *)

Print["\n=== Final test: Exact determination ===\n"];
(* Is excess uniquely determined by (eps, b4)? *)
byFullPattern = GroupBy[data4, {#["eps"], #["b4"]} &];
numPatterns = Length[Keys[byFullPattern]];
constantPatterns = Count[
  (Length[Union[(#["ss4"] - #["sumTriples"] + #["sumPairs"]) & /@ byFullPattern[key]]] == 1 &) /@ Keys[byFullPattern],
  True
];
Print["Patterns: ", numPatterns];
Print["Constant patterns: ", constantPatterns];
Print["All constant? ", constantPatterns == numPatterns];

If[constantPatterns == numPatterns,
  Print["\n✓ Excess is uniquely determined by (ε, b₄)!"];
  Print["This means a lookup table exists (similar to ω=3)."];
];
