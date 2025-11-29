(* Test: does the formula generalize to p1 != 3? *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Formula from p1=3 case *)
predictedSignSum[p1_, p2_, p3_] := Module[
  {M2, M3, e2, e3, c2, c3, inv12, inv13, inv23,
   r2, r3, delta, invSum},

  M2 = p1 p3; M3 = p1 p2;
  e2 = PowerMod[M2, -1, p2];
  e3 = PowerMod[M3, -1, p3];
  c2 = Mod[M2 e2, 2];
  c3 = Mod[M3 e3, 2];

  inv12 = Mod[PowerMod[p1, -1, p2], 2];
  inv13 = Mod[PowerMod[p1, -1, p3], 2];
  inv23 = Mod[PowerMod[p2, -1, p3], 2];
  invSum = inv12 + inv13 + inv23;

  r2 = Mod[p2, p1];
  r3 = Mod[p3, p1];

  delta = Mod[c2 + c3 + invSum, 2];

  (* Original formula for p1=3, try to generalize *)
  (* For p1=3: residues are 1 or 2 *)
  (* For general p1: residues are 2, 3, ..., p1-1 *)
  Which[
    r2 == 1 && r3 == 1, 3 - 4 delta,
    (r2 == 1 && r3 == 2) || (r2 == 2 && r3 == 1), -1 + 4 delta,
    r2 == 2 && r3 == 2, -5 - 4 delta,
    True, -999  (* undefined for other cases *)
  ]
];

Print["=== Testing formula with p1 = 5 ==="];
errors = 0;
total = 0;
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    actual = signSum[k];
    predicted = predictedSignSum[p1, p2, p3];

    If[predicted == -999,
      (* Residue case not covered by p1=3 formula *)
      Print[k, " = ", p1, "×", p2, "×", p3, ": residues (", Mod[p2, p1], ",", Mod[p3, p1], ") not in {1,2}×{1,2}"],
      total++;
      If[actual != predicted,
        Print["MISMATCH: ", k, " = ", p1, "×", p2, "×", p3,
              " actual=", actual, " predicted=", predicted,
              " residues=(", Mod[p2, p1], ",", Mod[p3, p1], ")"];
        errors++
      ]
    ]
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 15]]},
  {p3, Prime[Range[5, 20]]}
];
Print["p1=5: Tested ", total, " cases in {1,2}×{1,2}, errors: ", errors];

Print["\n=== Exploring all residue classes for p1=5 ==="];
(* For p1=5: r2, r3 ∈ {1, 2, 3, 4} *)
data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    actual = signSum[k];
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];
    AppendTo[data, {k, p1, p2, p3, actual, r2, r3}]
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 12]]},
  {p3, Prime[Range[5, 15]]}
];

Print["Grouping by (r2, r3) for p1=5:"];
grouped = GroupBy[data, {#[[6]], #[[7]]} &];
Do[
  ssVals = #[[5]] & /@ grouped[key];
  Print["  ", key, " → Σsigns ∈ ", Union[ssVals]],
  {key, Sort[Keys[grouped]]}
];

Print["\n=== Congruence check for p1=5 ==="];
Print["Expected: Σsigns ≡ 1 - 2×3 = -5 ≡ 3 (mod 4)"];
allSS = #[[5]] & /@ data;
Print["Actual mod 4 values: ", Union[Mod[allSS, 4]]];

Print["\n=== Testing p1 = 7 ==="];
data7 = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    actual = signSum[k];
    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];
    AppendTo[data7, {k, p1, p2, p3, actual, r2, r3}]
  ],
  {p1, {7}},
  {p2, Prime[Range[5, 12]]},
  {p3, Prime[Range[6, 15]]}
];

Print["Grouping by (r2, r3) for p1=7:"];
grouped7 = GroupBy[data7, {#[[6]], #[[7]]} &];
Do[
  ssVals = #[[5]] & /@ grouped7[key];
  Print["  ", key, " → Σsigns ∈ ", Union[ssVals]],
  {key, Sort[Keys[grouped7]]}
];
