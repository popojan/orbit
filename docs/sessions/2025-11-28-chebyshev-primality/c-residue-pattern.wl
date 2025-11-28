(* Test: does residue pattern (p2 mod p1, p3 mod p1) determine c? *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
semiprimeSignSum[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];
    ss12 = semiprimeSignSum[p1, p2];
    ss13 = semiprimeSignSum[p1, p3];
    ss23 = semiprimeSignSum[p2, p3];
    sum3 = ss12 + ss13 + ss23;
    c = (ss - sum3)/4;

    (* Residue signature *)
    r21 = Mod[p2, p1];
    r31 = Mod[p3, p1];
    r32 = Mod[p3, p2];

    AppendTo[data, <|
      "k" -> k, "p1" -> p1, "p2" -> p2, "p3" -> p3,
      "c" -> c, "r21" -> r21, "r31" -> r31, "r32" -> r32,
      "ss12" -> ss12, "ss13" -> ss13, "ss23" -> ss23
    |>];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 20]]}
];

Print["=== c vs (r21, r31) pattern ==="];
grouped = GroupBy[data, {#["r21"], #["r31"]} &];
Do[
  cVals = #["c"] & /@ grouped[key];
  Print[key, " → c ∈ ", Tally[cVals]],
  {key, Sort[Keys[grouped]]}
];

Print["\n=== Focus on c=2: what's special about (1,2) and (2,1)? ==="];
Print["c=2 cases: (p2 mod 3, p3 mod 3) patterns:"];
c2cases = Select[data, #["c"] == 2 &];
Do[
  d = row;
  Print[d["p2"], " mod 3 = ", d["r21"], ", ", d["p3"], " mod 3 = ", d["r31"]],
  {row, c2cases}
];

Print["\n=== c=-1 cases ==="];
cm1cases = Select[data, #["c"] == -1 &];
Do[
  d = row;
  Print[d["k"], " = 3×", d["p2"], "×", d["p3"],
        ": c=-1, (r21,r31)=(", d["r21"], ",", d["r31"], ")",
        ", (ss12,ss13,ss23)=(", d["ss12"], ",", d["ss13"], ",", d["ss23"], ")"],
  {row, cm1cases}
];

Print["\n=== Does (r21, r31, ss12, ss13, ss23) determine c? ==="];
grouped2 = GroupBy[data, {#["r21"], #["r31"], #["ss12"], #["ss13"], #["ss23"]} &];
conflicts = 0;
Do[
  cVals = Union[#["c"] & /@ grouped2[key]];
  If[Length[cVals] > 1,
    Print["CONFLICT at ", key, ": c ∈ ", cVals];
    conflicts++
  ],
  {key, Keys[grouped2]}
];
Print["Total conflicts: ", conflicts, " out of ", Length[Keys[grouped2]], " patterns"];
