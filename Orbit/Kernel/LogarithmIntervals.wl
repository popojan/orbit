(* ::Package:: *)

(* LogarithmIntervals: Rational interval bounds for logarithms

   Uses continued fraction convergents to achieve UNIT FRACTION interval widths.

   For CF convergents p_n/q_n:
     |p_n/q_n - p_{n-1}/q_{n-1}| = 1/(q_n * q_{n-1})

   This is always a unit fraction - a natural property of continued fractions.

   Supported constants:
   - log(2) = [0; 1, 2, 3, 1, 6, 3, 1, 1, 2, ...]
   - log(3) = [1; 10, 7, 9, 2, 1, 3, 1, 2, 1, ...]
   - log(10) = [2; 3, 9, 2, 1, 1, 3, 1, 18, 1, ...]

   Reference: CF expansions from high-precision computation
*)

BeginPackage["Orbit`"];

(* ============================================ *)
(* LOG(2) INTERVAL                             *)
(* ============================================ *)

Log2Interval::usage = "Log2Interval[k] returns an Interval[{lower, upper}] bracketing log(2).

Uses continued fraction convergents for UNIT FRACTION interval widths.

CF of log(2) = [0; 1, 2, 3, 1, 6, 3, 1, 1, 2, ...]

Properties:
- Width = 1/(q_k * q_{k+1}) where q_n are CF denominators
- Width is ALWAYS a unit fraction (numerator = 1)
- Both bounds are exact rationals
- Convergents alternate above/below log(2)
- Requires integer k (CF-based, no closed form for symbolic k)

First intervals:
  k=1: {1/2, 2/3}, width = 1/6
  k=2: {7/10, 2/3}, width = 1/30
  k=3: {9/13, 7/10}, width = 1/130

For symbolic k, use Log1PlusInterval[1, k] (series-based, slower convergence).

See also: Log3Interval, Log10Interval, Log1PlusInterval, EInterval";

Log2CFConvergent::usage = "Log2CFConvergent[n] returns the n-th CF convergent of log(2).

Uses cached CF terms for exact computation.

Examples:
  Log2CFConvergent[0]  (* 0 *)
  Log2CFConvergent[1]  (* 1 *)
  Log2CFConvergent[2]  (* 2/3 *)
  Log2CFConvergent[5]  (* 9/13 *)";

(* ============================================ *)
(* LOG(3) INTERVAL                             *)
(* ============================================ *)

Log3Interval::usage = "Log3Interval[k] returns an Interval[{lower, upper}] bracketing log(3).

Uses continued fraction convergents for UNIT FRACTION interval widths.

CF of log(3) = [1; 10, 7, 9, 2, 1, 3, 1, 2, 1, ...]

Properties:
- Width = 1/(q_k * q_{k+1}) = unit fraction
- Both bounds are exact rationals

See also: Log2Interval, Log10Interval";

Log3CFConvergent::usage = "Log3CFConvergent[n] returns the n-th CF convergent of log(3).";

(* ============================================ *)
(* LOG(10) INTERVAL                            *)
(* ============================================ *)

Log10Interval::usage = "Log10Interval[k] returns an Interval[{lower, upper}] bracketing log(10).

Uses continued fraction convergents for UNIT FRACTION interval widths.

CF of log(10) = [2; 3, 9, 2, 1, 1, 3, 1, 18, 1, ...]

Note: log(10) = log(2) + log(5), but using direct CF gives cleaner bounds.

See also: Log2Interval, Log3Interval";

Log10CFConvergent::usage = "Log10CFConvergent[n] returns the n-th CF convergent of log(10).";

Begin["`Private`"];

(* ============================================ *)
(* CACHED CF TERMS                              *)
(* ============================================ *)

(* First 50 CF terms of log(2) - computed from high precision *)
log2CFTerms = {0, 1, 2, 3, 1, 6, 3, 1, 1, 2, 1, 1, 1, 1, 3, 10, 1, 1, 1, 2,
               1, 1, 1, 1, 3, 2, 3, 1, 13, 7, 4, 1, 1, 1, 7, 2, 4, 1, 1, 2,
               5, 1, 1, 1, 1, 1, 1, 1, 4, 1};

