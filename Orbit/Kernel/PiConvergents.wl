(* ::Package:: *)

(* PiConvergents: Rational interval bounds for Pi

   Two methods:
   1. Wallis product: W_n = 16^n / ((2n+1) C(2n,n)^2)
      - Lower bound: 2 W_n
      - Upper bound: 2 W_n (4n+2)/(4n+1)
      - Convergence: O(1/n) (slow but closed-form)

   2. BBP formula: partial sums are monotone lower bounds
      - Lower bound: BBP partial sum
      - Upper bound: partial sum + 4/(15 * 16^{n+1})
      - Convergence: ~1.2 digits/term (exponential)

   Reference: docs/sessions/2025-12-20-pi-exploration/README.md
*)

BeginPackage["Orbit`"];

(* ============================================ *)
(* WALLIS PRODUCT                              *)
(* ============================================ *)

WallisPartialProduct::usage = "WallisPartialProduct[n] returns the n-th Wallis partial product W_n.

Formula: W_n = Product[4k^2/(4k^2-1), {k,1,n}] = 16^n / ((2n+1) Binomial[2n,n]^2)

The Wallis product converges to Pi/2: lim_{n->inf} W_n = Pi/2

First terms: 4/3, 64/45, 256/175, 16384/11025, ...

Options:
  Method -> \"ClosedForm\" (default) | \"Product\"";

(* ============================================ *)
(* PI INTERVAL (WALLIS)                        *)
(* ============================================ *)

PiIntervalWallis::usage = "PiIntervalWallis[n] returns an Interval[{lower, upper}] bracketing Pi
using the Wallis product.

Formulas:
  Lower = 2 * W_n = 2 * 16^n / ((2n+1) Binomial[2n,n]^2)
  Upper = 2 * W_n * (4n+2)/(4n+1)
  Width = 2 * W_n / (4n+1) ~ Pi/(4n)

Convergence: O(1/n) - slow but uses single closed-form expression.

First intervals:
  n=1: {8/3, 16/5} = {2.667, 3.2}, width 0.53
  n=5: {3.002, 3.145}, width 0.14
  n=10: {3.068, 3.143}, width 0.075

See also: PiIntervalBBP (faster), WallisPartialProduct";

(* ============================================ *)
(* BBP FORMULA                                 *)
(* ============================================ *)

BBPTerm::usage = "BBPTerm[k] returns the k-th term of the BBP formula for Pi (k >= 0).

Formula: term_k = (1/16^k) * (4/(8k+1) - 2/(8k+4) - 1/(8k+5) - 1/(8k+6))

Pi = Sum[BBPTerm[k], {k, 0, Infinity}]

Each term is positive. Partial sums monotonically increase to Pi.

First terms: 47/15, 4348480/4849845, ...";

BBPPartialSum::usage = "BBPPartialSum[n] returns the n-th BBP partial sum (summing k=0 to n).

Formula: Sum[BBPTerm[k], {k, 0, n}]

Properties:
- Monotonically increasing
- Always below Pi (lower bound)
- Converges at ~1.2 digits per term

Options:
  Method -> \"Rational\" (default) | \"Numeric\"";

(* ============================================ *)
(* PI INTERVAL (BBP)                           *)
(* ============================================ *)

PiIntervalBBP::usage = "PiIntervalBBP[n] returns an Interval[{lower, upper}] bracketing Pi
using the BBP formula.

Formulas:
  Lower = BBPPartialSum[n] (monotone increasing)
  Upper = Lower + 4/(15 * 16^{n+1}) (geometric tail bound)

Convergence: ~1.2 digits per term (exponential).

First intervals:
  n=0: {47/15, 47/15 + 1/60} = {3.133, 3.150}, width 0.017
  n=2: width 6.5e-5 (4 digits)
  n=5: width 1.6e-8 (7 digits)
  n=8: width 3.9e-12 (11 digits)

Width is ALWAYS a unit fraction: 1/(60 * 16^n) = 1/(2^{4n+2} * 3 * 5)

