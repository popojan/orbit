(* ::Package:: *)

(* EulerEConvergents: Monotonic rational approximations to Euler's e

   Main result: e = 1 + 4 * Sum[(4j+3)/(s[2j-1]*s[2j+1]), {j,0,Infinity}]

   where s_n are Bessel polynomial values satisfying:
     s_{-1} = 1, s_0 = 1, s_1 = 7
     s_n = (4n+2) * s_{n-1} + s_{n-2}

   Connection: s_n = (-1)^{n+1} * y_{n+1}(-2) where y_n is Bessel polynomial.
   Reference: OEIS A002119

   The transformed convergents T_n are every 3rd convergent of standard CF[E]:
     T_n = (3n+2)-th convergent of e

   Reference: docs/sessions/2025-12-17-sigma-conjugation-e/README.md
*)

BeginPackage["Orbit`"];

(* ============================================ *)
(* BESSEL POLYNOMIAL (short form)              *)
(* ============================================ *)

BesselPolynomial::usage = "BesselPolynomial[n, x] returns the n-th Bessel polynomial y_n(x).

Definition: y_n(x) = HypergeometricPFQ[{-n, n+1}, {}, -x/2]

Recurrence: y_n(x) = (2n-1) x y_{n-1}(x) + y_{n-2}(x)
with y_0(x) = 1, y_1(x) = x + 1.

First polynomials: 1, x+1, 3x²+3x+1, 15x³+15x²+6x+1, ...";

(* ============================================ *)
(* BESSEL SEQUENCE                             *)
(* ============================================ *)

BesselESequence::usage = "BesselESequence[n] returns the n-th term of the Bessel sequence
s_n = p_n + q_n where p_n/q_n is the n-th convergent of [0; 6, 10, 14, ...].

Satisfies recurrence: s_n = (4n+2) * s_{n-1} + s_{n-2}
with s_0 = 1, s_1 = 7.

Connection to Bessel polynomials: s_n = (-1)^{n+1} * y[n+1, -2]

Short form: s[n]

First terms: 1, 7, 71, 1001, 18089, 398959, 10391023, ...";

s::usage = "s[n] = BesselESequence[n] = (-1)^{n+1} * y[n+1, -2]. Short form for Bessel E-sequence.";

(* Short form s[n] - returns Inactive HPFQ for staged evaluation *)
(* ReleaseHold shows HPFQ form with (-1)^(n+1), Activate evaluates to positive s_n *)
(* Note: raw HPFQ alternates sign (-1,7,-71,...), factor (-1)^(n+1) corrects to (1,7,71,...) *)

(* Special case: s[-1] = 1 (from recurrence or y_0(-2) = 1) *)
s[-1] = 1;
(* For "always odd" expressions like 2j±1, sign factor (-1)^(odd+1) = (-1)^even = 1, so omit it *)
s[n : (2*_ + 1 | 2*_ - 1)] := Inactive[HypergeometricPFQ][{-n - 1, n + 2}, {}, 1];
(* General case: include sign correction *)
s[n_] := (-1)^(n + 1) Inactive[HypergeometricPFQ][{-n - 1, n + 2}, {}, 1];

(* BesselPolynomial defined in Private section *)

(* ============================================ *)
(* EULER E CONVERGENTS                         *)
(* ============================================ *)

EulerEConvergent::usage = "EulerEConvergent[n] returns the n-th transformed convergent T_n
approximating Euler's e.

T_n = (3q_n + p_n)/(q_n + p_n) where p_n/q_n is the n-th convergent of [0; 6, 10, 14, ...].

Properties:
- T_n alternates around e: odd n undershoot, even n overshoot
- T_n equals the (3n+2)-th convergent of standard CF[E]
- Converges at ~3 digits per term

First terms: 19/7, 193/71, 2721/1001, 49171/18089, ...";

(* ============================================ *)
(* MONOTONIC SEQUENCE                          *)
(* ============================================ *)

EulerEMonotone::usage = "EulerEMonotone[k] returns the k-th term of the monotonically
increasing sequence converging to e from below.

M_k = T_{2k-1} (odd transformed convergents)

Formula: M_k = 1 + Sum[EulerEMonotoneTerm[j], {j, 0, k-1}]

Properties:
- Strictly increasing: M_1 < M_2 < M_3 < ... < e
- Uses only odd-indexed Bessel values (s_{-1}, s_1, s_3, ...)
- Converges at ~6 digits per term

Options:
  Method -> \"Rational\" (default) | \"Symbolic\" | \"Numeric\" | \"Terms\"

