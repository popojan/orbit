(* Test: residues mod all primes <= p1 *)

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];

data = {};
Do[
  If[p1 < p2 < p3,
    k = p1 p2 p3;
    ss = signSum[k];

    (* Residues mod all primes <= p1 *)
    (* For p1=5: primes are {3, 5} (skip 2 since all are odd) *)
    r2mod3 = Mod[p2, 3];
    r3mod3 = Mod[p3, 3];
    r2mod5 = Mod[p2, 5];
    r3mod5 = Mod[p3, 5];

    (* Original 5-parity delta *)
    M2 = p1 p3; M3 = p1 p2;
    c2 = Mod[M2 PowerMod[M2, -1, p2], 2];
    c3 = Mod[M3 PowerMod[M3, -1, p3], 2];
    inv12 = Mod[PowerMod[p1, -1, p2], 2];
    inv13 = Mod[PowerMod[p1, -1, p3], 2];
    inv23 = Mod[PowerMod[p2, -1, p3], 2];
    delta = Mod[c2 + c3 + inv12 + inv13 + inv23, 2];

    AppendTo[data, <|
      "k" -> k, "ss" -> ss,
      "r2mod3" -> r2mod3, "r3mod3" -> r3mod3,
      "r2mod5" -> r2mod5, "r3mod5" -> r3mod5,
      "delta" -> delta
    |>];
  ],
  {p1, {5}},
  {p2, Prime[Range[4, 25]]},
  {p3, Prime[Range[5, 35]]}
];

Print["=== Test: (p2 mod 3, p3 mod 3, p2 mod 5, p3 mod 5, δ) ==="];
grouped = GroupBy[data, {#["r2mod3"], #["r3mod3"], #["r2mod5"], #["r3mod5"], #["delta"]} &];
conflicts = 0;
Do[
  ssVals = Union[#["ss"] & /@ grouped[key]];
  If[Length[ssVals] > 1,
    Print["CONFLICT: ", key, " → ", ssVals];
    conflicts++
  ],
  {key, Keys[grouped]}
];
Print["Conflicts: ", conflicts, " / ", Length[Keys[grouped]], " patterns"];

If[conflicts == 0,
  Print["\n=== SUCCESS! Multi-modulus residues + δ works! ==="];
  Print["Signature: (p2 mod 3, p3 mod 3, p2 mod 5, p3 mod 5, δ)"];
  Print["where δ = (c2 + c3 + inv12 + inv13 + inv23) mod 2"];
];
