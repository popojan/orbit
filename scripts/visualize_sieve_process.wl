#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Visualize the sieve process in detail *)

Print["=== VISUALIZING THE SIEVE PROCESS ===\n"];

(* Define functions directly *)
RecurseState[{n_, a_, b_}] := {n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))};
InitialState = {0, 0, 1};
SieveStateList[m_Integer] := Module[{h = Floor[(m - 1)/2]},
  NestList[RecurseState, InitialState, Max[0, h]]
];
PrimorialFromState[{n_, a_, b_}] := 2 * Denominator[b - 1];
StandardPrimorial[m_Integer] := Times @@ Prime @ Range @ PrimePi[m];

(* Display the full sieve for a value of m *)
VisualizeSieve[m_] := Module[{h, states},
  h = Floor[(m - 1)/2];

  Print["m = ", m, ", computing ", h, " sieve iterations\n"];

  states = SieveStateList[m];

  Print["Step\tn\ta\t\t\tb\t\t\tDenom(b)\tPrimes so far"];
  Print[StringRepeat["-", 120]];

  Do[
    Module[{n, a, b, denomB, primorial},
      {n, a, b} = states[[i]];
      denomB = Denominator[b];
      primorial = If[n == 0, "initial", PrimorialFromState[states[[i]]]];

      Print[i-1, "\t", n, "\t", a, "\t\t", b, "\t\t",
        denomB, "\t\t",
        If[denomB > 1, FactorInteger[denomB][[All, 1]], {1}]
      ]
    ],
    {i, Length[states]}
  ];

  Print["\nFinal primorial: ", PrimorialFromState[Last[states]]];
  Print["Verification: ", StandardPrimorial[m]];
  Print["Match: ", PrimorialFromState[Last[states]] == StandardPrimorial[m]];
  Print["\n"];
];

(* Run for small m *)
Do[VisualizeSieve[m], {m, {7, 11, 13}}];

(* === Analyze the sieve behavior === *)
Print["=== SIEVE BEHAVIOR ANALYSIS ===\n"];

AnalyzeSieveBehavior[m_] := Module[{h, states, transitions},
  h = Floor[(m - 1)/2];
  states = SieveStateList[m];

  Print["m = ", m, "\n"];

  Print["Tracking when denominators change:\n"];
  Print["Step\tn\t2n+1\tPrime?\tDenom(b)[n-1]\tDenom(b)[n]\tChanged?\tFactor"];
  Print[StringRepeat["-", 100]];

  Do[
    Module[{n, prevDenom, currDenom, divisor, changed, factor},
      n = states[[i, 1]];
      divisor = 2*n + 1;
      prevDenom = If[i == 1, 1, Denominator[states[[i-1, 3]]]];
      currDenom = Denominator[states[[i, 3]]];
      changed = (currDenom != prevDenom);
      factor = If[changed, currDenom/prevDenom, "-"];

      Print[i-1, "\t", n, "\t", divisor, "\t",
        If[PrimeQ[divisor], "YES", "no"], "\t",
        prevDenom, "\t\t", currDenom, "\t\t",
        If[changed, "YES", "no"], "\t",
        factor
      ]
    ],
    {i, 2, Length[states]}
  ];
  Print["\n"];
];

Do[AnalyzeSieveBehavior[m], {m, {13, 17}}];

(* === Look at the a sequence === *)
Print["=== THE a SEQUENCE ===\n"];

AnalyzeASequence[m_] := Module[{h, states, aValues},
  h = Floor[(m - 1)/2];
  states = SieveStateList[m];
  aValues = states[[All, 2]];

  Print["m = ", m, "\n"];
  Print["The a sequence shifts: a[n+1] = b[n]\n"];

  Print["n\ta[n]\t\t\tb[n]"];
  Print[StringRepeat["-", 60]];
  Do[
    Print[states[[i, 1]], "\t", states[[i, 2]], "\t\t", states[[i, 3]]],
    {i, 1, Min[10, Length[states]]}
  ];

  If[Length[states] > 10, Print["..."]];
  Print["\n"];
];

AnalyzeASequence[17];

(* === Pattern in b updates === *)
Print["=== HOW b UPDATES ===\n"];

AnalyzeBUpdates[m_] := Module[{h, states},
  h = Floor[(m - 1)/2];
  states = SieveStateList[m];

  Print["m = ", m, "\n"];
  Print["Recurrence: b[n+1] = b[n] + (a[n] - b[n]) * (2n+1)(n+1)/(2n+3)\n"];

  Print["n\tb[n]\t\ta[n]\t\ta[n]-b[n]\t\tCoeff\t\tUpdate\t\tb[n+1]"];
  Print[StringRepeat["-", 130]];

  Do[
    Module[{n, a, b, diff, coeff, update, nextB},
      {n, a, b} = states[[i]];
      diff = a - b;
      coeff = (2*n + 1)*(n + 1)/(2*n + 3);
      update = diff * coeff;
      nextB = If[i < Length[states], states[[i+1, 3]], "-"];

      Print[n, "\t", b, "\t", a, "\t", diff, "\t\t",
        coeff, "\t", update, "\t", nextB
      ]
    ],
    {i, 1, Min[8, Length[states]]}
  ];

  If[Length[states] > 8, Print["..."]];
  Print["\n"];
];

AnalyzeBUpdates[13];

(* === Look for telescoping === *)
Print["=== CHECKING FOR TELESCOPING ===\n"];

Print["Can we express b[h] as a telescoping sum or product?\n"];

CheckTelescoping[m_] := Module[{h, states, differences},
  h = Floor[(m - 1)/2];
  states = SieveStateList[m];

  Print["m = ", m, "\n"];
  Print["Looking at differences b[n+1] - b[n]:\n"];

  differences = Table[
    states[[i+1, 3]] - states[[i, 3]],
    {i, 1, Length[states] - 1}
  ];

  Print["n\tb[n+1] - b[n]\t\t\tFactorized"];
  Print[StringRepeat["-", 80]];
  Do[
    Module[{diff = differences[[i]], num, denom},
      num = Numerator[diff];
      denom = Denominator[diff];
      Print[i-1, "\t", diff, "\t\t",
        If[Abs[num] < 1000, FactorInteger[Abs[num]], "large"]
      ]
    ],
    {i, 1, Min[8, Length[differences]]}
  ];
  Print["\n"];
];

CheckTelescoping[13];

Print["=== ANALYSIS COMPLETE ==="];