Methods:
  \"Rational\" - Exact rational approximation (default)
  \"Symbolic\" - Held symbolic sum formula
  \"Numeric\"  - Numerical value (use WorkingPrecision option)
  \"Terms\"    - List {1, term_0, term_1, ...} where Total gives approximation

First terms: 19/7, 2721/1001, 1084483/398959, ...";

EulerEMonotoneSum::usage = "DEPRECATED: Use EulerEMonotone[k, Method -> \"Terms\"] instead.

Returns {1, term_0, ..., term_{k-1}} where Total gives approximation.";

EulerEMonotoneTerm::usage = "EulerEMonotoneTerm[j] returns the j-th term of the monotonic e series (j ≥ 0):

  term_j = 4 * (4j+3) / (s[2j-1] * s[2j+1])

where s[n] is the Bessel E-sequence.

e = 1 + Sum[EulerEMonotoneTerm[j], {j, 0, Infinity}]

First terms: 12/7, 4/1001, 4/36305269, ...

Options:
  Method -> \"Rational\" (default) | \"Symbolic\"";

EulerETermCanonical::usage = "EulerETermCanonical[t] is the canonical form of the
e-convergent term function, odd around t = 0.

Formula:
  g(t) = -16t π e / [K_{2t-1}(-1/2) K_{2t+1}(-1/2)]

Properties:
  - ODD around t = 0: g(-t) = -g(t)
  - BesselK orders 2t±1 symmetric around 2t
  - Real when both orders 2t±1 are half-integers: t ∈ {(2k+1)/4 : k ∈ ℤ} ∪ {0}
  - Series terms at t = 3/4, 7/4, 11/4, ... where orders are 1/2, 5/2, 9/2, ...

Note: Half-integer BesselK orders correspond to spherical Bessel functions.
The e ↔ Bessel polynomial connection is known (OEIS A002119); this symmetric
formula g(t) with K_{2t±1} structure provides an elegant closed form.

Examples:
  EulerETermCanonical[3/4]  (* 12/7, orders K_{1/2} and K_{5/2} *)
  EulerETermCanonical[7/4]  (* 4/1001, orders K_{5/2} and K_{9/2} *)";

EulerEMonotoneTermAnalytic::usage = "EulerEMonotoneTermAnalytic[j] returns the analytic continuation
of EulerEMonotoneTerm to complex j ∈ ℂ.

Delegates to canonical form: term[j] = EulerETermCanonical[j + 3/4]

Properties:
  - Agrees with EulerEMonotoneTerm[j] at non-negative integers j = 0, 1, 2, ...
  - At j = n (integer), BesselK orders are half-integers: 2n+1/2 and 2n+5/2
  - Result is REAL at these points (product of two pure imaginaries)
  - Odd around j = -3/4

Examples:
  N[EulerEMonotoneTermAnalytic[0]]  (* 12/7, uses K_{1/2} and K_{5/2} *)
  N[EulerEMonotoneTermAnalytic[1]]  (* 4/1001, uses K_{5/2} and K_{9/2} *)";

EulerEMonotoneAnalytic::usage = "EulerEMonotoneAnalytic[t] returns the analytic continuation
of the monotonic e approximation.

Formula: 1 + Sum[EulerEMonotoneTermAnalytic[j], {j, 0, t}]

Examples:
  EulerEMonotoneAnalytic[n]  (* symbolic *)
  N[EulerEMonotoneAnalytic[3]]  (* numeric *)";

EulerEAlternatingTerm::usage = "EulerEAlternatingTerm[k] returns the k-th term (k ≥ 0)
of the alternating e series:

  term_k = (-1)^(k+1) * 2 / (s[k] * s[k+1])

e = 3 + Sum[EulerEAlternatingTerm[k], {k, 0, Infinity}]
  = 3 - 2/7 + 2/497 - 2/71071 + ...

First terms: -2/7, 2/497, -2/71071, 2/18107089, ...";

EulerEAlternatingTermAnalytic::usage = "EulerEAlternatingTermAnalytic[k] returns the k-th term
of the alternating e series with analytic continuation via BesselK.

Simplified formula:
  term[k] = 2 (-1)^(k+1) π e / [K_{k+3/2}(-1/2) K_{k+5/2}(-1/2)]

Note: For consecutive indices, BesselK products are POSITIVE.
The (-1)^(k+1) factor provides alternation but makes the result
COMPLEX for non-integer k. For integer k, result is real.";