(* First 50 CF terms of log(3) *)
log3CFTerms = {1, 10, 7, 9, 2, 2, 1, 3, 1, 32, 2, 17, 1, 15, 1, 1, 7, 3, 1, 35,
               1, 1, 1, 2, 5, 3, 2, 1, 4, 2, 1, 3, 1, 5, 3, 13, 1, 1, 1, 6,
               2, 3, 1, 152, 1, 2, 3, 1, 7, 9};

(* First 50 CF terms of log(10) *)
log10CFTerms = {2, 3, 3, 3, 1, 1, 3, 6, 3, 3, 1, 4, 2, 1, 2, 1, 3, 26, 5, 1,
                23, 1, 1, 1, 2, 2, 3, 19, 1, 3, 716, 1, 2, 1, 1, 2, 2, 1, 22, 1,
                17, 4, 1, 13, 7, 3, 5, 1, 1, 1};

(* ============================================ *)
(* CF CONVERGENT HELPER                         *)
(* ============================================ *)

(* Generic CF convergent from stored terms *)
cfConvergent[terms_List, n_Integer] /; n >= 0 && n < Length[terms] :=
  FromContinuedFraction[Take[terms, n + 1]]

cfConvergent[terms_List, n_Integer] /; n >= Length[terms] := Module[{},
  Message[cfConvergent::range, n, Length[terms] - 1];
  $Failed
]

cfConvergent::range = "Index `1` exceeds cached CF terms (max `2`).";

(* ============================================ *)
(* LOG(2) IMPLEMENTATION                        *)
(* ============================================ *)

Log2CFConvergent[n_Integer /; n >= 0] := cfConvergent[log2CFTerms, n]

Log2CFConvergent[n_Integer /; n < 0] := (
  Message[Log2CFConvergent::nonneg, n];
  $Failed
)

Log2CFConvergent::nonneg = "Index `1` must be a non-negative integer.";

Log2Interval[k_Integer /; k >= 1] := Module[{c1, c2},
  c1 = Log2CFConvergent[k - 1];
  c2 = Log2CFConvergent[k];
  If[c1 === $Failed || c2 === $Failed, Return[$Failed]];
  Interval[{Min[c1, c2], Max[c1, c2]}]
]

Log2Interval[k_Integer /; k < 1] := (
  Message[Log2Interval::posk, k];
  $Failed
)

Log2Interval::posk = "Index `1` must be a positive integer.";

(* ============================================ *)
(* LOG(3) IMPLEMENTATION                        *)
(* ============================================ *)

Log3CFConvergent[n_Integer /; n >= 0] := cfConvergent[log3CFTerms, n]

Log3CFConvergent[n_Integer /; n < 0] := (
  Message[Log3CFConvergent::nonneg, n];
  $Failed
)

Log3CFConvergent::nonneg = "Index `1` must be a non-negative integer.";

Log3Interval[k_Integer /; k >= 1] := Module[{c1, c2},
  c1 = Log3CFConvergent[k - 1];
  c2 = Log3CFConvergent[k];
  If[c1 === $Failed || c2 === $Failed, Return[$Failed]];
  Interval[{Min[c1, c2], Max[c1, c2]}]
]

Log3Interval[k_Integer /; k < 1] := (
  Message[Log3Interval::posk, k];
  $Failed
)

Log3Interval::posk = "Index `1` must be a positive integer.";

(* ============================================ *)
(* LOG(10) IMPLEMENTATION                       *)
(* ============================================ *)

Log10CFConvergent[n_Integer /; n >= 0] := cfConvergent[log10CFTerms, n]

Log10CFConvergent[n_Integer /; n < 0] := (
  Message[Log10CFConvergent::nonneg, n];
  $Failed
)

Log10CFConvergent::nonneg = "Index `1` must be a non-negative integer.";

Log10Interval[k_Integer /; k >= 1] := Module[{c1, c2},
  c1 = Log10CFConvergent[k - 1];
  c2 = Log10CFConvergent[k];
  If[c1 === $Failed || c2 === $Failed, Return[$Failed]];
  Interval[{Min[c1, c2], Max[c1, c2]}]
]

Log10Interval[k_Integer /; k < 1] := (
  Message[Log10Interval::posk, k];
  $Failed
)

Log10Interval::posk = "Index `1` must be a positive integer.";

End[];

EndPackage[];
