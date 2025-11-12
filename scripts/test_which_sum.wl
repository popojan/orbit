#!/usr/bin/env wolframscript
(* ::Package:: *)

(* Test: Does recursive formula compute alternating or non-alternating sum? *)

Print["=== TESTING: WHICH SUM DOES RECURSIVE COMPUTE? ===\n"];

RecurseState[{n_, a_, b_}] := {
  n + 1, b, b + (a - b)*(n + 1/(3 + 2*n))
};

InitialState = {0, 0, 1};
IterateState[h_] := Nest[RecurseState, InitialState, h];

(* Test for several h values *)
TestWhichSum[h_] := Module[{
    state, recursiveB,
    alternatingSum, nonAlternatingSum,
    matchAlt, matchNonAlt
  },

  Print["h = ", h];

  (* Compute recursive b[h] *)
  state = IterateState[h];
  recursiveB = state[[3]];

  (* Compute alternating sum *)
  alternatingSum = Sum[(-1)^k * (k!)/(2*k + 1), {k, 1, h}];

  (* Compute non-alternating sum *)
  nonAlternatingSum = Sum[(k!)/(2*k + 1), {k, 1, h}];

  (* Check matches *)
  matchAlt = FullSimplify[recursiveB - 1 - alternatingSum] == 0;
  matchNonAlt = FullSimplify[recursiveB - 1 - nonAlternatingSum] == 0;

  Print["  Recursive b[h]:        ", recursiveB];
  Print["  b[h] - 1:              ", recursiveB - 1];
  Print[""];
  Print["  Alternating sum:       ", alternatingSum];
  Print["  Match with ALTERNATING: ", If[matchAlt, "✓ YES", "✗ NO"]];
  Print[""];
  Print["  Non-alternating sum:   ", nonAlternatingSum];
  Print["  Match with NON-ALT:     ", If[matchNonAlt, "✓ YES", "✗ NO"]];
  Print[""];

  (* Check denominators *)
  Print["  Denominator of b[h]-1:              ", Denominator[recursiveB - 1]];
  Print["  Denominator of alternating sum:     ", Denominator[alternatingSum]];
  Print["  Denominator of non-alternating sum: ", Denominator[nonAlternatingSum]];
  Print[""];

  {matchAlt, matchNonAlt}
];

(* Test for h = 1 through 6 *)
results = Table[TestWhichSum[h], {h, 1, 6}];

Print["=== SUMMARY ===\n"];

If[AllTrue[results, First],
  Print["*** RECURSIVE COMPUTES THE ALTERNATING SUM ***"],
  Print["Alternating sum doesn't always match"]
];

If[AllTrue[results, Last],
  Print["*** RECURSIVE COMPUTES THE NON-ALTERNATING SUM ***"],
  Print["Non-alternating sum doesn't always match"]
];

Print[""];
Print["=== ANALYSIS COMPLETE ==="];
