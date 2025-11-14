#!/usr/bin/env wolframscript
(* Analyze the GCD values when reducing the sum *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["GCD Analysis: The Common Divisor Pattern"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

Print["Computing unreduced and reduced forms...\n"];

(* Unreduced recurrence *)
UnreducedState[0] = {0, 2};
UnreducedState[k_] := UnreducedState[k] = Module[{n, d},
  {n, d} = UnreducedState[k - 1];
  {n * (2k + 1) + k! * d, d * (2k + 1)}
];

(* Also compute via direct sum for verification *)
data = Table[
  Module[{kMax, sum, numUnred, denomUnred, numRed, denomRed, gcd, prim,
          stateUnred},
    kMax = Floor[(m-1)/2];

    (* Direct sum *)
    sum = Sum[k!/(2k+1), {k, kMax}];
    numRed = Numerator[sum];
    denomRed = Denominator[sum];

    (* Unreduced from recurrence *)
    stateUnred = UnreducedState[kMax];
    numUnred = stateUnred[[1]];
    denomUnred = stateUnred[[2]];

    (* GCD *)
    gcd = GCD[numUnred, denomUnred];

    (* Primorial *)
    prim = Primorial[m];

    <|
      "m" -> m,
      "k" -> kMax,
      "N_unred" -> numUnred,
      "D_unred" -> denomUnred,
      "N_red" -> numRed,
      "D_red" -> denomRed,
      "GCD" -> gcd,
      "Primorial" -> prim,
      "D_unred/D_red" -> denomUnred/denomRed,
      "GCD factored" -> If[gcd < 10^15, FactorInteger[gcd], "TooLarge"]
    |>
  ],
  {m, 3, 31, 2}
];

(* Display table *)
Print["Summary table:\n"];
Print[Grid[
  Prepend[
    Table[
      {
        row["m"],
        row["GCD"],
        row["D_unred/D_red"],
        If[row["GCD factored"] =!= "TooLarge",
          Row[FactorInteger[row["GCD"]][[All, 1]], "·"],
          "..."
        ]
      },
      {row, Take[data, 10]}
    ],
    {"m", "GCD", "D_unred/D_red", "Prime factors"}
  ],
  Frame -> All,
  Alignment -> Left
]];

(* Pattern analysis *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["PATTERN ANALYSIS"];
Print[StringRepeat["=", 70], "\n"];

gcds = data[[All, "GCD"]];

Print["1. GCD VALUES"];
Print["First 10 GCDs: ", Take[gcds, 10]];

(* Growth *)
Print["\n2. GROWTH ANALYSIS"];
gcdRatios = Table[
  N[gcds[[i+1]]/gcds[[i]], 4],
  {i, 1, Min[10, Length[gcds]-1]}
];
Print["GCD growth ratios: ", gcdRatios];
Print["Mean growth: ", Mean[gcdRatios]];

(* Relation to m *)
Print["\n3. GCD vs m RELATIONSHIP"];
mVals = data[[All, "m"]];
logGcd = N[Log[gcds]];
logM = N[Log[mVals]];
Print["log(GCD) for m=3..21: ", Take[logGcd, 10]];
Print["Roughly: GCD ~ m^? or e^m ?"];

(* Compare to factorials and primorials *)
Print["\n4. COMPARISON TO KNOWN SEQUENCES"];
Do[
  m = row["m"];
  k = row["k"];
  gcd = row["GCD"];

  ratioToKFact = If[k > 0, N[gcd / k!, 4], "N/A"];
  ratioToPrim = N[gcd / row["Primorial"], 4];

  Print["m=", m, ": GCD/k! = ", ratioToKFact,
        ", GCD/Prim = ", ratioToPrim];
  ,
  {row, Take[data, 6]}
];

(* Detailed factorization analysis *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["FACTORIZATION STRUCTURE"];
Print[StringRepeat["=", 70], "\n"];

Do[
  If[row["GCD factored"] =!= "TooLarge",
    m = row["m"];
    gcd = row["GCD"];
    factors = row["GCD factored"];

    Print["m=", m, ": GCD = ", gcd];
    Print["  Factorization: ", factors];

    (* Check for pattern in exponents *)
    maxExps = Max[factors[[All, 2]]];
    Print["  Max exponent: ", maxExps];

    (* Which primes appear? *)
    primes = factors[[All, 1]];
    Print["  Primes: ", primes];
    Print[""];
  ];
  ,
  {row, Take[data, 8]}
];

(* Relation between GCD and D_unreduced *)
Print[StringRepeat["=", 70]];
Print["GCD vs D_unreduced STRUCTURE"];
Print[StringRepeat["=", 70], "\n"];

Print["We know: D_unreduced = 2·3·5·7·9·11·13·...·(2k+1)"];
Print["         D_reduced = Primorial(m)/6"];
Print["         GCD = D_unreduced / D_reduced\n"];

Print["So GCD contains all the 'extra' prime powers from composite odd numbers.\n"];

Do[
  m = row["m"];
  k = row["k"];
  dUnred = row["D_unred"];
  dRed = row["D_red"];

  (* Factor D_unreduced *)
  If[dUnred < 10^15,
    factUnred = FactorInteger[dUnred];
    factRed = FactorInteger[dRed];

    Print["m=", m, " (k=", k, ")"];
    Print["  D_unreduced = ", Row[factUnred, "·"]];
    Print["  D_reduced = ", Row[factRed, "·"]];

    (* Find the difference *)
    extraPowers = Table[
      pUnred = SelectFirst[factUnred, #[[1]] == p &, {p, 0}][[2]];
      pRed = SelectFirst[factRed, #[[1]] == p &, {p, 0}][[2]];
      {p, pUnred - pRed},
      {p, Union[factUnred[[All, 1]], factRed[[All, 1]]]}
    ];
    extraPowers = Select[extraPowers, #[[2]] > 0 &];

    Print["  Extra powers in GCD: ", extraPowers];
    Print[""];
  ];
  ,
  {row, Take[data, 5]}
];

(* Check if GCD follows a formula *)
Print[StringRepeat["=", 70]];
Print["SEARCHING FOR GCD FORMULA"];
Print[StringRepeat["=", 70], "\n"];

Print["Hypothesis: GCD = f(k) where f is some function of k\n"];

(* The GCD should relate to LCM or products *)
Print["Testing: GCD =? LCM(1,2,3,...,2k+1) / (Primorial/6)\n"];

Do[
  m = row["m"];
  k = row["k"];
  gcd = row["GCD"];

  (* Compute LCM *)
  lcmVal = LCM @@ Range[1, 2k+1];
  prim = row["Primorial"];

  predicted = lcmVal / (prim/6);

  Print["k=", k, ": GCD=", gcd, ", predicted=", predicted,
        ", match? ", gcd == predicted];
  ,
  {row, Take[data, 8]}
];

Print["\nDone!"];