This is the RECOMMENDED method for Pi interval bounds.

See also: PiInterval (alias), PiIntervalWallis, BBPPartialSum, BBPTerm";

PiInterval::usage = "PiInterval[n] is an alias for PiIntervalBBP[n].

Returns Interval[{lower, upper}] bracketing Pi with UNIT FRACTION width.

Width = 1/(60 * 16^n) - always a unit fraction for any n >= 0.

This parallels:
  - EulerEInterval (constant numerator 2)
  - SqrtInterval (unit fraction when fundamental x is odd)

See also: PiIntervalBBP, EulerEInterval, SqrtInterval";

(* ============================================ *)
(* CF CONVERGENTS (for comparison)             *)
(* ============================================ *)

PiCFConvergent::usage = "PiCFConvergent[n] returns the n-th CF convergent of Pi.

Pi = [3; 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, ...]

Properties:
- Convergents alternate around Pi
- Even n: below Pi
- Odd n: above Pi
- Width 1/(q_n * q_{n+1}) (variable improvement)

First convergents: 3, 22/7, 333/106, 355/113, ...";

PiIntervalCF::usage = "PiIntervalCF[n] returns an Interval[{lower, upper}] bracketing Pi
using CF convergents.

Uses consecutive convergents: Interval[{c_{2n}, c_{2n+1}}]
(even convergent below, odd above)

Properties:
- Optimal rational approximations
- Variable convergence rate (due to irregular CF)
- 355/113 is exceptionally close

See also: PiCFConvergent, PiIntervalBBP";

Begin["`Private`"];

(* ============================================ *)
(* WALLIS PRODUCT                              *)
(* ============================================ *)

Options[WallisPartialProduct] = {Method -> "ClosedForm"};

WallisPartialProduct[n_Integer /; n >= 1, OptionsPattern[]] := Module[{method},
  method = OptionValue[Method];
  Switch[method,
    "ClosedForm",
      16^n / ((2n + 1) Binomial[2n, n]^2),
    "Product",
      Product[4k^2/(4k^2 - 1), {k, 1, n}],
    _,
      Message[WallisPartialProduct::badmethod, method]; $Failed
  ]
]

WallisPartialProduct[n_Integer /; n < 1, OptionsPattern[]] := (
  Message[WallisPartialProduct::posint, n];
  $Failed
)

WallisPartialProduct::posint = "Index `1` must be a positive integer.";
WallisPartialProduct::badmethod = "Unknown method `1`. Use \"ClosedForm\" or \"Product\".";

(* ============================================ *)
(* PI INTERVAL (WALLIS)                        *)
(* ============================================ *)

PiIntervalWallis[n_Integer /; n >= 1] := Module[{wn, lower, upper},
  wn = 16^n / ((2n + 1) Binomial[2n, n]^2);
  lower = 2 wn;
  upper = 2 wn (4n + 2)/(4n + 1);
  Interval[{lower, upper}]
]

(* Symbolic form *)
PiIntervalWallis[n_Symbol] := With[{wn = 16^n / ((2n + 1) Binomial[2n, n]^2)},
  Interval[{2 wn, 2 wn (4n + 2)/(4n + 1)}]
]

PiIntervalWallis[n_Integer /; n < 1] := (
  Message[PiIntervalWallis::posint, n];
  $Failed
)

PiIntervalWallis::posint = "Index `1` must be a positive integer.";

(* ============================================ *)
(* BBP FORMULA                                 *)
(* ============================================ *)

BBPTerm[k_Integer /; k >= 0] :=
  1/16^k * (4/(8k + 1) - 2/(8k + 4) - 1/(8k + 5) - 1/(8k + 6))

BBPTerm[k_Integer /; k < 0] := (
  Message[BBPTerm::nonneg, k];
  $Failed
)

BBPTerm::nonneg = "Index `1` must be a non-negative integer.";

Options[BBPPartialSum] = {Method -> "Rational"};

