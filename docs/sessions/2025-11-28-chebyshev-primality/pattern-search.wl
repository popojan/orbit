(* Search for patterns in Σsigns values for ω=3 *)

Print["=== Pattern search for Σsigns(p₁p₂p₃) ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Collect data *)
data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    c1 = p2 p3 * PowerMod[p2 p3, -1, p1];
    c2 = p1 p3 * PowerMod[p1 p3, -1, p2];
    c3 = p1 p2 * PowerMod[p1 p2, -1, p3];
    {b1, b2, b3} = Mod[{c1, c2, c3}, 2];
    numOnes = b1 + b2 + b3;

    AppendTo[data, <|
      "p1" -> p1, "p2" -> p2, "p3" -> p3,
      "k" -> k, "ss" -> ss,
      "b" -> {b1, b2, b3}, "numOnes" -> numOnes,
      "r2" -> Mod[p2, p1], "r3" -> Mod[p3, p1],
      "total" -> (p1-2)(p2-2)(p3-2)
    |>]
  ],
  {p1, Prime[Range[2, 8]]},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 15]]}
];

Print["Total cases: ", Length[data], "\n"];

(* Group by number of 1s in b vector *)
Print["=== By count of 1s in (b₁,b₂,b₃) ===\n"];
byNumOnes = GroupBy[data, #["numOnes"] &];
Do[
  subset = byNumOnes[n];
  ssVals = Union[#["ss"] & /@ subset];
  Print["#{bᵢ=1} = ", n, ": ", Length[subset], " cases"];
  Print["  Σsigns values: ", ssVals[[;;Min[15, Length[ssVals]]]]];
  Print["  Range: [", Min[ssVals], ", ", Max[ssVals], "]"];
  (* Check if there's a simple formula *)
  totals = #["total"] & /@ subset;
  ratios = N[#["ss"]/#["total"]] & /@ subset;
  Print["  ss/total range: [", Min[ratios], ", ", Max[ratios], "]"];
  Print[""],
  {n, Sort[Keys[byNumOnes]]}
];

(* Look for formula based on b pattern *)
Print["=== Analyzing specific b patterns ===\n"];
byB = GroupBy[data, #["b"] &];
Do[
  subset = byB[b];
  ssVals = #["ss"] & /@ subset;
  totals = #["total"] & /@ subset;
  Print["b = ", b, ": ", Length[subset], " cases"];
  Print["  ss: ", ssVals[[;;Min[10, Length[ssVals]]]]];
  Print["  total: ", totals[[;;Min[10, Length[totals]]]]];
  (* Is ss = -total when b = (0,0,0)? *)
  If[b == {0, 0, 0},
    Print["  Checking ss = -total: ", Union[ssVals + totals]]
  ];
  (* Is ss = -1 when b = (1,1,1)? *)
  If[b == {1, 1, 1},
    Print["  Checking ss = -1: ", Union[ssVals] == {-1}]
  ];
  Print[""],
  {b, Sort[Keys[byB]]}
];

(* Try: ss = f(p1,b1) * f(p2,b2) * f(p3,b3) + correction *)
Print["=== Looking for correction term ===\n"];

fac[p_, b_] := If[b == 0, p - 2, 1];

Do[
  subset = byB[b];
  Do[
    d = s;
    predicted = -fac[d["p1"], d["b"][[1]]] * fac[d["p2"], d["b"][[2]]] * fac[d["p3"], d["b"][[3]]];
    correction = d["ss"] - predicted;
    If[i <= 5,
      Print[d["p1"], "*", d["p2"], "*", d["p3"], ": ss=", d["ss"],
            " predicted=", predicted, " correction=", correction]
    ],
    {i, Length[subset]}, {s, {subset[[i]]}}
  ];
  Print[""],
  {b, {{1, 0, 1}, {0, 1, 1}, {1, 1, 0}}}  (* patterns with two 1s *)
];

(* Maybe the formula involves more than just bᵢ? *)
Print["=== Deeper analysis: what else matters? ===\n"];

(* For a fixed b pattern, what determines ss? *)
subset = Select[data, #["b"] == {1, 0, 1} &];
Print["For b = (1,0,1):"];
Do[
  d = subset[[i]];
  Print["  ", d["p1"], "*", d["p2"], "*", d["p3"], ": ss=", d["ss"],
        " total=", d["total"], " ratio=", N[d["ss"]/d["total"]]],
  {i, Min[15, Length[subset]]}
];

(* The ratio ss/total might be more regular *)
Print["\n=== Ratio analysis ===\n"];
Do[
  subset = byB[b];
  ratios = N[#["ss"]/#["total"]] & /@ subset;
  Print["b = ", b, ": ratios = ", Union[Round[ratios, 0.001]][[;;Min[10, Length[Union[ratios]]]]]],
  {b, Sort[Keys[byB]]}
];

(* Check congruence mod 4 *)
Print["\n=== Verify Σsigns ≡ -5 (mod 4) ===\n"];
violations = Select[data, Mod[#["ss"], 4] != Mod[-5, 4] &];
Print["Violations: ", Length[violations], " / ", Length[data]];
If[Length[violations] > 0,
  Print["First violations: "];
  Do[Print["  k=", v["k"], " ss=", v["ss"], " mod 4=", Mod[v["ss"], 4]], {v, violations[[;;Min[5, Length[violations]]]]}]
];
