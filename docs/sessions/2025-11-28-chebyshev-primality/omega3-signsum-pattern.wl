(* Find pattern for signSum(p1*p2*p3) directly *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

(* Collect data with various modular properties *)
data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    (* Modular properties *)
    p2m4 = Mod[p2, 4];
    p3m4 = Mod[p3, 4];
    p2mp1 = Mod[p2, p1];
    p3mp1 = Mod[p3, p1];

    (* CRT coefficients *)
    M1 = p2 p3; M2 = p1 p3; M3 = p1 p2;
    e1 = PowerMod[M1, -1, p1];
    e2 = PowerMod[M2, -1, p2];
    e3 = PowerMod[M3, -1, p3];

    (* Parities of CRT coefficients *)
    parM1e1 = Mod[M1 e1, 2];
    parM2e2 = Mod[M2 e2, 2];
    parM3e3 = Mod[M3 e3, 2];

    AppendTo[data, <|
      "k" -> k, "p1" -> p1, "p2" -> p2, "p3" -> p3, "ss" -> ss,
      "p2m4" -> p2m4, "p3m4" -> p3m4,
      "p2mp1" -> p2mp1, "p3mp1" -> p3mp1,
      "parM1e1" -> parM1e1, "parM2e2" -> parM2e2, "parM3e3" -> parM3e3
    |>];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 20]]}
];

Print["=== signSum values for p1=3 ==="];
Print["Unique values: ", Union[#["ss"] & /@ data]];

Print["\n=== Group by (p2 mod 4, p3 mod 4) ==="];
grouped = GroupBy[data, {#["p2m4"], #["p3m4"]} &];
Do[
  ssVals = #["ss"] & /@ grouped[key];
  Print[key, " → ss ∈ ", Union[ssVals], " (", Length[ssVals], " cases)"],
  {key, Sort[Keys[grouped]]}
];

Print["\n=== Group by (p2 mod 3, p3 mod 3) ==="];
grouped2 = GroupBy[data, {#["p2mp1"], #["p3mp1"]} &];
Do[
  ssVals = #["ss"] & /@ grouped2[key];
  Print[key, " → ss ∈ ", Union[ssVals], " (", Length[ssVals], " cases)"],
  {key, Sort[Keys[grouped2]]}
];

Print["\n=== Group by CRT parity signature ==="];
grouped3 = GroupBy[data, {#["parM1e1"], #["parM2e2"], #["parM3e3"]} &];
Do[
  ssVals = #["ss"] & /@ grouped3[key];
  Print[key, " → ss ∈ ", Union[ssVals], " (", Length[ssVals], " cases)"],
  {key, Sort[Keys[grouped3]]}
];

Print["\n=== Try: (p2 mod 4, p3 mod 4, p2 mod 3, p3 mod 3) ==="];
grouped4 = GroupBy[data, {#["p2m4"], #["p3m4"], #["p2mp1"], #["p3mp1"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped4[key]];
  If[Length[ssVals] > 1,
    Print["CONFLICT at ", key, " → ss ∈ ", ssVals];
    conflicts++
  ],
  {key, Keys[grouped4]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped4]]];
