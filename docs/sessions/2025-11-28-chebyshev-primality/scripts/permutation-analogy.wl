(* Explore permutation analogy more deeply *)

Print["=== Permutation Analogy ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
signSum2[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

(* Transform ss to binary "inversion" indicator *)
(* ss = +1 → ε = 0 (no inversion)
   ss = -3 → ε = 1 (inversion) *)
epsilon[ss_] := (1 - ss) / 4;

Print["=== ω=2: Binary indicator ===\n"];
Print["ss = +1 → ε = 0 (p^{-1} mod q is odd)"];
Print["ss = -3 → ε = 1 (p^{-1} mod q is even)\n"];

(* For permutations: sign = (-1)^{#inversions}
   For us: ss = 1 - 4ε
   So: Σsigns = sum of (1 - 4ε_ij) = #{pairs} - 4×#{inversions} *)

Print["=== ω=3: Total inversions ===\n"];

data3 = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    (* Pairwise *)
    ss12 = signSum2[p1, p2]; ss13 = signSum2[p1, p3]; ss23 = signSum2[p2, p3];
    e12 = epsilon[ss12]; e13 = epsilon[ss13]; e23 = epsilon[ss23];
    totalInversions = e12 + e13 + e23;

    (* Formula attempt: ss = 3 - 4×totalInversions + correction *)
    predicted = 3 - 4 totalInversions;
    correction = ss - predicted;

    AppendTo[data3, <|
      "p" -> {p1, p2, p3}, "ss" -> ss,
      "e" -> {e12, e13, e23}, "totalInv" -> totalInversions,
      "predicted" -> predicted, "correction" -> correction
    |>]
  ],
  {p1, Prime[Range[2, 8]]},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 15]]}
];

(* Group by total inversions *)
byInv = GroupBy[data3, #["totalInv"] &];
Print["Corrections by total inversions:"];
Do[
  corrs = Union[#["correction"] & /@ byInv[inv]];
  Print["  #inv = ", inv, ": corrections = ", corrs, " (", Length[byInv[inv]], " cases)"],
  {inv, Sort[Keys[byInv]]}
];

(* The formula ss = 3 - 4×#inv doesn't work directly
   But maybe ss ≡ 3 - 4×#inv (mod 8)? *)

Print["\n=== Check: ss ≡ 3 - 4×#inv (mod 8)? ===\n"];
violations = Select[data3, Mod[#["ss"], 8] != Mod[3 - 4 #["totalInv"], 8] &];
Print["Violations: ", Length[violations], " / ", Length[data3]];

(* Try: ss = 3 - 4×#inv + 4×something *)
(* The correction is always a multiple of 4 and is in {-4, 0, 4, 8} *)
(* So ss = 3 - 4×(#inv - c) where c ∈ {-2, -1, 0, 1} *)

Print["\n=== What determines c = (3 - ss)/4 - #inv? ===\n"];

byE = GroupBy[data3, #["e"] &];
Print["By ε-pattern (e12, e13, e23):"];
Do[
  cs = (#["correction"]/4 &) /@ byE[e];  (* c = correction/4 *)
  uniqueCs = Union[cs];
  Print["  ε = ", e, ": c values = ", uniqueCs, " (", Length[byE[e]], " cases)"],
  {e, Sort[Keys[byE]]}
];

(* The ε-pattern alone doesn't determine c completely.
   What about adding b-pattern? *)

Print["\n=== By (ε, b) pattern ===\n"];

data3WithB = Map[
  Module[{p1, p2, p3, c1, c2, c3},
    {p1, p2, p3} = #["p"];
    c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
    c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
    c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
    Append[#, "b" -> Mod[{c1, c2, c3}, 2]]
  ] &,
  data3
];

byEB = GroupBy[data3WithB, {#["e"], #["b"]} &];
constantCount = 0;
Do[
  cs = (#["correction"]/4 &) /@ byEB[key];
  uniqueCs = Union[cs];
  If[Length[uniqueCs] == 1, constantCount++];
  {e, b} = key;
  Print["  ε=", e, " b=", b, ": c = ", uniqueCs, " (", Length[byEB[key]], " cases)"],
  {key, Sort[Keys[byEB]]}
];
Print["\nConstant patterns: ", constantCount, " / ", Length[Keys[byEB]]];

(* The analogy to permutations:
   - ε_ij is like "is (i,j) an inversion?"
   - Total #inversions affects Σsigns
   - But there's additional structure from CRT (b-pattern) *)

Print["\n=== The Analogy ===\n"];
Print["Permutation sign: (-1)^{#inversions}"];
Print[""];
Print["Our formula (conjecture):"];
Print["  Σsigns = 3 - 4×#inversions + 4×c(ε, b)"];
Print[""];
Print["where:"];
Print["  ε_ij = 1 if p_i^{-1} mod p_j is even"];
Print["  b_i = c_i mod 2 (CRT coefficient parity)"];
Print["  c is a correction depending on (ε, b)"];
Print[""];
Print["Note: This is like sign = (-1)^{#inv} but with additive structure"];
Print["      and CRT correction."];
