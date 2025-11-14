#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Check if factor 3 recovers without alternating sign *)

Print["=== CHECKING IF FACTOR 3 RECOVERS (without alternating) ===\n"];

PrimePower[n_, p_] := If[n == 0, Infinity,
  Module[{fi = FactorInteger[Abs[n]]},
    SelectFirst[fi, #[[1]] == p &, {0, 0}][[2]]
  ]
];

CheckRecovery[m_] := Module[{h, terms, partialSums, v3List},
  h = Floor[(m - 1)/2];

  Print["m = ", m, ", h = ", h];

  (* Without alternating sign *)
  terms = Table[(k!)/(2*k + 1), {k, 1, h}];
  partialSums = FoldList[Plus, 1/2 * First[terms], 1/2 * Rest[terms]];

  v3List = Table[{k, 2*k+1, PrimePower[Denominator[partialSums[[k]]], 3]}, {k, 1, h}];

  Print["k\t2k+1\tv_3(denom)"];
  Print[StringRepeat["-", 40]];

  Do[
    Module[{k = v[[1]], divisor = v[[2]], val = v[[3]]},
      Print[k, "\t", divisor, "\t", val,
        If[val == 0, " ← NO factor 3",
        If[val == 1, " ← factor 3 present!", ""]]
      ]
    ],
    {v, v3List}
  ];

  (* Check if 3 ever comes back *)
  recoveryPoint = FirstPosition[v3List[[4;;]], {_, _, Except[0]}, Missing[]];

  If[MissingQ[recoveryPoint],
    Print["\nFactor 3 NEVER recovers after k=4"],
    Print["\n*** Factor 3 RECOVERS at k = ", recoveryPoint[[1]] + 3, " ***"]
  ];

  Print["\nFinal denominator: ", Denominator[Last[partialSums]]];
  Print["Factorization: ", FactorInteger[Denominator[Last[partialSums]]]];
  Print[""];

  recoveryPoint
];

(* Test several m values *)
Do[CheckRecovery[m], {m, {13, 17, 23, 31, 43}}];

Print["=== ANALYSIS COMPLETE ==="];