EulerEAlternatingAnalytic::usage = "EulerEAlternatingAnalytic[n] returns the analytic continuation
of the alternating e series.

Formula: 3 + Sum[EulerEAlternatingTermAnalytic[k], {k, 0, n-1}]

Examples:
  EulerEAlternatingAnalytic[n]  (* symbolic *)
  N[EulerEAlternatingAnalytic[4]]  (* numeric *)";

(* Define EulerEMonotoneTerm in public context - j >= 0 *)
(* Pure function: term[j] = 4*(4j+3)/(s[2j-1]*s[2j+1]) *)
EulerEMonotoneTerm[jj_Integer /; jj >= 0] := 4 (4 jj + 3) / (Activate[s[2 jj - 1]] Activate[s[2 jj + 1]]);
EulerEMonotoneTerm[jj_Integer /; jj >= 0, Method -> "Symbolic"] :=
  With[{coef = 4 jj + 3, lo = 2 jj - 1, hi = 2 jj + 1},
    HoldForm[4 coef / (s[lo] s[hi])]];
EulerEMonotoneTerm[jj_Symbol] := 4 (4 jj + 3) / (s[2 jj - 1] s[2 jj + 1]);

(* Define EulerEAlternatingTerm in public context *)
EulerEAlternatingTerm[kk_Integer /; kk >= 0] := (-1)^(kk + 1) * 2 / (Activate[s[kk]] Activate[s[kk + 1]]);
EulerEAlternatingTerm[kk_Integer /; kk >= 0, Method -> "Symbolic"] :=
  With[{lo = kk, hi = kk + 1},
    HoldForm[(-1)^(lo + 1) * 2 / (s[lo] s[hi])]];
EulerEAlternatingTerm[kk_Symbol] := (-1)^(kk + 1) * 2 / (s[kk] s[kk + 1]);

(* ============================================ *)
(* ANALYTIC CONTINUATION via BesselK           *)
(* ============================================ *)

(* Canonical odd function centered at t = 0
   Formula: g(t) = -16t π e / [K_{2t-1}(-1/2) K_{2t+1}(-1/2)]

   Properties:
   - ODD around t = 0: g(-t) = -g(t)
   - BesselK orders 2t±1 symmetric around 2t (elegant!)
   - Real when both orders are half-integers: t ∈ {(2k+1)/4} ∪ {0}
   - Series terms at t = 3/4, 7/4, 11/4, ... where orders are 1/2, 5/2, 9/2, ...
   - Half-integer orders = spherical Bessel functions (known connection to A002119)
*)
EulerETermCanonical[t_] :=
  -16 t Pi E / (BesselK[2 t - 1, -1/2] BesselK[2 t + 1, -1/2]);

(* EulerEMonotoneTermAnalytic delegates to canonical form with shift
   term[j] = g(j + 3/4) where g is EulerETermCanonical
*)
EulerEMonotoneTermAnalytic[j_] := EulerETermCanonical[j + 3/4];

(* Analytic continuation of the full e approximation *)
(* e = 1 + Sum[term, {j, 0, ∞}] *)
EulerEMonotoneAnalytic[t_Integer] := 1 + Sum[EulerEMonotoneTermAnalytic[jj], {jj, 0, t}];
EulerEMonotoneAnalytic[t_] := 1 + Inactive[Sum][EulerEMonotoneTermAnalytic[jj], {jj, 0, t}];

(* Alternating series term - analytic continuation
   Note: For consecutive indices (k, k+1), BesselK products are POSITIVE.
   The (-1)^(k+1) factor is needed for alternation but makes the result
   complex for non-integer k. For integer k, result is real.
*)
EulerEAlternatingTermAnalytic[k_] :=
  2 (-1)^(k + 1) Pi E / (BesselK[k + 3/2, -1/2] BesselK[k + 5/2, -1/2]);

(* Alternating series - analytic continuation *)
EulerEAlternatingAnalytic[n_Integer] := 3 + Sum[EulerEAlternatingTermAnalytic[kk], {kk, 0, n - 1}];
EulerEAlternatingAnalytic[n_] := 3 + Inactive[Sum][EulerEAlternatingTermAnalytic[kk], {kk, 0, n - 1}];

(* ============================================ *)
(* ALTERNATIVE FORMULATION                     *)
(* ============================================ *)

(* ============================================ *)
(* INTERVAL BOUNDS                             *)
(* ============================================ *)

EulerEInterval::usage = "EulerEInterval[k] returns an Interval[{lower, upper}] bracketing Euler's e.

