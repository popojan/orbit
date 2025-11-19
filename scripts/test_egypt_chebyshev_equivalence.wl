#!/usr/bin/env wolframscript
(* ::Package:: *)

(*
  Test Egypt-Chebyshev Equivalence Conjecture

  Tests whether FactorialTerm[x,j] == ChebyshevTerm[x,j]
  for various values of x and j.

  See: docs/egypt-chebyshev-equivalence.md
*)

<< Orbit`

Print["="*70];
Print["Egypt-Chebyshev Equivalence Testing"];
Print["="*70];
Print[];

(* Test parameters *)
maxJ = 10;
testXValues = Range[1, 20];

(* Also test Pell-derived x values *)
pellTestDs = {2, 3, 5, 6, 7, 10, 11, 13, 14, 15};
pellXValues = Table[
  Module[{sol = PellSolution[d]},
    (x - 1) /. sol
  ],
  {d, pellTestDs}
];

allXValues = Join[testXValues, pellXValues];

Print["Test Configuration:"];
Print["  j range: 1 to ", maxJ];
Print["  Integer x values: ", Length[testXValues]];
Print["  Pell-derived x values: ", Length[pellXValues]];
Print["  Total x values: ", Length[allXValues]];
Print["  Total test cases: ", Length[allXValues] * maxJ];
Print[];

(* Run tests *)
results = Table[
  Module[{fac, cheb, diff, equal},
    fac = FactorialTerm[x, j];
    cheb = ChebyshevTerm[x, j];
    diff = Abs[fac - cheb];
    equal = (diff == 0);

    <|
      "x" -> x,
      "j" -> j,
      "Factorial" -> fac,
      "Chebyshev" -> cheb,
      "Difference" -> diff,
      "Equal" -> equal
    |>
  ],
  {x, allXValues},
  {j, 1, maxJ}
] // Flatten;

(* Summary statistics *)
totalTests = Length[results];
passedTests = Count[results, KeyValuePattern["Equal" -> True]];
failedTests = totalTests - passedTests;

Print["="*70];
Print["RESULTS"];
Print["="*70];
Print[];
Print["Total tests: ", totalTests];
Print["Passed (exact equality): ", passedTests, " (",
      N[100.0 * passedTests / totalTests], "%)"];
Print["Failed: ", failedTests];
Print[];

If[failedTests > 0,
  Print["FAILED CASES:"];
  Print[];
  failedCases = Select[results, !#["Equal"] &];
  Do[
    Print["  x=", case["x"], ", j=", case["j"]];
    Print["    Factorial: ", case["Factorial"]];
    Print["    Chebyshev: ", case["Chebyshev"]];
    Print["    Difference: ", case["Difference"]];
    Print[];
    ,
    {case, Take[failedCases, UpTo[5]]}
  ];
  If[Length[failedCases] > 5,
    Print["  ... and ", Length[failedCases] - 5, " more failures"];
  ];
  ,
  Print["✓ ALL TESTS PASSED - Conjecture holds for all tested values!"];
];

Print[];
Print["="*70];

(* Detailed verification for small cases *)
Print[];
Print["DETAILED VERIFICATION (j=1,2,3)"];
Print["="*70];
Print[];

Do[
  Print["Case j=", j, ":"];
  Print[];

  (* Test with x=1,2,3 *)
  Do[
    Module[{fac, cheb},
      fac = FactorialTerm[x, j];
      cheb = ChebyshevTerm[x, j];

      Print["  x=", x, ":"];
      Print["    FactorialTerm = ", fac];
      Print["    ChebyshevTerm = ", cheb];
      Print["    Equal? ", fac == cheb];
      Print[];
    ],
    {x, {1, 2, 3}}
  ];

  Print[];
  ,
  {j, 1, 3}
];

Print["="*70];
Print["Test complete. See docs/egypt-chebyshev-equivalence.md for analysis."];
Print["="*70];
