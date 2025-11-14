#!/usr/bin/env wolframscript
(* Parallel checkpoint-based primorial verification *)

(* Direct sum formulation - independent per m *)
RecurseState[{n_, a_, b_}] := {n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))};

SieveState[m_Integer] := Module[{h, state},
  h = Floor[(m - 1)/2];
  state = {0, 0, 1};
  Do[state = RecurseState[state], {h}];
  state
];

PrimorialFromState[{n_, a_, b_}] := 2 * Denominator[-1 + b];

Primorial0[m_Integer] := If[m == 2, 2, PrimorialFromState[SieveState[m]]];

StandardPrimorial[m_Integer] := Times @@ Prime[Range[PrimePi[m]]];

(* Parse arguments *)
args = Rest[$ScriptCommandLine];
maxM = If[Length[args] >= 1, ToExpression[args[[1]]], 100000];

Print["================================================================="];
Print["PARALLEL PRIMORIAL VERIFICATION"];
Print["================================================================="];
Print[];
Print["Maximum m: ", maxM];
Print["CPU cores available: ", $ProcessorCount];
Print[];

(* Generate test points - logarithmic sampling *)
testPoints = Join[
  {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97},
  Table[Floor[10^x], {x, 2, Log10[maxM], 0.1}],
  {maxM}
] // Union // Select[# <= maxM &];

Print["Test points: ", Length[testPoints]];
Print["  Range: ", Min[testPoints], " to ", Max[testPoints]];
Print["  Includes ", Count[testPoints, _?PrimeQ], " primes"];
Print[];

(* Verify in parallel *)
Print["Starting parallel verification..."];
Print[];

startTime = AbsoluteTime[];

results = ParallelTable[
  Module[{computed, standard, verified, t, tStd, pi, digits},
    pi = PrimePi[m];

    {t, computed} = AbsoluteTiming[Primorial0[m]];
    {tStd, standard} = AbsoluteTiming[StandardPrimorial[m]];

    digits = IntegerLength[computed];
    verified = (computed == standard);

    {m, pi, t, tStd, digits, verified}
  ],
  {m, testPoints},
  Method -> "FinestGrained"
];

totalTime = AbsoluteTime[] - startTime;

(* Display results *)
Print["================================================================="];
Print["RESULTS (Last 20 test points)"];
Print["================================================================="];
Print[];

Print["m\t\tπ(m)\tSieve(s)\tStd(s)\tDigits\t\tVerified"];
Print[StringRepeat["=", 75]];

startIdx = Max[1, Length[results] - 19];
Do[
  Module[{m, pi, t, tStd, digits, verified},
    {m, pi, t, tStd, digits, verified} = results[[i]];
    Print[
      m, "\t",
      If[m < 100000, "\t", ""],
      pi, "\t",
      N[t, 3], "\t\t",
      N[tStd, 3], "\t",
      digits, "\t\t",
      If[verified, "✓", "✗ FAIL"]
    ];
  ],
  {i, startIdx, Length[results]}
];

If[Length[results] > 20,
  Print["... (showing last 20 of ", Length[results], " total tests)"];
];

Print[];
Print["================================================================="];
Print["SUMMARY"];
Print["================================================================="];

failureCount = Count[results, {_, _, _, _, _, False}];

Print["Total tests: ", Length[results]];
Print["Failures: ", failureCount];
Print["Total time: ", N[totalTime, 4], " seconds"];
Print["Average time per test: ", N[totalTime / Length[results], 3], " seconds"];
Print[];

If[failureCount == 0,
  Module[{last = Last[results]},
    Print["SUCCESS: Formula verified for all ", Length[results], " test points up to m=", last[[1]]];
    Print[];
    Print["Largest primorial computed:"];
    Print["  m = ", last[[1]]];
    Print["  π(m) = ", last[[2]], " primes"];
    Print["  Primorial has ", last[[5]], " digits"];
    Print["  Sieve time: ", N[last[[3]], 3], "s"];
    Print["  Standard time: ", N[last[[4]], 3], "s"];
    Print["  Speedup: ", N[last[[4]]/last[[3]], 2], "x"];
  ];,
  Print["FAILURE: Formula failed at ", failureCount, " test point(s):"];
  Print[Select[results, !Last[#] &][[All, 1]]];
];

Print[];
Print["================================================================="];
Print[];
Print["Usage: wolframscript verify_primorial_parallel.wl [maxM]"];
Print["  maxM: Maximum m value to verify (default: 100000)"];
Print["  Tests ~", Ceiling[10 * Log10[maxM]], " logarithmically-spaced checkpoints"];
Print["================================================================="];
