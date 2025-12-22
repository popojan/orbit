(* ::Package:: *)

(* FunctionIntervals: Rational interval bounds for elementary functions

   Key insight: For ALTERNATING series, consecutive partial sums bracket the limit.
   Width = |next term|.

   UNIT FRACTION WIDTHS when argument x = 1/m (unit fraction):
   - sin(1/m): terms are 1/(m^(2k+1) * (2k+1)!)
   - cos(1/m): terms are 1/(m^(2k) * (2k)!)
   - arctan(1/m): terms are 1/(m^(2k+1) * (2k+1))
   - log(1 + 1/m): terms are 1/(k * m^k)

   For general rational x with Numerator[x] > 1, widths are rational but NOT unit fractions.
*)

BeginPackage["Orbit`"];

(* ============================================ *)
(* SIN INTERVAL                                *)
(* ============================================ *)

SinInterval::usage = "SinInterval[x, k] returns an Interval[{lower, upper}] bracketing sin(x).

Uses Taylor series with PAIRED terms for monotonic convergence.
k pairs = 2k individual terms, giving clean symbolic forms (no Min/Max).

Properties:
- Lower bound: sum of k pairs (2k terms)
- Upper bound: lower + next term
- Width = |x|^(4k+1) / (4k+1)!
- UNIT FRACTION width when Numerator[x] = 1 (i.e., x = 1/m)
- No Min/Max needed — works cleanly with symbolic x

First intervals for sin(1):
  k=1: 2 terms + next, width = 1/5040
  k=2: 4 terms + next, width = 1/362880
  k=3: 6 terms + next, width = 1/6227020800

See also: CosInterval, ArcTanInterval, SinSeriesTerm";

SinSeriesTerm::usage = "SinSeriesTerm[x, k] returns the k-th term of the sin(x) Taylor series (k >= 0).

Term k = (-1)^k * x^(2k+1) / (2k+1)!

First terms for sin(1): 1, -1/6, 1/120, -1/5040, ...";

(* ============================================ *)
(* COS INTERVAL                                *)
(* ============================================ *)

CosInterval::usage = "CosInterval[x, k] returns an Interval[{lower, upper}] bracketing cos(x).

Uses Taylor series with PAIRED terms for monotonic convergence.
k pairs = 2k individual terms, giving clean symbolic forms (no Min/Max).

Properties:
- Lower bound: sum of k pairs (2k terms)
- Upper bound: lower + next term
- Width = |x|^(4k) / (4k)!
- UNIT FRACTION width when Numerator[x] = 1 (i.e., x = 1/m)
- No Min/Max needed — works cleanly with symbolic x

See also: SinInterval, ArcTanInterval, CosSeriesTerm";

CosSeriesTerm::usage = "CosSeriesTerm[x, k] returns the k-th term of the cos(x) Taylor series (k >= 0).

Term k = (-1)^k * x^(2k) / (2k)!

First terms for cos(1): 1, -1/2, 1/24, -1/720, ...";

(* ============================================ *)
(* ARCTAN INTERVAL                             *)
(* ============================================ *)

ArcTanInterval::usage = "ArcTanInterval[x, k] returns an Interval[{lower, upper}] bracketing arctan(x).

Uses Taylor series with PAIRED terms for monotonic convergence.
k pairs = 2k individual terms, giving clean symbolic forms (no Min/Max).

Properties:
- Lower bound: sum of k pairs (2k terms)
- Upper bound: lower + next term
- Width = |x|^(4k+1) / (4k+1)
- UNIT FRACTION width when Numerator[x] = 1 (i.e., x = 1/m)
- Converges for |x| <= 1
- No Min/Max needed — works cleanly with symbolic x

Special case: ArcTanInterval[1, k] gives bounds for Pi/4.

See also: SinInterval, CosInterval, ArcTanSeriesTerm";

ArcTanSeriesTerm::usage = "ArcTanSeriesTerm[x, k] returns the k-th term of the arctan(x) Taylor series (k >= 0).

Term k = (-1)^k * x^(2k+1) / (2k+1)

First terms for arctan(1): 1, -1/3, 1/5, -1/7, ...";

(* ============================================ *)
(* LOG(1+x) INTERVAL                           *)
(* ============================================ *)

