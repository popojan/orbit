(* Test: find the minimal signature that determines c *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
semiprimeSign[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -1];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    s12 = semiprimeSign[p1, p2];
    s13 = semiprimeSign[p1, p3];
    s23 = semiprimeSign[p2, p3];
    sum3 = (s12 - 1)/(-2)*(-4) + (s13 - 1)/(-2)*(-4) + (s23 - 1)/(-2)*(-4);
    (* Simpler: sum3 = 2*(s12+s13+s23) - 3 *)
    (* Actually let me use original def *)
    ss12 = If[s12==1, 1, -3];
    ss13 = If[s13==1, 1, -3];
    ss23 = If[s23==1, 1, -3];
    sum3 = ss12 + ss13 + ss23;
    c = (ss - sum3)/4;

    (* All 6 inverse parities *)
    par12 = If[OddQ[PowerMod[p1, -1, p2]], 1, 0];
    par13 = If[OddQ[PowerMod[p1, -1, p3]], 1, 0];
    par21 = If[OddQ[PowerMod[p2, -1, p1]], 1, 0];
    par23 = If[OddQ[PowerMod[p2, -1, p3]], 1, 0];
    par31 = If[OddQ[PowerMod[p3, -1, p1]], 1, 0];
    par32 = If[OddQ[PowerMod[p3, -1, p2]], 1, 0];

    AppendTo[data, <|
      "k" -> k, "p1" -> p1, "p2" -> p2, "p3" -> p3, "c" -> c,
      "par12" -> par12, "par13" -> par13, "par21" -> par21,
      "par23" -> par23, "par31" -> par31, "par32" -> par32,
      "s12" -> s12, "s13" -> s13, "s23" -> s23
    |>];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 20]]}
];

Print["=== Test: all 6 parities ==="];
grouped = GroupBy[data, {#["par12"], #["par13"], #["par21"], #["par23"], #["par31"], #["par32"]} &];
conflicts = 0;
Do[
  cVals = Union[#["c"] & /@ grouped[key]];
  If[Length[cVals] > 1,
    Print["CONFLICT at ", key, ": c ∈ ", cVals];
    conflicts++
  ],
  {key, Keys[grouped]}
];
Print["Total conflicts with 6-parity: ", conflicts, " / ", Length[Keys[grouped]], " patterns"];

(* If still conflicts, try adding Legendre symbols *)
Print["\n=== Test: 6 parities + 3 Legendre ==="];
dataL = {};
Do[
  d = row;
  L12 = JacobiSymbol[d["p1"], d["p2"]];
  L13 = JacobiSymbol[d["p1"], d["p3"]];
  L23 = JacobiSymbol[d["p2"], d["p3"]];
  AppendTo[dataL, Append[d, "L" -> {L12, L13, L23}]],
  {row, data}
];

grouped2 = GroupBy[dataL, {#["par12"], #["par13"], #["par21"], #["par23"], #["par31"], #["par32"], #["L"]} &];
conflicts2 = 0;
Do[
  cVals = Union[#["c"] & /@ grouped2[key]];
  If[Length[cVals] > 1,
    Print["CONFLICT at ", key, ": c ∈ ", cVals];
    conflicts2++
  ],
  {key, Keys[grouped2]}
];
Print["Total conflicts with 6-parity + Legendre: ", conflicts2, " / ", Length[Keys[grouped2]], " patterns"];

(* Check which parities determine c=2 *)
Print["\n=== Parity patterns for c=2 ==="];
c2 = Select[data, #["c"] == 2 &];
Do[
  d = row;
  Print[d["k"], " = 3×", d["p2"], "×", d["p3"], ": (",
    d["par12"], ",", d["par13"], ",", d["par21"], ",",
    d["par23"], ",", d["par31"], ",", d["par32"], ")"],
  {row, c2}
];

Print["\n=== Parity patterns for c=-1 ==="];
cm1 = Select[data, #["c"] == -1 &];
Do[
  d = row;
  Print[d["k"], " = 3×", d["p2"], "×", d["p3"], ": (",
    d["par12"], ",", d["par13"], ",", d["par21"], ",",
    d["par23"], ",", d["par31"], ",", d["par32"], ")"],
  {row, cm1}
];
