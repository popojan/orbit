(* ::Package:: *)

BeginPackage["Orbit`"];

(* Usage messages *)
PrimeRepSparse::usage = "PrimeRepSparse[n] returns the greedy prime decomposition of integer n.";
PrimeOrbit::usage = "PrimeOrbit[n] returns all primes in the recursive decomposition of n.";
DirectPrimeDag::usage = "DirectPrimeDag[pmax] builds the prime DAG for primes up to pmax with direct edges only.";
AnalyzeGapOrbits::usage = "AnalyzeGapOrbits[p] analyzes orbit length distribution for gap-children after prime p.";
VerifyGapTheorem::usage = "VerifyGapTheorem[pmax] verifies the Gap Theorem for all primes up to pmax.";
ComputeInDegrees::usage = "ComputeInDegrees[pmax] computes in-degrees for all primes in DAG up to pmax.";
FindHubs::usage = "FindHubs[pmax, minDegree] finds primes with in-degree >= minDegree.";
PlotOrbitLengths::usage = "PlotOrbitLengths[p] plots orbit lengths for gap-children after prime p.";
PosetStatistics::usage = "PosetStatistics[p] computes partial order statistics for gap-children after prime p.";
AnalyzeJumps::usage = "AnalyzeJumps[p] analyzes jump points in orbit length for gap-children after prime p.";

Begin["`Private`"];

(* Core function: Greedy prime decomposition *)
PrimeRepSparse[n_Integer] := Module[{r = n, primes = {}, p},
  While[r >= 2,
    p = Prime[PrimePi[r]];
    AppendTo[primes, p];
    r -= p
  ];
  Append[primes, r]
];

(* Prime orbit - all primes in recursive decomposition *)
PrimeOrbit[n_Integer] := Module[{orbit = {}, queue = {n}, current, rep, primes},
  While[queue != {},
    current = First[queue];
    queue = Rest[queue];
    If[current > 1 && !MemberQ[orbit, current],
      rep = PrimeRepSparse[current];
      primes = Select[Most[rep], # > 1 &];
      orbit = Union[orbit, Select[primes, PrimeQ]];
      queue = Join[queue, PrimePi /@ Select[primes, PrimeQ]];
    ];
  ];
  Sort[orbit]
];

(* Build prime DAG with immediate predecessor edges only *)
DirectPrimeDag[pmax_Integer] := Module[{primes, edges},
  primes = Select[Range[2, pmax], PrimeQ];
  edges = Flatten[Table[
    Module[{sparse, immediatePred},
      sparse = PrimeRepSparse[PrimePi[p]];
      immediatePred = SelectFirst[sparse, PrimeQ, None];
      If[immediatePred =!= None, {p -> immediatePred}, {}]
    ],
    {p, primes}
  ]];
  Graph[DeleteDuplicates[edges], VertexLabels -> "Name",
    GraphLayout -> "LayeredDigraphEmbedding"]
];

(* Verify gap theorem for range of primes *)
VerifyGapTheorem[pmax_Integer] := Module[{primes, results},
  primes = Select[Range[2, pmax], PrimeQ];
  results = Table[
    Module[{gap, count},
      gap = NextPrime[prime] - prime;
      count = Length@Select[PrimeOrbit /@ Prime @ Range[prime, prime + gap],
        Length[#] >= 2 && #[[Length[#] - 1]] == prime &];
      {prime, gap, count, gap == count}
    ],
    {prime, primes}
  ];
  Select[results, !Last[#] &] (* Return violations if any *)
];

(* Analyze orbit lengths for a gap prime *)
AnalyzeGapOrbits[p_Integer] := Module[{gap, idx, lengths, data},
  gap = NextPrime[p] - p;
  idx = PrimePi[p];
  lengths = Table[Length[PrimeOrbit[Prime[idx + k]]], {k, 0, gap - 1}];
  data = {
    "Gap" -> gap,
    "Min length" -> Min[lengths],
    "Max length" -> Max[lengths],
    "Mean length" -> N[Mean[lengths]],
    "Std dev" -> N[StandardDeviation[lengths]],
    "Unique lengths" -> Length[DeleteDuplicates[lengths]],
    "Step count" -> Length[DeleteDuplicates[Differences[lengths]]],
    "Distribution" -> Tally[lengths]
  };
  Association[data]
];

(* Compute in-degrees for all primes *)
ComputeInDegrees[pmax_Integer] := Module[{dag, degrees},
  dag = DirectPrimeDag[pmax];
  degrees = Thread[VertexList[dag] -> VertexInDegree[dag]];
  Reverse @ SortBy[degrees, Last]
];

(* Find primes with in-degree > threshold *)
FindHubs[pmax_Integer, minDegree_Integer : 10] :=
  Select[ComputeInDegrees[pmax], Last[#] >= minDegree &];

(* Plot orbit lengths for a gap *)
PlotOrbitLengths[p_Integer] := Module[{g, idx, data},
  g = NextPrime[p] - p;
  idx = PrimePi[p];
  data = Table[{k, Length[PrimeOrbit[Prime[idx + k]]]}, {k, 0, g - 1}];
  ListPlot[data,
    PlotLabel -> Row[{"Orbit lengths for gap after prime ", p, " (gap = ", g, ")"}],
    AxesLabel -> {"k", "Orbit length"},
    PlotMarkers -> Automatic,
    Joined -> True,
    GridLines -> Automatic
  ]
];

(* Count incomparable pairs in poset *)
CountIncomparablePairs[p_Integer, gap_Integer] := Module[{orbits, pairs, idx},
  idx = PrimePi[p];
  orbits = Table[PrimeOrbit[Prime[idx + k]], {k, 0, gap - 1}];
  pairs = Subsets[Range[gap], {2}];
  Count[pairs, {i_, j_} /;
    !SubsetQ[orbits[[i]], orbits[[j]]] &&
    !SubsetQ[orbits[[j]], orbits[[i]]]]
];

(* Poset statistics *)
PosetStatistics[p_Integer] := Module[{gap, incomp, total},
  gap = NextPrime[p] - p;
  incomp = CountIncomparablePairs[p, gap];
  total = Binomial[gap, 2];
  Association[{
    "Prime" -> p,
    "Gap" -> gap,
    "Total pairs" -> total,
    "Incomparable" -> incomp,
    "Incomparable %" -> N[100 * incomp / total]
  }]
];

(* Analyze all jumps in a gap *)
AnalyzeJumps[p_Integer] := Module[{g, idx, lengths, jumps, data},
  g = NextPrime[p] - p;
  idx = PrimePi[p];
  lengths = Table[Length[PrimeOrbit[Prime[idx + k]]], {k, 0, g - 1}];
  jumps = Position[Differences[lengths], Except[0]] // Flatten;

  data = Table[
    Association[{
      "k" -> k,
      "Prime" -> Prime[idx + k],
      "Factorization" -> FactorInteger[Prime[idx + k]],
      "Omega" -> PrimeOmega[Prime[idx + k]],
      "Omega_0" -> PrimeNu[Prime[idx + k]],
      "Length before" -> lengths[[k]],
      "Length after" -> lengths[[k + 1]],
      "Jump size" -> lengths[[k + 1]] - lengths[[k]],
      "Offset k factorization" -> If[k > 0, FactorInteger[k], {}],
      "Offset k is prime?" -> PrimeQ[k]
    }],
    {k, jumps}
  ];

  Dataset[data]
];

End[];
EndPackage[];
