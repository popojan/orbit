#!/usr/bin/env wolframscript

(* Rigorous verification for non-constant density sequences *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== VERIFYING NON-CONSTANT DENSITY SEQUENCES ==="];
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

(* Detailed verification with examples *)
VerifyWithExamples[name_, seq_, testElement_] := Module[{s, gap, nextElem, indices, checkElems, orbits, count},
  s = testElement;
  nextElem = SelectFirst[seq, # > s &, None];

  If[nextElem === None,
    Print["  Cannot test element ", s, " - no next element"];
    Return[Null];
  ];

  gap = nextElem - s;
  indices = Range[s, s + gap];

  If[Max[indices] > Length[seq],
    Print["  Cannot test element ", s, " - insufficient sequence length"];
    Return[Null];
  ];

  checkElems = seq[[#]] & /@ indices;

  Print["  Testing ", name, " element: ", s];
  Print["    Gap: ", gap];
  Print["    Next element: ", nextElem];
  Print["    Checking positions: ", indices];
  Print["    Elements at positions: ", checkElems];

  orbits = AbstractOrbit[#, seq] & /@ checkElems;
  Print["    Orbits:"];
  Do[Print["      ", checkElems[[i]], ": ", orbits[[i]]], {i, Length[orbits]}];

  count = Length@Select[orbits, Length[#] >= 2 && #[[Length[#] - 1]] == s &];
  Print["    Count with ", s, " as second-to-last: ", count];
  Print["    Gap theorem: ", count, " == ", gap, " ? ", count == gap];

  count == gap
]

(* Generate sequences *)
Print["Generating sequences..."];
semiprimes = Select[Range[4, 1000], PrimeOmega[#] == 2 &];
almostPrimes3 = Select[Range[8, 1000], PrimeOmega[#] == 3 &];
primes = Select[Range[2, 1000], PrimeQ];

Print["  Semiprimes: ", Length[semiprimes], " elements, density ~ ", N[Length[semiprimes]/1000]];
Print["  3-almost primes: ", Length[almostPrimes3], " elements, density ~ ", N[Length[almostPrimes3]/1000]];
Print["  Primes: ", Length[primes], " elements, density ~ ", N[Length[primes]/1000]];
Print[""];

(* Test specific examples *)
Print["=== DETAILED VERIFICATION ==="];
Print[""];

Print["Semiprimes (Ω(n) = 2):"];
VerifyWithExamples["semiprime", semiprimes, 6];
Print[""];
VerifyWithExamples["semiprime", semiprimes, 10];
Print[""];

Print["3-almost primes (Ω(n) = 3):"];
VerifyWithExamples["3-almost", almostPrimes3, 12];
Print[""];
VerifyWithExamples["3-almost", almostPrimes3, 20];
Print[""];

Print["Primes (sanity check):"];
VerifyWithExamples["prime", primes, 7];
Print[""];

(* Compute densities to verify non-constant *)
Print["=== DENSITY ANALYSIS ==="];
Print[""];

AnalyzeDensity[name_, seq_, points_] := Module[{densities},
  densities = Table[
    {n, N[Count[seq, x_ /; x <= n] / n]},
    {n, points}
  ];
  Print[name, " density at checkpoints:"];
  Do[Print["  n=", d[[1]], ": ", d[[2]]], {d, densities}];
  Print[""];
]

checkpoints = {50, 100, 200, 500, 1000};
AnalyzeDensity["Semiprimes", semiprimes, checkpoints];
AnalyzeDensity["3-almost primes", almostPrimes3, checkpoints];
AnalyzeDensity["Primes", primes, checkpoints];
AnalyzeDensity["Even numbers", Range[2, 1000, 2], checkpoints];

Print["=== STRUCTURAL ANALYSIS ==="];
Print[""];

(* Check if there's algebraic structure in predecessor operation *)
Print["Predecessor structure (first 10 elements):"];
Print[""];

AnalyzePredecessors[name_, seq_] := Module[{preds},
  preds = Table[
    Module[{idx, sparse, pred},
      idx = FirstPosition[seq, s, {0}][[1]];
      If[idx == 0, s -> None,
        sparse = AbstractSparse[idx, seq];
        pred = SelectFirst[Most[sparse], MemberQ[seq, #] &, None];
        s -> pred
      ]
    ],
    {s, Take[seq, UpTo[10]]}
  ];
  Print[name, ":"];
  Do[Print["  ", p], {p, preds}];
  Print[""];
]

AnalyzePredecessors["Semiprimes", semiprimes];
AnalyzePredecessors["3-almost primes", almostPrimes3];
AnalyzePredecessors["Primes", primes];

Print["=== COMPLETE ==="];
