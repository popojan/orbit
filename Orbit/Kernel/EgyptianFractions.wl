(* ::Package:: *)

(* Egyptian Fractions - Monotone decomposition of rationals into unit fractions *)
(* Based on modular inverse algorithm from popojan/egypt repository *)

BeginPackage["Orbit`"];

EgyptianFractions::usage = "EgyptianFractions[q] decomposes rational q into sum of unit fractions (Egyptian fractions).

Options:
  Method -> \"List\" (default) | \"Raw\" | \"Expression\" | \"Partials\"
  MaxRecursion -> Automatic | n | Infinity  (bisection depth; 0 = no split, 3 = max 8 terms/tuple, Infinity = full expansion; Automatic = 0 for Raw/Expression/Partials, 3 for List)
  MergeOrder -> None | \"Forward\" | \"Backward\"  (O(k²) postprocessing, default None)
  MaxItems -> n  (for irrational inputs: number of CF terms, default 10)

Output modes:
  \"List\"       - List of unit fractions {1/a, 1/b, 1/c, ...}
  \"Raw\"        - Symbolic form {{u, v, i, j}, ...} where each term = Σₖ₌ᵢʲ 1/((u+vk)(u+v(k-1)))
  \"Expression\" - HoldForm symbolic sums for display
  \"Partials\"   - {partial sums} showing monotone convergence (ignores MaxRecursion, MergeOrder)

MONOTONICITY THEOREM:
  The partial sums form a STRICTLY INCREASING sequence that NEVER exceeds q.
  This is guaranteed when using the raw algorithm (no merge strategy).

  S_1 < S_2 < S_3 < ... < S_n = q  where S_k = Σⱼ₌₁ᵏ (1/dⱼ)

