(* ω=4: Include b-patterns from ALL levels *)

Print["=== ω=4: All-level b-patterns ===\n"];

isPrimitiveLobe[n_, k_] := GCD[n-1, k] == 1 && GCD[n, k] == 1;
signSum[k_] := Total[(-1)^(# - 1) & /@ Select[Range[2, k-1], isPrimitiveLobe[#, k] &]];
epsilon[p_, q_] := If[EvenQ[PowerMod[p, -1, q]], 1, 0];

(* b-vector for a product of primes *)
bVector[primes_List] := Module[{k = Times @@ primes, n = Length[primes]},
  Table[
    Module[{others = Delete[primes, i], prod},
      prod = Times @@ others;
      Mod[prod * PowerMod[prod, -1, primes[[i]]], 2]
    ],
    {i, n}
  ]
];

Print["Computing ω=4 with all-level b-patterns...\n"];

data4 = {};
Do[
  If[p1 < p2 < p3 < p4,
    primes = {p1, p2, p3, p4};
    k = p1 p2 p3 p4;
    ss4 = signSum[k];

    (* All pairs *)
    ss12 = signSum[p1 p2]; ss13 = signSum[p1 p3]; ss14 = signSum[p1 p4];
    ss23 = signSum[p2 p3]; ss24 = signSum[p2 p4]; ss34 = signSum[p3 p4];
    sumPairs = ss12 + ss13 + ss14 + ss23 + ss24 + ss34;

    (* All triples *)
    ss123 = signSum[p1 p2 p3]; ss124 = signSum[p1 p2 p4];
    ss134 = signSum[p1 p3 p4]; ss234 = signSum[p2 p3 p4];
    sumTriples = ss123 + ss124 + ss134 + ss234;

    (* ε values *)
    e12 = epsilon[p1, p2]; e13 = epsilon[p1, p3]; e14 = epsilon[p1, p4];
    e23 = epsilon[p2, p3]; e24 = epsilon[p2, p4]; e34 = epsilon[p3, p4];
    epsPattern = {e12, e13, e14, e23, e24, e34};

    (* b-vectors at ALL levels *)
    b4 = bVector[primes];
    b123 = bVector[{p1, p2, p3}];
    b124 = bVector[{p1, p2, p4}];
    b134 = bVector[{p1, p3, p4}];
    b234 = bVector[{p2, p3, p4}];

    (* Derived quantities *)
    numInv = Total[epsPattern];
    numB4 = Total[b4];
    sumTripleB = Total[b123] + Total[b124] + Total[b134] + Total[b234];

    excess = ss4 - sumTriples + sumPairs;

    AppendTo[data4, <|
      "p" -> primes, "ss4" -> ss4, "excess" -> excess,
      "sumPairs" -> sumPairs, "sumTriples" -> sumTriples,
      "eps" -> epsPattern, "numInv" -> numInv,
      "b4" -> b4, "numB4" -> numB4,
      "b123" -> b123, "b124" -> b124, "b134" -> b134, "b234" -> b234,
      "sumTripleB" -> sumTripleB
    |>]
  ],
  {p1, Prime[Range[2, 6]]},
  {p2, Prime[Range[3, 8]]},
  {p3, Prime[Range[4, 10]]},
  {p4, Prime[Range[5, 12]]}
];

Print["Total cases: ", Length[data4], "\n"];

(* Test: Is excess determined by (ε, b4, all triple b's)? *)
Print["=== Test: excess by (ε, b4, b123, b124, b134, b234) ===\n"];
byAllB = GroupBy[data4,
  {#["eps"], #["b4"], #["b123"], #["b124"], #["b134"], #["b234"]} &
];
constantAll = True;
numConstant = 0;
Do[
  exVals = Union[#["excess"] & /@ byAllB[key]];
  If[Length[exVals] == 1, numConstant++, constantAll = False],
  {key, Keys[byAllB]}
];
Print["Total patterns: ", Length[Keys[byAllB]]];
Print["Constant patterns: ", numConstant];
Print["All constant? ", constantAll];

(* Maybe simpler: (numInv, numB4, sumTripleB) ? *)
Print["\n=== Test: excess by (numInv, numB4, sumTripleB) ===\n"];
bySimple = GroupBy[data4, {#["numInv"], #["numB4"], #["sumTripleB"]} &];
constantSimple = True;
numConstant2 = 0;
Do[
  exVals = Union[#["excess"] & /@ bySimple[key]];
  If[Length[exVals] == 1,
    numConstant2++;
    Print[key, " → ", First[exVals]],
    constantSimple = False;
    Print[key, " → ", exVals, " (NOT constant)"]
  ],
  {key, Sort[Keys[bySimple]]}
];
Print["\nConstant by (numInv, numB4, sumTripleB)? ", constantSimple];

(* What if we use the formula from each triple? *)
Print["\n=== Using ω=3 formula for triples ===\n"];
Print["ω=3 formula: ss₃ = 11 - 4*(#inv + #b)\n"];

(* For each triple, compute predicted value from its (inv, b) *)
data4WithPred = Map[
  Module[{d = #, eps = #["eps"], b123 = #["b123"], b124 = #["b124"],
          b134 = #["b134"], b234 = #["b234"],
          inv123, inv124, inv134, inv234,
          pred123, pred124, pred134, pred234, predSum},
    inv123 = eps[[1]] + eps[[2]] + eps[[4]];  (* e12 + e13 + e23 *)
    inv124 = eps[[1]] + eps[[3]] + eps[[5]];  (* e12 + e14 + e24 *)
    inv134 = eps[[2]] + eps[[3]] + eps[[6]];  (* e13 + e14 + e34 *)
    inv234 = eps[[4]] + eps[[5]] + eps[[6]];  (* e23 + e24 + e34 *)

    pred123 = 11 - 4*(inv123 + Total[b123]);
    pred124 = 11 - 4*(inv124 + Total[b124]);
    pred134 = 11 - 4*(inv134 + Total[b134]);
    pred234 = 11 - 4*(inv234 + Total[b234]);
    predSum = pred123 + pred124 + pred134 + pred234;

    Append[d, "predSumTriples" -> predSum]
  ] &,
  data4
];

(* How close is predSumTriples to actual sumTriples? *)
errors = Select[data4WithPred, #["predSumTriples"] != #["sumTriples"] &];
Print["Triple prediction errors: ", Length[errors], " / ", Length[data4]];

If[Length[errors] == 0,
  Print["✓ ω=3 formula works perfectly for all triples!\n"];

  (* Now: ss₄ = sumTriples - sumPairs + excess
         = predSumTriples - sumPairs + excess
     And predSumTriples can be computed from (ε, triple-b's) *)

  Print["Since sumTriples = predSumTriples, and sumPairs is known..."];
  Print["The only unknown is 'excess'."];

  (* What determines excess beyond what we've tested? *)
  Print["\n=== Deeper analysis of excess ===\n"];

  (* Maybe excess depends on how the b-values interact across triples? *)
  (* For ω=3: correction = 4*(2 - #inv) - 4*#b = 8 - 4*(#inv + #b)
     This can be rewritten as: correction = -4*#inv - 4*#b + 8

     For ω=4: Maybe there's a similar linear combination? *)

  Print["Attempting linear regression...\n"];
  Print["excess = a₀ + a₁*numInv + a₂*numB4 + a₃*sumTripleB + ...\n"];

  (* Create design matrix *)
  designMatrix = Map[
    {1, #["numInv"], #["numB4"], #["sumTripleB"]} &,
    data4WithPred
  ];
  target = #["excess"] & /@ data4WithPred;

  (* Least squares *)
  coeffs = LeastSquares[designMatrix, target];
  Print["Coefficients: ", coeffs // N];
  Print["  (constant, numInv, numB4, sumTripleB)\n"];

  (* Check fit *)
  predictions = designMatrix . coeffs;
  residuals = target - predictions;
  Print["Residual range: ", {Min[residuals], Max[residuals]} // N];
  Print["Unique residuals: ", Union[residuals] // N];
];
