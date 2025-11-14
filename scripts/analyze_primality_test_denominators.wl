#!/usr/bin/env wolframscript
(* Analyze denominator structure in the primality test Mod[alt[m], 1/(m-1)!] *)

Print["======================================================================"];
Print["Analyzing Denominator Structure for Prime m"];
Print["======================================================================\n"];

(* Define alternating formula *)
alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}] /; m >= 3;

(* Analyze denominator for prime m *)
AnalyzePrimeDenominator[m_] := Module[{result, denom, fact, mPower, otherFactors, legendrePowers},
  result = Mod[alt[m], 1/(m-1)!];
  denom = Denominator[result];
  fact = FactorInteger[denom];

  (* Power of m itself *)
  mPower = SelectFirst[fact, #[[1]] == m &, {m, 0}][[2]];

  (* Other prime factors *)
  otherFactors = Select[fact, #[[1]] != m &];

  (* Compare with Legendre's formula for (m-1)! *)
  legendrePowers = Table[
    {p, Sum[Floor[(m-1)/p^i], {i, 1, Floor[Log[p, m-1]]}]},
    {p, otherFactors[[All, 1]]}
  ];

  <|
    "m" -> m,
    "Denominator" -> denom,
    "Factorization" -> fact,
    "Power of m" -> mPower,
    "Other factors" -> otherFactors,
    "Legendre (m-1)!" -> legendrePowers,
    "Comparison" -> Table[
      {p, "Actual" -> actualPower, "Legendre" -> legendre, "Diff" -> actualPower - legendre},
      {p, otherFactors[[All, 1]]},
      {actualPower, otherFactors[[All, 2]]},
      {legendre, legendrePowers[[All, 2]]}
    ]
  |>
];

(* Test for primes up to 41 *)
primes = Select[Range[3, 41, 2], PrimeQ];

Print["Detailed analysis for each prime:\n"];

analyses = Table[AnalyzePrimeDenominator[p], {p, primes}];

(* Display each analysis *)
Do[
  Module[{m, pow, comp},
    m = analysis["m"];
    pow = analysis["Power of m"];
    comp = analysis["Comparison"];

    Print["m = ", m, " (prime)"];
    Print["  Power of m in denominator: ", pow];
    Print["  Other prime powers:"];

    If[Length[comp] > 0,
      Do[
        {p, rules} = item;
        actual = "Actual" /. rules;
        legendre = "Legendre" /. rules;
        diff = "Diff" /. rules;
        Print["    ", p, "^", actual, " (Legendre predicts ", p, "^", legendre,
          If[diff != 0, ", diff = " <> ToString[diff], " ✓"], ")"];
        ,
        {item, comp}
      ];
    ];
    Print[];
  ],
  {analysis, analyses}
];

(* Summary statistics *)
Print["======================================================================"];
Print["PATTERN ANALYSIS"];
Print["======================================================================\n"];

(* Check if m always appears to first power *)
mPowers = Table[analysis["Power of m"], {analysis, analyses}];
Print["Powers of m: ", mPowers];
Print["All equal to 1? ", AllTrue[mPowers, # == 1 &], "\n"];

(* Analyze differences from Legendre *)
Print["Differences from Legendre's formula:\n"];

allDiffs = Flatten[Table[
  Module[{comp = analysis["Comparison"]},
    Table[
      {analysis["m"], p, "Diff" /. rules},
      {item, comp},
      {p, item[[1]]},
      {rules, item[[2]]}
    ]
  ],
  {analysis, analyses}
], 1];

(* Group by difference value *)
diffGroups = GroupBy[allDiffs, #[[3]] &];

Print["Differences grouped:"];
Do[
  diff = key;
  count = Length[diffGroups[diff]];
  Print["  Diff = ", diff, ": ", count, " occurrences"];
  If[count <= 10,
    Print["    Examples: ", Take[diffGroups[diff], UpTo[5]]];
  ];
  ,
  {key, Sort[Keys[diffGroups]]}
];

(* Check if difference is always 0 (perfect match with Legendre) *)
Print["\nAll differences = 0 (perfect match)? ", AllTrue[allDiffs, #[[3]] == 0 &]];

(* If not all zero, analyze pattern *)
If[!AllTrue[allDiffs, #[[3]] == 0 &],
  Print["\nNon-zero differences found:"];
  nonZero = Select[allDiffs, #[[3]] != 0 &];
  Print["Count: ", Length[nonZero]];
  Print["Examples: "];
  Do[
    {m, p, diff} = item;
    Print["  m=", m, ", p=", p, ", diff=", diff];
    ,
    {item, Take[nonZero, UpTo[10]]}
  ];
];

Print["\nDone!"];
