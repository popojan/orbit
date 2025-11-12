#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Compare formula with and without alternating sign *)

Print["=== ALTERNATING SIGN COMPARISON ===\n"];

(* Helper *)
PrimePower[n_, p_] := If[n == 0, Infinity,
  Module[{fi = FactorInteger[Abs[n]]},
    SelectFirst[fi, #[[1]] == p &, {0, 0}][[2]]
  ]
];

(* Original formula WITH alternating sign *)
PrimorialWithAlternating[m_] := Module[{h, sum},
  If[m == 2, Return[2]];
  h = Floor[(m - 1)/2];
  sum = 1/2 * Sum[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
  Denominator[sum]
];

(* Formula WITHOUT alternating sign *)
PrimorialWithoutAlternating[m_] := Module[{h, sum},
  If[m == 2, Return[2]];
  h = Floor[(m - 1)/2];
  sum = 1/2 * Sum[(k!)/(2*k + 1), {k, 1, h}];  (* No (-1)^k *)
  Denominator[sum]
];

(* Standard primorial for comparison *)
StandardPrimorial[m_] := Times @@ Prime @ Range @ PrimePi[m];

(* Compare results *)
Print["=== COMPARISON TABLE ===\n"];
Print["m\tWith (-1)^k\tWithout (-1)^k\tStandard\tMatch?\tRatio"];
Print[StringRepeat["-", 90]];

Do[
  Module[{withAlt, withoutAlt, standard, match, ratio},
    withAlt = PrimorialWithAlternating[m];
    withoutAlt = PrimorialWithoutAlternating[m];
    standard = StandardPrimorial[m];
    match = (withAlt == standard);
    ratio = withoutAlt / standard;

    Print[m, "\t", withAlt, "\t\t", withoutAlt, "\t\t", standard,
      "\t", If[match, "✓", "✗"],
      "\t", If[ratio == 1, "1", FactorInteger[ratio]]
    ]
  ],
  {m, 2, 23}
];

Print["\n"];

(* Detailed analysis of first few terms *)
Print["=== STEP-BY-STEP ANALYSIS ===\n"];

AnalyzeStepByStep[m_, useAlternating_] := Module[{
    h, terms, partialSums, label
  },
  h = Floor[(m - 1)/2];
  label = If[useAlternating, "WITH alternating", "WITHOUT alternating"];

  Print["Formula ", label, " sign for m = ", m, ":\n"];

  terms = Table[
    If[useAlternating, (-1)^k, 1] * (k!)/(2*k + 1),
    {k, 1, h}
  ];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];

  Print["k\tTerm\t\tPartial Sum\t\tNumerator\tDenominator\tv_3(den)"];
  Print[StringRepeat["-", 110]];

  Do[
    Module[{term, num, den, v3},
      term = If[k == 1, 1/2 * terms[[1]], 1/2 * terms[[k]]];
      num = Numerator[partialSums[[k]]];
      den = Denominator[partialSums[[k]]];
      v3 = PrimePower[den, 3];

      Print[k, "\t", term, "\t\t", partialSums[[k]], "\t\t",
        num, "\t", den, "\t", v3]
    ],
    {k, 1, Min[8, h]}
  ];

  Print["\nFinal denominator: ", Denominator[Last[partialSums]]];
  Print["Factorization: ", FactorInteger[Denominator[Last[partialSums]]]];
  Print["\n"];
];

(* Compare with and without for m=13 *)
Print["=== m = 13 (DETAILED) ===\n"];
AnalyzeStepByStep[13, True];
AnalyzeStepByStep[13, False];

(* Track v_3 specifically *)
Print["=== TRACKING v_3 THROUGH EARLY STEPS ===\n"];

CompareV3Evolution[m_] := Module[{
    h, withAlt, withoutAlt
  },
  h = Floor[(m - 1)/2];

  Print["m = ", m, "\n"];

  (* With alternating *)
  withAlt = Module[{terms, partialSums},
    terms = Table[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];
    partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];
    Table[PrimePower[Denominator[partialSums[[k]]], 3], {k, 1, h}]
  ];

  (* Without alternating *)
  withoutAlt = Module[{terms, partialSums},
    terms = Table[(k!)/(2*k + 1), {k, 1, h}];
    partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];
    Table[PrimePower[Denominator[partialSums[[k]]], 3], {k, 1, h}]
  ];

  Print["k\tv_3 (with -1^k)\tv_3 (without -1^k)\tDifference"];
  Print[StringRepeat["-", 60]];

  Do[
    Print[k, "\t", withAlt[[k]], "\t\t", withoutAlt[[k]], "\t\t\t",
      If[withAlt[[k]] == withoutAlt[[k]], "same",
        "DIFFER by " <> ToString[withoutAlt[[k]] - withAlt[[k]]]]
    ],
    {k, 1, h}
  ];

  Print["\n"];
];

Do[CompareV3Evolution[m], {m, {7, 11, 13, 17}}];

(* Check if WITHOUT alternating has v_3 > 1 *)
Print["=== CHECKING FOR v_3 > 1 (without alternating sign) ===\n"];

TestV3[m_] := Module[{h, terms, partialSums, v3List, violations},
  h = Floor[(m - 1)/2];

  terms = Table[(k!)/(2*k + 1), {k, 1, h}];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];

  v3List = Table[{
    k,
    Denominator[partialSums[[k]]],
    PrimePower[Denominator[partialSums[[k]]], 3]
  }, {k, 1, h}];

  violations = Select[v3List, Last[#] > 1 &];

  If[Length[violations] > 0,
    Print["m = ", m, ": FOUND v_3 > 1 at steps:"];
    Print["k\tDenominator\tv_3"];
    Do[Print[v[[1]], "\t", v[[2]], "\t", v[[3]]], {v, violations}];
    Print[""],
    Print["m = ", m, ": all steps have v_3 ≤ 1 ✓\n"]
  ];

  violations
];

Do[TestV3[m], {m, 3, 31, 2}];

Print["=== ANALYSIS COMPLETE ==="];
