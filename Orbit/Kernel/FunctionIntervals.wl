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

Uses Taylor series: sin(x) = x - x^3/3! + x^5/5! - ...

Properties:
- Alternating series: consecutive partial sums bracket sin(x)
- Width = |x|^(2k+1) / (2k+1)!
- UNIT FRACTION width when Numerator[x] = 1 (i.e., x = 1/m)
- Rational width for any rational x

First intervals for sin(1):
  k=1: {1, 5/6}, width = 1/6
  k=2: {5/6, 101/120}, width = 1/120
  k=3: {101/120, 4241/5040}, width = 1/5040

See also: CosInterval, ArcTanInterval, SinSeriesTerm";

SinSeriesTerm::usage = "SinSeriesTerm[x, k] returns the k-th term of the sin(x) Taylor series (k >= 0).

Term k = (-1)^k * x^(2k+1) / (2k+1)!

First terms for sin(1): 1, -1/6, 1/120, -1/5040, ...";

(* ============================================ *)
(* COS INTERVAL                                *)
(* ============================================ *)

CosInterval::usage = "CosInterval[x, k] returns an Interval[{lower, upper}] bracketing cos(x).

Uses Taylor series: cos(x) = 1 - x^2/2! + x^4/4! - ...

Properties:
- Alternating series: consecutive partial sums bracket cos(x)
- Width = |x|^(2k) / (2k)!
- UNIT FRACTION width when Numerator[x] = 1 (i.e., x = 1/m)
- Rational width for any rational x

First intervals for cos(1):
  k=1: {1, 1/2}, width = 1/2
  k=2: {1/2, 13/24}, width = 1/24
  k=3: {13/24, 389/720}, width = 1/720

See also: SinInterval, ArcTanInterval, CosSeriesTerm";

CosSeriesTerm::usage = "CosSeriesTerm[x, k] returns the k-th term of the cos(x) Taylor series (k >= 0).

Term k = (-1)^k * x^(2k) / (2k)!

First terms for cos(1): 1, -1/2, 1/24, -1/720, ...";

(* ============================================ *)
(* ARCTAN INTERVAL                             *)
(* ============================================ *)

ArcTanInterval::usage = "ArcTanInterval[x, k] returns an Interval[{lower, upper}] bracketing arctan(x).

Uses Taylor series: arctan(x) = x - x^3/3 + x^5/5 - x^7/7 + ...

Properties:
- Alternating series: consecutive partial sums bracket arctan(x)
- Width = |x|^(2k+1) / (2k+1)
- UNIT FRACTION width when Numerator[x] = 1 (i.e., x = 1/m)
- Converges for |x| <= 1

Special case: ArcTanInterval[1, k] gives bounds for Pi/4.

First intervals for arctan(1) = Pi/4:
  k=1: {1, 2/3}, width = 1/3
  k=2: {2/3, 13/15}, width = 1/15
  k=3: {13/15, 76/105}, width = 1/35

See also: SinInterval, CosInterval, ArcTanSeriesTerm";

ArcTanSeriesTerm::usage = "ArcTanSeriesTerm[x, k] returns the k-th term of the arctan(x) Taylor series (k >= 0).

Term k = (-1)^k * x^(2k+1) / (2k+1)

First terms for arctan(1): 1, -1/3, 1/5, -1/7, ...";

(* ============================================ *)
(* LOG(1+x) INTERVAL                           *)
(* ============================================ *)

Log1PlusInterval::usage = "Log1PlusInterval[x, k] returns an Interval[{lower, upper}] bracketing log(1+x).

Uses Taylor series: log(1+x) = x - x^2/2 + x^3/3 - x^4/4 + ...

Properties:
- Alternating series for x > 0: consecutive partial sums bracket log(1+x)
- Width = |x|^(k+1) / (k+1)
- UNIT FRACTION width when Numerator[x] = 1 (i.e., x = 1/m)
- Converges for |x| < 1 (and x = 1)

Special case: Log1PlusInterval[1, k] gives bounds for log(2).

First intervals for log(1+1) = log(2):
  k=1: {1, 1/2}, width = 1/2
  k=2: {1/2, 5/6}, width = 1/3
  k=3: {5/6, 7/12}, width = 1/4

See also: Log2Interval (CF-based, faster convergence), SinInterval";

Log1PlusSeriesTerm::usage = "Log1PlusSeriesTerm[x, k] returns the k-th term of the log(1+x) Taylor series (k >= 1).

Term k = (-1)^(k+1) * x^k / k

First terms for log(2): 1, -1/2, 1/3, -1/4, ...";

Begin["`Private`"];

(* ============================================ *)
(* GENERIC ALTERNATING SERIES INTERVAL         *)
(* ============================================ *)

(* Helper: create interval from alternating series partial sums
   termExpr: the general term as a function of summation variable
   var: summation variable (formal symbol)
   k: number of terms
   start: starting index (0 for sin/cos/arctan, 1 for log)

   For integer k: evaluates sums and orders bounds
   For symbolic k: returns Inactive[Sum] expressions
*)
alternatingSeriesInterval[termExpr_, var_, k_Integer, start_: 0] := Module[{s1, s2},
  s1 = Sum[termExpr, {var, start, k - 1}];
  s2 = Sum[termExpr, {var, start, k}];
  Interval[{Min[s1, s2], Max[s1, s2]}]
]

alternatingSeriesInterval[termExpr_, var_, k_, start_: 0] := Interval[{
  Inactive[Sum][termExpr, {var, start, k - 1}],
  Inactive[Sum][termExpr, {var, start, k}]
}]

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
