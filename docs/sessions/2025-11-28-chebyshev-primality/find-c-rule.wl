(* Find what determines c in Σsigns(p1p2p3) = Σsigns(p1p2) + Σsigns(p1p3) + Σsigns(p2p3) + 4c *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
semiprimeSignSum[p_, q_] := If[OddQ[PowerMod[p, -1, q]], 1, -3];

(* Compute c for each triple *)
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

    (* Various properties *)
    inv12 = PowerMod[p1, -1, p2];
    inv13 = PowerMod[p1, -1, p3];
    inv21 = PowerMod[p2, -1, p1];
    inv23 = PowerMod[p2, -1, p3];
    inv31 = PowerMod[p3, -1, p1];
    inv32 = PowerMod[p3, -1, p2];

    (* Parities of inverses *)
    parities = {OddQ[inv12], OddQ[inv13], OddQ[inv21], OddQ[inv23], OddQ[inv31], OddQ[inv32]};
    numOdd = Count[parities, True];

    (* Legendre symbols *)
    L12 = JacobiSymbol[p1, p2];
    L13 = JacobiSymbol[p1, p3];
    L21 = JacobiSymbol[p2, p1];
    L23 = JacobiSymbol[p2, p3];
    L31 = JacobiSymbol[p3, p1];
    L32 = JacobiSymbol[p3, p2];
    prodL = L12 L13 L21 L23 L31 L32;

    AppendTo[data, <|
      "k" -> k, "p1" -> p1, "p2" -> p2, "p3" -> p3,
      "ss" -> ss, "sum3" -> sum3, "c" -> c,
      "numOdd" -> numOdd, "parities" -> parities,
      "prodL" -> prodL,
      "inv12" -> inv12, "inv13" -> inv13, "inv23" -> inv23,
      "inv21" -> inv21, "inv31" -> inv31, "inv32" -> inv32,
      "p2mod6" -> Mod[p2, 6], "p3mod6" -> Mod[p3, 6],
      "p2modp1" -> Mod[p2, p1], "p3modp1" -> Mod[p3, p1],
      "p3modp2" -> Mod[p3, p2]
    |>];
  ],
  {p1, {3}},
  {p2, Prime[Range[3, 12]]},
  {p3, Prime[Range[4, 20]]}
];

Print["=== Distribution of c ==="];
groups = GroupBy[data, #["c"] &];
Do[
  Print["c = ", c, ": ", Length[groups[c]], " cases"],
  {c, Sort[Keys[groups]]}
];

Print["\n=== c=2 cases (special) ==="];
Do[
  d = row;
  Print[d["k"], " = ", d["p1"], "×", d["p2"], "×", d["p3"]];
  Print["  Σsigns=", d["ss"], ", sum3=", d["sum3"]];
  Print["  numOdd=", d["numOdd"], ", parities=", d["parities"]];
  Print["  inverses: (", d["inv12"], ",", d["inv13"], ",", d["inv23"], ")"];
  Print["  p2 mod p1=", d["p2modp1"], ", p3 mod p1=", d["p3modp1"], ", p3 mod p2=", d["p3modp2"]];
  Print[""],
  {row, groups[2]}
];

Print["\n=== Pattern search: numOdd vs c ==="];
Do[
  vals = #["numOdd"] & /@ groups[c];
  Print["c=", c, " → numOdd ∈ ", Union[vals]],
  {c, Sort[Keys[groups]]}
];

Print["\n=== Pattern search: prodL vs c ==="];
Do[
  vals = #["prodL"] & /@ groups[c];
  Print["c=", c, " → prodL ∈ ", Union[vals]],
  {c, Sort[Keys[groups]]}
];

(* Check if (numOdd, prodL) determines c *)
Print["\n=== Does (numOdd, prodL) determine c? ==="];
grouped = GroupBy[data, {#["numOdd"], #["prodL"]} &];
Do[
  cVals = Union[#["c"] & /@ grouped[key]];
  If[Length[cVals] > 1,
    Print["CONFLICT at ", key, ": c ∈ ", cVals],
    Print[key, " → c=", First[cVals]]
  ],
  {key, Sort[Keys[grouped]]}
];
