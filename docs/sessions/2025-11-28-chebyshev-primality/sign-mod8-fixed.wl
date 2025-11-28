(* Does "sign" determine ss mod 8? - FIXED *)

Print["=== Sign and ss mod 8 ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

bVector[primes_List] := Module[{k = Times @@ primes, n = Length[primes]},
  Table[
    Module[{others = Delete[primes, i], prod},
      prod = Times @@ others;
      Mod[prod * PowerMod[prod, -1, primes[[i]]], 2]
    ],
    {i, n}
  ]
];

(* KEY FINDINGS:
   ω=2: ε determines ss₂ mod 8  (ε=0 → 1, ε=1 → 5)
   ω=3: (#inv + #b) mod 2 determines ss₃ mod 8 (0 → 3, 1 → 7)
   ω=4: Need to find what determines ss₄ mod 8 ∈ {1, 5} *)

Print["=== ω=4: Finding the sign ===\n"];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    primes = {p1, p2, p3, p4};
    k = p1 p2 p3 p4;
    ss = signSum[k];

    (* ε at level 2 (all 6 pairs) *)
    e12 = epsilon[p1, p2]; e13 = epsilon[p1, p3]; e14 = epsilon[p1, p4];
    e23 = epsilon[p2, p3]; e24 = epsilon[p2, p4]; e34 = epsilon[p3, p4];
    numInv = e12 + e13 + e14 + e23 + e24 + e34;

    (* b at level 4 *)
    b4 = bVector[primes];
    numB4 = Total[b4];

    (* b at level 3 (each triple) *)
    b123 = bVector[{p1, p2, p3}];
    b124 = bVector[{p1, p2, p4}];
    b134 = bVector[{p1, p3, p4}];
    b234 = bVector[{p2, p3, p4}];
    sumB3 = Total[b123] + Total[b124] + Total[b134] + Total[b234];

    (* Inversions within each triple *)
    inv123 = e12 + e13 + e23;
    inv124 = e12 + e14 + e24;
    inv134 = e13 + e14 + e34;
    inv234 = e23 + e24 + e34;

    (* Triple signs (as in ω=3 formula) *)
    tripleSign123 = Mod[inv123 + Total[b123], 2];
    tripleSign124 = Mod[inv124 + Total[b124], 2];
    tripleSign134 = Mod[inv134 + Total[b134], 2];
    tripleSign234 = Mod[inv234 + Total[b234], 2];
    sumTripleSigns = tripleSign123 + tripleSign124 + tripleSign134 + tripleSign234;

    AppendTo[data4, <|
      "p" -> primes, "ss" -> ss, "mod8" -> Mod[ss, 8],
      "numInv" -> numInv, "numB4" -> numB4, "sumB3" -> sumB3,
      "tripleSign123" -> tripleSign123, "tripleSign124" -> tripleSign124,
      "tripleSign134" -> tripleSign134, "tripleSign234" -> tripleSign234,
      "sumTripleSigns" -> sumTripleSigns
    |>]
  ],
  {p1, Prime[Range[2, 6]]},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 10]]},
  {p4, Prime[Range[5, 12]]}
];

Print["Total cases: ", Length[data4]];
Print["ss₄ mod 8 values: ", Union[#["mod8"] & /@ data4], "\n"];

(* Test various sign candidates *)
signTests = {
  {"numInv + numB4 mod 2", Function[d, Mod[d["numInv"] + d["numB4"], 2]]},
  {"numInv + sumB3 mod 2", Function[d, Mod[d["numInv"] + d["sumB3"], 2]]},
  {"sumTripleSigns mod 2", Function[d, Mod[d["sumTripleSigns"], 2]]},
  {"numB4 + sumTripleSigns mod 2", Function[d, Mod[d["numB4"] + d["sumTripleSigns"], 2]]},
  {"numInv + sumTripleSigns mod 2", Function[d, Mod[d["numInv"] + d["sumTripleSigns"], 2]]},
  {"sumTripleSigns + numB4 + numInv mod 2", Function[d, Mod[d["sumTripleSigns"] + d["numB4"] + d["numInv"], 2]]}
};

Do[
  {name, f} = test;
  grouped = GroupBy[data4, f[#] &];
  mod8vals0 = Union[#["mod8"] & /@ grouped[0]];
  mod8vals1 = Union[#["mod8"] & /@ grouped[1]];
  determines = Length[mod8vals0] == 1 && Length[mod8vals1] == 1 && mod8vals0 != mod8vals1;
  Print[name, ":"];
  Print["  sign=0 → mod8 ∈ ", mod8vals0, " (", Length[grouped[0]], " cases)"];
  Print["  sign=1 → mod8 ∈ ", mod8vals1, " (", Length[grouped[1]], " cases)"];
  If[determines, Print["  ✓ DETERMINES mod 8!"]];
  Print[""],
  {test, signTests}
];

(* Maybe we need inclusion-exclusion of the triple signs *)
Print["=== Inclusion-exclusion of triple signs ===\n"];

(* For ω=3: sign = (#inv_pair + #b_triple) mod 2
   For ω=4: sign = (#triple_signs - #something + #b4) mod 2 ? *)

incExcSign = Map[
  Mod[#["sumTripleSigns"] - #["numInv"] + #["numB4"], 2] &,
  data4
];

data4IE = MapThread[Append[#1, "incExcSign" -> #2] &, {data4, incExcSign}];
byIE = GroupBy[data4IE, #["incExcSign"] &];
mod8vals0 = Union[#["mod8"] & /@ byIE[0]];
mod8vals1 = Union[#["mod8"] & /@ byIE[1]];
Print["sumTripleSigns - numInv + numB4 mod 2:"];
Print["  sign=0 → mod8 ∈ ", mod8vals0, " (", Length[byIE[0]], " cases)"];
Print["  sign=1 → mod8 ∈ ", mod8vals1, " (", Length[byIE[1]], " cases)"];
If[Length[mod8vals0] == 1 && Length[mod8vals1] == 1 && mod8vals0 != mod8vals1,
  Print["  ✓ DETERMINES mod 8!"]
];

(* Try all linear combinations of our base parities *)
Print["\n=== Exhaustive search over linear combinations ===\n"];

bestScore = 100;
bestFormula = "";
Do[
  signVal = Map[
    Mod[a * #["numInv"] + b * #["numB4"] + c * #["sumB3"] + d * #["sumTripleSigns"], 2] &,
    data4
  ];
  grouped = GatherBy[Transpose[{signVal, data4}], First];
  If[Length[grouped] == 2,
    vals0 = Union[#["mod8"] & /@ (Last /@ Select[Transpose[{signVal, data4}], First[#] == 0 &])];
    vals1 = Union[#["mod8"] & /@ (Last /@ Select[Transpose[{signVal, data4}], First[#] == 1 &])];
    score = Length[vals0] + Length[vals1];
    If[score < bestScore,
      bestScore = score;
      bestFormula = StringJoin[
        If[a == 1, "numInv", ""],
        If[b == 1, "+numB4", ""],
        If[c == 1, "+sumB3", ""],
        If[d == 1, "+sumTripleSigns", ""]
      ]
    ];
    If[Length[vals0] == 1 && Length[vals1] == 1 && vals0 != vals1,
      Print["FOUND: ", {a, b, c, d}, " → mod8: ", {vals0, vals1}]
    ]
  ],
  {a, 0, 1}, {b, 0, 1}, {c, 0, 1}, {d, 0, 1}
];

Print["\nBest score: ", bestScore, " with formula: ", bestFormula];
