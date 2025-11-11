# Prime DAG Computational Exploration Guide

This guide is for using Claude Code (or similar computational assistants) to explore the prime index DAG structure systematically.

## Core Implementation

### Essential Functions

```mathematica
(* Greedy prime decomposition *)
PrimeRepSparse[n_Integer] := Module[{r = n, primes = {}, p},
  While[r >= 2,
    p = Prime[PrimePi[r]];
    AppendTo[primes, p];
    r -= p
  ];
  Append[primes, r]
]

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
]

(* Build prime DAG with direct edges only *)
DirectPrimeDag[pmax_Integer] := Module[{primes, edges},
  primes = Select[Range[2, pmax], PrimeQ];
  edges = Flatten[Table[
    Select[Most[PrimeRepSparse[PrimePi[p]]], PrimeQ] /. q_ :> (p -> q),
    {p, primes}
  ]];
  Graph[DeleteDuplicates[edges], VertexLabels -> "Name",
    GraphLayout -> "LayeredDigraphEmbedding"]
]
```

## Research Questions for Computational Exploration

### 1. Gap Theorem Verification

**Question:** Does the Gap Theorem hold universally?

```mathematica
(* Verify gap theorem for range of primes *)
VerifyGapTheorem[pmax_Integer] := Module[{primes, results},
  primes = Select[Range[2, pmax], PrimeQ];
  results = Table[
    Module[{p, gap, count},
      p = PrimePi[prime];
      gap = NextPrime[prime] - prime;
      count = Length[Select[Range[p, p + gap - 1], 
        MemberQ[PrimeOrbit[#], prime] &]];
      {prime, gap, count, gap == count}
    ],
    {prime, primes}
  ];
  Select[results, !Last[#] &] (* Return violations if any *)
]

(* Usage: VerifyGapTheorem[10000] should return {} *)
```

### 2. Orbit Length Distributions

**Question:** What is the typical orbit length distribution across gap-children?

```mathematica
(* Analyze orbit lengths for a gap prime *)
AnalyzeGapOrbits[p_Integer] := Module[{gap, lengths, data},
  gap = NextPrime[p] - p;
  lengths = Table[Length[PrimeOrbit[p + k]], {k, 0, gap - 1}];
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
]

(* Batch analysis *)
BatchGapAnalysis[primes_List] := 
  Association[# -> AnalyzeGapOrbits[#] & /@ primes]

(* Usage: BatchGapAnalysis[{89, 113, 523, 1327, 31397}] *)
```

### 3. Partial Order Structure

**Question:** What fraction of gap-children form incomparable pairs?

```mathematica
(* Count incomparable pairs in poset *)
CountIncomparablePairs[p_Integer, gap_Integer] := Module[{orbits, pairs},
  orbits = Table[PrimeOrbit[p + k], {k, 0, gap - 1}];
  pairs = Subsets[Range[gap], {2}];
  Count[pairs, {i_, j_} /; 
    !SubsetQ[orbits[[i]], orbits[[j]]] && 
    !SubsetQ[orbits[[j]], orbits[[i]]]]
]

(* Poset statistics *)
PosetStatistics[p_Integer] := Module[{gap, incomp, total},
  gap = NextPrime[p] - p;
  incomp = CountIncomparablePairs[p, gap];
  total = Binomial[gap, 2];
  {
    "Prime" -> p,
    "Gap" -> gap,
    "Total pairs" -> total,
    "Incomparable" -> incomp,
    "Incomparable %" -> N[100 * incomp / total]
  }
]
```

### 4. Hub Identification

**Question:** Which primes are major hubs (high in-degree)?

```mathematica
(* Compute in-degrees for all primes *)
ComputeInDegrees[pmax_Integer] := Module[{dag, degrees},
  dag = DirectPrimeDag[pmax];
  degrees = Thread[VertexList[dag] -> VertexInDegree[dag]];
  Reverse @ SortBy[degrees, Last]
]

(* Find primes with in-degree > threshold *)
FindHubs[pmax_Integer, minDegree_Integer : 10] := 
  Select[ComputeInDegrees[pmax], Last[#] >= minDegree &]

(* Correlation with gaps *)
HubGapCorrelation[pmax_Integer] := Module[{hubs, data},
  hubs = FindHubs[pmax, 10];
  data = Table[
    {p, Last[#], NextPrime[p] - p} & /@ Select[hubs, First[#] == p &],
    {p, First /@ hubs}
  ];
  ListPlot[Flatten[data, 1][[All, {2, 3}]], 
    AxesLabel -> {"In-degree", "Gap"},
    PlotLabel -> "Hub In-degree vs. Prime Gap"]
]
```

### 5. Jump Point Analysis

**Question:** What arithmetic properties characterize indices where orbit length jumps?

