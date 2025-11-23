#!/usr/bin/env wolframscript
(* Test whether Egypt converges monotonically or alternates *)

<< Orbit`

Print["=== TESTING EGYPT CONVERGENCE PATTERN ===\n"];

(* Test sqrt(13) *)
nn = 13;
sol = PellSolution[13];
xval = x /. sol;
yval = y /. sol;

Print["Testing sqrt(13) with Pell solution: x=", xval, ", y=", yval, "\n"];

Print["=== Egypt Intervals for k=1 to 10 ===\n"];
Print["k\tLower bound\t\tUpper bound\t\tMidpoint\t\tError"];
Print["---------------------------------------------------------------------------------"];

intervals = Table[EgyptSqrt[nn, {xval, yval}, k], {k, 1, 10}];

Do[
  int = intervals[[k]];
  bounds = List @@ int;
  lower = bounds[[1]];
  upper = bounds[[2]];
  mid = Mean[bounds];
  err = Abs[mid - Sqrt[nn]];

  Print[k, "\t", N[lower, 12], "\t", N[upper, 12], "\t", N[mid, 12], "\t", N[err, 8]];
, {k, 1, 10}];

Print["\n=== TESTING MONOTONICITY ===\n"];

(* Extract lower and upper bounds *)
lowers = Table[Min[List @@ intervals[[k]]], {k, 1, 10}];
uppers = Table[Max[List @@ intervals[[k]]], {k, 1, 10}];

Print["Lower bounds:"];
Do[Print["  k=", k, ": ", N[lowers[[k]], 15]], {k, 1, 10}];

Print["\nUpper bounds:"];
Do[Print["  k=", k, ": ", N[uppers[[k]], 15]], {k, 1, 10}];

Print["\n--- Checking monotonicity of lower bounds ---"];
lowerMonotone = True;
Do[
  If[lowers[[k+1]] < lowers[[k]],
    Print["NOT monotone: k=", k, " -> ", k+1, ": ", N[lowers[[k]], 10], " -> ", N[lowers[[k+1]], 10]];
    lowerMonotone = False;
  ];
, {k, 1, 9}];
If[lowerMonotone, Print["Lower bounds are MONOTONICALLY INCREASING ✓"]];

Print["\n--- Checking monotonicity of upper bounds ---"];
upperMonotone = True;
Do[
  If[uppers[[k+1]] > uppers[[k]],
    Print["NOT monotone: k=", k, " -> ", k+1, ": ", N[uppers[[k]], 10], " -> ", N[uppers[[k+1]], 10]];
    upperMonotone = False;
  ];
, {k, 1, 9}];
If[upperMonotone, Print["Upper bounds are MONOTONICALLY DECREASING ✓"]];

Print["\n=== COMPARING WITH CONTINUED FRACTION ===\n"];

(* Get CF convergents *)
cf = ContinuedFraction[Sqrt[nn], 10];
Print["CF for sqrt(13): ", cf];

convergents = Convergents[cf, 10];
Print["\nCF convergents (k=1 to 10):"];
Do[
  conv = N[convergents[[k]], 15];
  err = Abs[conv - Sqrt[nn]];
  Print["  k=", k, ": ", conv, " (error: ", N[err, 8], ")"];
, {k, 1, Min[10, Length[convergents]]}];

Print["\n--- CF alternation test ---"];
cfValues = N[convergents, 20];
cfAlternates = True;
Do[
  If[k >= 2,
    diff_k = cfValues[[k]] - Sqrt[nn];
    diff_km1 = cfValues[[k-1]] - Sqrt[nn];
    If[Sign[diff_k] == Sign[diff_km1],
      Print["CF does NOT alternate at k=", k-1, " -> ", k];
      cfAlternates = False;
    ];
  ];
, {k, 2, Min[10, Length[cfValues]]}];
If[cfAlternates, Print["CF convergents ALTERNATE around sqrt ✓"]];

Print["\n=== CONCLUSION ===\n"];

Print["Egypt method:"];
If[lowerMonotone && upperMonotone,
  Print["  ✓ MONOTONIC - bounds squeeze from both sides"],
  Print["  ✗ NOT monotonic"]
];

Print["\nContinued Fraction:"];
If[cfAlternates,
  Print["  ✓ ALTERNATING - convergents oscillate around sqrt"],
  Print["  ✗ NOT alternating"]
];

Print["\n==> This is the KEY DIFFERENCE between Egypt and CF methods!"];
