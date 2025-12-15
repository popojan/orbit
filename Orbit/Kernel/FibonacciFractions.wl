(* ::Package:: *)

(* Fibonacci Fractions - Fibonacci-based representation of rational numbers *)
(* Based on Zeckendorf decomposition and entry point theorem *)

BeginPackage["Orbit`"];

FibonacciEntryPoint::usage = "FibonacciEntryPoint[q] returns the smallest positive n such that q divides F_n.

Every positive integer divides some Fibonacci number (Pisano period property).
This is the 'entry point' or 'rank of apparition' of q in the Fibonacci sequence.

Examples:
  FibonacciEntryPoint[5]   (* 5: F_5 = 5 *)
  FibonacciEntryPoint[7]   (* 8: F_8 = 21 = 7*3 *)
  FibonacciEntryPoint[11]  (* 10: F_10 = 55 = 11*5 *)
  FibonacciEntryPoint[113] (* 19: F_19 = 4181 = 113*37 *)
";

Zeckendorf::usage = "Zeckendorf[n] returns the Zeckendorf representation of n as a list of Fibonacci indices.

Zeckendorf's theorem: Every positive integer has a unique representation as a sum
of non-consecutive Fibonacci numbers.

Returns list of indices {i_1, i_2, ...} in decreasing order such that n = Σ F_{i_k}.
Indices are guaranteed to be non-consecutive (|i_j - i_k| >= 2 for j != k).

Examples:
  Zeckendorf[7]   (* {5, 3}: 7 = F_5 + F_3 = 5 + 2 *)
  Zeckendorf[100] (* {11, 9, 5, 3}: 100 = 89 + 8 + 2 + 1 *)
";

FibonacciFraction::usage = "FibonacciFraction[p/q] expresses rational p/q using Fibonacci numbers.

FIBONACCI FRACTION REPRESENTATION THEOREM:
Every rational p/q can be written as:
  p/q = (Σ F_{a_i}) / F_n

where n is the entry point of q and {a_i} is the Zeckendorf decomposition of p*(F_n/q).

Options:
  Method -> \"Indices\" | \"Expression\" | \"Sum\" | \"Terms\" | \"Count\" | \"GoldenRatio\" | \"Polynomial\" | \"Matrix\"
    - \"Indices\": {n, {a_1, a_2, ...}} where p/q = (Σ F_{a_i})/F_n (default)
    - \"Expression\": Inactive Fibonacci[] calls (use Activate to evaluate)
    - \"Sum\": Evaluated sum (numerical result)
    - \"Terms\": List of evaluated terms {F_{a_1}/F_n, F_{a_2}/F_n, ...}
    - \"Count\": {entry point, number of Zeckendorf terms} — quick complexity check
    - \"GoldenRatio\": Binet form with GoldenRatio, use FullSimplify to evaluate
    - \"Polynomial\": Factored P(x)/Q(x) form, substitute x->GoldenRatio to evaluate
    - \"Matrix\": Q-matrix form: (Σ Q^{a_i}) / Q^n where Q={{1,1},{1,0}}

