(* Analyze 4-value classes more carefully *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    r2 = Mod[p2, p1];
    r3 = Mod[p3, p1];

    inv12 = Mod[PowerMod[p1, -1, p2], 2];
    inv13 = Mod[PowerMod[p1, -1, p3], 2];
    inv21 = Mod[PowerMod[p2, -1, p1], 2];
    inv23 = Mod[PowerMod[p2, -1, p3], 2];
    inv31 = Mod[PowerMod[p3, -1, p1], 2];
    inv32 = Mod[PowerMod[p3, -1, p2], 2];

    M1 = p2 p3; M2 = p1 p3; M3 = p1 p2;
    c1 = Mod[M1 PowerMod[M1, -1, p1], 2];
    c2 = Mod[M2 PowerMod[M2, -1, p2], 2];
    c3 = Mod[M3 PowerMod[M3, -1, p3], 2];

    pars = {inv12, inv13, inv21, inv23, inv31, inv32, c1, c2, c3};
    AppendTo[data, <|"ss" -> ss, "r2" -> r2, "r3" -> r3, "pars" -> pars|>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 20]]},
  {p3, Prime[Range[5, 30]]}
];

byClass = GroupBy[data, {#["r2"], #["r3"]} &];
parNames = {"inv12", "inv13", "inv21", "inv23", "inv31", "inv32", "c1", "c2", "c3"};

(* Focus on class {1, 2} which has 4 values *)
Print["=== Detailed analysis of class {1, 2} ===\n"];
classData = byClass[{1, 2}];
Print["Values: ", Sort[Union[#["ss"] & /@ classData]]];
Print["Cases: ", Length[classData], "\n"];

(* Group by individual parities and show distribution *)
Do[
  Print[parNames[[i]], ":"];
  grouped = GroupBy[classData, #["pars"][[i]] &];
  Do[
    ssVals = Sort[Tally[#["ss"] & /@ grouped[v]]];
    Print["  ", v, " → ", ssVals],
    {v, {0, 1}}
  ],
  {i, 9}
];

(* Try: is there a pattern with inv12 and inv13 separately? *)
Print["\n=== Try (inv12, inv13) as 2-bit key ==="];
grouped2 = GroupBy[classData, {#["pars"][[1]], #["pars"][[2]]} &];
Do[
  ssVals = Sort[Union[#["ss"] & /@ grouped2[key]]];
  Print[key, " → ", ssVals],
  {key, Sort[Keys[grouped2]]}
];

(* Maybe the 4 values correspond to (inv12, inv13)? *)
Print["\n=== Hypothesis: Σsigns = f(inv12, inv13, δ) ==="];
(* where δ = inv32 ⊕ c2 ⊕ c3 *)
dataWithDelta = Map[
  Append[#, "delta" -> Mod[#["pars"][[6]] + #["pars"][[8]] + #["pars"][[9]], 2]] &,
  classData
];
grouped3 = GroupBy[dataWithDelta, {#["pars"][[1]], #["pars"][[2]], #["delta"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped3[key]];
  Print[key, " → ", ssVals];
  If[Length[ssVals] > 1, conflicts++],
  {key, Sort[Keys[grouped3]]}
];
Print["Conflicts: ", conflicts];
