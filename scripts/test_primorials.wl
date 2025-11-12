#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Test script for primorial functions *)

Print["Loading Orbit paclet..."];
PacletDirectoryLoad[FileNameJoin[{DirectoryName[$InputFileName], "..", "Orbit"}]];
Needs["Orbit`"];

Print["Testing primorial functions\n"];

(* Test basic functionality *)
Print["=== Basic Tests ==="];
testValues = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31};

Print["Testing PrimorialRaw formula:"];
Do[
  Module[{m = val, raw, denom, standard},
    raw = PrimorialRaw[m];
    standard = Times @@ Prime @ Range @ PrimePi[m];
    Print["  m = ", m, ": PrimePi[m] = ", PrimePi[m]];
    Print["    Raw formula = ", N[raw, 5]];
    Print["    Denominator = ", Denominator[raw]];
    Print["    Standard primorial = ", standard];
    Print["    Match: ", Denominator[raw] == standard];
  ],
  {val, testValues}
];

Print["\n=== Method Comparison ==="];
Print["Comparing all methods for m = 2 to 50:\n"];

(* Test all methods *)
methods = {"Primorial0", "Sieve"};
allMatch = True;

Do[
  Module[{m = val, standard, results},
    standard = Times @@ Prime @ Range @ PrimePi[m];
    results = Association[
      "Primorial0" -> Primorial0[m],
      "Sieve" -> PrimorialFromState[SieveState[m]]
    ];
    If[!AllTrue[Values[results], # == standard &],
      Print["FAILURE at m = ", m, ": ", results];
      allMatch = False;
    ]
  ],
  {val, 2, 50}
];

If[allMatch,
  Print["SUCCESS: All methods match standard primorial for m = 2 to 50"],
  Print["FAILURE: Some methods produced incorrect results"]
];

Print["\n=== Batch Verification ==="];
batchResult = BatchVerifyPrimorial[100, "Primorial0"];
Print["Tested m = 2 to 100"];
Print["All match: ", batchResult["All match"]];
If[Length[batchResult["Failures"]] > 0,
  Print["Failures: ", batchResult["Failures"]],
  Print["No failures detected"]
];

Print["\n=== Detailed Example ==="];
exampleM = 23;
Print["Detailed comparison for m = ", exampleM, ":\n"];
comparison = CompareAllMethods[exampleM];
Print["Standard primorial: ", comparison["Standard primorial"]];
Print["PrimePi[m]: ", comparison["PrimePi[m]"]];
Print["All methods match: ", comparison["All methods match"]];
Print["\nMethod details:"];
Do[
  Module[{method = meth, result},
    result = comparison["Method results", method];
    Print["  ", method, ": ", result["Computed"], " (Match: ", result["Match"], ")"];
  ],
  {meth, methods}
];

Print["\n=== Performance Test ==="];
Print["Computing primorial for larger values:"];
Do[
  Module[{m = val, timing, result},
    {timing, result} = AbsoluteTiming[Primorial0[m]];
    Print["  m = ", m, " (PrimePi = ", PrimePi[m], "): ",
      Round[timing, 0.001], " seconds, result has ",
      IntegerLength[result], " digits"];
  ],
  {val, {100, 500, 1000, 5000}}
];

Print["\n=== Test Complete ==="];
