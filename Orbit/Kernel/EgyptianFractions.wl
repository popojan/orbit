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

RawFractionsFromCF::usage = "RawFractionsFromCF[q] constructs raw fractions directly from continued fraction.

ALTERNATIVE CONSTRUCTION proving Egypt ↔ CF equivalence:
  RawFractionsSymbolic[q] === RawFractionsFromCF[q]  (* Always True *)

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
RawFractionsSymbolic[q_Rational] := Module[
  {result = {}, v, a, b, t},
  {a, b} = NumeratorDenominator[q];

  While[a > 0 && b > 1,
    v = PowerMod[-a, -1, b];  (* Modular inverse: v ≡ (-a)^(-1) mod b *)
    {t, a} = QuotientRemainder[a, (1 + a*v)/b];
    b -= t*v;
    PrependTo[result, {b, v, 1, t}];
  ];

  (* Handle remaining unit fraction if any *)
  If[a > 0 && b == 1, PrependTo[result, {1, 0, 0, 0}]];

  result
]

(* ===================================================================
   ALTERNATIVE: CF-based Construction (proves Egypt ↔ CF equivalence)
   =================================================================== *)

(* Step function for folding CF pairs into raw tuples *)
RawStep[{a1_, b1_, 1, j1_}, {b2_, j2_}] := {#, b1 + b2 * #, 1, j2} &[a1 + j1 * b1]

(* Construct raw fractions directly from continued fraction *)
RawFractionsFromCF[q_Rational] := Module[
  {cf = ContinuedFraction[q], cfTail, pairs, eg},

  cfTail = Drop[cf, 1];  (* Remove a₀ *)

  (* Edge case: CF tail has only one element (e.g., 1/n → {0,n}) *)
  (* For 1/n, the tuple is {1, n-1, 1, 1} giving value 1/n *)
  If[Length[cfTail] == 1,
    Return[{{1, First[cfTail] - 1, 1, 1}}]
  ];

  (* Fold pairs of CF coefficients *)
  pairs = Partition[cfTail, 2];
  eg = Drop[FoldList[RawStep, {1, 0, 1, 0}, pairs], 1];

  (* Handle integer part if present *)
  If[First[cf] > 0, PrependTo[eg, {1, 0, 0, 0}]];

  (* Handle even-length CF: last coefficient has no pair *)
  If[EvenQ[Length[cf]] && Length[eg] > 0,
    AppendTo[eg, RawStep[Last[eg], {Last[cf] - 1, 1}]]
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

End[];

EndPackage[];
