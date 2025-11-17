#!/usr/bin/env wolframscript
(* COMPREHENSIVE TEST: CF center norms for ALL mod 8 classes *)

Print[StringRepeat["=", 80]];
Print["CF CENTER NORM ANALYSIS - ALL MOD 8 CLASSES"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

TestCenterNorm[p_] := Module[{period, convs, halfIdx, xh, yh, normh, mod8},
  period = CFPeriod[p];
  mod8 = Mod[p, 8];

  If[period > 0,
    convs = Convergents[ContinuedFraction[Sqrt[p], period + 5]];
    halfIdx = Ceiling[period / 2];

    If[halfIdx <= Length[convs],
      xh = Numerator[convs[[halfIdx]]];
      yh = Denominator[convs[[halfIdx]]];
      normh = xh^2 - p*yh^2;

      {p, mod8, period, normh},
      Nothing
    ],
    Nothing
  ]
]

(* Get all primes < 5000 *)
allPrimes = Select[Range[3, 5000], PrimeQ];
Print["Total primes < 5000: ", Length[allPrimes]];
Print[];

Print["Computing center norms for all primes..."];
Print[];

results = Table[
  TestCenterNorm[p],
  {p, allPrimes}
];

results = DeleteCases[results, Nothing];
Print["Valid results: ", Length[results]];
Print[];

Print[StringRepeat["=", 80]];
Print["ANALYSIS BY MOD 8 CLASS"];
Print[StringRepeat["=", 80]];
Print[];

For[m = 1, m <= 7, m += 2,
  subset = Select[results, #[[2]] == m &];

  If[Length[subset] > 0,
    Print[StringRepeat["-", 60]];
    Print["p ≡ ", m, " (mod 8): n=", Length[subset]];
    Print[StringRepeat["-", 60]];
    Print[];

    (* Get center norms *)
    norms = subset[[All, 4]];
    uniqueNorms = Union[norms];
    normTally = Tally[norms];

    Print["Unique center norms: ", uniqueNorms];
    Print["Distribution:"];
    Do[
      {norm, count} = normTally[[i]];
      pct = N[100.0 * count / Length[subset], 3];
      Print["  norm = ", StringPadRight[ToString[norm], 6], ": ",
            StringPadRight[ToString[count], 5], "/", Length[subset],
            " (", pct, "%)"];
      ,
      {i, Length[normTally]}
    ];
    Print[];

    (* Check for patterns *)
    If[Length[uniqueNorms] == 1,
      Print["★ UNIVERSAL PATTERN: All have norm = ", uniqueNorms[[1]]];
      ,
      (* Multiple norms - check if there's a rule *)
      Print["Multiple norms observed. Checking for conditional patterns..."];

      (* Check period parity *)
      evenPeriod = Select[subset, Mod[#[[3]], 2] == 0 &];
      oddPeriod = Select[subset, Mod[#[[3]], 2] == 1 &];

      If[Length[evenPeriod] > 0,
        normsEven = Union[evenPeriod[[All, 4]]];
        Print["  Even period (n=", Length[evenPeriod], "): norms = ", normsEven];
      ];

      If[Length[oddPeriod] > 0,
        normsOdd = Union[oddPeriod[[All, 4]]];
        Print["  Odd period (n=", Length[oddPeriod], "): norms = ", normsOdd];
      ];
      Print[];

      (* Check period mod 4 *)
      For[r = 0, r <= 3, r++,
        subMod4 = Select[subset, Mod[#[[3]], 4] == r &];
        If[Length[subMod4] > 0,
          normsMod4 = Union[subMod4[[All, 4]]];
          Print["  Period ≡ ", r, " (mod 4) (n=", Length[subMod4], "): norms = ", normsMod4];
        ];
      ];
    ];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["DETAILED EXAMPLES"];
Print[StringRepeat["=", 80]];
Print[];

(* Show first 10 examples for each mod 8 class *)
For[m = 1, m <= 7, m += 2,
  subset = Select[results, #[[2]] == m &];

  If[Length[subset] > 0,
    Print["p ≡ ", m, " (mod 8) - First 10 examples:"];
    Print["p       period  per%4  norm"];
    Print[StringRepeat["-", 40]];

    Do[
      {p, m8, per, norm} = subset[[i]];
      Print[
        StringPadRight[ToString[p], 8],
        StringPadRight[ToString[per], 8],
        StringPadRight[ToString[Mod[per, 4]], 7],
        norm
      ];
      ,
      {i, Min[10, Length[subset]]}
    ];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["SUMMARY"];
Print[StringRepeat["=", 80]];
Print[];

For[m = 1, m <= 7, m += 2,
  subset = Select[results, #[[2]] == m &];

  If[Length[subset] > 0,
    norms = Union[subset[[All, 4]]];
    Print["p ≡ ", m, " (mod 8): norms ∈ ", norms];
  ]
];

Print[];
Print["TEST COMPLETE"];
