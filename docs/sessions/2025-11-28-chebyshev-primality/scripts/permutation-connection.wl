(* Explore connection to permutation signs *)

Print["=== Connection to permutation signs ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Key insight: CRT maps (a₁, ..., aω) → n
   The parity of n involves "carries" from mod k reduction
   This is similar to how transpositions contribute to permutation sign *)

Print["=== Analyzing the structure ===\n"];

(* For ω=2: The formula is based on p^{-1} mod q
   This is like computing a "relative position" *)

(* For ω=3: We have:
   ss3 = ss12 + ss13 + ss23 + correction
   where correction ∈ {-4, 0, 4, 8} *)

(* Hypothesis: correction depends on some "triple product" like Levi-Civita *)

Print["=== Testing Levi-Civita-like formula ===\n"];

signSum2[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

(* Collect data for ω=3 with detailed invariants *)
data3 = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    (* Pairwise *)
    ss12 = signSum2[p1, p2];
    ss13 = signSum2[p1, p3];
    ss23 = signSum2[p2, p3];

    (* Modular inverses (the "coordinates") *)
    inv12 = PowerMod[p1, -1, p2];
    inv13 = PowerMod[p1, -1, p3];
    inv21 = PowerMod[p2, -1, p1];
    inv23 = PowerMod[p2, -1, p3];
    inv31 = PowerMod[p3, -1, p1];
    inv32 = PowerMod[p3, -1, p2];

    (* Parities of inverses *)
    e12 = Mod[inv12, 2]; e13 = Mod[inv13, 2];
    e21 = Mod[inv21, 2]; e23 = Mod[inv23, 2];
    e31 = Mod[inv31, 2]; e32 = Mod[inv32, 2];

    (* Total parity (like Levi-Civita over all pairs?) *)
    totalParityPairs = Mod[e12 + e13 + e21 + e23 + e31 + e32, 2];

    (* Correction *)
    sumPairs = ss12 + ss13 + ss23;
    correction = ss - sumPairs;

    AppendTo[data3, <|
      "p" -> {p1, p2, p3}, "ss" -> ss,
      "sumPairs" -> sumPairs, "correction" -> correction,
      "e" -> {e12, e13, e21, e23, e31, e32},
      "totalParity" -> totalParityPairs
    |>]
  ],
  {p1, Prime[Range[2, 8]]},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 15]]}
];

(* Group by total parity *)
Print["Correction by total parity of inverses:"];
byParity = GroupBy[data3, #["totalParity"] &];
Do[
  corrections = Union[#["correction"] & /@ byParity[p]];
  Print["  totalParity = ", p, ": corrections = ", corrections],
  {p, Sort[Keys[byParity]]}
];

(* Maybe it's the number of odd inverses? *)
Print["\nCorrection by count of odd inverses:"];
byCount = GroupBy[data3, Total[#["e"]] &];
Do[
  corrections = Union[#["correction"] & /@ byCount[c]];
  Print["  #{odd inv} = ", c, ": corrections = ", corrections, " (", Length[byCount[c]], " cases)"],
  {c, Sort[Keys[byCount]]}
];

(* Try: correction = 4 * (something) *)
Print["\n=== Analyzing correction = 4 * factor ===\n"];

byCorr = GroupBy[data3, #["correction"] &];
Do[
  subset = byCorr[corr];
  factor = corr / 4;
  eCounts = Tally[Total[#["e"]] & /@ subset];
  Print["correction = ", corr, " (factor ", factor, "): #{odd inv} dist = ", eCounts],
  {corr, Sort[Keys[byCorr]]}
];

(* The formula might be: correction = 4 * (2 - #{odd_inv among (e12,e13,e23)}) ? *)
Print["\n=== Testing: correction = 4 * (2 - #{upper triangle odd}) ===\n"];

errors = 0;
Do[
  d = data3[[i]];
  {e12, e13, e21, e23, e31, e32} = d["e"];
  upperTriangleOdd = e12 + e13 + e23;  (* Only count (i,j) with i < j *)
  predictedCorr = 4 * (2 - upperTriangleOdd);
  If[d["correction"] != predictedCorr,
    errors++;
    If[errors <= 10,
      Print["Error: ", d["p"], " corr=", d["correction"], " predicted=", predictedCorr,
            " upper=", upperTriangleOdd]
    ]
  ],
  {i, Length[data3]}
];
Print["Errors: ", errors, " / ", Length[data3]];

(* Try other combinations *)
Print["\n=== Testing various formulas ===\n"];

formulas = {
  {"e12+e13+e23", Function[d, d["e"][[1]] + d["e"][[2]] + d["e"][[4]]]},
  {"e21+e31+e32", Function[d, d["e"][[3]] + d["e"][[5]] + d["e"][[6]]]},
  {"e12+e21", Function[d, d["e"][[1]] + d["e"][[3]]]},
  {"e12*e13*e23", Function[d, d["e"][[1]] * d["e"][[2]] * d["e"][[4]]]},
  {"totalParity", Function[d, d["totalParity"]]},
  {"(e12+e21)+(e13+e31)+(e23+e32)", Function[d, Total[d["e"]]]}
};

Do[
  {name, f} = formula;
  grouped = GroupBy[data3, f[#] &];
  constant = True;
  Do[
    corrections = Union[#["correction"] & /@ grouped[key]];
    If[Length[corrections] > 1, constant = False],
    {key, Keys[grouped]}
  ];
  If[constant,
    Print["CONSTANT by ", name, ":"];
    Do[
      corrections = Union[#["correction"] & /@ grouped[key]];
      Print["  ", name, "=", key, " → corr=", First[corrections]],
      {key, Sort[Keys[grouped]]}
    ];
    Print[""]
  ],
  {formula, formulas}
];

(* The key relationship: e_ij + e_ji = ? *)
Print["\n=== Relationship: e_ij + e_ji ===\n"];

Do[
  d = data3[[i]];
  {p1, p2, p3} = d["p"];
  {e12, e13, e21, e23, e31, e32} = d["e"];

  (* For each pair, check e_ij + e_ji *)
  sum12 = Mod[e12 + e21, 2];
  sum13 = Mod[e13 + e31, 2];
  sum23 = Mod[e23 + e32, 2];

  If[i <= 10,
    Print[{p1, p2, p3}, ": e12+e21=", e12, "+", e21, "=", sum12,
          " e13+e31=", e13, "+", e31, "=", sum13,
          " e23+e32=", e23, "+", e32, "=", sum23]
  ],
  {i, Length[data3]}
];

Print["\n(Note: e_ij*e_ji ≡ 1 mod p means e_ij = e_ji^{-1} mod p)"];
