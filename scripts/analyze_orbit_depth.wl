#!/usr/bin/env wolframscript

(* Analyze orbit depth - are k-almost prime orbits trivial? *)

SetDirectory[ParentDirectory[DirectoryName[$InputFileName]]];
PacletDirectoryLoad["Orbit"];
Needs["Orbit`"];

Print["=== ORBIT DEPTH ANALYSIS ==="];
Print[""];
Print["Checking if k-almost prime orbits are trivial/shallow"];
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

(* Generate sequences *)
semiprimes = Select[Range[4, 500], PrimeOmega[#] == 2 &];
almostPrimes3 = Select[Range[8, 500], PrimeOmega[#] == 3 &];
primes = Select[Range[2, 500], PrimeQ];

(* Compute orbit length distribution *)
AnalyzeOrbitLengths[name_, seq_] := Module[{sample, orbits, lengths, stats},
  sample = Take[seq, UpTo[50]];
  orbits = AbstractOrbit[#, seq] & /@ sample;
  lengths = Length /@ orbits;
  stats = <|
    "Mean" -> N[Mean[lengths]],
    "Max" -> Max[lengths],
    "Min" -> Min[lengths],
    "Distribution" -> Tally[lengths]
  |>;

  Print[name, " orbit lengths (first 50 elements):"];
  Print["  Mean: ", stats["Mean"]];
  Print["  Max: ", stats["Max"]];
  Print["  Min: ", stats["Min"]];
  Print["  Distribution: ", stats["Distribution"]];
  Print[""];

  stats
]

statsPrimes = AnalyzeOrbitLengths["Primes", primes];
statsSemi = AnalyzeOrbitLengths["Semiprimes", semiprimes];
statsAlmost3 = AnalyzeOrbitLengths["3-almost primes", almostPrimes3];

(* Check specific orbits *)
Print["=== SPECIFIC ORBIT EXAMPLES ==="];
Print[""];

ShowOrbit[name_, seq_, elem_] := Module[{orbit},
  orbit = AbstractOrbit[elem, seq];
  Print[name, " orbit of ", elem, ": ", orbit, " (length ", Length[orbit], ")"];
]

ShowOrbit["Prime", primes, 17];
ShowOrbit["Prime", primes, 47];
ShowOrbit["Prime", primes, 97];
Print[""];

ShowOrbit["Semiprime", semiprimes, 15];
ShowOrbit["Semiprime", semiprimes, 51];
ShowOrbit["Semiprime", semiprimes, 95];
Print[""];

ShowOrbit["3-almost", almostPrimes3, 24];
ShowOrbit["3-almost", almostPrimes3, 60];
ShowOrbit["3-almost", almostPrimes3, 100];
Print[""];

(* Key insight check: Are orbits in k-almost primes mostly length 2? *)
Print["=== CRITICAL QUESTION ==="];
Print[""];
Print["For semiprimes: ", Count[Length /@ (AbstractOrbit[#, semiprimes] & /@ Take[semiprimes, 50]), 2], "/50 have orbit length exactly 2"];
Print["For 3-almost: ", Count[Length /@ (AbstractOrbit[#, almostPrimes3] & /@ Take[almostPrimes3, 50]), 2], "/50 have orbit length exactly 2"];
Print["For primes: ", Count[Length /@ (AbstractOrbit[#, primes] & /@ Take[primes, 50]), 2], "/50 have orbit length exactly 2"];
Print[""];

Print["If k-almost primes have mostly length-2 orbits {s, elem},"];
Print["then the Gap Theorem becomes TRIVIAL - just combinatorics,"];
Print["not genuine structure like primes have!"];
Print[""];

Print["=== COMPLETE ==="];
