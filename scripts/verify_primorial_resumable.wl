#!/usr/bin/env wolframscript
(* Resumable large-scale primorial verification with continuous progress *)

(* Parse command line arguments *)
args = Rest[$ScriptCommandLine];
maxM = If[Length[args] >= 1, ToExpression[args[[1]]], 10000000];
stateFile = "primorial_verification_state.mx";
checkpointInterval = 60; (* seconds between auto-saves *)

(* Iterative sieve formulation *)
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

(* Continuous progress bar *)
ProgressBar[current_, total_, width_: 50, eta_: ""] := Module[{pct, filled, bar},
  pct = N[100 * current / total];
  filled = Floor[width * current / total];
  bar = StringJoin[
    "[",
    StringRepeat["=", filled],
    If[filled < width, ">", ""],
    StringRepeat[" ", width - filled - If[filled < width, 1, 0]],
    "]"
  ];
  WriteString["stdout", "\r", bar, " ", ToString[Round[pct, 0.1]], "%",
    If[eta != "", " ETA: " <> eta, ""], "   "];
];

(* Estimate time remaining *)
EstimateETA[completed_, total_, elapsed_] := Module[{rate, remaining, mins},
  If[completed == 0, Return["unknown"]];
  rate = elapsed / completed;
  remaining = rate * (total - completed);
  mins = Floor[remaining / 60];
  If[mins < 1,
    ToString[Floor[remaining]] <> "s",
    ToString[mins] <> "m"
  ]
];

(* Load previous state if exists *)
LoadState[] := If[FileExistsQ[stateFile],
  Module[{state},
    state = Import[stateFile, "MX"];
    Print["Loaded previous state: ", Length[state[[1]]], " tests completed"];
    Print["Last test: m=", Last[state[[1]]][[1]]];
    Print[];
    state
  ],
  {{}, 0, AbsoluteTime[]} (* {results, failureCount, startTime} *)
];

(* Save state *)
SaveState[results_, failureCount_, startTime_] := Module[{},
  Export[stateFile, {results, failureCount, startTime}, "MX"];
];

(* Generate dense test points - logarithmic + linear sampling *)
GenerateTestPoints[max_] := Module[{points, logPoints, linearPoints},
  (* Logarithmic sampling: every 10^(0.1) from 100 to max *)
  logPoints = Table[Floor[10^x], {x, 2, Log10[max], 0.1}];

  (* Add some linear samples in early range for smoothness *)
  linearPoints = Range[100, 10000, 1000];

  (* Combine and deduplicate *)
  points = Union[Join[linearPoints, logPoints, {max}]];

  (* Filter to only those <= max *)
  Select[points, # <= max &]
];

(* Main verification *)
Print["================================================================="];
Print["RESUMABLE PRIMORIAL VERIFICATION"];
Print["================================================================="];
Print[];
Print["Target maximum m: ", maxM];
Print["State file: ", stateFile];
Print["Checkpoint interval: ", checkpointInterval, " seconds"];
Print[];

(* Load or initialize state *)
{previousResults, failureCount, sessionStartTime} = LoadState[];
testPoints = GenerateTestPoints[maxM];
remainingTests = Select[testPoints, !MemberQ[previousResults[[All, 1]], #] &];

If[Length[remainingTests] == 0,
  Print["All tests already completed up to m=", maxM];
  Print["Delete ", stateFile, " to restart or increase maxM"];
  Exit[0];
];

Print["Total test points: ", Length[testPoints]];
Print["Already completed: ", Length[previousResults]];
Print["Remaining: ", Length[remainingTests]];
Print[];
Print["Starting verification..."];
Print[];

startTime = If[Length[previousResults] == 0, AbsoluteTime[], sessionStartTime];
checkpointResults = previousResults;
lastCheckpointTime = AbsoluteTime[];
testCount = 0;

(* Verification loop with continuous progress *)
Do[
  Module[{t, computed, standard, verified, digits, pi, currentTime, elapsed, eta},
    pi = PrimePi[m];
    testCount++;

    (* Continuous progress update *)
    currentTime = AbsoluteTime[];
    elapsed = currentTime - startTime;
    eta = EstimateETA[Length[checkpointResults] - Length[previousResults] + testCount,
                      Length[remainingTests], elapsed];
    ProgressBar[testCount, Length[remainingTests], 50, eta];

    (* Compute with sieve *)
    {t, computed} = AbsoluteTiming[Primorial0[m]];
    digits = IntegerLength[computed];

    (* Verify against standard *)
    {tStd, standard} = AbsoluteTiming[StandardPrimorial[m]];
    verified = (computed == standard);

    If[!verified, failureCount++];

    AppendTo[checkpointResults, {m, pi, t, tStd, digits, verified}];

    (* Time-based checkpoint saving *)
    If[currentTime - lastCheckpointTime > checkpointInterval,
      SaveState[checkpointResults, failureCount, startTime];
      lastCheckpointTime = currentTime;
    ];
  ],
  {m, remainingTests}
];

Print["\n"]; (* Newline after progress bar *)

(* Final save *)
SaveState[checkpointResults, failureCount, startTime];

totalTime = AbsoluteTime[] - startTime;

Print[];
Print["================================================================="];
Print["RESULTS"];
Print["================================================================="];
Print[];

Print["m\t\tπ(m)\tSieve(s)\tStd(s)\tDigits\t\tVerified"];
Print[StringRepeat["=", 75]];

(* Show last 20 results *)
startIdx = Max[1, Length[checkpointResults] - 19];
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
  {i, startIdx, Length[checkpointResults]}
];

If[Length[checkpointResults] > 20,
  Print["... (showing last 20 tests, ", Length[checkpointResults], " total)"];
];

Print[];
Print["================================================================="];
Print["SUMMARY"];
Print["================================================================="];
Print["Total tests performed: ", Length[checkpointResults]];
Print["Failures: ", failureCount];
Print["Total verification time: ", N[totalTime, 4], " seconds"];
Print["Tests per second: ", N[Length[checkpointResults] / totalTime, 2]];
Print[];

If[failureCount == 0 && Length[remainingTests] == 0,
  Print["SUCCESS: Formula verified for all test points up to m=", Max[testPoints]];
  Print[];
  Print["Largest primorial computed:"];
  Module[{last = Last[checkpointResults]},
    Print["  m = ", last[[1]]];
    Print["  π(m) = ", last[[2]], " primes"];
    Print["  Primorial has ", last[[5]], " digits"];
    Print["  Sieve computation time: ", N[last[[3]], 3], "s"];
    Print["  Standard computation time: ", N[last[[4]], 3], "s"];
    Print["  Speedup: ", N[last[[4]]/last[[3]], 2], "x"];
  ];
  Print[];
  Print["To verify higher values, run with larger maxM parameter:"];
  Print["  wolframscript verify_primorial_resumable.wl 100000000"];,
  If[failureCount > 0,
    Print["FAILURE: Formula failed at ", failureCount, " test point(s)"];
    Print["Failed at: ", Select[checkpointResults, !Last[#] &][[All, 1]]];,
    Print["PARTIAL: Verification in progress"];
  ];
];

Print[];
Print["================================================================="];
Print[];
Print["Usage: wolframscript verify_primorial_resumable.wl [maxM]"];
Print["  maxM: Maximum m value to verify (default: 10000000)"];
Print[];
Print["To resume interrupted verification: rerun the same command"];
Print["To restart from scratch: delete ", stateFile];
Print["================================================================="];
