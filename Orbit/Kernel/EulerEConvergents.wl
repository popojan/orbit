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

Compare with EulerESquareCanonical (EVEN, real-valued for all real s).

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
(* FAST RECURRENCE (public API)                *)
(* ============================================ *)

EulerERational::usage = "EulerERational[n] returns the rational approximation to e,
computed via fast recurrence. Result equals EulerEConvergent[n].

Recurrence: a_{k+1} = (4k+6) * a_k + a_{k-1}
  - Numerator: p_1=19, p_2=193, ... → y_{n+1}(2) (Bessel polynomial)
  - Denominator: q_1=7, q_2=71, ... → s_n (CF denominator)

Convergence: ~2-3 decimal digits per step (increasing with n).

Options:
  Method -> \"Recurrence\" (default) | \"ClosedForm\" | \"Both\"

Methods:
  \"Recurrence\" - Iterative computation O(n), returns (p_n, q_n) pair
  \"ClosedForm\" - Via HypergeometricPFQ
  \"Both\" - Returns {recurrence_result, closed_form_result} for verification

Performance note: FromContinuedFraction is ~2x faster in Mathematica for n>50.
Recurrence is useful for: (1) getting (p,q) pair directly,
(2) implementation in other languages, (3) Bessel polynomial connection.

Examples:
  EulerERational[10]  (* 1098127402131/403978495031, ~25 digits *)
  EulerERational[5, Method -> \"Both\"]  (* verify agreement *)

See also: EulerEMonotone, BesselESequence, EulerEConvergent";

EulerERecurrencePair::usage = "EulerERecurrencePair[n] returns {p_n, q_n} where e ≈ p_n/q_n.

Uses fast iterative recurrence: a_{k+1} = (4k+6) * a_k + a_{k-1}
  p: starts 19, 193, ... (y_{n+1}(2))
  q: starts 7, 71, ...   (s_n)

Returns the raw numerator and denominator (large integers for large n).

Examples:
  EulerERecurrencePair[1]  (* {19, 7} *)
  EulerERecurrencePair[5]  (* {1084483, 398959} *)
  Apply[Divide, EulerERecurrencePair[10]]  (* same as EulerERational[10] *)";

(* ============================================ *)
(* ALTERNATIVE FORMULATION                     *)
(* ============================================ *)

(* ============================================ *)
(* INTERVAL BOUNDS                             *)
(* ============================================ *)

EulerEIntervalMediant::usage = "EulerEIntervalMediant[k] returns an Interval[{lower, upper}] bracketing e,
with RATIONAL bounds 10-40× tighter than EulerEInterval[k].

The lower bound is the mediant (Farey sum) of consecutive convergents:
  mediant(a/b, c/d) = (a+c)/(b+d)

Properties:
- Both bounds are RATIONAL (exact arithmetic)
- Width is ALWAYS a UNIT FRACTION (numerator = 1)
- Improvement factor grows with k: ~11× at k=1, ~43× at k=5
- Mediant is always below e for these convergent pairs

Comparison at same k:
  k=1: Standard ~4×10⁻³,  Mediant ~4×10⁻⁴  (11× better)
  k=2: Standard ~1×10⁻⁷,  Mediant ~6×10⁻⁹  (19× better)
  k=3: Standard ~5×10⁻¹³, Mediant ~2×10⁻¹⁴ (27× better)

See also: EInterval (alias), PiInterval, SqrtInterval";

EInterval::usage = "EInterval[k] is an alias for EulerEIntervalMediant[k].

Returns Interval[{lower, upper}] bracketing e with UNIT FRACTION width.

This parallels:
  - PiInterval (unit fraction width)
  - SqrtInterval (unit fraction when fundamental x is odd)

The three functions PiInterval, EInterval, SqrtInterval form a unified API
for interval bounds on fundamental constants with clean unit fraction widths.

See also: EulerEIntervalMediant, PiInterval, SqrtInterval";

EulerEIntervalHarmonic::usage = "EulerEIntervalHarmonic[k] returns an Interval[{lower, upper}] bracketing e,
with RATIONAL bounds exactly 2× tighter than EulerEInterval[k].

The lower bound is the harmonic mean of consecutive convergents:
  HM(a/b, c/d) = 2ac/(ad+bc)

Properties:
- Both bounds are RATIONAL
- Exactly 2× improvement (constant, independent of k)
- Equivalent to geometric mean but rational

See also: EulerEInterval, EulerEIntervalMediant";

EulerEIntervalGeometric::usage = "EulerEIntervalGeometric[k] returns an Interval[{lower, upper}] bracketing e,
with bounds ~2× tighter than EulerEInterval[k].

Computed as Sqrt[EulerESquareInterval[k]].

Properties:
- Bounds are ALGEBRAIC (square roots of rationals)
- ~2× improvement (same as harmonic mean)
- Uses geometric mean of consecutive Bessel ratios

See also: EulerEInterval, EulerEIntervalMediant, EulerEIntervalHarmonic";

EulerESquareInterval::usage = "EulerESquareInterval[k] returns an Interval[{lower, upper}] bracketing e².

Formula: bound(n) = |y_n(2) y_{n+1}(2) / (y_n(-2) y_{n+1}(-2))|
where y_n(x) is the Bessel polynomial.

Properties:
- lower = bound(2k) converges monotonically from below
- upper = bound(2k+1) converges monotonically from above
- Uses consecutive indices (n, n+1) with mixed parity for monotone convergence
- Width shrinks super-exponentially (~6 orders of magnitude per step)

First intervals:
  k=1: {7.378..., 7.391...}, width ~1.1×10⁻²
  k=2: {7.38905580..., 7.38905610...}, width ~3×10⁻⁷
  k=3: width ~1.3×10⁻¹²
  k=4: width ~1.6×10⁻¹⁸

Derivation: The original e² formula y_n(2)y_{n+2}(2)/(y_n(-2)y_{n+2}(-2)) alternates
because y_n(-2) = (-1)^n |y_n(-2)|. Using consecutive indices (n, n+1) with mixed
parity transforms alternating convergence into monotone interval bounds.

See also: EulerESquareIntervalAnalytic, EulerEIntervalGeometric";

EulerESquareIntervalAnalytic::usage = "EulerESquareIntervalAnalytic[t] returns the e² bound at continuous index t.

Uses BesselK-based analytic extension of Bessel polynomials:
  y_n(x) = Sqrt[2/(π x)] Exp[1/x] BesselK[n + 1/2, 1/x]

Indexing (shifted to match discrete version):
- t = k (integer): lower bound of EulerESquareInterval[k]
- t = k + 0.5: upper bound of EulerESquareInterval[k]
- t = k + 0.25: crosses e² (between lower and upper)
- Smooth interpolation between bounds

Examples:
  EulerESquareIntervalAnalytic[1]     (* lower bound of k=1 discrete *)
  EulerESquareIntervalAnalytic[1.25]  (* approximately e² *)
  EulerESquareIntervalAnalytic[1.5]   (* upper bound of k=1 discrete *)

See also: EulerESquareCanonical, EulerEMonotoneAnalytic";

EulerESquareCanonical::usage = "EulerESquareCanonical[s] is the canonical EVEN meromorphic form for e².

Formula:
  E² × K_{s-½}(½) K_{s+½}(½) / (K_{s-½}(-½) K_{s+½}(-½))

Properties:
- EVEN function: f(s) = f(-s)
- Meromorphic (analytic except at poles)
- Real at INTEGER s; complex at non-integers
- Sign: f(0) = -1, f(n) > 0 for n ≠ 0
- f(±∞) → e²
- Poles where K_{s±½}(-½) = 0 (off real axis)
- Zeros where K_{s±½}(½) = 0 (on imaginary axis)

Compare with EulerETermCanonical (ODD function for e).

See also: EulerETermCanonical, EulerESquareInterval";

EulerEIntervalAnalytic::usage = "EulerEIntervalAnalytic[t] returns the e bound at continuous index t.

Computed as Sqrt[EulerESquareIntervalAnalytic[t]].

Indexing:
- t = k (integer): lower bound (sqrt of e² lower bound)
- t = k + 0.5: upper bound
- t = k + 0.25: crosses e

See also: EulerESquareIntervalAnalytic, EulerEMonotoneAnalytic";

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

(* ============================================ *)
(* E² CF-BASED INTERVAL (UNIT FRACTION WIDTH)  *)
(* ============================================ *)

ESquareInterval::usage = "ESquareInterval[k] returns an Interval[{lower, upper}] bracketing e².

Uses continued fraction convergents for UNIT FRACTION interval widths.

CF of e² = [7; 2, 1, 1, 3, 18, 5, 1, 1, 6, 30, 8, 1, 1, 9, ...]

The CF has a beautiful quasi-periodic structure:
  Initial: {7, 2, 1, 1, 3}
  Then repeating: {12m+6, 3m+2, 1, 1, 3m+3} for m = 1, 2, 3, ...

Properties:
- Width = 1/(q_k * q_{k+1}) where q_n are CF denominators
- Width is ALWAYS a unit fraction (numerator = 1)
- Both bounds are exact rationals
- Exponential convergence (~2-3 digits per term)
- Requires integer k (CF-based, not symbolic)

This differs from EulerESquareInterval (Bessel polynomial based, non-unit-fraction width).

First intervals:
  k=1: {7, 15/2}, width = 1/2
  k=2: {15/2, 22/3}, width = 1/6
  k=3: {22/3, 37/5}, width = 1/15

Note: CF-based intervals (ESquareInterval, Log2Interval, etc.) require integer k.
Series-based intervals (SinInterval, CosInterval, etc.) support symbolic k.

See also: EInterval, EulerESquareInterval, Log2Interval";

ESquareCFConvergent::usage = "ESquareCFConvergent[n] returns the n-th CF convergent of e².

Uses the quasi-periodic CF pattern for exact computation to arbitrary depth.

Examples:
  ESquareCFConvergent[0]  (* 7 *)
  ESquareCFConvergent[1]  (* 15/2 *)
  ESquareCFConvergent[5]  (* 1264/171 *)";

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
      With[{kVal = limit, jj = \[FormalJ]},
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
      With[{nVal = limit, mm = \[FormalM]},
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

(* ============================================ *)
(* E² INTERVAL BOUNDS                          *)
(* ============================================ *)

(* bound(n) = |y_n(2) y_{n+1}(2) / (y_n(-2) y_{n+1}(-2))|
   - bound(2k) < e² (monotone from below)
   - bound(2k+1) > e² (monotone from above)
*)
eSquareBound[n_Integer] := Abs[
  BesselPolynomial[n, 2] BesselPolynomial[n + 1, 2] /
  (BesselPolynomial[n, -2] BesselPolynomial[n + 1, -2])
]

EulerESquareInterval[k_Integer /; k >= 1] := Module[{lower, upper},
  lower = eSquareBound[2 k];      (* even index, below e² *)
  upper = eSquareBound[2 k + 1];  (* odd index, above e² *)
  Interval[{lower, upper}]
]

EulerESquareInterval[k_Integer /; k < 1] := (
  Message[EulerESquareInterval::posint, k];
  $Failed
)

EulerESquareInterval::posint = "Index `1` must be a positive integer.";

(* Analytic extension of Bessel polynomial via BesselK *)
besselPolyAnalytic[n_, x_] := Sqrt[2/(Pi x)] * Exp[1/x] * BesselK[n + 1/2, 1/x]

(* Analytic e² bound - extends to non-integer t *)
eSquareBoundAnalytic[t_] := Abs[
  besselPolyAnalytic[t, 2] * besselPolyAnalytic[t + 1, 2] /
  (besselPolyAnalytic[t, -2] * besselPolyAnalytic[t + 1, -2])
]

(* EulerESquareCanonical - canonical EVEN meromorphic function
   BesselK indices (s - 1/2, s + 1/2) symmetric around s
   No Abs - true analytic continuation
*)
EulerESquareCanonical[s_] := E^2 *
  (BesselK[s - 1/2, 1/2] * BesselK[s + 1/2, 1/2]) /
  (BesselK[s - 1/2, -1/2] * BesselK[s + 1/2, -1/2])

(* Legacy alias *)
EulerESquareMeromorphic[s_] := EulerESquareCanonical[s]

(* EulerESquareIntervalAnalytic - analytic extension
   Shifted so t=k matches discrete EulerESquareInterval[k] lower bound
   internal index = 2t, so:
   - t=1 → lower bound of k=1 discrete
   - t=1.5 → upper bound of k=1 discrete
   - crossings at t = 1.25, 2.25, 3.25, ...
*)
EulerESquareIntervalAnalytic[t_?NumericQ] := eSquareBoundAnalytic[2 t]
EulerESquareIntervalAnalytic[t_Symbol] := eSquareBoundAnalytic[2 t]

(* EulerEIntervalAnalytic - analytic extension via sqrt of e² *)
EulerEIntervalAnalytic[t_?NumericQ] := Sqrt[eSquareBoundAnalytic[2 t]]
EulerEIntervalAnalytic[t_Symbol] := Sqrt[eSquareBoundAnalytic[2 t]]

(* Mediant interval: rational, 10-40× tighter *)
EulerEIntervalMediant[k_Integer /; k >= 1] := Module[{lo, hi, med},
  lo = EulerEConvergent[2 k - 1];  (* below e *)
  hi = EulerEConvergent[2 k];      (* above e *)
  med = (Numerator[lo] + Numerator[hi]) / (Denominator[lo] + Denominator[hi]);
  Interval[{med, hi}]  (* mediant is always below e for these pairs *)
]

EulerEIntervalMediant[k_Integer /; k < 1] := (
  Message[EulerEIntervalMediant::posint, k];
  $Failed
)

EulerEIntervalMediant::posint = "Index `1` must be a positive integer.";

(* EInterval - alias for EulerEIntervalMediant (unit fraction widths) *)
EInterval[k_Integer /; k >= 1] := EulerEIntervalMediant[k]
EInterval[k_Symbol] := EulerEIntervalMediant[k]
EInterval[k_Integer /; k < 1] := (Message[EulerEIntervalMediant::posint, k]; $Failed)

(* Harmonic mean interval: rational, exactly 2× tighter *)
EulerEIntervalHarmonic[k_Integer /; k >= 1] := Module[{lo, hi, hm},
  lo = EulerEConvergent[2 k - 1];
  hi = EulerEConvergent[2 k];
  hm = 2 lo hi / (lo + hi);  (* harmonic mean, rational *)
  Interval[{hm, hi}]
]

EulerEIntervalHarmonic[k_Integer /; k < 1] := (
  Message[EulerEIntervalHarmonic::posint, k];
  $Failed
)

EulerEIntervalHarmonic::posint = "Index `1` must be a positive integer.";

(* Geometric mean interval: algebraic (sqrt), ~2× tighter *)
EulerEIntervalGeometric[k_Integer /; k >= 1] := Sqrt[EulerESquareInterval[k]]

EulerEIntervalGeometric[k_Integer /; k < 1] := (
  Message[EulerEIntervalGeometric::posint, k];
  $Failed
)

EulerEIntervalGeometric::posint = "Index `1` must be a positive integer.";

(* ============================================ *)
(* FAST RECURRENCE FOR e APPROXIMATION         *)
(* ============================================ *)

(* Both numerator and denominator satisfy: a_{n+1} = (4n+2) * a_n + a_{n-1}
   Numerator p_n: p_0=1, p_1=3 → y_n(2) (Bessel polynomial at x=2)
   Denominator q_n: q_0=1, q_1=1 → s_{n-1} (CF denominator)
   Result: e_n = p_n / q_n converges to e with ~2-3 digits per step *)

(* Shifted recurrence: indices match EulerEConvergent[n] directly
   p_0=3, p_1=19 → y_{n+1}(2)
   q_0=1, q_1=7  → s_n
   Recurrence: a_{k+1} = (4k+6) a_k + a_{k-1} for k >= 1 *)

eulerERecurrence[n_Integer /; n >= 1] := Module[
  {p0 = 3, p1 = 19, q0 = 1, q1 = 7, pPrev, pCurr, pNext, qPrev, qCurr, qNext},
  If[n == 1, Return[{19, 7}]];

  pPrev = p0; pCurr = p1;
  qPrev = q0; qCurr = q1;

  Do[
    pNext = (4 k + 6) pCurr + pPrev;
    qNext = (4 k + 6) qCurr + qPrev;
    pPrev = pCurr; pCurr = pNext;
    qPrev = qCurr; qCurr = qNext;
  , {k, 1, n - 1}];

  {pCurr, qCurr}
]

eulerERecurrence[0] := {3, 1}  (* edge case: y_1(2)/s_0 = 3/1 *)

(* Closed form via HypergeometricPFQ - shifted to match EulerEConvergent *)
eulerEClosedForm[n_Integer /; n >= 1] := Module[{pn, qn},
  (* p_n = y_{n+1}(2) = HypergeometricPFQ[{-(n+1), n+2}, {}, -1] *)
  pn = HypergeometricPFQ[{-n - 1, n + 2}, {}, -1];
  (* q_n = s_n = BesselESequence[n] *)
  qn = besselE[n];
  {pn, qn}
]

eulerEClosedForm[0] := {3, 1}  (* y_1(2) / s_0 = 3/1 *)

(* Public API *)
EulerERecurrencePair[n_Integer /; n >= 1] := eulerERecurrence[n]

EulerERecurrencePair[n_Integer /; n < 1] := (
  Message[EulerERecurrencePair::posint, n];
  $Failed
)

EulerERecurrencePair::posint = "Index `1` must be a positive integer (n ≥ 1).";

Options[EulerERational] = {Method -> "Recurrence"};

EulerERational[n_Integer /; n >= 1, OptionsPattern[]] := Module[
  {method, pqRec, pqClosed},
  method = OptionValue[Method];

  Switch[method,
    "Recurrence",
      Apply[Divide, eulerERecurrence[n]],

    "ClosedForm",
      Apply[Divide, eulerEClosedForm[n]],

    "Both",
      pqRec = eulerERecurrence[n];
      pqClosed = eulerEClosedForm[n];
      {Apply[Divide, pqRec], Apply[Divide, pqClosed]},

    _,
      Message[EulerERational::badmethod, method]; $Failed
  ]
]

EulerERational[n_Integer /; n < 1, OptionsPattern[]] := (
  Message[EulerERational::posint, n];
  $Failed
)

EulerERational::posint = "Index `1` must be a positive integer (n ≥ 1).";
EulerERational::badmethod = "Unknown method `1`. Use \"Recurrence\", \"ClosedForm\", or \"Both\".";

(* ============================================ *)
(* E² CF-BASED INTERVAL                        *)
(* ============================================ *)

(* Generate e² CF terms using quasi-periodic pattern:
   Initial: {7, 2, 1, 1, 3}
   Then: {12k+6, 3k+2, 1, 1, 3k+3} for k = 1, 2, 3, ...
*)
eSquareCFTerm[0] := 7
eSquareCFTerm[1] := 2
eSquareCFTerm[2] := 1
eSquareCFTerm[3] := 1
eSquareCFTerm[4] := 3
eSquareCFTerm[n_Integer /; n >= 5] := Module[{k, pos},
  (* n = 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, ... *)
  (* Maps to k = 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, ... *)
  (* pos in group = 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, ... *)
  k = Quotient[n - 5, 5] + 1;
  pos = Mod[n - 5, 5];
  Switch[pos,
    0, 12 k + 6,
    1, 3 k + 2,
    2, 1,
    3, 1,
    4, 3 k + 3
  ]
]

(* Generate first n+1 CF terms *)
eSquareCFTerms[n_Integer] := Table[eSquareCFTerm[i], {i, 0, n}]

(* CF convergent from terms *)
ESquareCFConvergent[n_Integer /; n >= 0] := FromContinuedFraction[eSquareCFTerms[n]]

ESquareCFConvergent[n_Integer /; n < 0] := (
  Message[ESquareCFConvergent::nonneg, n];
  $Failed
)

ESquareCFConvergent::nonneg = "Index `1` must be a non-negative integer.";

(* E² interval using CF convergents *)
ESquareInterval[k_Integer /; k >= 1] := Module[{c1, c2},
  c1 = ESquareCFConvergent[k - 1];
  c2 = ESquareCFConvergent[k];
  Interval[{Min[c1, c2], Max[c1, c2]}]
]

ESquareInterval[k_Integer /; k < 1] := (
  Message[ESquareInterval::posk, k];
  $Failed
)

ESquareInterval::posk = "Index `1` must be a positive integer.";

End[];

EndPackage[];
