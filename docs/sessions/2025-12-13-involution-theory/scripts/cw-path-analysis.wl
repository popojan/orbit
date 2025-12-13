#!/usr/bin/env wolframscript
(* Calkin-Wilf Path Analysis *)
(* Date: 2025-12-13 *)
(* Key insight: gold = L^{-1} (CW inverse) *)

(* --- CW Generators --- *)
L[x_] := x/(1 + x) // Together;
R[x_] := x + 1;
Linv[x_] := x/(1 - x) // Together;  (* = gold! *)
Rinv[x_] := x - 1;

(* --- Involutions --- *)
silver[x_] := (1 - x)/(1 + x) // Together;
copper[x_] := 1 - x;
inv[x_] := 1/x;
gold[x_] := x/(1 - x) // Together;

(* --- Find CW path from 1 to r --- *)
findCWPath[r_] := Module[{x = r, path = {}},
  While[x =!= 1 && Length[path] < 100,
    If[x < 1,
      PrependTo[path, "L"];
      x = Linv[x],
      PrependTo[path, "R"];
      x = Rinv[x]
    ]
  ];
  path
];

(* --- Main --- *)
If[$ScriptCommandLine =!= {},
  Print["=== CALKIN-WILF PATH ANALYSIS ===\n"];

  Print["Key insight: gold(x) = x/(1-x) = L^{-1}(x)\n"];

  (* Test CW paths *)
  testFracs = {1/2, 1/3, 2/3, 3/7, 7/11, 5/8, 3/5};
  Print["CW paths from 1:"];
  Print["Fraction | Path | Length"];
  Print[StringJoin@Table["-", {40}]];

  Do[
    path = findCWPath[r];
    Print[r, " | ", StringJoin[path], " | ", Length[path]],
    {r, testFracs}
  ];

  Print["\n=== PATH 1/2 -> 3/7 (different I) ==="];
  path12 = findCWPath[1/2];
  path37 = findCWPath[3/7];

  Print["1 -> 1/2: ", StringJoin[path12]];
  Print["1 -> 3/7: ", StringJoin[path37]];
  Print[""];
  Print["Combined: 1/2 -> 1 -> 3/7"];
  Print["  Use gold (= L^{-1}) to go 1/2 -> 1"];
  Print["  Then follow path to 3/7: ", StringJoin[path37]];
  Print["  Total CW steps: ", 1 + Length[path37]];

  Print["\n=== SPECIAL CASE: 1/(2^k + 1) ==="];
  Print["These have I = 1 (same as 1/2), so direct path via silver/copper"];
  Print[""];
  Print["k | Target | sc-path | Length | |CF| | Ratio"];
  Print[StringJoin@Table["-", {50}]];

  Do[
    target = 1/(2^k + 1);
    dist = 2k - 1;
    cfLen = Total[ContinuedFraction[target]];
    path = StringJoin@Table[If[OddQ[i], "s", "c"], {i, dist}];
    Print[k, " | 1/", 2^k + 1, " | ", path, " | ", dist, " | ", cfLen, " | ", N[dist/cfLen, 2]],
    {k, 1, 6}
  ];

  Print["\n=== KEY RESULT ==="];
  Print["Involution path length grows LOGARITHMICALLY (2k-1)"];
  Print["CF length grows EXPONENTIALLY (2^k + 1)"];
  Print["Ratio -> 0 as k -> infinity"];
];
