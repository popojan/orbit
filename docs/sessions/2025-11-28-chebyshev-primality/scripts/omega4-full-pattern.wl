(* Test if ω=4 correction depends on full (b, ε) pattern *)

Print["=== ω=4: Full (b, ε) pattern analysis ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* ε_ij = 1 if p_i^{-1} mod p_j is even (inversion indicator) *)
epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

(* Collect ω=4 data with full patterns *)
Print["Computing ω=4 cases...\n"];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    k = p1 p2 p3 p4;
    ss4 = signSum[k];

    (* All 6 ε values (upper triangle) *)
    e12 = epsilon[p1, p2]; e13 = epsilon[p1, p3]; e14 = epsilon[p1, p4];
    e23 = epsilon[p2, p3]; e24 = epsilon[p2, p4]; e34 = epsilon[p3, p4];
    epsilonPattern = {e12, e13, e14, e23, e24, e34};
    numInv = Total[epsilonPattern];

    (* b-vector (CRT parities) *)
    c1 = p2 p3 p4 * PowerMod[p2 p3 p4, -1, p1];
    c2 = p1 p3 p4 * PowerMod[p1 p3 p4, -1, p2];
    c3 = p1 p2 p4 * PowerMod[p1 p2 p4, -1, p3];
    c4 = p1 p2 p3 * PowerMod[p1 p2 p3, -1, p4];
    bPattern = Mod[{c1, c2, c3, c4}, 2];
    numB = Total[bPattern];

    (* For ω=3: ss = 11 - 4*(#inv + #b)
       For ω=4: Try ss = C - 4*(#inv + #b) + something? *)

    AppendTo[data4, <|
      "p" -> {p1, p2, p3, p4}, "k" -> k, "ss4" -> ss4,
      "epsilon" -> epsilonPattern, "numInv" -> numInv,
      "b" -> bPattern, "numB" -> numB
    |>]
  ],
  {p1, Prime[Range[2, 7]]},
  {p2, Prime[Range[3, 9]]},
  {p3, Prime[Range[4, 11]]},
  {p4, Prime[Range[5, 13]]}
];

Print["Total ω=4 cases: ", Length[data4], "\n"];

(* Test 1: Is ss4 = C - 4*(#inv + #b) for some constant C? *)
Print["=== Test: ss4 = C - 4*(#inv + #b)? ===\n"];
computedC = (#["ss4"] + 4*(#["numInv"] + #["numB"]) &) /@ data4;
uniqueC = Union[computedC];
Print["Unique C values: ", uniqueC];
Print["If one value, formula works!\n"];

(* Test 2: Is ss4 determined by (numInv, numB)? *)
Print["=== ss4 by (#inv, #b) ===\n"];
byInvB = GroupBy[data4, {#["numInv"], #["numB"]} &];
constantInvB = True;
Do[
  ssVals = Union[#["ss4"] & /@ byInvB[key]];
  If[Length[ssVals] > 1, constantInvB = False];
  Print[key, " → ss4 ∈ ", ssVals, " (", Length[byInvB[key]], " cases)"],
  {key, Sort[Keys[byInvB]]}
];
Print["\nConstant by (#inv, #b)? ", constantInvB];

(* Test 3: Is ss4 determined by full (b, ε) pattern? *)
Print["\n=== ss4 by full (b, ε) pattern ===\n"];
byFullPattern = GroupBy[data4, {#["b"], #["epsilon"]} &];
constantFull = True;
numConstant = 0;
Do[
  ssVals = Union[#["ss4"] & /@ byFullPattern[key]];
  If[Length[ssVals] == 1, numConstant++, constantFull = False],
  {key, Keys[byFullPattern]}
];
Print["Total patterns: ", Length[Keys[byFullPattern]]];
Print["Constant patterns: ", numConstant];
Print["Constant by full (b, ε)? ", constantFull];

If[constantFull,
  Print["\n🎉 FORMULA EXISTS!\n"];
  Print["ss4 is uniquely determined by (b-pattern, ε-pattern)\n"];

  (* Try to find simpler formula *)
  Print["=== Looking for closed form ===\n"];

  (* For each pattern, what is ss4? *)
  Print["Sample patterns:"];
  sample = Take[Sort[Keys[byFullPattern]], Min[20, Length[Keys[byFullPattern]]]];
  Do[
    {b, eps} = key;
    ss = First[Union[#["ss4"] & /@ byFullPattern[key]]];
    numInv = Total[eps];
    numB = Total[b];
    (* Try: ss = 19 - 4*(#inv + #b) + correction *)
    naive = 19 - 4*(numInv + numB);
    corr = ss - naive;
    Print["b=", b, " ε=", eps, " → ss=", ss, " (19-4*(", numInv, "+", numB, ")=", naive, ", Δ=", corr, ")"],
    {key, sample}
  ];
];

(* Test 4: Maybe ss4 depends on PRODUCTS of ε_ij values? *)
Print["\n=== Testing: dependence on ε products ===\n"];

(* In permutations, sign = (-1)^{#inversions}
   The "triple product" might matter too *)

data4Extended = Map[
  Module[{eps = #["epsilon"], b = #["b"], prods},
    (* Products of pairs of ε values *)
    prods = {
      eps[[1]] * eps[[6]],  (* e12 * e34 - opposite pairs *)
      eps[[2]] * eps[[5]],  (* e13 * e24 *)
      eps[[3]] * eps[[4]]   (* e14 * e23 *)
    };
    Append[#, "epsProd" -> Total[prods]]
  ] &,
  data4
];

byInvBProd = GroupBy[data4Extended, {#["numInv"], #["numB"], #["epsProd"]} &];
constantInvBProd = True;
numConstant2 = 0;
Do[
  ssVals = Union[#["ss4"] & /@ byInvBProd[key]];
  If[Length[ssVals] == 1, numConstant2++, constantInvBProd = False],
  {key, Keys[byInvBProd]}
];
Print["Constant by (#inv, #b, epsProd)? ", constantInvBProd];
Print["Constant patterns: ", numConstant2, " / ", Length[Keys[byInvBProd]]];
