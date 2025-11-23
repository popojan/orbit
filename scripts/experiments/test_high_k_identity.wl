#!/usr/bin/env wolframscript
(* Test Chebyshev-Hyperbolic identity for high k values *)

<< Orbit`

Print["Testing Chebyshev-Hyperbolic identity for high k values\n"];
Print["Attempting to REFUTE with random k...\n"];
Print[StringRepeat["=", 70]];
Print[];

(* The identity to test *)
chebyshevForm[x_, k_] := Module[{n, m, u},
  n = Ceiling[k/2];
  m = Floor[k/2];
  u = x + 1;
  ChebyshevT[n, u] * (ChebyshevU[m, u] - ChebyshevU[m-1, u])
];

hyperbolicForm[x_, k_] := Module[{s, denom},
  s = ArcSinh[Sqrt[x/2]];
  denom = Sqrt[2] * Sqrt[2 + x];
  1/2 + Cosh[(1 + 2*k)*s] / denom
];

(* Test various k and x *)
Print["Testing random k values:\n"];
Print["k\tx\tChebyshev\tHyperbolic\tDiff\t\tMatch?"];
Print[StringRepeat["-", 80]];

testCases = {
  {10, 2},
  {15, 3},
  {20, 5},
  {25, 1},
  {30, 7},
  {50, 2},
  {77, 4},  (* random *)
  {100, 3},
  {123, 5}, (* random *)
  {200, 2}
};

Do[
  {k, x} = testCases[[i]];
  cheb = N[chebyshevForm[x, k], 15];
  hyp = N[hyperbolicForm[x, k], 15];
  diff = Abs[cheb - hyp];
  relDiff = diff / Abs[cheb];
  match = relDiff < 10^-10;

  Print[k, "\t", x, "\t", N[cheb, 8], "\t", N[hyp, 8], "\t",
        N[relDiff, 4], "\t", match];

  If[!match,
    Print[">>> MISMATCH FOUND! k=", k, ", x=", x];
    Print["    Chebyshev: ", N[cheb, 20]];
    Print["    Hyperbolic: ", N[hyp, 20]];
    Print["    Absolute diff: ", N[diff, 10]];
  ];
, {i, 1, Length[testCases]}];

Print[];
Print[StringRepeat["=", 70]];
Print[];

(* Test extreme values *)
Print["Testing extreme x values (fixed k=10):\n"];
Print["x\t\tChebyshev\tHyperbolic\tRel Diff\tMatch?"];
Print[StringRepeat["-", 80]];

k = 10;
extremeX = {0.01, 0.1, 0.5, 1, 10, 100, 1000};

Do[
  cheb = N[chebyshevForm[x, k], 15];
  hyp = N[hyperbolicForm[x, k], 15];
  diff = Abs[cheb - hyp];
  relDiff = diff / Abs[cheb];
  match = relDiff < 10^-10;

  Print[N[x,6], "\t", N[cheb, 8], "\t", N[hyp, 8], "\t",
        N[relDiff, 4], "\t", match];

  If[!match,
    Print[">>> POTENTIAL ISSUE at x=", N[x,10]];
  ];
, {x, extremeX}];

Print[];
Print[StringRepeat["=", 70]];
Print[];

(* Statistical test: many random k *)
Print["Statistical test: 100 random k values\n"];

mismatches = 0;
maxRelDiff = 0;
testCount = 100;

SeedRandom[42];  (* reproducible *)

Do[
  k = RandomInteger[{1, 500}];
  x = RandomReal[{0.1, 10}];

  cheb = N[chebyshevForm[x, k], 15];
  hyp = N[hyperbolicForm[x, k], 15];
  relDiff = Abs[cheb - hyp] / Abs[cheb];

  If[relDiff > maxRelDiff, maxRelDiff = relDiff];

  If[relDiff > 10^-10,
    mismatches++;
    If[mismatches <= 5,
      Print["Mismatch #", mismatches, ": k=", k, ", x=", N[x,5],
            ", relDiff=", N[relDiff, 6]];
    ];
  ];
, {i, 1, testCount}];

Print[];
Print["Results of ", testCount, " random tests:"];
Print["  Mismatches: ", mismatches];
Print["  Max relative difference: ", N[maxRelDiff, 10]];
Print["  Success rate: ", N[100.0*(testCount - mismatches)/testCount, 4], "%"];
Print[];

If[mismatches == 0,
  Print["SURVIVED REFUTATION ATTEMPT!"];
  Print["No mismatches found in ", testCount, " random tests."];
  Print["Identity appears to hold for arbitrary k, x."];
,
  Print["REFUTED! Found ", mismatches, " cases where identity fails."];
];

Print[];
Print["DONE!"];
