(* Does full (ε, b) pattern determine ss₄ mod 8? *)

Print["=== ω=4: Full pattern and mod 8 ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

bVector[primes_List] := Module[{n = Length[primes]},
  Table[
    Module[{others = Delete[primes, i], prod},
      prod = Times @@ others;
      Mod[prod * PowerMod[prod, -1, primes[[i]]], 2]
    ],
    {i, n}
  ]
];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    primes = {p1, p2, p3, p4};
    k = p1 p2 p3 p4;
    ss = signSum[k];

    (* Full ε pattern (6 values) *)
    e12 = epsilon[p1, p2]; e13 = epsilon[p1, p3]; e14 = epsilon[p1, p4];
    e23 = epsilon[p2, p3]; e24 = epsilon[p2, p4]; e34 = epsilon[p3, p4];
    epsPattern = {e12, e13, e14, e23, e24, e34};

    (* Full b pattern at all levels *)
    b4 = bVector[primes];
    b123 = bVector[{p1, p2, p3}];
    b124 = bVector[{p1, p2, p4}];
    b134 = bVector[{p1, p3, p4}];
    b234 = bVector[{p2, p3, p4}];

    AppendTo[data4, <|
      "p" -> primes, "ss" -> ss, "mod8" -> Mod[ss, 8],
      "eps" -> epsPattern, "b4" -> b4,
      "b123" -> b123, "b124" -> b124, "b134" -> b134, "b234" -> b234
    |>]
  ],
  {p1, Prime[Range[2, 6]]},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 10]]},
  {p4, Prime[Range[5, 12]]}
];

Print["Total cases: ", Length[data4], "\n"];

(* Test: Full (ε, b4) pattern and mod 8 *)
Print["=== mod 8 by (ε, b4) ===\n"];
byEpsB4 = GroupBy[data4, {#["eps"], #["b4"]} &];
constantEpsB4 = True;
numConstant = 0;
Do[
  mod8vals = Union[#["mod8"] & /@ byEpsB4[key]];
  If[Length[mod8vals] == 1, numConstant++, constantEpsB4 = False],
  {key, Keys[byEpsB4]}
];
Print["Total (ε, b4) patterns: ", Length[Keys[byEpsB4]]];
Print["Constant mod 8: ", numConstant];
Print["All constant? ", constantEpsB4];

(* Test: Full pattern including triple b's *)
Print["\n=== mod 8 by full pattern (ε, b4, b123, b124, b134, b234) ===\n"];
byFull = GroupBy[data4, {#["eps"], #["b4"], #["b123"], #["b124"], #["b134"], #["b234"]} &];
constantFull = True;
numConstantFull = 0;
Do[
  mod8vals = Union[#["mod8"] & /@ byFull[key]];
  If[Length[mod8vals] == 1, numConstantFull++, constantFull = False],
  {key, Keys[byFull]}
];
Print["Total full patterns: ", Length[Keys[byFull]]];
Print["Constant mod 8: ", numConstantFull];
Print["All constant? ", constantFull];

If[constantFull,
  Print["\n✓ Full pattern DETERMINES ss₄ mod 8!"];
  Print["(And we already know it determines ss₄ exactly)\n"];

  (* So the "sign" is encoded in the full pattern *)
  Print["=== Distribution of mod 8 values ===\n"];
  byMod8 = GroupBy[data4, #["mod8"] &];
  Do[
    Print["mod 8 = ", m, ": ", Length[byMod8[m]], " cases"],
    {m, {1, 5}}
  ];
];

(* INSIGHT: Since we earlier found that full pattern determines ss₄ exactly,
   it automatically determines mod 8.

   The question is: can we find a SIMPLER formula for mod 8?
   i.e., what PART of the full pattern determines mod 8? *)

Print["\n=== Looking for minimal pattern for mod 8 ===\n"];

(* Maybe just the PARITIES of triple b-sums? *)
tripleParities = Map[
  {Mod[Total[#["b123"]], 2], Mod[Total[#["b124"]], 2],
   Mod[Total[#["b134"]], 2], Mod[Total[#["b234"]], 2]} &,
  data4
];
data4TP = MapThread[Append[#1, "tripleParities" -> #2] &, {data4, tripleParities}];

byTP = GroupBy[data4TP, #["tripleParities"] &];
constantTP = True;
numConstantTP = 0;
Do[
  mod8vals = Union[#["mod8"] & /@ byTP[key]];
  If[Length[mod8vals] == 1, numConstantTP++, constantTP = False],
  {key, Keys[byTP]}
];
Print["By triple parities only:"];
Print["  Patterns: ", Length[Keys[byTP]]];
Print["  Constant: ", numConstantTP];

(* By (ε, triple parities) *)
byEpsTP = GroupBy[data4TP, {#["eps"], #["tripleParities"]} &];
constantEpsTP = True;
numConstantEpsTP = 0;
Do[
  mod8vals = Union[#["mod8"] & /@ byEpsTP[key]];
  If[Length[mod8vals] == 1, numConstantEpsTP++, constantEpsTP = False],
  {key, Keys[byEpsTP]}
];
Print["\nBy (ε, triple parities):"];
Print["  Patterns: ", Length[Keys[byEpsTP]]];
Print["  Constant: ", numConstantEpsTP];
Print["  All constant? ", constantEpsTP];

(* By (total inversions, b4 parity, sum of triple parities) - a 3D parameter *)
by3D = GroupBy[data4TP,
  {Total[#["eps"]], Total[#["b4"]], Total[#["tripleParities"]]} &
];
constant3D = True;
numConstant3D = 0;
Do[
  mod8vals = Union[#["mod8"] & /@ by3D[key]];
  If[Length[mod8vals] == 1, numConstant3D++, constant3D = False],
  {key, Keys[by3D]}
];
Print["\nBy (#inv, #b4, #tripleParity1s):"];
Print["  Patterns: ", Length[Keys[by3D]]];
Print["  Constant: ", numConstant3D];
Print["  All constant? ", constant3D];
