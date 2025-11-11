#!/usr/bin/env wolframscript
(* -*- mode: mathematica -*- *)

(* Adversarial testing: Perturb prime sequence and check if GT breaks *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];

Print["=== ADVERSARIAL GAP THEOREM TESTING =="];
Print["=== Perturbations of Prime Sequence =="];
Print[""];

(* Abstract implementation *)
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

VerifyAbstractGapTheorem[seq_List, maxTest_] := Module[{results, tested = 0},
  results = Table[
    Module[{gap, nextElem, indices, checkElements, orbits, count},
      tested++;

      nextElem = SelectFirst[seq, # > s &, None];
      If[nextElem === None || s > maxTest,
        Nothing,
        gap = nextElem - s;
        indices = Range[s, s + gap];
        If[Max[indices] > Length[seq],
          Nothing,
          checkElements = seq[[#]] & /@ indices;
          orbits = AbstractOrbit[#, seq] & /@ checkElements;
          count = Length@Select[orbits, Length[#] >= 2 && #[[Length[#] - 1]] == s &];
          {s, gap, count, gap == count}
        ]
      ]
    ],
    {s, Select[seq, # <= maxTest &]}
  ];
  DeleteCases[results, Nothing]
]

(* Generate base primes *)
nmax = 1000;
testUpTo = 200;
primes = Select[Range[2, nmax], PrimeQ];

Print["Base configuration:"];
Print["  Primes up to: ", nmax];
Print["  Number of primes: ", Length[primes]];
Print["  Test elements with value ≤ ", testUpTo];
Print[""];

(* Sanity check: Unperturbed primes *)
Print["=== BASELINE: UNPERTURBED PRIMES ==="];
Print[""];
resultsBaseline = VerifyAbstractGapTheorem[primes, testUpTo];
violationsBaseline = Select[resultsBaseline, !Last[#] &];
Print["Tested: ", Length[resultsBaseline]];
Print["Violations: ", Length[violationsBaseline]];
If[Length[violationsBaseline] > 0,
  Print["WARNING: Baseline has violations! First 3:"];
  Do[Print["  ", v], {v, Take[violationsBaseline, UpTo[3]]}];
];
Print[""];

(* Perturbation strategies *)
Print["=== PERTURBATION STRATEGIES ==="];
Print[""];

(* Strategy 1: Shift one prime by ±2 *)
TestShiftPrime[primes_, k_, delta_, testUpTo_] := Module[{perturbed, original, changed, results, violations},
  original = primes[[k]];
  changed = original + delta;
  perturbed = ReplacePart[primes, k -> changed];

  Print["Shift: p_", k, " = ", original, " → ", changed, " (", If[delta > 0, "+", ""], delta, ")"];
  Print["  Changed prime is ", If[PrimeQ[changed], "PRIME", "COMPOSITE"]];

  results = VerifyAbstractGapTheorem[perturbed, testUpTo];
  violations = Select[results, !Last[#] &];

  Print["  Tested: ", Length[results]];
  Print["  Violations: ", Length[violations]];

  If[Length[violations] > 0,
    Print["  ✗ BREAKS Gap Theorem"];
    Print["  First violations:"];
    Do[Print["    s=", v[[1]], ", gap=", v[[2]], ", count=", v[[3]]],
      {v, Take[violations, UpTo[3]]}];
  ,
    Print["  ✓ Still satisfies Gap Theorem"];
  ];
  Print[""];

  <|
    "Type" -> "Shift",
    "Index" -> k,
    "Original" -> original,
    "Changed" -> changed,
    "Delta" -> delta,
    "IsChangedPrime?" -> PrimeQ[changed],
    "Tested" -> Length[results],
    "Violations" -> Length[violations],
    "Breaks?" -> Length[violations] > 0
  |>
]

(* Strategy 2: Remove one prime *)
TestRemovePrime[primes_, k_, testUpTo_] := Module[{perturbed, removed, results, violations},
  removed = primes[[k]];
  perturbed = Delete[primes, k];

  Print["Remove: p_", k, " = ", removed];

  results = VerifyAbstractGapTheorem[perturbed, testUpTo];
  violations = Select[results, !Last[#] &];

  Print["  Tested: ", Length[results]];
  Print["  Violations: ", Length[violations]];

  If[Length[violations] > 0,
    Print["  ✗ BREAKS Gap Theorem"];
    Print["  First violations:"];
    Do[Print["    s=", v[[1]], ", gap=", v[[2]], ", count=", v[[3]]],
      {v, Take[violations, UpTo[3]]}];
  ,
    Print["  ✓ Still satisfies Gap Theorem"];
  ];
  Print[""];

  <|
    "Type" -> "Remove",
    "Index" -> k,
    "Removed" -> removed,
    "Tested" -> Length[results],
    "Violations" -> Length[violations],
    "Breaks?" -> Length[violations] > 0
  |>
]

(* Strategy 3: Insert composite between primes *)
TestInsertComposite[primes_, k_, testUpTo_] := Module[{perturbed, before, after, inserted, results, violations},
  before = primes[[k]];
  after = primes[[k+1]];
  inserted = Floor[(before + after)/2];

  (* Ensure composite *)
  If[PrimeQ[inserted], inserted = inserted + 1];
  If[inserted >= after, inserted = before + 1];
  While[PrimeQ[inserted] && inserted < after, inserted++];

  If[inserted >= after,
    Print["Skip: Cannot insert composite between p_", k, "=", before, " and p_", k+1, "=", after];
    Print[""];
    Return[<|"Type" -> "Insert", "Skipped" -> True|>];
  ];

  perturbed = Insert[primes, inserted, k+1];

  Print["Insert: ", inserted, " between p_", k, "=", before, " and p_", k+1, "=", after];
  Print["  Inserted value is ", If[PrimeQ[inserted], "PRIME (unexpected)", "COMPOSITE"]];

  results = VerifyAbstractGapTheorem[perturbed, testUpTo];
  violations = Select[results, !Last[#] &];

  Print["  Tested: ", Length[results]];
  Print["  Violations: ", Length[violations]];

  If[Length[violations] > 0,
    Print["  ✗ BREAKS Gap Theorem"];
    Print["  First violations:"];
    Do[Print["    s=", v[[1]], ", gap=", v[[2]], ", count=", v[[3]]],
      {v, Take[violations, UpTo[3]]}];
  ,
    Print["  ✓ Still satisfies Gap Theorem"];
  ];
  Print[""];

  <|
    "Type" -> "Insert",
    "Index" -> k,
    "Before" -> before,
    "After" -> after,
    "Inserted" -> inserted,
    "IsInsertedPrime?" -> PrimeQ[inserted],
    "Tested" -> Length[results],
    "Violations" -> Length[violations],
    "Breaks?" -> Length[violations] > 0
  |>
]

(* Run tests on selected primes *)
Print["=== SHIFT TESTS ==="];
Print[""];

testIndices = {5, 10, 15, 20, 25};  (* Test a few primes *)

resultsShiftPlus2 = Table[TestShiftPrime[primes, k, +2, testUpTo], {k, testIndices}];
resultsShiftMinus2 = Table[TestShiftPrime[primes, k, -2, testUpTo], {k, testIndices}];

Print["=== REMOVE TESTS ==="];
Print[""];

resultsRemove = Table[TestRemovePrime[primes, k, testUpTo], {k, testIndices}];

Print["=== INSERT TESTS ==="];
Print[""];

resultsInsert = Table[TestInsertComposite[primes, k, testUpTo], {k, testIndices}];

(* Summary *)
Print["=== SUMMARY ==="];
Print[""];

allResults = Join[resultsShiftPlus2, resultsShiftMinus2, resultsRemove,
  DeleteCases[resultsInsert, <|"Type" -> "Insert", "Skipped" -> True|>]];

Print["Total perturbations tested: ", Length[allResults]];
Print["Perturbations that BREAK GT: ", Count[allResults, r_ /; r["Breaks?"]]];
Print["Perturbations that PRESERVE GT: ", Count[allResults, r_ /; !r["Breaks?"]]];
Print[""];

breakages = Select[allResults, #["Breaks?"] &];
If[Length[breakages] > 0,
  Print["Breakdown by type:"];
  Print["  Shift+2 breaks: ", Count[resultsShiftPlus2, r_ /; r["Breaks?"]], "/", Length[resultsShiftPlus2]];
  Print["  Shift-2 breaks: ", Count[resultsShiftMinus2, r_ /; r["Breaks?"]], "/", Length[resultsShiftMinus2]];
  Print["  Remove breaks: ", Count[resultsRemove, r_ /; r["Breaks?"]], "/", Length[resultsRemove]];
  Print["  Insert breaks: ", Count[resultsInsert, r_ /; If[KeyExistsQ[r, "Breaks?"], r["Breaks?"], False]],
    "/", Count[resultsInsert, r_ /; KeyExistsQ[r, "Breaks?"]]];
,
  Print["✓ ALL perturbations preserve Gap Theorem (ROBUST!)"];
];

(* Export results *)
Export["reports/perturbed_primes_test.json", allResults];
Print[""];
Print["Exported to reports/perturbed_primes_test.json"];

Print[""];
Print["=== COMPLETE ==="];
