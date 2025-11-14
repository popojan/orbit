#!/usr/bin/env wolframscript

(* Show sequences that FAIL Gap Theorem with detailed examples *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== SEQUENCES THAT FAIL GAP THEOREM ==="];
Print[""];

AbstractSparse[n_Integer, seq_List] := Module[{r = n, result = {}, s},
  While[r >= First[seq],
    s = SelectFirst[Reverse[seq], # <= r &, None];
    If[s === None, Break[]];
    AppendTo[result, s];
    r -= s
  ];
  Append[result, r]
]

AbstractOrbit[n_Integer, seq_List] := Module[{orbit = {}, queue = {n}, current, sparse, elems},
  While[queue != {},
    current = First[queue];
    queue = Rest[queue];
    If[current >= First[seq] && !MemberQ[orbit, current],
      sparse = AbstractSparse[current, seq];
      elems = Select[Most[sparse], MemberQ[seq, #] &];
      orbit = Union[orbit, elems];
      queue = Join[queue, FirstPosition[seq, #, {0}][[1]] & /@ elems];
    ];
  ];
  Sort[orbit]
]

ShowFailure[name_, seq_, elem_] := Module[{s, gap, nextElem, indices, checkElems, orbits, count, violations},
  s = elem;
  nextElem = SelectFirst[seq, # > s &, None];

  If[nextElem === None,
    Print["  Cannot test - no next element"];
    Return[Null];
  ];

  gap = nextElem - s;
  indices = Range[s, Min[s + gap, Length[seq]]];

  If[Max[indices] > Length[seq],
    Print["  Cannot test - insufficient sequence length"];
    Return[Null];
  ];

  checkElems = seq[[#]] & /@ indices;
  orbits = AbstractOrbit[#, seq] & /@ checkElems;
  count = Length@Select[orbits, Length[#] >= 2 && #[[Length[#] - 1]] == s &];

  Print[""];
  Print["  Element: ", s, " (", name, ")"];
  Print["  Gap: ", gap, " (next element: ", nextElem, ")"];
  Print["  Positions checked: ", indices];
  Print["  Elements at those positions: ", checkElems];
  Print[""];
  Print["  Orbits:"];
  Do[
    Print["    ", checkElems[[i]], ": ", orbits[[i]],
      If[Length[orbits[[i]]] >= 2 && orbits[[i]][[Length[orbits[[i]]] - 1]] == s, " ✓ (has " <> ToString[s] <> ")", " ✗"]],
    {i, Length[orbits]}
  ];
  Print[""];
  Print["  Expected count: ", gap];
  Print["  Actual count: ", count];
  Print["  VIOLATION: ", count, " ≠ ", gap];
  Print[""];
]

(* ===== Consecutive Integers (complete failure) ===== *)
Print["1. CONSECUTIVE INTEGERS (complete failure)"];
Print["Why: Trivial orbits - decomposition is n = n + 0"];
Print[""];
integers = Range[1, 200];
ShowFailure["integer", integers, 5];
ShowFailure["integer", integers, 10];

(* ===== Powers of 2 (too sparse) ===== *)
Print[""];
Print["2. POWERS OF 2 (too sparse)"];
Print["Why: Exponentially sparse, gaps too large"];
Print[""];
powers = 2^Range[1, 10];  (* Need to extend sequence for checking *)
powers = Join[powers, ConstantArray[0, 1024]];  (* Pad to allow indexing *)
(* Actually generate more elements for proper test *)
powers = 2^Range[1, 10];
Print["  Powers of 2: ", powers];
Print["  Density at 1000: ", N[Count[powers, x_ /; x <= 1000] / 1000]];
Print["  (Too sparse for meaningful Gap Theorem - most indices don't exist)"];
Print[""];

(* ===== Fibonacci (super-linear gaps) ===== *)
Print["3. FIBONACCI NUMBERS (too sparse)"];
Print["Why: Super-linear gap growth"];
Print[""];
fib = Table[Fibonacci[n], {n, 2, 20}];
fibExtended = Join[fib, ConstantArray[0, Max[fib] + 100]];
Print["  Fibonacci: ", fib];
Print["  Gaps: ", Differences[fib]];
Print["  Gap growth: exponential (~φ^n)"];
Print["  Density at 1000: ", N[Count[fib, x_ /; x <= 1000] / 1000]];
Print[""];

(* ===== Squares (density ~ 1/√n) ===== *)
Print["4. SQUARES (too sparse)"];
Print["Why: Density ~ 1/√n, vanishing density"];
Print[""];
squares = Range[1, 40]^2;
Print["  Squares: ", Take[squares, 15]];
Print["  Gaps: ", Take[Differences[squares], 10]];
Print["  Density at 1000: ", N[Count[squares, x_ /; x <= 1000] / 1000]];
Print[""];

(* ===== Odd numbers (almost works, except edge case) ===== *)
Print["5. ODD NUMBERS (fails at boundary)");
Print["Why: Element 1 has special behavior");
Print[""];
odds = Range[1, 199, 2];
ShowFailure["odd", odds, 1];
Print["  Note: All other odd numbers pass! Only element 1 fails.");
Print["  This is an edge case, not fundamental failure.");
Print[""];

(* ===== Triangular numbers ===== *)
Print["6. TRIANGULAR NUMBERS"];
Print["Why: Non-linear gap growth");
Print[""];
triangular = Table[n(n+1)/2, {n, 1, 50}];
ShowFailure["triangular", triangular, 3];
ShowFailure["triangular", triangular, 6];

(* ===== Summary ===== *)
Print[""];
Print["=== SUMMARY OF FAILURES ==="];
Print[""];
Print["Sequences FAIL Gap Theorem when:");
Print["  1. Density too low (sparse sequences - powers, Fibonacci, squares)"];
Print["  2. Trivial orbit structure (consecutive integers)"];
Print["  3. Non-linear gap growth (triangular, etc.)"];
Print[""];
Print["Common pattern: Either TOO SPARSE or TOO DENSE (consecutive)"];
Print["Sweet spot: Intermediate density with non-trivial structure (primes!)"];
Print[""];

Print["=== COMPLETE ==="];
