#!/usr/bin/env wolframscript
(* Complete exhaustive primorial verification - EVERY m >= 3 *)

(* Parse command line arguments *)
args = Rest[$ScriptCommandLine];
maxM = If[Length[args] >= 1, ToExpression[args[[1]]], 100000];

Print["================================================================="]
Print["COMPLETE EXHAUSTIVE PRIMORIAL VERIFICATION"]
Print["================================================================="]
Print[]
Print["Verifying formula at EVERY m from 3 to ", maxM, " (m=2 is a special case)"]
Print[]

(* Recurrence step *)
RecurseState[{n_, a_, b_}] := {n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))};

(* Extract primorial from sieve state *)
PrimorialFromState[{n_, a_, b_}] := 2 * Denominator[-1 + b];

(* Main verification loop *)
startTime = AbsoluteTime[];
sieveState = {0, 0, 1};
standardPrimorial = 2;
failureCount = 0;
testCount = 0;
lastPrintTime = startTime;

(* Progress display *)
totalTests = maxM - 3 + 1;

Print["Starting verification of ", totalTests, " values (every m from 3 to ", maxM, ")..."]
Print[]

Do[
  Module[{sievePrimorial, verified, currentTime, elapsed, rate, eta, pct},
    (* Advance sieve state (only for odd m) *)
    If[OddQ[m], sieveState = RecurseState[sieveState]];

    (* Update standard primorial *)
    standardPrimorial *= If[PrimeQ[m], m, 1];

    (* Extract and verify *)
    sievePrimorial = PrimorialFromState[sieveState];
    verified = (sievePrimorial == standardPrimorial);

    If[!verified,
      failureCount++;
      Print["\n*** FAILURE at m=", m, " ***"];
      Print["  Sieve:    ", sievePrimorial];
      Print["  Standard: ", standardPrimorial];
      Print[]
    ];

    testCount++;

    (* Progress update every 2 seconds *)
    currentTime = AbsoluteTime[];
    If[currentTime - lastPrintTime > 2,
      elapsed = currentTime - startTime;
      rate = testCount / elapsed;
      eta = (totalTests - testCount) / rate;
      pct = N[100.0 * testCount / totalTests];

      WriteString["stdout", "\r",
        "Progress: ", IntegerPart[pct], "% (",
        testCount, "/", totalTests, ") | ",
        "m=", m, " | ",
        IntegerPart[rate], " tests/sec | ",
        "ETA: ", IntegerPart[eta/60], "m", IntegerPart[Mod[eta, 60]], "s   "
      ];

      lastPrintTime = currentTime
    ]
  ],
  {m, 3, maxM, 1}
];

Print["\n"]

totalTime = AbsoluteTime[] - startTime;

(* Final results *)
Print[]
Print["================================================================="]
Print["VERIFICATION COMPLETE"]
Print["================================================================="]
Print[]
Print["Total m values tested: ", testCount, " (every m from 3 to ", maxM, ")"]
Print["  (includes all ", PrimePi[maxM] - 1, " primes >= 3)"]
Print["Failures: ", failureCount]
Print["Verification time: ", N[totalTime, 4], " seconds"]
Print["Average rate: ", N[testCount / totalTime, 2], " tests/second"]
Print[]

If[failureCount == 0,
  Print["SUCCESS: Formula verified for EVERY m from 3 to ", maxM];
  Print[];
  Print["Final primorial (m=", maxM, ")"];
  Print["  π(", maxM, ") = ", PrimePi[maxM], " primes"];
  Print["  Primorial has ", IntegerLength[standardPrimorial], " digits"],
  Print["FAILURE: Formula failed at ", failureCount, " value(s)"]
]

Print[]
Print["================================================================="]
Print[]
Print["Usage: wolframscript verify_primorial_complete.wl [maxM]"]
Print["  maxM: Maximum m value (default: 100000)"]
Print[]
Print["This script verifies the formula at EVERY m value (both odd and even)"]
Print["For large maxM, this may take considerable time"]
Print["================================================================="]
