#!/usr/bin/env wolframscript
(* Large-scale test: 1000 random numbers *)

Print["================================================================"];
Print["LARGE SCALE TEST: 1000 Random Numbers"];
Print["================================================================"];
Print[""];

(* Same functions as before *)
ComputeMn[n_Integer] := Module[{factorizations, d, k},
  factorizations = {};
  For[d = 2, d <= Floor[Sqrt[n]] + 10, d++,
    k = (n - d^2) / d;
    If[IntegerQ[k] && k >= 0,
      AppendTo[factorizations, {d, k}];
    ];
  ];
  Length[factorizations]
]

ComputeResidue[n_Integer, alpha_Integer, epsilon_Real] := Module[{fn, dMax, kMax},
  dMax = Floor[Sqrt[n]] + 20;
  kMax = 100;
  fn = 0;
  For[d = 2, d <= dMax, d++,
    For[k = 0, k <= kMax, k++,
      Module[{dist},
        dist = (n - k*d - d^2)^2 + epsilon;
        fn += dist^(-alpha);
      ];
    ];
  ];
  epsilon^alpha * fn
]

(* Generate large sample *)
SeedRandom[12345];

Print["Generating sample: 1000 random integers from [10, 5000]"];
Print[""];

sample = RandomSample[Range[10, 5000], 1000];

alpha = 3;
epsilon = 0.001;

Print["Testing with alpha=3, epsilon=0.001"];
Print[""];

(* Run tests with progress indicator *)
startTime = AbsoluteTime[];
successCount = 0;
failures = {};

Print["Progress: 0%"];

Do[
  Module[{n, mn, residue, match},
    n = sample[[i]];
    mn = ComputeMn[n];
    residue = ComputeResidue[n, alpha, epsilon];
    match = Abs[residue - mn] < 0.01;

    If[match, successCount++, AppendTo[failures, {n, mn, residue}]];

    (* Progress update every 100 *)
    If[Mod[i, 100] == 0,
      Print["Progress: ", i, "/1000 (", N[100*i/1000, 3], "%)  Successes: ", successCount];
    ];
  ],
  {i, 1, Length[sample]}
];

totalTime = AbsoluteTime[] - startTime;

Print[""];
Print["================================================================"];
Print["RESULTS"];
Print["================================================================"];
Print[""];

Print["Total tests: 1000"];
Print["Successes: ", successCount];
Print["Failures: ", Length[failures]];
Print["Success rate: ", N[100 * successCount / 1000, 4], "%"];
Print[""];

Print["Total computation time: ", N[totalTime, 4], " seconds"];
Print["Average per test: ", N[totalTime / 1000, 5], " seconds"];
Print["Throughput: ", N[1000 / totalTime, 3], " tests/second"];
Print[""];

(* Analyze failures *)
If[Length[failures] > 0,
  Print["FAILURES (first 10):"];
  Print["n\tM(n)\tResidue\t\tDiff"];
  Print[StringRepeat["-", 50]];
  Do[
    Module[{n, mn, residue, diff},
      {n, mn, residue} = failures[[i]];
      diff = Abs[residue - mn];
      Print[n, "\t", mn, "\t", N[residue, 6], "\t", N[diff, 6]];
    ],
    {i, 1, Min[10, Length[failures]]}
  ];
  Print[""];
];

(* Statistics *)
Print["Sample statistics:");
primeCount = Count[sample, _?PrimeQ];
Print["  Primes: ", primeCount, " (", N[100*primeCount/1000, 3], "%)"];
Print["  Composites: ", 1000 - primeCount, " (", N[100*(1000-primeCount)/1000, 3], "%)"];
Print[""];

Print["Range tested: [", Min[sample], ", ", Max[sample], "]"];
Print[""];

Print["================================================================"];
Print["VERDICT"];
Print["================================================================"];
Print[""];

If[successCount >= 995,
  Print["*** EXCELLENT! ***"];
  Print["Success rate >= 99.5%"];
  Print["Conjecture is VERY STRONGLY supported by numerical evidence."];
  Print[""];
  Print["Ready for publication as: 'Conjecture (numerically verified for 1000+ cases)'"];
,
  If[successCount >= 950,
    Print["Strong evidence, but some failures detected"];
    Print["May need investigation of edge cases"];
  ,
    Print["CAUTION: Significant failure rate"];
    Print["Conjecture may need revision"];
  ];
];

Print[""];