Parameters:
  k - positive integer (refinement level)

Returns: Interval[{T_{2k-1}, T_{2k}}] where T_{2k-1} < e < T_{2k}

Properties:
- lower = EulerEConvergent[2k-1] (odd T_n, undershoots e)
- upper = EulerEConvergent[2k] (even T_n, overshoots e)
- Width shrinks by ~6 decimal digits per increment of k
- Both bounds are optimal rationals (from CF structure)

First intervals:
  k=1: {19/7, 193/71} ≈ {2.714..., 2.718...}, width ~4×10⁻³
  k=2: {2721/1001, 49171/18089} ≈ {2.71828..., 2.71828...}, width ~1×10⁻⁷
  k=3: width ~5×10⁻¹³
  k=4: width ~6×10⁻¹⁹

Use Normal[result] to extract {lower, upper} list for numeric operations.

See also: EulerEConvergent, EulerEMonotone";

EulerEAlternating::usage = "EulerEAlternating[n] returns the n-th partial sum of the
alternating series starting from 3:

e = 3 + Sum[(-1)^{k+1} * 2/(s_k * s_{k+1}), {k, 0, Infinity}]
  = 3 - 2/7 + 2/497 - 2/71071 + ...

Returns the partial sum with n terms (k = 0 to n-1).

Options:
  Method -> \"Rational\" (default) | \"Symbolic\" | \"Numeric\" | \"Terms\"

Methods:
  \"Rational\" - Exact rational partial sum (default)
  \"Symbolic\" - Held symbolic sum formula
  \"Numeric\"  - Numerical value (use WorkingPrecision option)
  \"Terms\"    - {base, signedTerms} for inspection";

Begin["`Private`"];

(* ============================================ *)
(* BESSEL POLYNOMIAL                           *)
(* ============================================ *)

BesselPolynomial[n_, x_] := HypergeometricPFQ[{-n, n + 1}, {}, -x/2];

(* ============================================ *)
(* BESSEL SEQUENCE (memoized)                  *)
(* ============================================ *)

besselE[-1] = 1;  (* For extended recurrence: s[-1] = 1 *)
besselE[0] = 1;
besselE[1] = 7;
besselE[n_Integer] := besselE[n] = (4 n + 2) besselE[n - 1] + besselE[n - 2]

BesselESequence[n_Integer /; n >= 0] := besselE[n]

BesselESequence[n_Integer /; n < 0] := (
  Message[BesselESequence::nonneg, n];
  $Failed
)

BesselESequence::nonneg = "Index `1` must be a non-negative integer.";

(* ============================================ *)
(* EULER E CONVERGENT                          *)
(* ============================================ *)

(* Convergent p_n/q_n of [0; 6, 10, 14, ..., 4n+2] *)
arithmeticCFConvergent[n_Integer /; n >= 1] :=
  FromContinuedFraction[Prepend[Table[4 k + 2, {k, n}], 0]]

EulerEConvergent[n_Integer /; n >= 1] := Module[{pq, p, q},
  pq = arithmeticCFConvergent[n];
  p = Numerator[pq];
  q = Denominator[pq];
  (3 q + p)/(q + p)
]

EulerEConvergent[n_Integer /; n < 1] := (
  Message[EulerEConvergent::posint, n];
  $Failed
)

EulerEConvergent::posint = "Index `1` must be a positive integer.";

(* ============================================ *)
(* MONOTONIC SEQUENCE                          *)
(* ============================================ *)

Options[EulerEMonotone] = {Method -> "Rational", WorkingPrecision -> MachinePrecision};

