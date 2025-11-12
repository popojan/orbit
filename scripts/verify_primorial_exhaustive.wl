#!/usr/bin/env wolframscript
(* Exhaustive primorial verification - EVERY prime m value *)

(* Parse command line arguments *)
args = Rest[$ScriptCommandLine];
maxM = If[Length[args] >= 1, ToExpression[args[[1]]], 1000000];
stateFile = "primorial_verification_state.mx";
checkpointInterval = 60; (* seconds between auto-saves *)

(* Recurrence step *)
RecurseState[{n_, a_, b_}] := {n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))};

(* Extract primorial from state *)
PrimorialFromState[{n_, a_, b_}] := 2 * Denominator[-1 + b];

(* Progress bar *)
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

(* ETA estimation *)
EstimateETA[completed_, total_, elapsed_] := Module[{rate, remaining, mins, hours},
  If[completed == 0, Return["unknown"]];
  rate = elapsed / completed;
  remaining = rate * (total - completed);
  hours = Floor[remaining / 3600];
  mins = Floor[Mod[remaining, 3600] / 60];
  If[hours > 0,
    ToString[hours] <> "h" <> ToString[mins] <> "m",
    If[mins > 0,
      ToString[mins] <> "m",
      ToString[Floor[remaining]] <> "s"
    ]
  ]
];

(* Load/save state *)
LoadState[] := If[FileExistsQ[stateFile],
  Module[{state},
    state = Import[stateFile, "MX"];
    Print["Loaded previous state: verified up to m=", state[[1]]];
    Print["  Last primorial has ", IntegerLength[state[[2]]], " digits"];
    Print[];
    state
  ],
  {2, 2, {0, 0, 1}, 0, AbsoluteTime[]} (* {lastM, standardPrimorial, sieveState, failureCount, startTime} *)
];

SaveState[lastM_, standardPrimorial_, sieveState_, failureCount_, startTime_] := Module[{result},
  result = Quiet[Check[
    Export[stateFile, {lastM, standardPrimorial, sieveState, failureCount, startTime}, "MX"],
    $Failed
  ]];
  If[result === $Failed,
    Print["\n*** WARNING: State save failed at m=", lastM, " ***\n"];,
    (* Success - print to stderr so it doesn't mess up progress bar *)
    WriteString["stderr", "(saved m=", lastM, ") "];
  ];
  result
];

(* Main verification *)
Print["================================================================="];
Print["EXHAUSTIVE PRIMORIAL VERIFICATION"];
Print["================================================================="];
Print[];
Print["Target: Verify formula for EVERY odd m from 3 to ", maxM];
Print["Method: Incremental sieve with standard primorial comparison"];
Print["State file: ", stateFile];
Print["Checkpoint interval: ", checkpointInterval, " seconds"];
Print[];

(* Load state *)
{currentM, standardPrimorial, sieveState, failureCount, sessionStartTime} = LoadState[];

If[currentM >= maxM,
  Print["Already verified up to m=", currentM, " >= target ", maxM];
  Print["Delete ", stateFile, " to restart or increase maxM"];
  Exit[0];
];

Print["Resuming from m=", currentM];
totalTests = Floor[(maxM - currentM) / 2];
Print["Odd m values to verify: ", totalTests];
Print["  (includes ", PrimePi[maxM] - PrimePi[currentM], " primes)"];
Print[];
Print["Starting verification..."];
Print[];

startTime = If[currentM == 2, AbsoluteTime[], sessionStartTime];
lastCheckpointTime = AbsoluteTime[];
testCount = 0;
recentResults = {};

(* Main loop - verify at EVERY odd m *)
Do[
  Module[{sievePrimorial, verified, currentTime, elapsed, eta},
    currentM = m;

    (* Advance sieve state by one step *)
    sieveState = RecurseState[sieveState];

    (* Update standard primorial: multiply by m if prime, else by 1 *)
    standardPrimorial *= If[PrimeQ[m], m, 1];

    (* Extract primorial from sieve *)
    sievePrimorial = PrimorialFromState[sieveState];

    (* Verify *)
    verified = (sievePrimorial == standardPrimorial);
    If[!verified,
      failureCount++;
      Print["\nFAILURE at m=", m];
    ];

    (* Track recent results (only for primes) *)
    testCount++;
    If[PrimeQ[m],
      AppendTo[recentResults, {m, PrimePi[m], IntegerLength[standardPrimorial], verified}];
      If[Length[recentResults] > 20, recentResults = Drop[recentResults, 1]];
    ];

    (* Progress *)
    currentTime = AbsoluteTime[];
    elapsed = currentTime - startTime;
    eta = EstimateETA[testCount, totalTests, elapsed];
    ProgressBar[testCount, totalTests, 50, eta];

    (* Time-based checkpoint *)
    If[currentTime - lastCheckpointTime > checkpointInterval,
      SaveState[m, standardPrimorial, sieveState, failureCount, startTime];
      lastCheckpointTime = currentTime;
    ];
  ],
  {m, If[currentM == 2, 3, currentM + 2], maxM, 2}  (* Start from 3 if fresh, else next odd m *)
];

Print["\n"];

(* Final save *)
SaveState[currentM, standardPrimorial, sieveState, failureCount, startTime];

totalTime = AbsoluteTime[] - startTime;

Print[];
Print["================================================================="];
Print["RESULTS (Last 20 primes)"];
Print["================================================================="];
Print[];

Print["m\t\tπ(m)\tDigits\t\tVerified"];
Print[StringRepeat["=", 60]];

Do[
  Module[{m, pi, digits, verified},
    {m, pi, digits, verified} = recentResults[[i]];
    Print[
      m, "\t",
      If[m < 100000, "\t", ""],
      pi, "\t",
      digits, "\t\t",
      If[verified, "✓", "✗ FAIL"]
    ];
  ],
  {i, Length[recentResults]}
];

If[Length[recentResults] == 20,
  Print["... (showing last 20 primes)"];
];

Print[];
Print["================================================================="];
Print["SUMMARY"];
Print["================================================================="];
Print["Total odd m values tested: ", testCount];
Print["  (includes ", PrimePi[currentM] - 1, " primes from 3 to ", currentM, ")"];
Print["Failures: ", failureCount];
Print["Verification time: ", N[totalTime, 4], " seconds"];
Print["Tests per second: ", N[testCount / totalTime, 2]];
Print[];

If[failureCount == 0,
  Print["SUCCESS: Formula verified for EVERY odd m up to ", currentM];
  Print["  This includes ALL ", PrimePi[currentM] - 1, " primes in this range"];
  Print[];
  Print["Largest primorial computed:"];
  Print["  m = ", currentM];
  Print["  π(m) = ", PrimePi[currentM], " primes"];
  Print["  Primorial has ", IntegerLength[standardPrimorial], " digits"];,
  Print["FAILURE: Formula failed at ", failureCount, " value(s)"];
];

Print[];
Print["================================================================="];
Print[];
Print["Usage: wolframscript verify_primorial_exhaustive.wl [maxM]"];
Print["  maxM: Maximum m value to verify (default: 1000000)"];
Print[];
Print["To resume interrupted verification: rerun the same command"];
Print["To restart from scratch: delete ", stateFile];
Print["================================================================="];
