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

EulerEMonotoneTermAnalytic::usage = "EulerEMonotoneTermAnalytic[t] returns the analytic continuation
of EulerEMonotoneTerm to complex t ∈ ℂ using Bessel K functions.

The continuation uses:
  y_n(x) = Sqrt[2/(π x)] Exp[1/x] BesselK[n + 1/2, 1/x]
  s(t) = (-1)^(t+1) y_{t+1}(-2)
  term[t] = 4(4t+3) / (s(2t-1) s(2t+1))

Properties:
  - Agrees with EulerEMonotoneTerm[j] at non-negative integers
  - Works in complex domain (use Re[] for real plots)
  - Reveals rapid exponential decay of terms

Examples:
  EulerEMonotoneTermAnalytic[t]  (* symbolic *)
  N[EulerEMonotoneTermAnalytic[1.5]]  (* numeric *)";

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

Formula: (-1)^(k+1) * 2 / (s(k) * s(k+1))

where s(n) = (-1)^(n+1) * y_{n+1}(-2) analytically continued.";

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

(* Analytic continuation helpers for BesselK representation *)
besselYContinued[n_, z_] := Sqrt[2/(Pi z)] Exp[1/z] BesselK[n + 1/2, 1/z];
besselSContinued[n_] := (-1)^(n + 1) besselYContinued[n + 1, -2];

(* Analytic continuation of EulerEMonotoneTerm via BesselK *)
(* Pure function: term[t] = 4*(4t+3)/(s[2t-1]*s[2t+1]) *)
EulerEMonotoneTermAnalytic[t_] :=
  4 (4 t + 3) / (besselSContinued[2 t - 1] besselSContinued[2 t + 1]);

(* Analytic continuation of the full e approximation *)
(* e = 1 + Sum[term, {j, 0, ∞}] *)
EulerEMonotoneAnalytic[t_Integer] := 1 + Sum[EulerEMonotoneTermAnalytic[jj], {jj, 0, t}];
EulerEMonotoneAnalytic[t_] := 1 + Inactive[Sum][EulerEMonotoneTermAnalytic[jj], {jj, 0, t}];

(* Alternating series term - analytic continuation *)
EulerEAlternatingTermAnalytic[k_] :=
  (-1)^(k + 1) * 2 / (besselSContinued[k] besselSContinued[k + 1]);

(* Alternating series - analytic continuation *)
EulerEAlternatingAnalytic[n_Integer] := 3 + Sum[EulerEAlternatingTermAnalytic[kk], {kk, 0, n - 1}];
EulerEAlternatingAnalytic[n_] := 3 + Inactive[Sum][EulerEAlternatingTermAnalytic[kk], {kk, 0, n - 1}];

(* ============================================ *)
(* ALTERNATIVE FORMULATION                     *)
(* ============================================ *)

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
arithmeticCFConvergent[n_Integer /; n >= 1] := Module[{p, q, pPrev, qPrev, pNew, qNew, a},
  (* Initialize: p_{-1}=1, p_0=0; q_{-1}=0, q_0=1 *)
  pPrev = 1; p = 0;
  qPrev = 0; q = 1;

  Do[
    a = 4 k + 2;
    pNew = a p + pPrev;
    qNew = a q + qPrev;
    pPrev = p; p = pNew;
    qPrev = q; q = qNew,
    {k, 1, n}
  ];

  p/q
]

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

End[];

EndPackage[];