(* Helper for shared logic - formulation: e = 1 + Sum[term[j], {j, 0, ∞}] *)
eulerEMonotoneImpl[k_, isInf_, opts___] := Module[
  {method, prec, terms, limit},
  method = OptionValue[EulerEMonotone, {opts}, Method];
  prec = OptionValue[EulerEMonotone, {opts}, WorkingPrecision];
  limit = If[isInf, Infinity, k - 1];

  Switch[method,
    "Symbolic",
      With[{kVal = limit, jj = Global`j},
        HoldForm[1 + 4 Inactive[Sum][(4 jj + 3)/(s[2 jj - 1] s[2 jj + 1]), {jj, 0, kVal}]]
      ],

    "Rational",
      If[isInf, Message[EulerEMonotone::infrat]; $Failed, EulerEConvergent[2 k - 1]],

    "Numeric",
      If[isInf, Message[EulerEMonotone::infrat]; $Failed, N[EulerEConvergent[2 k - 1], prec]],

    "Terms",
      If[isInf,
        Message[EulerEMonotone::infrat]; $Failed,
        (* e = 1 + Sum[term[j], {j,0,k-1}], return {1, term[0], ..., term[k-1]} *)
        terms = Table[4 (4 j + 3)/(besselE[2 j - 1] besselE[2 j + 1]), {j, 0, k - 1}];
        Prepend[terms, 1]
      ],

    _,
      Message[EulerEMonotone::badmethod, method]; $Failed
  ]
]

EulerEMonotone[k_Integer /; k >= 1, opts:OptionsPattern[]] := eulerEMonotoneImpl[k, False, opts]

EulerEMonotone[DirectedInfinity[1], opts:OptionsPattern[]] := eulerEMonotoneImpl[Infinity, True, opts]

EulerEMonotone[k_Integer /; k < 1, OptionsPattern[]] := (
  Message[EulerEMonotone::posint, k];
  $Failed
)

EulerEMonotone::posint = "Index `1` must be a positive integer.";
EulerEMonotone::badmethod = "Unknown method `1`. Use \"Rational\", \"Symbolic\", \"Numeric\", or \"Terms\".";
EulerEMonotone::infrat = "Infinity is only supported with Method -> \"Symbolic\".";

(* Legacy function - deprecated *)
EulerEMonotoneSum[k_Integer /; k >= 1] := EulerEMonotone[k, Method -> "Terms"]

(* ============================================ *)
(* ALTERNATING SERIES                          *)
(* ============================================ *)

Options[EulerEAlternating] = {Method -> "Rational", WorkingPrecision -> MachinePrecision};

(* Helper for shared logic *)
eulerEAlternatingImpl[n_, isInf_, opts___] := Module[
  {method, prec, base, terms, limit},
  method = OptionValue[EulerEAlternating, {opts}, Method];
  prec = OptionValue[EulerEAlternating, {opts}, WorkingPrecision];
  limit = If[isInf, Infinity, n - 1];

  Switch[method,
    "Symbolic",
      With[{nVal = limit, mm = Global`m},
        HoldForm[3 + Inactive[Sum][(-1)^(mm + 1) 2/(s[mm] s[mm + 1]), {mm, 0, nVal}]]
      ],

    "Rational",
      If[isInf, Message[EulerEAlternating::infrat]; $Failed,
        3 + Sum[(-1)^(k + 1) 2/(besselE[k] besselE[k + 1]), {k, 0, n - 1}]],

    "Numeric",
      If[isInf, Message[EulerEAlternating::infrat]; $Failed,
        N[3 + Sum[(-1)^(k + 1) 2/(besselE[k] besselE[k + 1]), {k, 0, n - 1}], prec]],

    "Terms",
      If[isInf,
        Message[EulerEAlternating::infrat]; $Failed,
        terms = Table[(-1)^(k + 1) 2/(besselE[k] besselE[k + 1]), {k, 0, n - 1}];
        Prepend[terms, 3]  (* {3, term_0, term_1, ...} so Total gives approximation *)
      ],

    _,
      Message[EulerEAlternating::badmethod, method]; $Failed
  ]
]

EulerEAlternating[n_Integer /; n >= 0, opts:OptionsPattern[]] := eulerEAlternatingImpl[n, False, opts]

EulerEAlternating[DirectedInfinity[1], opts:OptionsPattern[]] := eulerEAlternatingImpl[Infinity, True, opts]

EulerEAlternating[n_Integer /; n < 0, OptionsPattern[]] := (
  Message[EulerEAlternating::nonneg, n];
  $Failed
)

EulerEAlternating::nonneg = "Index `1` must be a non-negative integer.";
EulerEAlternating::badmethod = "Unknown method `1`. Use \"Rational\", \"Symbolic\", \"Numeric\", or \"Terms\".";
EulerEAlternating::infrat = "Infinity is only supported with Method -> \"Symbolic\".";

(* ============================================ *)
(* INTERVAL BOUNDS                             *)
(* ============================================ *)

EulerEInterval[k_Integer /; k >= 1] := Module[{lower, upper},
  lower = EulerEConvergent[2 k - 1];  (* odd T_n, below e *)
  upper = EulerEConvergent[2 k];      (* even T_n, above e *)
  Interval[{lower, upper}]
]

EulerEInterval[k_Integer /; k < 1] := (
  Message[EulerEInterval::posint, k];
  $Failed
)

EulerEInterval::posint = "Index `1` must be a positive integer.";

End[];

EndPackage[];