Algorithm:
  Uses modular inverse: v = (-a)^(-1) mod b
  Iteratively: {t, a'} = QuotientRemainder[a, (1 + a*v)/b]; b' = b - t*v

Connection to continued fractions (THEOREM):
  Egypt values = Total /@ Partition[Differences @ Convergents[q], 2]

  That is: each Egypt term equals the sum of a consecutive pair of CF differences.
  - CF differences alternate: +d₁, -d₂, +d₃, -d₄, ...
  - Pairing cancels alternation: (d₁ - d₂), (d₃ - d₄), ... all positive
  - This explains WHY Egypt is monotone: paired differences yield positive increments.

  Verification:
    compare[q_] := {Total /@ Partition[Differences @ Convergents[q], 2],
                    ReleaseHold @ EgyptianFractions[q, Method -> \"Expression\"]}

Examples:
  EgyptianFractions[7/19]                       (* {1/3, 1/33, 1/209} *)
  EgyptianFractions[2023/2024, Method->\"Raw\"]    (* {{1,1,1,2023}} - single tuple *)
  EgyptianFractions[3/7, Method->\"Partials\"]     (* Monotone convergence sequence *)

Bisection control (MaxRecursion):
  EgyptianFractions[2023/2024, MaxRecursion->0]        (* 2023 fractions - no split, O(n) *)
  EgyptianFractions[2023/2024, MaxRecursion->3]        (* ~18 fractions - max 8 terms/tuple *)
  EgyptianFractions[2023/2024, MaxRecursion->Infinity] (* ~12 fractions - full split *)

Merge postprocessing (O(k²)):
  EgyptianFractions[2023/2024, MergeOrder->\"Forward\"]  (* Merge from smallest *)
  EgyptianFractions[2023/2024, MergeOrder->\"Backward\"] (* Merge from largest *)

Irrational numbers (CF approximation):
  EgyptianFractions[Pi, MaxItems->2] // Total   (* 22/7 - Archimedes approx *)
  EgyptianFractions[Sqrt[2], MaxItems->5]       (* CF truncation at 5 terms *)
  EgyptianFractions[GoldenRatio]                (* Default 10 CF terms *)
";

MergeOrder::usage = "MergeOrder is an option for EgyptianFractions specifying merge direction.
Values: None (default), \"Forward\", \"Backward\". O(k²) postprocessing.";

RawFractionsSymbolic::usage = "RawFractionsSymbolic[q] returns symbolic form {{u, v, i, j}, ...}.

CONSTRAINT: Only defined for proper fractions 0 < q < 1.
Returns unevaluated for q ≤ 0 or q ≥ 1.

Each tuple represents: Σₖ₌ᵢʲ 1/((u+vk)(u+v(k-1)))

This is the 'raw' algebraic form that preserves structure.
Telescoping property: 1/((u+vk)(u+v(k-1))) = (1/v)(1/(u+v(k-1)) - 1/(u+vk))

Example:
  RawFractionsSymbolic[2023/2024]
  (* → {{2, 1, 1, 2023}} meaning Σₖ₌₁²⁰²³ 1/(k(k+1)) *)
";

ExpandRawFraction::usage = "ExpandRawFraction[{u, v, i, j}] expands symbolic form to unit fractions.

Converts {u, v, i, j} → {1/((u+v*i)(u+v*(i-1))), ..., 1/((u+v*j)(u+v*(j-1)))}

Example:
  ExpandRawFraction[{2, 1, 1, 3}]
  (* → {1/2, 1/6, 1/12} *)
";

CalculateRawSum::usage = "CalculateRawSum[{u, v, i, j}] computes the value of a raw fraction symbolically.

Formula: (1 - i + j) / ((u - v + v*i)(u + v*j))

This is the closed form for Σₖ₌ᵢʲ 1/((u+vk)(u+v(k-1))).

Example:
  CalculateRawSum[{2, 1, 1, 3}]
  (* → 3/4, which equals 1/2 + 1/6 + 1/12 *)
";

TupleBits::usage = "TupleBits[{u, v, i, j}] computes bit complexity of a raw tuple.

Formula: Log₂(u) + Log₂(v) + Log₂(j)   (for v > 0)
For v = 0: Log₂(u)

This is the canonical complexity measure for Egyptian representations.

Example:
  TupleBits[{1, 1, 1, 2023}]  (* ≈ 10.98 bits *)
";

RawDenominators::usage = "RawDenominators[tuples] extracts all denominators from raw tuples.

Example:
  RawDenominators[{{1, 2, 1, 1}, {3, 8, 1, 2}}]  (* {3, 33, 209} *)
";

DisjointRawQ::usage = "DisjointRawQ[tuples1, tuples2] tests if two raw tuple lists have disjoint denominators.

Example:
  DisjointRawQ[RawFractionsSymbolic[1/3], RawFractionsSymbolic[2/5]]
";

EgyptianInteger::usage = "EgyptianInteger[n] returns optimized disjoint Egyptian representation for integer n.

OPTIMIZED ALGORITHM using 1/1 + Egypt formula tail:
  - n=1: Canonical split 1 = 1/3 + (1/2 + 1/6) → 2 tuples
  - n=2: 1/1 + canonical(1) → 3 tuples (vs 12 with old method, 75% savings)
  - n≥3: 1/1 + consecutive harmonics H[2,k] + Egypt formula tail

Key insights:
  1. Denominator 1 is disjoint from ALL other denominators (≥2)
  2. Egypt formula for remainder is O(log) tuples vs greedy explosion
  3. Optimizes for total BITS, not tuple count

The tuple {1, 0, 0, 0} represents integer 1 via formula: 1/u = 1/1 = 1.

BIT COMPLEXITY COMPARISON (vs old greedy approach):
  n | New bits | Old bits | Improvement
  1 |     2    |     4    |    2x
  2 |     2    |     5    |    2x
  5 |  4,177   | 947,493  |  227x !!!

Options:
  Method -> \"List\" (default) | \"Raw\" | \"Expression\"

Example:
  EgyptianInteger[2]                       (* {1, 1/2, 1/3, 1/6} *)
  EgyptianInteger[2, Method -> \"Raw\"]     (* {{1,0,0,0}, {1,2,1,1}, {1,1,1,2}} *)
  EgyptianInteger[2, Method -> \"Expression\"] (* Symbolic forms *)
";


CanonicalEgyptian::usage = "CanonicalEgyptian[q] returns canonical Egyptian representation.

For proper fractions (0 < q < 1): returns RawFractionsSymbolic[q]
For integers: searches for disjoint split with minimal tuple bits
For improper fractions: splits into integer + fractional parts

Options:
  MaxSplits -> 3         Maximum number of splits for integer search
  MaxDenominator -> 100  Maximum denominator in split search
  \"All\" -> False        Return all candidates instead of best one

Returns list of raw tuples {{u, v, i, j}, ...}.
With \"All\" -> True, returns {{tuples, tupleCount, bits}, ...}.

Canonicity criteria (in priority order):
  1. Minimal number of raw tuples
  2. Minimal total tuple bits

Note: 'Minimal k (splits)' is redundant - minimizing tuples yields reasonable k.

Example:
  CanonicalEgyptian[1]                 (* {1/2, 1/3, 1/6} as raw tuples *)
  CanonicalEgyptian[1, \"All\" -> True]  (* All disjoint reps of 1 *)
  CanonicalEgyptian[7/19]              (* Same as RawFractionsSymbolic *)

Note: For n >= 2, finding disjoint representations requires larger search space.
";

RawFractionsFromCF::usage = "RawFractionsFromCF[q] constructs raw fractions directly from continued fraction.

CONSTRAINT: Only defined for proper fractions 0 < q < 1.
Returns unevaluated for q ≤ 0 or q ≥ 1.

ALTERNATIVE CONSTRUCTION proving Egypt ↔ CF equivalence:
  RawFractionsSymbolic[q] === RawFractionsFromCF[q]  (* Always True for 0 < q < 1 *)

Algorithm:
  1. Compute CF = ContinuedFraction[q]
  2. Pair consecutive CF coefficients: (a₁,a₂), (a₃,a₄), ...
  3. Fold pairs using RawStep recurrence
  4. Handle odd-length CF edge case

The fact that ModInv and CF methods produce IDENTICAL tuples
is a computational proof of the Egypt ↔ CF theorem.

Example:
  RawFractionsFromCF[7/19]  (* {{1, 2, 1, 1}, {3, 8, 1, 2}} *)
  RawFractionsSymbolic[7/19]  (* Same! *)
";

Begin["`Private`"];

(* ===================================================================
   CORE ALGORITHM - Modular Inverse Decomposition
   =================================================================== *)

(* Raw symbolic form: each {u, v, i, j} represents telescoping sum *)
RawFractionsSymbolic[q_Rational /; 0 < q < 1] := Module[
  {result = {}, v, a, b, t},
  {a, b} = NumeratorDenominator[q];

  While[a > 0 && b > 1,
    v = PowerMod[-a, -1, b];  (* Modular inverse: v ≡ (-a)^(-1) mod b *)
    {t, a} = QuotientRemainder[a, (1 + a*v)/b];
    b -= t*v;
    PrependTo[result, {b, v, 1, t}];
  ];

  result
]

(* ===================================================================
   ALTERNATIVE: CF-based Construction (proves Egypt ↔ CF equivalence)
   =================================================================== *)

(* Step function for folding CF pairs into raw tuples *)
RawStep[{a1_, b1_, 1, j1_}, {b2_, j2_}] := {#, b1 + b2 * #, 1, j2} &[a1 + j1 * b1]

(* Construct raw fractions directly from continued fraction *)
RawFractionsFromCF[q_Rational /; 0 < q < 1] := Module[
  {cf = ContinuedFraction[q], cfTail, pairs, eg},

  (* For proper fractions, CF = {0, a₁, a₂, ...} *)
  cfTail = Drop[cf, 1];  (* Remove a₀ = 0 *)

  (* Edge case: CF tail has only one element (e.g., 1/n → {0,n}) *)
  (* For 1/n, the tuple is {1, n-1, 1, 1} giving value 1/n *)
  If[Length[cfTail] == 1,
    Return[{{1, First[cfTail] - 1, 1, 1}}]
  ];

  (* Fold pairs of CF coefficients *)
  pairs = Partition[cfTail, 2];
  eg = Drop[FoldList[RawStep, {1, 0, 1, 0}, pairs], 1];

  (* Handle odd-length CF tail: last coefficient has no pair *)
  If[OddQ[Length[cfTail]] && Length[eg] > 0,
    AppendTo[eg, RawStep[Last[eg], {Last[cfTail] - 1, 1}]]
  ];

  eg
]

(* Construct raw fractions from explicit CF list *)
(* Used for irrational numbers where we have a truncated CF *)
RawFractionsFromCFList[cfList_List] := Module[
  {cfTail, pairs, eg},

  (* cfList should be {a₀, a₁, a₂, ...} *)
  (* For proper fractions (0 < x < 1), a₀ = 0 *)
  cfTail = If[First[cfList] == 0, Drop[cfList, 1], cfList];

  If[Length[cfTail] == 0, Return[{}]];

  (* Edge case: CF tail has only one element *)
  If[Length[cfTail] == 1,
    Return[{{1, First[cfTail] - 1, 1, 1}}]
  ];

  (* Fold pairs of CF coefficients *)
  pairs = Partition[cfTail, 2];
  eg = Drop[FoldList[RawStep, {1, 0, 1, 0}, pairs], 1];

  (* Handle odd-length CF tail: last coefficient has no pair *)
  If[OddQ[Length[cfTail]] && Length[eg] > 0,
    AppendTo[eg, RawStep[Last[eg], {Last[cfTail] - 1, 1}]]
  ];

  eg
]

(* Expand single raw tuple to list of unit fractions *)
ExpandRawFraction[{u_, v_, i_, j_}] := Which[
  v == 0 && i == 0 && j == 0, {1/u},    (* Pure unit fraction *)
  v == 0, {1/u},                         (* Degenerate case *)
  True, Table[1/((u + v*k)*(u + v*(k - 1))), {k, i, j}]
]

(* ===================================================================
   BISECTION - O(log n) unit fractions via recursive halving
   =================================================================== *)

(* Halve a single raw tuple once if it exceeds maxTerms *)
(* Returns list of raw tuples (either original or two halves) *)
HalveRawFractionOnce[{u_, v_, i_, j_}, maxTerms_] :=
  If[j - i + 1 <= maxTerms || v == 0,
    (* Small enough or degenerate - keep as is *)
    {{u, v, i, j}},
    (* Split: compute value, halve it, convert halves back to raw *)
    Module[{value, a, b, half1, half2},
      value = CalculateRawSum[{u, v, i, j}];
      {a, b} = NumeratorDenominator[value];
      (* Split into two parts that sum to a/b *)
      If[OddQ[a],
        half1 = Floor[a/2]/b;
        half2 = Ceiling[a/2]/b;
        ,
        half1 = (a/2 - 1)/b;
        half2 = (a/2 + 1)/b;
      ];
      (* Convert halves to raw tuples and flatten *)
      Join[
        If[half1 > 0, RawFractionsSymbolic[half1], {}],
        If[half2 > 0, RawFractionsSymbolic[half2], {}]
      ]
    ]
  ]

(* Recursively halve all tuples until all are within maxTerms *)
HalveAllRaw[tuples_List, maxTerms_] :=
  FixedPoint[
    Flatten[HalveRawFractionOnce[#, maxTerms] & /@ #, 1] &,
    tuples
  ]

(* Bisect raw tuples based on recursion depth *)
(* maxRecursion = bisection depth: 0 = no split, n = max 2^n terms/tuple, Infinity = full expansion *)
BisectRaw[tuples_List, maxRecursion_] := Which[
  maxRecursion === 0, tuples,           (* No bisection *)
  maxRecursion === Infinity, HalveAllRaw[tuples, 1],  (* Full expansion: split until 1 term per tuple *)
  True, HalveAllRaw[tuples, 2^maxRecursion]  (* Max 2^n terms per tuple *)
]

(* ===================================================================
   MERGE - Combine consecutive unit fractions into larger ones
   =================================================================== *)

(* Merge consecutive unit fractions where possible *)
(* Finds sequences that sum to a unit fraction and combines them *)
MergeFractions[fracs_List] := Module[
  {sorted, i, j, result = {}, accum, pos},

  sorted = ReverseSort[fracs];
  i = 1;

  While[i <= Length[sorted],
    If[Denominator[sorted[[i]]] > 1,
      (* Look for consecutive fractions that sum to unit fraction *)
      accum = Accumulate[sorted[[i ;;]]];
      pos = Flatten[Position[Numerator /@ accum, 1]];
      j = If[pos =!= {}, i + Last[pos] - 1, i];
      AppendTo[result, Total[sorted[[i ;; j]]]];
      i = j + 1;
      ,
      AppendTo[result, sorted[[i]]];
      i += 1;
    ]
  ];

  ReverseSort[result]
]

(* Fix duplicate fractions by re-decomposing their sum *)
FixDuplicates[fracs_List] := FixedPoint[
  Module[{groups, dupPos},
    groups = Split[ReverseSort[#]];
    dupPos = FirstPosition[groups, _List?(Length[#] > 1 &)];
    If[MissingQ[dupPos] || dupPos === {},
      Flatten[groups],
      (* Found duplicates - re-decompose their sum *)
      ReverseSort[Flatten[Join[
        groups[[;; First[dupPos] - 1]],
        {ExpandRawFraction /@ RawFractionsSymbolic[Total[groups[[First[dupPos]]]]]},
        groups[[First[dupPos] + 1 ;;]]
      ]]]
    ]
  ] &,
  fracs
]

(* Closed form for raw sum value *)
CalculateRawSum[{u_, v_, i_, j_}] := Which[
  v == 0 && i == 0 && j == 0, 1/u,
  v == 0, 1/u,
  True, (1 - i + j) / ((u - v + v*i)*(u + v*j))
]

(* Symbolic partial sum: sum up to index k within a raw tuple *)
(* For {u, v, 1, j}, partial sum at step k is CalculateRawSum[{u, v, 1, k}] *)
RawPartialSum[{u_, v_, i_, j_}, k_] := Which[
  k < i, 0,
  k > j, CalculateRawSum[{u, v, i, j}],
  v == 0, 1/u,
  True, (k - i + 1) / ((u - v + v*i)*(u + v*k))
]

(* Generate all partial sums symbolically for single raw tuple *)
RawPartialSumsAll[{u_, v_, i_, j_}] := Which[
  v == 0, {1/u},
  True, Table[RawPartialSum[{u, v, i, j}, k], {k, i, j}]
]

(* Format raw form as HoldForm expression for display *)
(* ReleaseHold expands to list of unit fractions *)
(* Use \[FormalK] to avoid Private` context pollution *)
FormatRawFraction[{u_, v_, i_, j_}] := Which[
  v == 0 && i == 0 && j == 0,
    1/u,
  True,
    With[{uu = u, vv = v, ii = i, jj = j},
      HoldForm[Sum[1/((uu + vv*\[FormalK])*(uu + vv*(\[FormalK] - 1))), {\[FormalK], ii, jj}]]
    ]
]

(* ===================================================================
   CANONICAL REPRESENTATION HELPERS
   =================================================================== *)

(* Tuple bit complexity - canonical measure *)
TupleBits[{u_, v_, _, j_}] := If[v == 0, Log2[u], Log2[u] + Log2[v] + Log2[j]]

(* Total bits for list of tuples *)
TotalTupleBits[tuples_List] := Total[TupleBits /@ tuples]

(* Extract all denominators from raw tuples *)
RawDenominators[tuples_List] := Denominator /@ Flatten[ExpandRawFraction /@ tuples]

(* Check if two tuple lists have disjoint denominators *)
DisjointRawQ[tuples1_List, tuples2_List] :=
  DisjointQ[RawDenominators[tuples1], RawDenominators[tuples2]]

(* Check if list of tuple lists are mutually disjoint *)
MutuallyDisjointQ[tupleLists_List] := Module[{allDenoms},
  allDenoms = RawDenominators /@ tupleLists;
  Length[Union @@ allDenoms] === Total[Length /@ allDenoms]
]


(* ===================================================================
   OPTIMIZED EGYPTIAN INTEGER (with 1/1 allowed)
   =================================================================== *)

Options[EgyptianInteger] = {Method -> "List", Optimize -> False}

(* Bit complexity for a single tuple *)
TupleBitsCeiling[{u_, v_, _, j_}] := If[v == 0,
  Ceiling@Log2[Max[u, 1]],
  Ceiling@Log2[Max[u, 1]] + Ceiling@Log2[Max[v, 1]] + Ceiling@Log2[Max[j, 1]]
]

(* Total bits for a list of tuples *)
TotalBitsCeiling[tuples_List] := Total[TupleBitsCeiling /@ tuples]

(* Build representation for given stopK *)
(* Returns {tuples, totalBits} *)
BuildAtStopK[n_Integer, stopK_Integer] := Module[
  {remaining = n - 1, harmonic, harmonicBits, remainder, tailTuples, tailBits,
   allTuples, harmonicDenoms, tailDenoms},

  (* Compute H[2, stopK] *)
  harmonic = Sum[1/d, {d, 2, stopK}];

  (* If harmonic exceeds remaining, this stopK is invalid *)
  If[harmonic > remaining, Return[{$Failed, Infinity}]];

  remainder = remaining - harmonic;

  (* Bits for harmonic part: each 1/d is tuple {1, d-1, 1, 1} *)
  harmonicBits = Sum[Ceiling@Log2[d] + Ceiling@Log2[Max[d - 1, 1]] + 1, {d, 2, stopK}];

  (* Tail from Egypt formula *)
  If[remainder == 0,
    tailTuples = {};
    tailBits = 0;
    ,
    tailTuples = RawFractionsSymbolic[remainder];
    (* Handle case where RawFractionsSymbolic returns unevaluated *)
    If[!ListQ[tailTuples] || Length[tailTuples] == 0,
      Return[{$Failed, Infinity}]
    ];

    (* CRITICAL: Check that tail denominators don't overlap with harmonic denominators *)
    harmonicDenoms = Range[2, stopK];
    tailDenoms = RawDenominators[tailTuples];
    If[!DisjointQ[harmonicDenoms, tailDenoms],
      (* Overlap detected - this stopK produces duplicates *)
      Return[{$Failed, Infinity}]
    ];

    tailBits = TotalBitsCeiling[tailTuples];
  ];

  (* Construct all tuples *)
  allTuples = Join[
    {{1, 0, 0, 0}},  (* 1/1 *)
    Table[{1, dd - 1, 1, 1}, {dd, 2, stopK}],  (* consecutive harmonics *)
    tailTuples  (* Egypt formula tail *)
  ];

  {allTuples, 1 + harmonicBits + tailBits}  (* +1 for the 1/1 tuple *)
]

(* Core optimized algorithm using 1/1 *)
(* Returns raw tuples directly *)
EgyptianIntegerRaw[1] := {{1, 2, 1, 1}, {1, 1, 1, 2}}  (* 1 = 1/3 + (1/2 + 1/6), 2 tuples *)

EgyptianIntegerRaw[2] := {{1, 0, 0, 0}, {1, 2, 1, 1}, {1, 1, 1, 2}}  (* 2 = 1/1 + canonical(1), 3 tuples *)

EgyptianIntegerRaw[n_Integer /; n >= 3] := Module[
  {remaining = n - 1, d = 2, usedDenoms = {1}, harmonicK, tailTuples},

  (* Start with 1/1 tuple *)
  (* Then consecutive harmonics H[2,k] for remaining n-1 *)

  (* Phase 1: Consecutive harmonic part starting from d=2 *)
  While[remaining > 0 && 1/d <= remaining,
    remaining = remaining - 1/d;
    AppendTo[usedDenoms, d];
    harmonicK = d;
    d++;
  ];

  (* Phase 2: Use Egypt formula for remainder (much better than greedy!) *)
  (* Egypt formula produces O(log) tuples with bounded denominators *)
  tailTuples = If[remaining == 0,
    {},
    RawFractionsSymbolic[remaining]
  ];

  (* Construct raw tuples *)
  Join[
    {{1, 0, 0, 0}},  (* 1/1 *)
    Table[{1, dd - 1, 1, 1}, {dd, 2, harmonicK}],  (* consecutive harmonics *)
    tailTuples  (* Egypt formula tail *)
  ]
]

(* Optimized version: search for best stopping point *)
EgyptianIntegerRawOptimized[1] := EgyptianIntegerRaw[1]
EgyptianIntegerRawOptimized[2] := EgyptianIntegerRaw[2]

EgyptianIntegerRawOptimized[n_Integer /; n >= 3] := Module[
  {maxK, bestTuples, bestBits, result, bits},

  (* Find the maximum k where H[2,k] < n-1 *)
  maxK = 2;
  While[Sum[1/d, {d, 2, maxK + 1}] < n - 1, maxK++];
  maxK = Min[maxK, 200];  (* Safety limit *)

  bestTuples = {};
  bestBits = Infinity;

  (* Try each stopping point *)
  Do[
    {result, bits} = BuildAtStopK[n, stopK];
    If[result =!= $Failed && bits < bestBits,
      bestTuples = result;
      bestBits = bits;
    ],
    {stopK, 2, maxK}
  ];

  (* Fallback to non-optimized if something went wrong *)
  If[bestTuples === {}, EgyptianIntegerRaw[n], bestTuples]
]

(* Main API with Method option *)
EgyptianInteger[n_Integer /; n >= 1, OptionsPattern[]] := Module[
  {raw},

  raw = If[TrueQ[OptionValue[Optimize]],
    EgyptianIntegerRawOptimized[n],
    EgyptianIntegerRaw[n]
  ];

  Switch[OptionValue[Method],
    "Raw",
      raw,

    "Expression",
      FormatRawFraction /@ raw,

    "List" | _,
      Sort[Flatten[ExpandRawFraction /@ raw], Greater]
  ]
]


(* Generate k-splits of integer n into proper fractions *)
(* Returns list of {q1, q2, ...} where each qi is a proper fraction *)
GenerateSplits[n_Integer, k_Integer, maxDenom_Integer: 100] := Module[
  {fracs, result},

  Which[
    k == 2,
      (* k=2: enumerate q1 = a/b, q2 = n - q1 *)
      fracs = Flatten[Table[
        {a/b, n - a/b},
        {b, 2, maxDenom}, {a, 1, b - 1}
      ], 1];
      (* Filter: both must be proper fractions *)
      Select[fracs, 0 < #[[1]] < 1 && 0 < #[[2]] < 1 &],

    k == 3,
      (* k=3: enumerate q1, q2, then q3 = n - q1 - q2 *)
      result = {};
      Do[
        Do[
          q3 = n - a1/b1 - a2/b2;
          If[0 < q3 < 1 && q3 =!= a1/b1 && q3 =!= a2/b2,
            AppendTo[result, {a1/b1, a2/b2, q3}]
          ],
          {b2, b1, Min[maxDenom, 20]}, {a2, 1, b2 - 1}  (* limit inner loop for speed *)
        ],
        {b1, 2, Min[maxDenom, 20]}, {a1, 1, b1 - 1}
      ];
      DeleteDuplicatesBy[result, Sort],

    True,
      (* k > 3: not implemented *)
      {}
  ]
]

(* Find canonical disjoint representation for integer n *)
(* returnAll: if True, return all candidates sorted by (tupleCount, bits) *)
(* Priority: 1. minimal raw tuples, 2. minimal bits (k is irrelevant) *)
FindCanonicalInteger[n_Integer, maxSplits_Integer: 3, maxDenom_Integer: 100, returnAll_: False] :=
  Module[
    {splits, rawLists, allCandidates = {}},

    (* Search ALL k values, collect ALL candidates *)
    Do[
      splits = GenerateSplits[n, k, maxDenom];

      (* For each split, compute raw tuples and check disjointness *)
      Do[
        (* Skip splits with repeated fractions *)
        If[Length[DeleteDuplicates[split]] == Length[split],
          rawLists = RawFractionsSymbolic /@ split;
          If[MutuallyDisjointQ[rawLists],
            AppendTo[allCandidates, {
              Join @@ rawLists,  (* combined tuples *)
              Length[Join @@ rawLists],  (* tuple count *)
              TotalTupleBits[Join @@ rawLists]  (* total bits *)
            }]
          ]
        ],
        {split, splits}
      ],
      {k, 2, maxSplits}
    ];

    (* Sort by (tupleCount, bits) - k is NOT a criterion *)
    If[Length[allCandidates] > 0,
      allCandidates = DeleteDuplicatesBy[SortBy[allCandidates, {#[[2]] &, #[[3]] &}], First];
      If[returnAll,
        allCandidates,
        First[allCandidates][[1]]  (* return just the tuples *)
      ],
      (* No candidates found *)
      If[returnAll, {}, $Failed]
    ]
  ]

(* ===================================================================
   MAIN API
   =================================================================== *)

EgyptianFractions[q_Rational, OptionsPattern[]] := Module[
  {raw, maxRec, mergeOrd, bisected, expanded, partials, method},

  raw = RawFractionsSymbolic[q];
  method = OptionValue[Method];
  mergeOrd = OptionValue[MergeOrder];

  (* Resolve MaxRecursion: Automatic depends on Method *)
  (* 0 = no split, 3 = max 8 terms/tuple, Infinity = full expansion *)
  maxRec = OptionValue[MaxRecursion];
  maxRec = If[maxRec === Automatic,
    If[MemberQ[{"Raw", "Expression", "Partials"}, method], 0, 3],  (* Raw/Expression/Partials: no split *)
    maxRec
  ];

  (* Apply bisection if needed *)
  bisected = BisectRaw[raw, maxRec];

  Switch[method,
    "Raw",
      bisected,

    "Expression",
      FormatRawFraction /@ bisected,

    "Partials",
      (* Use original raw tuples (ignores MaxRecursion, MergeOrder) *)
      (* Symbolic computation: O(1) per partial sum *)
      If[Length[raw] == 1,
        RawPartialSumsAll[First[raw]],
        (* Multiple tuples: partial sums within each tuple, accumulate across *)
        Module[{accum = 0, result = {}},
          Do[
            partials = RawPartialSumsAll[tuple];
            AppendTo[result, accum + # & /@ partials];
            accum += CalculateRawSum[tuple];
          , {tuple, raw}];
          Flatten[result]
        ]
      ],

    "List" | _,
      (* Expand, fix duplicates, optionally merge *)
      expanded = Sort[Flatten[ExpandRawFraction /@ bisected], Greater];
      expanded = FixDuplicates[expanded];
      Switch[mergeOrd,
        "Forward",
          FixDuplicates[MergeFractions[Reverse[expanded]]],
        "Backward",
          FixDuplicates[MergeFractions[expanded]],
        _,
          expanded
      ]
  ]
]

Options[EgyptianFractions] = {Method -> "List", MaxRecursion -> Automatic, MergeOrder -> None, MaxItems -> 10}

(* ===================================================================
   IRRATIONAL INPUT HANDLING
   =================================================================== *)

(* Handle irrational/real numbers via CF approximation *)
(* Matches any numeric that's not Rational or Integer *)
EgyptianFractions[x_?NumericQ, opts:OptionsPattern[]] /; !IntegerQ[x] && !Head[x] === Rational := Module[
  {maxItems, cf, intPart, fracCF, raw, partials},

  maxItems = OptionValue[MaxItems];

  (* Get CF expansion with specified number of terms *)
  cf = ContinuedFraction[x, maxItems];

  (* Split into integer part and fractional CF *)
  intPart = First[cf];
  fracCF = Prepend[Drop[cf, 1], 0];  (* {0, a₁, a₂, ...} for fractional part *)

  (* Get raw tuples from fractional CF *)
  raw = RawFractionsFromCFList[fracCF];

  Switch[OptionValue[Method],
    "Raw",
      If[intPart == 0, raw, Prepend[raw, {intPart, 0, 0, 0}]],

    "Expression",
      If[intPart == 0,
        FormatRawFraction /@ raw,
        Prepend[FormatRawFraction /@ raw, intPart]
      ],

    "Partials",
      If[Length[raw] == 1,
        If[intPart == 0,
          RawPartialSumsAll[First[raw]],
          intPart + # & /@ RawPartialSumsAll[First[raw]]
        ],
        Module[{accum = intPart, result = If[intPart == 0, {}, {intPart}]},
          Do[
            partials = RawPartialSumsAll[tuple];
            AppendTo[result, accum + # & /@ partials];
            accum += CalculateRawSum[tuple];
          , {tuple, raw}];
          Flatten[result]
        ]
      ],

    "List" | _,
      If[intPart == 0,
        Sort[Flatten[ExpandRawFraction /@ raw], Greater],
        Prepend[Sort[Flatten[ExpandRawFraction /@ raw], Greater], intPart]
      ]
  ]
]

(* ===================================================================
   INTEGER INPUT HANDLING
   =================================================================== *)

(* Integer input: trivial case *)
EgyptianFractions[n_Integer, OptionsPattern[]] := Switch[OptionValue[Method],
  "Raw", {{n, 0, 0, 0}},
  "Expression", {n},
  "Partials", {n},
  _, {n}
]

(* Improper fractions: extract integer part *)
EgyptianFractions[q_Rational, opts:OptionsPattern[]] /; q >= 1 := Module[
  {intPart = Floor[q], fracPart = FractionalPart[q]},
  If[fracPart == 0,
    EgyptianFractions[intPart, opts],
    Join[{intPart}, EgyptianFractions[fracPart, opts]]
  ]
] /; q > 1

(* ===================================================================
   CANONICAL EGYPTIAN REPRESENTATION
   =================================================================== *)

Options[CanonicalEgyptian] = {MaxSplits -> 3, MaxDenominator -> 100, "All" -> False}

(* Proper fractions: just use RawFractionsSymbolic *)
CanonicalEgyptian[q_Rational /; 0 < q < 1, OptionsPattern[]] :=
  If[OptionValue["All"],
    {{RawFractionsSymbolic[q], Length[RawFractionsSymbolic[q]],
      TotalTupleBits[RawFractionsSymbolic[q]]}},
    RawFractionsSymbolic[q]
  ]

(* Integers: search for disjoint representation *)
CanonicalEgyptian[n_Integer /; n >= 1, OptionsPattern[]] :=
  FindCanonicalInteger[n, OptionValue[MaxSplits], OptionValue[MaxDenominator], OptionValue["All"]]

(* Improper fractions: split into integer + fractional, combine *)
CanonicalEgyptian[q_Rational /; q > 1, opts:OptionsPattern[]] := Module[
  {intPart = Floor[q], fracPart = FractionalPart[q], intRaw, fracRaw},
  fracRaw = RawFractionsSymbolic[fracPart];
  If[intPart == 0,
    fracRaw,
    intRaw = CanonicalEgyptian[intPart, opts];
    If[intRaw === $Failed,
      $Failed,
      (* Check disjointness with fractional part *)
      If[DisjointRawQ[intRaw, fracRaw],
        Join[intRaw, fracRaw],
        (* Not disjoint - need more sophisticated search *)
        $Failed
      ]
    ]
  ]
]

End[];

EndPackage[];
