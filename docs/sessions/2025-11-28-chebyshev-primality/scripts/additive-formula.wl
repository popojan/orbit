(* Test: Is Σsigns(p₁p₂p₃) = Σsigns(p₁p₂) + Σsigns(p₁p₃) + Σsigns(p₂p₃) + correction? *)

Print["=== Testing additive formula for ω=3 ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* ω=2 formula: Σsigns(pq) = +1 if p^{-1} mod q is odd, -3 if even *)
signSum2[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

(* Collect data *)
data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss3 = signSum[k];
    ss12 = signSum2[p1, p2];
    ss13 = signSum2[p1, p3];
    ss23 = signSum2[p2, p3];
    sumOfPairs = ss12 + ss13 + ss23;
    correction = ss3 - sumOfPairs;

    AppendTo[data, <|
      "p" -> {p1, p2, p3}, "k" -> k,
      "ss3" -> ss3, "ss12" -> ss12, "ss13" -> ss13, "ss23" -> ss23,
      "sum" -> sumOfPairs, "correction" -> correction
    |>]
  ],
  {p1, Prime[Range[2, 8]]},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 15]]}
];

Print["Total cases: ", Length[data], "\n"];

(* Check if correction is constant or has pattern *)
corrections = Union[#["correction"] & /@ data];
Print["Correction values: ", corrections];
Print[""];

(* If not constant, group by correction *)
byCorr = GroupBy[data, #["correction"] &];
Print["=== Distribution of corrections ===\n"];
Do[
  Print["correction = ", c, ": ", Length[byCorr[c]], " cases"],
  {c, Sort[Keys[byCorr]]}
];

(* Check if correction depends on (ss12, ss13, ss23) pattern *)
Print["\n=== Correction by (ss12, ss13, ss23) ===\n"];
bySSPattern = GroupBy[data, {#["ss12"], #["ss13"], #["ss23"]} &];
Do[
  subset = bySSPattern[pattern];
  corrs = Union[#["correction"] & /@ subset];
  Print["(ss12, ss13, ss23) = ", pattern, ": corrections = ", corrs, " (", Length[subset], " cases)"];

  (* If constant correction, show formula *)
  If[Length[corrs] == 1,
    c = First[corrs];
    sumPairs = Total[pattern];
    Print["  → ss3 = ", sumPairs, " + ", c, " = ", sumPairs + c]
  ],
  {pattern, Sort[Keys[bySSPattern]]}
];

(* The key: is correction determined by ss pattern? *)
Print["\n=== Is correction CONSTANT per (ss12, ss13, ss23)? ===\n"];

allConstant = True;
Do[
  subset = bySSPattern[pattern];
  corrs = Union[#["correction"] & /@ subset];
  If[Length[corrs] > 1,
    Print["NOT constant for pattern ", pattern, ": ", corrs];
    allConstant = False
  ],
  {pattern, Keys[bySSPattern]}
];

If[allConstant,
  Print["YES! Correction is constant for each (ss12, ss13, ss23) pattern!"];
  Print["\n=== THE FORMULA ===\n"];
  Print["Σsigns(p₁p₂p₃) = Σsigns(p₁p₂) + Σsigns(p₁p₃) + Σsigns(p₂p₃) + c"];
  Print["where c depends on the tuple (Σsigns(p₁p₂), Σsigns(p₁p₃), Σsigns(p₂p₃)):"];
  Print[""];
  Do[
    subset = bySSPattern[pattern];
    c = First[Union[#["correction"] & /@ subset]];
    Print["  ", pattern, " → c = ", c],
    {pattern, Sort[Keys[bySSPattern]]}
  ],

  Print["NO - correction varies within some patterns"]
];

(* Maybe try inclusion-exclusion style *)
Print["\n=== Alternative: Inclusion-exclusion style ===\n"];
Print["Try: ss3 = ss12 + ss13 + ss23 - ss1 - ss2 - ss3 + 1"];
Print["where ssi = Σsigns(pi) = -1 for prime\n"];

errors = 0;
Do[
  {p1, p2, p3} = d["p"];
  ss3 = d["ss3"];
  predicted = d["ss12"] + d["ss13"] + d["ss23"] - (-1) - (-1) - (-1) + 1;
  (* = sum + 3 + 1 = sum + 4 *)
  If[ss3 != predicted, errors++],
  {d, data}
];
Print["Formula ss3 = sum + 4: errors = ", errors, " / ", Length[data]];

(* Try other combinations *)
Do[
  offset = o;
  matches = Count[data, d_ /; d["ss3"] == d["sum"] + offset];
  If[matches > 0,
    Print["ss3 = sum + ", offset, ": ", matches, " matches"]
  ],
  {o, Range[-10, 10]}
];

Print["\n=== Maybe correction depends on more ===\n"];

(* Compute parities b1, b2, b3 *)
dataWithB = Map[
  Module[{p1, p2, p3, c1, c2, c3},
    {p1, p2, p3} = #["p"];
    c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
    c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
    c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
    Append[#, "b" -> Mod[{c1, c2, c3}, 2]]
  ] &,
  data
];

(* Group by both ss pattern and b pattern *)
byBoth = GroupBy[dataWithB, {#["ss12"], #["ss13"], #["ss23"], #["b"]} &];
Print["Joint patterns (ss12, ss13, ss23, b):"];
constantCount = 0;
Do[
  subset = byBoth[key];
  corrs = Union[#["correction"] & /@ subset];
  If[Length[corrs] == 1, constantCount++];
  If[Length[subset] >= 3,  (* Only show patterns with enough data *)
    Print["  ", key, " → corr = ", corrs, " (", Length[subset], " cases)"]
  ],
  {key, Sort[Keys[byBoth]]}
];
Print["\nConstant patterns: ", constantCount, " / ", Length[Keys[byBoth]]];