BBPPartialSum[n_Integer /; n >= 0, OptionsPattern[]] := Module[{method, sum},
  method = OptionValue[Method];
  sum = Sum[1/16^k * (4/(8k + 1) - 2/(8k + 4) - 1/(8k + 5) - 1/(8k + 6)), {k, 0, n}];
  Switch[method,
    "Rational", sum,
    "Numeric", N[sum],
    _, Message[BBPPartialSum::badmethod, method]; $Failed
  ]
]

BBPPartialSum[n_Integer /; n < 0, OptionsPattern[]] := (
  Message[BBPPartialSum::nonneg, n];
  $Failed
)

BBPPartialSum::nonneg = "Index `1` must be a non-negative integer.";
BBPPartialSum::badmethod = "Unknown method `1`. Use \"Rational\" or \"Numeric\".";

(* ============================================ *)
(* PI INTERVAL (BBP)                           *)
(* ============================================ *)

PiIntervalBBP[n_Integer /; n >= 0] := Module[{lower, upper, tailBound},
  lower = Sum[1/16^k * (4/(8k + 1) - 2/(8k + 4) - 1/(8k + 5) - 1/(8k + 6)), {k, 0, n}];
  tailBound = 4/(15 * 16^(n + 1));
  upper = lower + tailBound;
  Interval[{lower, upper}]
]

(* Symbolic form - use formal symbol \[FormalK] for clean output *)
PiIntervalBBP[n_Symbol] := With[{kk = \[FormalK]},
  With[{
    lower = Inactive[Sum][1/16^kk (4/(8kk + 1) - 2/(8kk + 4) - 1/(8kk + 5) - 1/(8kk + 6)), {kk, 0, n}],
    tail = 4/(15 * 16^(n + 1))
  },
  Interval[{lower, lower + tail}]
]]

PiIntervalBBP[n_Integer /; n < 0] := (
  Message[PiIntervalBBP::nonneg, n];
  $Failed
)

PiIntervalBBP::nonneg = "Index `1` must be a non-negative integer.";

(* PiInterval - alias for PiIntervalBBP *)
PiInterval[n_Integer /; n >= 0] := PiIntervalBBP[n]
PiInterval[n_Symbol] := PiIntervalBBP[n]
PiInterval[n_Integer /; n < 0] := (Message[PiIntervalBBP::nonneg, n]; $Failed)

(* ============================================ *)
(* CF CONVERGENTS                              *)
(* ============================================ *)

(* Cache the first 50 CF terms of Pi *)
piCFTerms = {3, 7, 15, 1, 292, 1, 1, 1, 2, 1, 3, 1, 14, 2, 1, 1, 2, 2, 2, 2,
             1, 84, 2, 1, 1, 15, 3, 13, 1, 4, 2, 6, 6, 99, 1, 2, 2, 6, 3, 5,
             1, 1, 6, 8, 1, 7, 1, 2, 3, 7};

PiCFConvergent[n_Integer /; n >= 0 && n < Length[piCFTerms]] :=
  FromContinuedFraction[Take[piCFTerms, n + 1]]

PiCFConvergent[n_Integer /; n >= Length[piCFTerms]] := Module[{terms},
  terms = ContinuedFraction[Pi, n + 1];
  FromContinuedFraction[terms]
]

PiCFConvergent[n_Integer /; n < 0] := (
  Message[PiCFConvergent::nonneg, n];
  $Failed
)

PiCFConvergent::nonneg = "Index `1` must be a non-negative integer.";

PiIntervalCF[n_Integer /; n >= 0] := Module[{cEven, cOdd},
  cEven = PiCFConvergent[2n];    (* below Pi *)
  cOdd = PiCFConvergent[2n + 1]; (* above Pi *)
  Interval[{cEven, cOdd}]
]

PiIntervalCF[n_Integer /; n < 0] := (
  Message[PiIntervalCF::nonneg, n];
  $Failed
)

PiIntervalCF::nonneg = "Index `1` must be a non-negative integer.";

End[];

EndPackage[];
