(* Does "sign" determine ss mod 8? *)

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

(* For ω=2: ss₂ ∈ {1, -3} ≡ {1, 1} (mod 4) but {1, 5} (mod 8)
   Sign = ε₁₂ determines which one! *)
Print["=== ω=2: ss₂ mod 8 ===\n"];
Do[
  If[p < q,
    ss = signSum[p q];
    e = epsilon[p, q];
    Print[{p, q}, ": ss = ", ss, " mod 8 = ", Mod[ss, 8], ", ε = ", e]
  ],
  {p, Prime[Range[2, 6]]},
  {q, Prime[Range[3, 8]]}
];

(* For ω=3: ss₃ = 11 - 4*(#inv + #b)
   ss₃ mod 8 = 11 - 4*(#inv + #b) mod 8 = 3 - 4*(#inv + #b) mod 8
   If (#inv + #b) is even: ss₃ ≡ 3 (mod 8)
   If (#inv + #b) is odd: ss₃ ≡ -1 ≡ 7 (mod 8)
   So ss₃ ∈ {3, 7} (mod 8) *)

Print["\n=== ω=3: ss₃ mod 8 ===\n"];
data3 = {};
Do[
  If[p1 < p2 < p3,
    primes = {p1, p2, p3};
    ss = signSum[p1 p2 p3];
    e12 = epsilon[p1, p2]; e13 = epsilon[p1, p3]; e23 = epsilon[p2, p3];
    numInv = e12 + e13 + e23;
    b = bVector[primes];
    numB = Total[b];
    parity = Mod[numInv + numB, 2];
    AppendTo[data3, <|"ss" -> ss, "mod8" -> Mod[ss, 8], "parity" -> parity|>]
  ],
  {p1, Prime[Range[2, 6]]},
  {p2, Prime[Range[3, 9]]},
  {p3, Prime[Range[4, 11]]}
];

Print["ss₃ mod 8 values: ", Union[#["mod8"] & /@ data3]];
byParity3 = GroupBy[data3, #["parity"] &];
Print["Parity 0 → mod 8: ", Union[#["mod8"] & /@ byParity3[0]]];
Print["Parity 1 → mod 8: ", Union[#["mod8"] & /@ byParity3[1]]];

Print["\n✓ For ω=3: sign = (#inv + #b) mod 2 determines ss₃ mod 8"];

(* For ω=4: We need to find what determines ss₄ mod 8 *)
Print["\n=== ω=4: Finding the sign ===\n"];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    primes = {p1, p2, p3, p4};
    k = p1 p2 p3 p4;
    ss = signSum[k];

    (* ε at level 2 *)
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

    (* Various sign candidates *)
    sign1 = Mod[numInv + numB4, 2];
    sign2 = Mod[numInv + sumB3, 2];
    sign3 = Mod[numInv + numB4 + sumB3, 2];
    sign4 = Mod[numInv - sumB3 + numB4, 2];  (* inclusion-exclusion *)

    AppendTo[data4, <|
      "ss" -> ss, "mod8" -> Mod[ss, 8],
      "sign1" -> sign1, "sign2" -> sign2, "sign3" -> sign3, "sign4" -> sign4
    |>]
  ],
  {p1, Prime[Range[2, 6]]},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 10]]},
  {p4, Prime[Range[5, 12]]}
];

Print["ss₄ mod 8 values: ", Union[#["mod8"] & /@ data4]];
Print[""];

(* Test each sign candidate *)
signs = {"sign1", "sign2", "sign3", "sign4"};
signNames = {
  "#inv + #b4",
  "#inv + sumB3",
  "#inv + #b4 + sumB3",
  "#inv - sumB3 + #b4"
};

Do[
  bySig = GroupBy[data4, #[signs[[i]]] &];
  mod8_0 = Union[#["mod8"] & /@ bySig[0]];
  mod8_1 = Union[#["mod8"] & /@ bySig[1]];
  constant = Length[mod8_0] == 1 && Length[mod8_1] == 1 && mod8_0 != mod8_1;
  Print[signNames[[i]], ":"];
  Print["  sign=0 → mod8 ∈ ", mod8_0];
  Print["  sign=1 → mod8 ∈ ", mod8_1];
  If[constant, Print["  ✓ DETERMINES mod 8!"]];
  Print[""],
  {i, Length[signs]}
];

(* None of the simple ones work, try more combinations *)
Print["=== Trying more complex signs ===\n"];

(* Maybe we need parity of each triple individually *)
data4Ext = Map[
  Module[{d = #, p123Inv, p124Inv, p134Inv, p234Inv},
    (* Inversions within each triple *)
    (* (These are already computed implicitly, but let's be explicit) *)
    #
  ] &,
  data4
];

(* Check if there's ANY binary predicate that determines mod 8 *)
Print["Checking all 2^4 combinations of sign1..sign4:\n"];

bestSplit = {0, "", {}, {}};
Do[
  (* Compute combined sign as XOR of selected individual signs *)
  combined = Map[
    Mod[c1 * #["sign1"] + c2 * #["sign2"] + c3 * #["sign3"] + c4 * #["sign4"], 2] &,
    data4
  ];
  byC = GatherBy[Transpose[{combined, data4}], First];

  If[Length[byC] == 2,
    vals0 = Union[Last /@ Select[Transpose[{combined, data4}], First[#] == 0 &]][[All, "mod8"]];
    vals1 = Union[Last /@ Select[Transpose[{combined, data4}], First[#] == 1 &]][[All, "mod8"]];
    score = Length[Union[vals0]] + Length[Union[vals1]];
    If[Length[Union[vals0]] == 1 && Length[Union[vals1]] == 1,
      Print["FOUND: c=", {c1, c2, c3, c4}, " → ", {vals0, vals1}]
    ]
  ],
  {c1, 0, 1}, {c2, 0, 1}, {c3, 0, 1}, {c4, 0, 1}
];
