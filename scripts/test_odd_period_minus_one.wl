#!/usr/bin/env wolframscript
(* TEST: For ODD period, is there norm -1 near midpoint? *)

Print[StringRepeat["=", 80]];
Print["PELL -1 CONNECTION: ODD PERIOD ANALYSIS"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

TestOddPeriod[p_] := Module[{period, convs, norms, minusOneIdx, halfIdx, mod8},
  period = CFPeriod[p];
  mod8 = Mod[p, 8];

  If[period > 0 && OddQ[period],
    convs = Convergents[ContinuedFraction[Sqrt[p], period + 5]];
    halfIdx = Ceiling[period / 2];

    (* Compute all norms up to period *)
    norms = Table[
      Module[{x, y, norm},
        x = Numerator[convs[[i]]];
        y = Denominator[convs[[i]]];
        norm = x^2 - p*y^2;
        {i, norm}
      ],
      {i, Min[period, Length[convs]]}
    ];

    (* Find where norm = -1 *)
    minusOneIdx = Select[norms, #[[2]] == -1 &];

    {p, mod8, period, halfIdx, norms, minusOneIdx},
    Nothing
  ]
]

(* Find primes with ODD period *)
primes = Select[Range[3, 300], PrimeQ];
results = DeleteCases[Table[TestOddPeriod[p], {p, primes}], Nothing];

Print["Primes with ODD period < 300: ", Length[results]];
Print[];

If[Length[results] > 0,
  Print[StringRepeat["=", 80]];
  Print["ANALYSIS OF ODD PERIOD CASES"];
  Print[StringRepeat["=", 80]];
  Print[];

  Do[
    {p, m8, per, halfIdx, norms, minusOne} = results[[i]];

    Print["p = ", p, " (mod 8 = ", m8, ", period = ", per, ")"];
    Print["  Half-period index: ", halfIdx];
    Print[];

    Print["  All norms:"];
    Do[
      {idx, norm} = norms[[j]];
      marker = Which[
        idx == halfIdx, " ← HALF",
        norm == -1, " ★ (-1 solution!)",
        idx == per, " ← FUNDAMENTAL",
        True, ""
      ];
      Print["    idx=", idx, ": norm=", norm, marker];
      ,
      {j, Length[norms]}
    ];

    Print[];

    If[Length[minusOne] > 0,
      {idx1, _} = minusOne[[1]];
      Print["  ★ Norm -1 found at index: ", idx1];
      Print["  Distance from half: |", idx1, " - ", halfIdx, "| = ", Abs[idx1 - halfIdx]];
      Print["  Ratio: ", N[idx1 / per, 4]];

      (* Check if it's AT or NEAR half *)
      If[idx1 == halfIdx,
        Print["  → EXACTLY at half-period! ✓"];
      ];

      If[Abs[idx1 - halfIdx] <= 1,
        Print["  → Within 1 step of half-period! ✓"];
      ];
    ,
      Print["  ✗ No norm -1 found (unexpected for odd period!)"];
    ];

    Print[];
    Print[StringRepeat["-", 60]];
    Print[];
    ,
    {i, Min[20, Length[results]]}
  ];

  Print[StringRepeat["=", 80]];
  Print["STATISTICAL SUMMARY"];
  Print[StringRepeat["=", 80]];
  Print[];

  (* Collect positions of -1 *)
  positions = Table[
    {p, m8, per, halfIdx, norms, minusOne} = results[[i]];
    If[Length[minusOne] > 0,
      {idx1, _} = minusOne[[1]];
      dist = Abs[idx1 - halfIdx];
      ratio = N[idx1 / per];
      {p, per, idx1, halfIdx, dist, ratio},
      Nothing
    ],
    {i, Length[results]}
  ];

  positions = DeleteCases[positions, Nothing];

  Print["Found norm -1 in ", Length[positions], "/", Length[results], " odd period primes"];
  Print[];

  If[Length[positions] > 0,
    Print["Position analysis:"];
    Print["  At exactly half: ", Count[positions, {_, _, idx_, half_, 0, _}]];
    Print["  Within 1 of half: ", Count[positions, {_, _, _, _, d_, _} /; d <= 1]];
    Print["  Within 2 of half: ", Count[positions, {_, _, _, _, d_, _} /; d <= 2]];
    Print[];

    ratios = positions[[All, 6]];
    Print["  Mean ratio (idx/-1 / period): ", N[Mean[ratios], 4]];
    Print["  (Perfect half would be ~0.5)"];
    Print[];

    Print["Distribution of distances:"];
    distTally = Tally[positions[[All, 5]]];
    Do[
      {dist, count} = distTally[[j]];
      Print["    Distance ", dist, ": ", count, " cases"];
      ,
      {j, Length[distTally]}
    ];
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print["WILDBERGER'S INSIGHT VERIFICATION"];
Print[StringRepeat["=", 80]];
Print[];

Print["Classical theorem: x²-py²=-1 solvable ⟺ period is ODD"];
Print[];
Print["Our data:"];
Print["  - ODD period primes tested: ", Length[results]];
Print["  - Should ALL have norm -1 at some convergent"];
Print["  - Question: Is that convergent near period/2?"];
Print[];

If[Length[positions] > 0,
  exactHalf = Count[positions, {_, _, idx_, half_, 0, _}];
  nearHalf = Count[positions, {_, _, _, _, d_, _} /; d <= 2];

  If[exactHalf == Length[positions],
    Print["★★★ BREAKTHROUGH: Norm -1 is ALWAYS exactly at half-period!"];
  ];

  If[nearHalf == Length[positions],
    Print["★★ PATTERN: Norm -1 is ALWAYS within 2 steps of half-period!"];
  ];
];

Print[];
Print["TEST COMPLETE"];