Examples:
  FibonacciFraction[7/11]
    (* {10, {9, 2}}: 7/11 = (F_9 + F_2)/F_10 = 35/55 *)

  FibonacciFraction[7/11, Method -> \"Expression\"]
    (* (Fibonacci[9] + Fibonacci[2])/Fibonacci[10] — displayed but unevaluated *)

  FibonacciFraction[22/7, Method -> \"Expression\"] // Activate
    (* 22/7 *)

  FibonacciFraction[7/11, Method -> \"GoldenRatio\"]
    (* (φ^9 - ψ^9 + φ^2 - ψ^2)/(φ^10 - ψ^10) — use FullSimplify *)

  FibonacciFraction[7/11, Method -> \"Matrix\"]
    (* (Q^9 + Q^2)/Q^10 — use Activate, then [[1,2]] for ratio *)
";

FibonacciEgyptianSeries::usage = "FibonacciEgyptianSeries[n] returns partial sums of the Fibonacci Egyptian series.

The Fibonacci Egyptian series is:
  S = Σ_{k=1}^{∞} 1/(F_{2k+1} * F_{2k+3})
    = 1/(F_3*F_5) + 1/(F_5*F_7) + 1/(F_7*F_9) + ...
    = 1/10 + 1/65 + 1/442 + ...

This series arises from pairing consecutive differences of Fibonacci ratio convergents.

Returns list of first n partial sums {S_1, S_2, ..., S_n}.

Examples:
  FibonacciEgyptianSeries[5]
    (* {1/10, 3/26, 2/17, 21/178, 55/466} *)

  N[Last[FibonacciEgyptianSeries[20]]]
    (* ≈ 0.118034 — converges to (√5 - 2) *)
";

FibonacciTelescopingSum::usage = "FibonacciTelescopingSum[a, b] computes Σ_{k=a}^{b} 1/(F_k * F_{k+1}).

This sum telescopes via the identity:
  1/(F_k * F_{k+1}) = (1/F_{k-1}) * (1/F_k - 1/F_{k+1})

The partial sums converge to approximately 0.7739 as b → ∞.

Examples:
  FibonacciTelescopingSum[2, 5]  (* 91/120 *)
  FibonacciTelescopingSum[2, 10] (* 23437129/30290260 *)
";

FibonacciProductDenominators::usage = "FibonacciProductDenominators[max] lists all F_a * F_b products up to max.

Returns sorted list of {product, {a, b}} pairs where F_a * F_b <= max.

Examples:
  FibonacciProductDenominators[100]
    (* {{2, {2,3}}, {3, {2,4}}, {4, {3,3}}, {5, {2,5}}, ...} *)
";

FibonacciRationalize::usage = "FibonacciRationalize[x, accuracy] approximates real x to given accuracy.

Returns Fibonacci fraction representation (same format as FibonacciFraction).

Finds smallest Fibonacci denominator F_n achieving |m/F_n - x| < accuracy.

Options:
  Method -> same as FibonacciFraction (\"Indices\", \"Expression\", \"Phi\", \"Matrix\", etc.)

Examples:
  FibonacciRationalize[Pi, 10^-6]
    (* {19, {21, 17, 14, 12, 10, 7, 4}} *)

  FibonacciRationalize[Pi, 10^-6, Method -> \"Phi\"]
    (* (φ^21 - ψ^21 + ...)/(φ^19 - ψ^19) *)

  FibonacciRationalize[Pi, 10^-6, Method -> \"Sum\"]
    (* 355/113 *)
";

Begin["`Private`"];

(* Entry point: smallest n with q | F_n *)
FibonacciEntryPoint[q_Integer /; q > 0] := Module[{n = 1},
  While[Mod[Fibonacci[n], q] =!= 0, n++];
  n
]

(* Zeckendorf representation - returns indices in decreasing order *)
Zeckendorf[0] := {}
Zeckendorf[n_Integer /; n > 0] := Module[{fibs, result = {}, remaining = n},
  (* Build list of {F_k, k} pairs up to n *)
  fibs = Reverse[Table[{Fibonacci[k], k}, {k, 2, Ceiling[Log[GoldenRatio, n*Sqrt[5]] + 1]}]];
  fibs = Select[fibs, #[[1]] <= n &];
  (* Greedy: take largest Fibonacci not exceeding remainder *)
  Do[
    If[f[[1]] <= remaining,
      AppendTo[result, f[[2]]];
      remaining -= f[[1]]
    ],
    {f, fibs}
  ];
  result
]

(* Fibonacci Fraction representation *)
Options[FibonacciFraction] = {Method -> "Indices"};

FibonacciFraction[q_Rational, OptionsPattern[]] := Module[
  {p = Numerator[q], d = Denominator[q], n, mult, m, zeck, output},

  (* Find entry point *)
  n = FibonacciEntryPoint[d];
  mult = Fibonacci[n] / d;
  m = p * mult;
  zeck = Zeckendorf[m];

  output = OptionValue[Method];
  Switch[output,
    "Indices",
      {n, zeck},
    "Expression",
      (* Build inactive expression: (Fibonacci[a1] + Fibonacci[a2] + ...)/Fibonacci[n] *)
      (* Use Inactive so Activate[] evaluates cleanly without nesting issues *)
      Plus @@ (Inactive[Fibonacci][#] & /@ zeck) / Inactive[Fibonacci][n],
    "Sum",
      Total[Fibonacci[#]/Fibonacci[n] & /@ zeck],
    "Terms",
      Fibonacci[#]/Fibonacci[n] & /@ zeck,
    "Count",
      {n, Length[zeck]},
    "GoldenRatio",
      (* Binet formula: F_k = (φ^k - ψ^k)/√5, so ratio cancels √5 *)
      (* Returns symbolic form: (Σ(φ^{a_i} - ψ^{a_i})) / (φ^n - ψ^n) *)
      (* FullSimplify evaluates directly since φ, ψ are GoldenRatio forms *)
      Module[{phi = GoldenRatio, psi = 1 - GoldenRatio},
        Plus @@ ((phi^# - psi^#) & /@ zeck) / (phi^n - psi^n)
      ],
    "Polynomial",
      (* Factored polynomial P(x)/Q(x) where P(φ)/Q(φ) = p/q *)
      (* Substitute x -> GoldenRatio to evaluate *)
      With[{xx = Global`x},
        Factor[Plus @@ ((xx^# - (1-xx)^#) & /@ zeck) / (xx^n - (1-xx)^n)]
      ],
    "Matrix",
      (* Q-matrix: Q^k[[1,2]] = F_k where Q = {{1,1},{1,0}} *)
      (* Returns matrix ratio - Activate gives 2x2 matrix, [[1,2]] is the rational *)
      With[{indices = zeck, denom = n},
        Plus @@ (Inactive[MatrixPower][{{1,1},{1,0}}, #] & /@ indices) /
          Inactive[MatrixPower][{{1,1},{1,0}}, denom]
      ],
    _,
      {n, zeck}
  ]
]

(* Handle integers *)
FibonacciFraction[n_Integer, OptionsPattern[]] := FibonacciFraction[n/1, Method -> OptionValue[Method]]

(* Fibonacci Egyptian Series: Σ 1/(F_{2k+1} * F_{2k+3}) *)
FibonacciEgyptianSeries[n_Integer /; n > 0] := Module[{terms, partials},
  terms = Table[1/(Fibonacci[2k + 1] * Fibonacci[2k + 3]), {k, 1, n}];
  Accumulate[terms]
]

(* Telescoping sum: Σ_{k=a}^{b} 1/(F_k * F_{k+1}) *)
FibonacciTelescopingSum[a_Integer, b_Integer] /; a >= 2 && b >= a :=
  Sum[1/(Fibonacci[k] * Fibonacci[k + 1]), {k, a, b}]

(* List Fibonacci product denominators *)
FibonacciProductDenominators[max_Integer] := Module[{pairs},
  pairs = Flatten[
    Table[{Fibonacci[a] * Fibonacci[b], {a, b}}, {a, 2, 20}, {b, a, 20}],
    1
  ];
  pairs = Select[pairs, #[[1]] <= max &];
  SortBy[DeleteDuplicatesBy[pairs, First], First]
]

(* Fibonacci rationalization of irrationals *)
Options[FibonacciRationalize] = {Method -> "Indices"};

FibonacciRationalize[x_?NumericQ, accuracy_?Positive, OptionsPattern[]] := Module[
  {n = 3, fn, m, err, method = OptionValue[Method], prec},

  (* Set precision based on requested accuracy *)
  prec = Ceiling[-Log10[accuracy]] + 50;

  Block[{$MaxExtraPrecision = prec},
    (* Find smallest n with |Round[x*F_n]/F_n - x| < accuracy *)
    While[True,
      fn = Fibonacci[n];
      m = Round[N[x, prec] * fn];
      err = Abs[m/fn - N[x, prec]];
      If[err < accuracy,
        Return[FibonacciFraction[m/fn, Method -> method]]
      ];
      n++;
    ]
  ]
]

End[];

EndPackage[];
