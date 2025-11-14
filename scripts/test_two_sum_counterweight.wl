#!/usr/bin/env wolframscript
(* Test two-sum structure: main sum + counterweight sum *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Testing Two-Sum Counterweight Approach"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

(* Formula: Sum[(-1)^k · k!/(2k+1)] + α·Sum[(-1)^k · g(k)/(2k+1)] *)

(* Test different counterweight functions g(k) with various α *)

counterweights = <|
  (* Simple polynomial counterweights *)
  "α=1, g(k)=1" -> {1, Function[k, 1]},
  "α=-1, g(k)=1" -> {-1, Function[k, 1]},
  "α=1, g(k)=k" -> {1, Function[k, k]},
  "α=-1, g(k)=k" -> {-1, Function[k, k]},

  (* Lower factorials *)
  "α=1, g(k)=(k-1)!" -> {1, Function[k, If[k>=1, (k-1)!, 1]]},
  "α=-1, g(k)=(k-1)!" -> {-1, Function[k, If[k>=1, (k-1)!, 1]]},
  "α=1/2, g(k)=(k-1)!" -> {1/2, Function[k, If[k>=1, (k-1)!, 1]]},

  (* Reciprocal factorials (convergent series) *)
  "α=1, g(k)=1/k!" -> {1, Function[k, 1/k!]},
  "α=-1, g(k)=1/k!" -> {-1, Function[k, 1/k!]},

  (* Binomial *)
  "α=1, g(k)=C(2k,k)" -> {1, Function[k, Binomial[2k, k]]},
  "α=-1, g(k)=C(2k,k)" -> {-1, Function[k, Binomial[2k, k]]},

  (* Mixed *)
  "α=1, g(k)=k·(k-1)" -> {1, Function[k, k*(k-1)]},
  "α=-1, g(k)=k·(k-1)" -> {-1, Function[k, k*(k-1)]}
|>;

TestCounterweight[name_, alpha_, g_, mMax_: 25] := Module[
  {results},

  results = Table[
    Module[{mainSum, counterSum, totalSum, denom, numer, prim, ratio},
      mainSum = Sum[(-1)^j * j!/(2j+1), {j, 1, (m-1)/2}];
      counterSum = alpha * Sum[(-1)^j * g[j]/(2j+1), {j, 1, (m-1)/2}];
      totalSum = mainSum + counterSum;

      denom = Denominator[totalSum];
      numer = Numerator[totalSum];
      prim = Primorial[m];
      ratio = prim/denom;

      {m, denom, ratio, IntegerLength[Abs[numer]]}
    ],
    {m, 3, mMax, 2}
  ];

  (* Check consistency *)
  ratios = results[[All, 3]];
  numerSizes = results[[All, 4]];

  consistentRatio = If[Length[DeleteDuplicates[ratios]] <= 2,
    First[Sort[ratios]],
    "Inconsistent"
  ];

  <|
    "Name" -> name,
    "Ratio" -> consistentRatio,
    "Avg numerator size" -> Mean[numerSizes]
  |>
];

Print["Testing counterweight formulas...\n"];

testResults = KeyValueMap[
  Function[{name, params},
    {alpha, g} = params;
    TestCounterweight[name, alpha, g, 25]
  ],
  counterweights
];

(* Summary *)
Print[StringRepeat["=", 70]];
Print["RESULTS"];
Print[StringRepeat["=", 70], "\n"];

Print[Grid[
  Prepend[
    Table[
      {
        result["Name"],
        result["Ratio"],
        NumberForm[result["Avg numerator size"], {4, 1}]
      },
      {result, testResults}
    ],
    {"Counterweight", "Primorial/Denominator", "Avg Num Digits"}
  ],
  Frame -> All,
  Alignment -> Left
]];

(* Find successes *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["FINDINGS");
Print[StringRepeat["=", 70], "\n"];

successes = Select[testResults,
  (IntegerQ[#["Ratio"]] || Head[#["Ratio"]] === Rational) &&
  #["Ratio"] =!= "Inconsistent" &
];

If[Length[successes] > 0,
  Print["✓ Found ", Length[successes], " counterweights with consistent ratios:\n"];
  Do[
    Print["  • ", result["Name"]];
    Print["    Ratio: ", result["Ratio"]];
    If[IntegerQ[result["Ratio"]] && result["Ratio"] > 1,
      Print["    Missing primes: ",
            FactorInteger[result["Ratio"]][[All, 1]]];
    ];
    Print["    Avg numerator: ", NumberForm[result["Avg numerator size"], {4, 1}],
          " digits"];
    Print[""];
    ,
    {result, successes}
  ];
  ,
  Print["✗ No counterweights produce consistent ratios\n"];
];

Print["Done!"];
