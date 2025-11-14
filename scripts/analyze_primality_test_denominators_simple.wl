#!/usr/bin/env wolframscript
(* Simplified analysis of denominator structure for prime m *)

Print["======================================================================"];
Print["Analyzing Denominator Structure for Prime m"];
Print["======================================================================\n"];

(* Define alternating formula *)
alt[m_] := Sum[(-1)^k * k!/(2k+1), {k, 1, Floor[(m-1)/2]}] /; m >= 3;

(* Legendre's formula for ν_p(n!) *)
Legendre[n_, p_] := Sum[Floor[n/p^i], {i, 1, Floor[Log[p, n]]}];

(* Test for primes *)
primes = Select[Range[3, 41, 2], PrimeQ];

Print["Detailed analysis for each prime:\n"];

Do[
  Module[{result, denom, fact, mPower, otherFactors},
    result = Mod[alt[m], 1/(m-1)!];
    denom = Denominator[result];
    fact = FactorInteger[denom];

    (* Power of m itself *)
    mPower = SelectFirst[fact, #[[1]] == m &, {m, 0}][[2]];

    (* Other prime factors *)
    otherFactors = Select[fact, #[[1]] != m &];

    Print["m = ", m, " (prime)"];
    Print["  Denominator: ", denom];
    Print["  Factorization: ", fact];
    Print["  Power of m: ", mPower];

    If[Length[otherFactors] > 0,
      Print["  Other prime powers (actual vs Legendre):"];
      Do[
        {p, actualPower} = factor;
        legendrePower = Legendre[m-1, p];
        diff = actualPower - legendrePower;
        Print["    ", p, ": actual=", actualPower, ", Legendre=", legendrePower,
              ", diff=", diff, If[diff == 0, " ✓", ""]];
        ,
        {factor, otherFactors}
      ];
    ];
    Print[];
  ],
  {m, primes}
];

(* Summary statistics *)
Print["======================================================================"];
Print["PATTERN ANALYSIS"];
Print["======================================================================\n"];

(* Check if m always appears to first power *)
mPowers = Table[
  Module[{result, denom, fact},
    result = Mod[alt[m], 1/(m-1)!];
    denom = Denominator[result];
    fact = FactorInteger[denom];
    SelectFirst[fact, #[[1]] == m &, {m, 0}][[2]]
  ],
  {m, primes}
];

Print["Powers of m in denominators: ", mPowers];
Print["All equal to 1? ", AllTrue[mPowers, # == 1 &], "\n"];

(* Collect all differences *)
Print["Collecting all differences from Legendre's formula...\n"];

allDiffs = Flatten[Table[
  Module[{result, denom, fact, otherFactors},
    result = Mod[alt[m], 1/(m-1)!];
    denom = Denominator[result];
    fact = FactorInteger[denom];
    otherFactors = Select[fact, #[[1]] != m &];

    Table[
      {m, p, actualPower, Legendre[m-1, p], actualPower - Legendre[m-1, p]},
      {factor, otherFactors},
      {p, factor[[1]]},
      {actualPower, factor[[2]]}
    ]
  ],
  {m, primes}
], 1];

Print["Total prime powers analyzed: ", Length[allDiffs]];
Print["All differences = 0? ", AllTrue[allDiffs, #[[5]] == 0 &]];

If[!AllTrue[allDiffs, #[[5]] == 0 &],
  nonZero = Select[allDiffs, #[[5]] != 0 &];
  Print["\nNon-zero differences: ", Length[nonZero], " out of ", Length[allDiffs]];
  Print["Examples of non-zero differences:"];
  Print["m | prime p | actual | Legendre | diff"];
  Print[StringRepeat["-", 50]];
  Do[
    {m, p, actual, leg, diff} = item;
    Print[StringPadRight[ToString[m], 2], " | ",
          StringPadRight[ToString[p], 7], " | ",
          StringPadRight[ToString[actual], 6], " | ",
          StringPadRight[ToString[leg], 8], " | ",
          diff];
    ,
    {item, Take[nonZero, UpTo[20]]}
  ];
,
  Print["\n✓ PERFECT MATCH: All prime powers match Legendre's formula exactly!"];
  Print["  This means: Denominator = m · (m-1)! (in unreduced form)"];
];

Print["\nDone!"];