Log1PlusInterval::usage = "Log1PlusInterval[x, k] returns an Interval[{lower, upper}] bracketing log(1+x).

Uses Taylor series with PAIRED terms for monotonic convergence.
k pairs = 2k individual terms, giving clean symbolic forms (no Min/Max).

Properties:
- Lower bound: sum of k pairs (2k terms)
- Upper bound: lower + next term
- Width = |x|^(2k+1) / (2k+1)
- UNIT FRACTION width when Numerator[x] = 1 (i.e., x = 1/m)
- Converges for |x| < 1 (and x = 1)
- No Min/Max needed — works cleanly with symbolic x

Special case: Log1PlusInterval[1, k] gives bounds for log(2).
For log(2), width = 1/(2k+1) — the harmonic unit fractions!

See also: Log2Interval (CF-based, faster convergence), SinInterval";

Log1PlusSeriesTerm::usage = "Log1PlusSeriesTerm[x, k] returns the k-th term of the log(1+x) Taylor series (k >= 1).

Term k = (-1)^(k+1) * x^k / k

First terms for log(2): 1, -1/2, 1/3, -1/4, ...";

Begin["`Private`"];

(* ============================================ *)
(* GENERIC ALTERNATING SERIES INTERVAL         *)
(* ============================================ *)

(* Helper: create interval from alternating series using PAIRED terms
   termExpr: the general term as a function of summation variable
   var: summation variable (formal symbol)
   k: number of PAIRS (= 2k individual terms)
   start: starting index (0 for sin/cos/arctan, 1 for log)

   Pairs of consecutive terms sum to positive values (for |x| < convergence radius).
   This gives MONOTONIC partial sums — no Min/Max needed!

   Lower bound: T_k = S_{2k} (sum of k pairs = 2k terms)
   Upper bound: T_k + term_{2k+1} (next unpaired term)
   Width: |term_{2k+1}| — unit fraction when Numerator[x] = 1
*)
alternatingSeriesInterval[termExpr_, var_, k_Integer, start_: 0] := Module[{lower, nextTerm},
  lower = Sum[termExpr, {var, start, start + 2 k - 1}];
  nextTerm = termExpr /. var -> start + 2 k;
  Interval[{lower, lower + nextTerm}]
]

alternatingSeriesInterval[termExpr_, var_, k_, start_: 0] := Module[{lower, nextTerm},
  lower = Inactive[Sum][termExpr, {var, start, start + 2 k - 1}];
  nextTerm = termExpr /. var -> start + 2 k;
  Interval[{lower, lower + nextTerm}]
]

(* ============================================ *)
(* SIN IMPLEMENTATION                          *)
(* ============================================ *)

SinSeriesTerm[x_, k_] := (-1)^k * x^(2 k + 1) / (2 k + 1)!

SinInterval[x_, k_] := With[{j = \[FormalJ]},
  alternatingSeriesInterval[(-1)^j x^(2 j + 1)/(2 j + 1)!, j, k, 0]
]

(* ============================================ *)
(* COS IMPLEMENTATION                          *)
(* ============================================ *)

CosSeriesTerm[x_, k_] := (-1)^k * x^(2 k) / (2 k)!

CosInterval[x_, k_] := With[{j = \[FormalJ]},
  alternatingSeriesInterval[(-1)^j x^(2 j)/(2 j)!, j, k, 0]
]

(* ============================================ *)
(* ARCTAN IMPLEMENTATION                       *)
(* ============================================ *)

ArcTanSeriesTerm[x_, k_] := (-1)^k * x^(2 k + 1) / (2 k + 1)

ArcTanInterval[x_, k_] := With[{j = \[FormalJ]},
  alternatingSeriesInterval[(-1)^j x^(2 j + 1)/(2 j + 1), j, k, 0]
]

(* ============================================ *)
(* LOG(1+x) IMPLEMENTATION                     *)
(* ============================================ *)

Log1PlusSeriesTerm[x_, k_] := (-1)^(k + 1) * x^k / k

Log1PlusInterval[x_, k_] := With[{j = \[FormalJ]},
  alternatingSeriesInterval[(-1)^(j + 1) x^j / j, j, k, 1]
]

End[];

EndPackage[];
