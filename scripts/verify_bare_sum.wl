#!/usr/bin/env wolframscript
(* Verify the user's claim about bare sum without prefactor *)

Primorial[m_] := Product[Prime[i], {i, 1, PrimePi[m]}];

Print["=" ~~ StringRepeat["=", 70]];
Print["Verifying Bare Sum Formula"];
Print["=" ~~ StringRepeat["=", 70], "\n"];

(* Test exactly what user specified *)
Print["User's formula: Sum[k!/(2k+1), {k, Floor[(m-1)/2]}]\n"];

results = Table[
  sum = Sum[k!/(2k+1), {k, Floor[(m-1)/2]}];
  denom = Denominator[sum];
  numer = Numerator[sum];
  prim = Primorial[m];
  ratio = prim/denom;

  {m, numer, denom, prim, ratio},
  {m, 3, 41, 2}
];

Print["m | Numerator | Denominator | Primorial | Ratio"];
Print[StringRepeat["-", 70]];

Do[
  {m, num, denom, prim, ratio} = row;
  Print[m, " | ", num, " | ", denom, " | ", prim, " | ", N[ratio, 4]];
  ,
  {row, Take[results, 12]}
];

(* Check for eventual stabilization *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["RATIO ANALYSIS"];
Print[StringRepeat["=", 70], "\n"];

ratios = results[[All, 5]];
Print["All ratios: ", N[ratios, 4]];

(* Check last 10 *)
lastRatios = Take[ratios, -10];
Print["\nLast 10 ratios: ", N[lastRatios, 4]];

If[Length[DeleteDuplicates[lastRatios]] == 1,
  Print["\n✓✓✓ STABLE! Ratio = ", lastRatios[[1]]];

  (* Find where it stabilized *)
  stableFrom = Nothing;
  Do[
    If[Length[DeleteDuplicates[ratios[[i;;]]]] == 1,
      stableFrom = results[[i, 1]];
      Break[];
    ],
    {i, 1, Length[ratios]}
  ];

  Print["Stable from m = ", stableFrom];

  If[lastRatios[[1]] == 1/6,
    Print["\n✓✓✓ USER IS CORRECT! Ratio = 1/6"];
    Print["This means: Denominator = 6·Primorial"];
    Print["So: Primorial(m) = (1/6)·Denominator[Sum]"];
    Print["\nTo extract primorial: Denominator[Sum] / 6"];
  ];
  ,
  Print["\n✗ Not stable or I made an error"];
  Print["Unique ratios in last 10: ", DeleteDuplicates[N[lastRatios, 4]]];
];

(* Also test the alternating version for comparison *)
Print["\n" ~~ StringRepeat["=", 70]];
Print["COMPARISON: Alternating version"];
Print[StringRepeat["=", 70], "\n"];

altResults = Table[
  sum = Sum[(-1)^k * k!/(2k+1), {k, Floor[(m-1)/2]}];
  denom = Denominator[sum];
  prim = Primorial[m];
  ratio = prim/denom;
  {m, ratio},
  {m, 3, 21, 2}
];

Print["Alternating ratios: ", N[altResults[[All, 2]], 4]];

Print["\nDone!"];
