(* Test ω=4: Can we extend the formula? *)

Print["=== Testing ω=4 ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* ω=2 formula *)
signSum2[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

(* Collect ω=4 data *)
Print["Computing ω=4 cases (this may take a while)...\n"];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    k = p1 p2 p3 p4;
    ss4 = signSum[k];

    (* All ω=2 subproducts *)
    ss12 = signSum2[p1, p2];
    ss13 = signSum2[p1, p3];
    ss14 = signSum2[p1, p4];
    ss23 = signSum2[p2, p3];
    ss24 = signSum2[p2, p4];
    ss34 = signSum2[p3, p4];
    sumOfPairs = ss12 + ss13 + ss14 + ss23 + ss24 + ss34;

    (* ω=3 subproducts *)
    ss123 = signSum[p1 p2 p3];
    ss124 = signSum[p1 p2 p4];
    ss134 = signSum[p1 p3 p4];
    ss234 = signSum[p2 p3 p4];
    sumOfTriples = ss123 + ss124 + ss134 + ss234;

    AppendTo[data4, <|
      "p" -> {p1, p2, p3, p4}, "k" -> k,
      "ss4" -> ss4,
      "sumPairs" -> sumOfPairs,
      "sumTriples" -> sumOfTriples,
      "ss123" -> ss123, "ss124" -> ss124, "ss134" -> ss134, "ss234" -> ss234
    |>]
  ],
  {p1, Prime[Range[2, 5]]},
  {p2, Prime[Range[3, 7]]},
  {p3, Prime[Range[4, 9]]},
  {p4, Prime[Range[5, 11]]}
];

Print["ω=4 cases computed: ", Length[data4], "\n"];

(* Test inclusion-exclusion style formulas *)
Print["=== Testing formulas ===\n"];

(* Formula 1: ss4 = sumOfTriples - sumOfPairs + ? *)
Print["Testing: ss4 = sumTriples - sumPairs + offset"];
Do[
  matches = Count[data4, d_ /; d["ss4"] == d["sumTriples"] - d["sumPairs"] + off];
  If[matches > Length[data4]/10,
    Print["  offset = ", off, ": ", matches, " / ", Length[data4], " matches"]
  ],
  {off, Range[-20, 20]}
];

(* Formula 2: ss4 = sumOfTriples + offset *)
Print["\nTesting: ss4 = sumTriples + offset"];
Do[
  matches = Count[data4, d_ /; d["ss4"] == d["sumTriples"] + off];
  If[matches > 0,
    Print["  offset = ", off, ": ", matches, " matches"]
  ],
  {off, Range[-20, 20]}
];

(* Show the actual correction needed *)
Print["\n=== Correction analysis ===\n"];

Print["ss4 - sumTriples values:"];
corrections = Union[(#["ss4"] - #["sumTriples"]) & /@ data4];
Print[corrections];

Print["\nss4 - (sumTriples - sumPairs) values:"];
corrections2 = Union[(#["ss4"] - #["sumTriples"] + #["sumPairs"]) & /@ data4];
Print[corrections2];

(* Maybe it's: ss4 = sumTriples - sumPairs + sumSingles + 1 *)
(* where sumSingles = 4 * (-1) = -4 *)
Print["\nTesting inclusion-exclusion: ss4 = sumTriples - sumPairs - 4 + 1"];
matches = Count[data4, d_ /; d["ss4"] == d["sumTriples"] - d["sumPairs"] - 3];
Print["Matches: ", matches, " / ", Length[data4]];

(* Show a few examples *)
Print["\n=== Sample data ===\n"];
Do[
  d = data4[[i]];
  Print[d["p"], ": ss4=", d["ss4"]];
  Print["  sumPairs=", d["sumPairs"], " sumTriples=", d["sumTriples"]];
  Print["  ss4 - sumTriples = ", d["ss4"] - d["sumTriples"]];
  Print["  ss4 - sumTriples + sumPairs = ", d["ss4"] - d["sumTriples"] + d["sumPairs"]];
  Print[""],
  {i, Min[10, Length[data4]]}
];

(* Check congruence mod 4 for ω=4 *)
(* Expected: Σsigns ≡ 1 - 2*4 = -7 ≡ 1 (mod 4) *)
Print["=== Congruence check for ω=4 ==="];
Print["Expected: Σsigns ≡ 1 - 8 = -7 ≡ 1 (mod 4)\n"];

violations = Select[data4, Mod[#["ss4"], 4] != 1 &];
Print["Violations: ", Length[violations], " / ", Length[data4]];
If[Length[violations] > 0,
  Print["Violating values mod 4: ", Union[Mod[#["ss4"], 4] & /@ violations]]
];

(* What values does ss4 take? *)
ss4Values = Union[#["ss4"] & /@ data4];
Print["\nss4 values: ", ss4Values];
Print["All ≡ 1 (mod 4)? ", AllTrue[ss4Values, Mod[#, 4] == 1 &]];
