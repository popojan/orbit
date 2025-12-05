(* ::Package:: *)

(* Egyptian Fractions - Monotone decomposition of rationals into unit fractions *)
(* Based on modular inverse algorithm from popojan/egypt repository *)

BeginPackage["Orbit`"];

EgyptianFractions::usage = "EgyptianFractions[q] decomposes rational q into sum of unit fractions (Egyptian fractions).

Options:
  Method -> \"List\" (default) | \"Raw\" | \"Expression\" | \"Partials\"

Output modes:
  \"List\"       - List of unit fractions {1/a, 1/b, 1/c, ...}
  \"Raw\"        - Symbolic form {{u, v, i, j}, ...} where each term = Σₖ₌ᵢʲ 1/((u+vk)(u+v(k-1)))
  \"Expression\" - HoldForm symbolic sums for display
  \"Partials\"   - {partial sums} showing monotone convergence

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
  EgyptianFractions[7/19]                     (* {1/3, 1/33, 1/209} *)
  EgyptianFractions[2023/2024, Method->\"Raw\"]  (* Symbolic telescoping form *)
  EgyptianFractions[3/7, Method->\"Partials\"]   (* Monotone convergence sequence *)
";

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

OPTIMIZED ALGORITHM using 1/1:
  - n=1: Canonical split 1 = 1/3 + (1/2 + 1/6) → 2 tuples
  - n=2: 1/1 + canonical(1) → 3 tuples (vs 12 with old method, 75% savings)
  - n≥3: 1/1 + consecutive harmonics H[2,k] → O(e^(n-1)) tuples

Key insight: Denominator 1 is disjoint from ALL other denominators (≥2).
This breaks the recursive disjointness constraint that caused exponential growth.

The tuple {1, 0, 0, 0} represents integer 1 via formula: 1/u = 1/1 = 1.

Options:
  Method -> \"List\" (default) | \"Raw\" | \"Expression\"

Complexity comparison:
  n | EgyptianInteger | DisjointEgyptianInteger | Savings
  1 |       2         |           2             |   0%
  2 |       3         |          12             |  75%
  3 |      ~k         |          31             |  58%

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

(* Expand single raw tuple to list of unit fractions *)
ExpandRawFraction[{u_, v_, i_, j_}] := Which[
  v == 0 && i == 0 && j == 0, {1/u},    (* Pure unit fraction *)
  v == 0, {1/u},                         (* Degenerate case *)
  True, Table[1/((u + v*k)*(u + v*(k - 1))), {k, i, j}]
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

Options[EgyptianInteger] = {Method -> "List"}

(* Core optimized algorithm using 1/1 *)
(* Returns raw tuples directly *)
EgyptianIntegerRaw[1] := {{1, 2, 1, 1}, {1, 1, 1, 2}}  (* 1 = 1/3 + (1/2 + 1/6), 2 tuples *)

EgyptianIntegerRaw[2] := {{1, 0, 0, 0}, {1, 2, 1, 1}, {1, 1, 1, 2}}  (* 2 = 1/1 + canonical(1), 3 tuples *)

EgyptianIntegerRaw[n_Integer /; n >= 3] := Module[
  {remaining = n - 1, d = 2, usedDenoms = {1}, harmonicK, tailFracs = {}, maxIter = 10000},

  (* Start with 1/1 tuple *)
  (* Then consecutive harmonics H[2,k] for remaining n-1 *)

  (* Phase 1: Consecutive harmonic part starting from d=2 *)
  While[remaining > 0 && 1/d <= remaining,
    remaining = remaining - 1/d;
    AppendTo[usedDenoms, d];
    harmonicK = d;
    d++;
  ];

  (* Phase 2: Greedy tail for remainder (avoiding used denoms) *)
  While[remaining > 0 && Length[tailFracs] < maxIter,
    d = Max[2, Ceiling[1/remaining]];
    While[MemberQ[usedDenoms, d], d++];
    AppendTo[tailFracs, 1/d];
    AppendTo[usedDenoms, d];
    remaining = remaining - 1/d;
  ];

  (* Construct raw tuples *)
  Join[
    {{1, 0, 0, 0}},  (* 1/1 *)
    Table[{1, dd - 1, 1, 1}, {dd, 2, harmonicK}],  (* consecutive harmonics *)
    Table[{1, Denominator[f] - 1, 1, 1}, {f, tailFracs}]  (* greedy tail *)
  ]
]

(* Main API with Method option *)
EgyptianInteger[n_Integer /; n >= 1, OptionsPattern[]] := Module[
  {raw},

  raw = EgyptianIntegerRaw[n];

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
  {raw, expanded, partials},

  raw = RawFractionsSymbolic[q];

  Switch[OptionValue[Method],
    "Raw",
      raw,

    "Expression",
      FormatRawFraction /@ raw,

    "Partials",
      (* Use symbolic computation for single-tuple case (O(1) per partial) *)
      (* Multi-tuple case: compute symbolically by accumulating complete tuples *)
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
      (* Default: expand and sort by decreasing denominator *)
      Sort[Flatten[ExpandRawFraction /@ raw], Greater]
  ]
]

Options[EgyptianFractions] = {Method -> "List"}

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