```mathematica
(* Analyze all jumps in a gap *)
AnalyzeJumps[p_Integer] := Module[{g, lengths, jumps, data},
  g = NextPrime[p] - p;
  lengths = Table[Length[PrimeOrbit[p + k]], {k, 0, g - 1}];
  jumps = Position[Differences[lengths], Except[0]] // Flatten;
  
  data = Table[{
    "k" -> k,
    "Index" -> p + k,
    "Factorization" -> FactorInteger[p + k],
    "Omega" -> PrimeOmega[p + k],
    "Omega_0" -> PrimeNu[p + k],
    "Length before" -> lengths[[k]],
    "Length after" -> lengths[[k + 1]],
    "Jump size" -> lengths[[k + 1]] - lengths[[k]],
    "Offset k factorization" -> If[k > 0, FactorInteger[k], {}],
    "Offset k is prime?" -> PrimeQ[k]
  }, {k, jumps}];
  
  Dataset[data]
]

(* Statistical summary across multiple gaps *)
JumpStatistics[primes_List] := Module[{allJumps},
  allJumps = Flatten[AnalyzeJumps /@ primes, 1];
  {
    "Total jumps analyzed" -> Length[allJumps],
    "Jumps where k is prime" -> Count[allJumps, _?(#["Offset k is prime?"] &)],
    "Mean omega" -> N[Mean[#["Omega"] & /@ allJumps]],
    "Mean jump size" -> N[Mean[#["Jump size"] & /@ allJumps]]
  }
]
```

### 6. Visualization Suite

```mathematica
(* Plot orbit lengths for a gap *)
PlotOrbitLengths[p_Integer] := Module[{g, data},
  g = NextPrime[p] - p;
  data = Table[{k, Length[PrimeOrbit[p + k]]}, {k, 0, g - 1}];
  ListPlot[data,
    PlotLabel -> Row[{"Orbit lengths for gap after prime ", p, " (gap = ", g, ")"}],
    AxesLabel -> {"k", "Orbit length"},
    PlotMarkers -> Automatic,
    Joined -> True,
    GridLines -> Automatic
  ]
]

(* Community structure visualization *)
VisualizeCommunities[pmax_Integer] := Module[{dag, communities},
  dag = DirectPrimeDag[pmax];
  communities = FindGraphCommunities[dag];
  HighlightGraph[dag, communities,
    GraphLayout -> "SpringElectricalEmbedding"]
]

(* Distance distribution *)
DistanceDistribution[pmax_Integer] := Module[{dag, primes, distances},
  dag = DirectPrimeDag[pmax];
  primes = Select[Range[2, pmax], PrimeQ];
  distances = Table[
    GraphDistance[dag, p, 2, Method -> "Dijkstra"],
    {p, primes}
  ];
  Histogram[DeleteCases[distances, ∞],
    PlotLabel -> "Distribution of distances to attractor 2",
    AxesLabel -> {"Distance", "Count"}]
]
```

## Systematic Exploration Protocol

### Phase 1: Verification (Primes up to 10,000)
1. Verify Gap Theorem holds for all primes
2. Compute orbit sizes and distributions
3. Build complete DAG and analyze properties

### Phase 2: Pattern Discovery (Primes up to 100,000)
1. Identify all hub primes (in-degree ≥ 10)
2. Analyze jump patterns across 100+ gaps
3. Measure poset incomparability statistics
4. Correlate orbit properties with classical invariants

### Phase 3: Large-Scale Analysis (Primes up to 1,000,000)
1. Distribution of orbit lengths
2. Hub-gap correlation at scale
3. Community structure evolution
4. Statistical properties of jumps

### Phase 4: Hypothesis Testing
Based on patterns from Phases 1-3, formulate and test:
- Predictive models for orbit length
- Jump location heuristics
- Hub characterization criteria
- Connections to classical number theory

## Performance Considerations

For large computations:
- Cache `PrimeOrbit` results (memoization)
- Use parallel processing where applicable
- Store intermediate results
- Focus on specific prime ranges

```mathematica
(* Memoized version *)
PrimeOrbitMemo = Function[n, PrimeOrbit[n], Listable];
PrimeOrbitMemo = Function[Null, 
  If[!ValueQ[cache[#]], cache[#] = PrimeOrbit[#]]; cache[#]
];
```

## Expected Outputs

For each computational session, generate:
1. Data tables (CSV format for further analysis)
2. Visualizations (PNG/PDF for documentation)
3. Summary statistics (markdown or JSON)
4. Anomalies or counterexamples (if any)

## Open Questions for Exploration

1. Is the partial order on gap-children always a lattice? Tree? General poset?
2. What is the growth rate of maximum orbit length as function of p?
3. Can we characterize primes by their "orbit signature"?
4. Does the step function pattern have universal features across all gaps?
5. Are there primes whose gap-children have trivial poset (total order)?
6. What is the distribution of community sizes in the DAG?
7. How does average path length to attractors grow with prime size?

## Integration with Main Research

Results from computational exploration should feed back to:
- Update `prime-dag-gap-theorem.md` with new theorems
- Refine conjectures based on empirical patterns
- Identify edge cases requiring theoretical analysis
- Generate visualizations for intuition building

---

**Target:** Claude Code or similar computational assistant with WolframScript
**Goal:** Systematic exploration of prime DAG structure through computational experiments
**Approach:** Question-driven, with emphasis on pattern discovery and statistical analysis
