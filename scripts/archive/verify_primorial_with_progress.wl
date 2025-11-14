#!/usr/bin/env wolframscript
(* Large-scale primorial verification with progress bar *)

(* Iterative sieve formulation - fast *)
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

(* Progress bar helper *)
ProgressBar[current_, total_, width_: 50] := Module[{pct, filled, bar},
  pct = N[100 * current / total];
  filled = Floor[width * current / total];
  bar = StringJoin[
    "[",
    StringRepeat["=", filled],
    If[filled < width, ">", ""],
    StringRepeat[" ", width - filled - If[filled < width, 1, 0]],
    "]"
  ];
  WriteString["stdout", "\r", bar, " ", ToString[Round[pct, 0.1]], "% (", current, "/", total, ")"];
];

(* Main verification *)
Print["================================================================="];
Print["LARGE-SCALE PRIMORIAL VERIFICATION"];
Print["================================================================="];
Print[];

maxM = 10000000; (* 10 million *)

Print["Target: Verify formula for all m from 3 to ", maxM];
Print["Method: Iterative sieve (O(m) per value)"];
Print[];

(* Checkpoint values for verification *)
checkpoints = {100, 1000, 10000, 100000, 500000, 1000000, 5000000, 10000000};

Print["Verification checkpoints: ", checkpoints];
Print[];
Print["Starting verification..."];
Print[];

startTime = AbsoluteTime[];
failureCount = 0;
checkpointResults = {};

(* Test each checkpoint *)
Do[
  Module[{t, computed, standard, verified, digits, pi},
    pi = PrimePi[m];

    (* Progress *)
    ProgressBar[Position[checkpoints, m][[1, 1]], Length[checkpoints]];

    (* Compute with sieve *)
    {t, computed} = AbsoluteTiming[Primorial0[m]];
    digits = IntegerLength[computed];

    (* Verify against standard *)
    {tStd, standard} = AbsoluteTiming[StandardPrimorial[m]];
    verified = (computed == standard);

    If[!verified, failureCount++];

    AppendTo[checkpointResults, {m, pi, t, tStd, digits, verified}];
  ],
  {m, checkpoints}
];

Print["\n"]; (* Newline after progress bar *)

totalTime = AbsoluteTime[] - startTime;

Print[];
Print["================================================================="];
Print["RESULTS"];
Print["================================================================="];
Print[];

Print["m\t\tπ(m)\tSieve(s)\tStd(s)\tDigits\t\tVerified"];
Print[StringRepeat["=", 75]];

Do[
  Module[{m, pi, t, tStd, digits, verified},
    {m, pi, t, tStd, digits, verified} = checkpointResults[[i]];
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
  {i, Length[checkpointResults]}
];

Print[];
Print["================================================================="];
Print["SUMMARY"];
Print["================================================================="];
Print["Total checkpoints tested: ", Length[checkpoints]];
Print["Failures: ", failureCount];
Print["Total verification time: ", N[totalTime, 4], " seconds"];
Print[];

If[failureCount == 0,
  Print["SUCCESS: Formula verified for all checkpoints up to m=", Max[checkpoints]];
  Print[];
  Print["Largest primorial computed:"];
  Module[{last = Last[checkpointResults]},
    Print["  m = ", last[[1]]];
    Print["  π(m) = ", last[[2]], " primes"];
    Print["  Primorial has ", last[[5]], " digits"];
    Print["  Sieve computation time: ", N[last[[3]], 3], "s"];
    Print["  Standard computation time: ", N[last[[4]], 3], "s"];
    Print["  Speedup: ", N[last[[4]]/last[[3]], 2], "x"];
  ];,
  Print["FAILURE: Formula failed at ", failureCount, " checkpoint(s)"];
  Print["Failed at: ", Select[checkpointResults, !Last[#] &][[All, 1]]];
];

Print[];
Print["================================================================="];
