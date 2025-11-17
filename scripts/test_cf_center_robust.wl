#!/usr/bin/env wolframscript
(* ROBUST TEST: CF center norm ±2 pattern *)

Print[StringRepeat["=", 80]];
Print["ROBUST CF CENTER TEST"];
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

Print["PART 1: Testing Mersenne primes (special cases)"];
Print[StringRepeat["-", 60]];
Print[];

mersennePrimes = {13, 61, 127, 541, 8191};
Print["Mersenne primes to test: ", mersennePrimes];
Print[];

Print["p       mod8  period  norm(1/2)  expected  match?"];
Print[StringRepeat["-", 60]];

mersenneResults = Table[
  result = TestCenterNorm[p];
  If[result =!= Nothing,
    {p, mod8, per, norm} = result;
    expectedNorm = If[mod8 == 7, 2, If[mod8 == 3, -2, "N/A"]];
    match = If[mod8 == 3 || mod8 == 7, norm == expectedNorm, False];

    Print[
      StringPadRight[ToString[p], 8],
      StringPadRight[ToString[mod8], 6],
      StringPadRight[ToString[per], 8],
      StringPadRight[ToString[norm], 11],
      StringPadRight[ToString[expectedNorm], 10],
      If[match, "✓", "✗"]
    ];

    {p, mod8, per, norm, expectedNorm, match},
    Nothing
  ],
  {p, mersennePrimes}
];

mersenneResults = DeleteCases[mersenneResults, Nothing];

Print[];
Print["Mersenne results: ", Count[mersenneResults, {_, _, _, _, _, True}],
      "/", Length[mersenneResults], " match pattern"];
Print[];

Print[StringRepeat["=", 80]];
Print["PART 2: Random sample from primes < 10000"];
Print[StringRepeat["-", 60]];
Print[];

(* Get all primes < 10000 *)
allPrimes = Select[Range[3, 10000], PrimeQ];
Print["Total primes < 10000: ", Length[allPrimes]];

(* Random sample *)
SeedRandom[42];  (* Reproducible *)
sampleSize = 200;
samplePrimes = RandomSample[allPrimes, Min[sampleSize, Length[allPrimes]]];
Print["Random sample size: ", Length[samplePrimes]];
Print[];

Print["Computing center norms for sample..."];
Print[];

sampleResults = Table[
  result = TestCenterNorm[p];
  If[result =!= Nothing,
    {p, mod8, per, norm} = result;
    expectedNorm = If[mod8 == 7, 2, If[mod8 == 3, -2, "N/A"]];
    match = If[mod8 == 3 || mod8 == 7, norm == expectedNorm, False];

    {p, mod8, per, norm, expectedNorm, match},
    Nothing
  ],
  {p, samplePrimes}
];

sampleResults = DeleteCases[sampleResults, Nothing];

Print["Sample computed: ", Length[sampleResults], " primes"];
Print[];

Print[StringRepeat["=", 80]];
Print["RESULTS ANALYSIS"];
Print[StringRepeat["-", 60]];
Print[];

(* Group by mod 8 *)
Print["By mod 8 class:"];
Print[];

For[m = 1, m <= 7, m += 2,
  subset = Select[sampleResults, #[[2]] == m &];

  If[Length[subset] > 0,
    matches = Count[subset, {_, _, _, _, _, True}];
    total = Length[subset];

    Print["p ≡ ", m, " (mod 8): ", matches, "/", total, " match"];

    If[m == 3 || m == 7,
      (* Should all match *)
      expectedNorm = If[m == 7, 2, -2];
      norms = subset[[All, 4]];
      uniqueNorms = Union[norms];

      Print["  Expected norm: ", expectedNorm];
      Print["  Observed norms: ", uniqueNorms];

      If[Length[uniqueNorms] == 1 && uniqueNorms[[1]] == expectedNorm,
        Print["  ✓ PERFECT: All have expected norm"],
        Print["  ✗ VIOLATIONS FOUND!"];
        violations = Select[subset, #[[4]] != expectedNorm &];
        Print["  Violations (first 5):"];
        Do[
          {p, m8, per, norm, exp, mat} = violations[[i]];
          Print["    p=", p, ", norm=", norm, " (expected ", exp, ")"];
          ,
          {i, Min[5, Length[violations]]}
        ];
      ];
    ];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["SUMMARY"];
Print[StringRepeat["-", 60]];
Print[];

(* Overall statistics *)
totalMod37 = Length[Select[sampleResults, #[[2]] == 3 || #[[2]] == 7 &]];
matchesMod37 = Count[Select[sampleResults, #[[2]] == 3 || #[[2]] == 7 &], {_, _, _, _, _, True}];

Print["Total primes p ≡ 3,7 (mod 8): ", totalMod37];
Print["Matches pattern: ", matchesMod37, "/", totalMod37];
Print["Success rate: ", N[100.0 * matchesMod37 / totalMod37, 3], "%"];
Print[];

If[matchesMod37 == totalMod37,
  Print["✓ PATTERN CONFIRMED: 100% match for ", totalMod37, " primes"],
  Print["✗ PATTERN VIOLATED: ", totalMod37 - matchesMod37, " exceptions found"]
];

Print[];
Print["Mersenne primes: ", Count[mersenneResults, {_, _, _, _, _, True}],
      "/", Length[mersenneResults], " match"];
Print[];

(* Check other mod classes *)
otherMod = Select[sampleResults, #[[2]] != 3 && #[[2]] != 7 &];
If[Length[otherMod] > 0,
  Print["Primes p ≡ 1,5 (mod 8): ", Length[otherMod]];
  Print["  (Pattern not expected for these classes)"];
  normsOther = Union[otherMod[[All, 4]]];
  Print["  Observed center norms: ", normsOther];
];

Print[];
Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
