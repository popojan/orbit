(* ::Package:: *)

(* CircFunctions: Rational Circle Algebra (v2 - 7-centered parametrization)

   The unit circle parametrized so that multiplication is just addition:
     t1 \[Cross] t2 = t1 + t2 + 7/4

   All operations stay in rationals until explicitly converted to coordinates.

   Key design choice: self-dual point at t = 0, duality is simple negation.
   The number 7 has prominent role: offset = 7/4, identity = -7/4.

   Dual frameworks (±7/4) are symmetric around 0, related by t \[LeftRightArrow] -t.

   v2 changes (Dec 2025):
     - γ: Cos[3π/4 + πt] → Cos[5π/4 + πt]
     - κ: {γ[-t], γ[t]} → {-γ[-t], γ[t]}
     - Self-dual point: t = 1/2 → t = 0
     - CircDual: (1-t) → (-t)
     - All offsets: 5/4 → 7/4

   Reference: docs/sessions/2025-12-07-circ-hartley-exploration/README.md
*)

BeginPackage["Orbit`"];

(* ============================================ *)
(* CORE: RATIONAL PARAMETER ALGEBRA             *)
(* All operations return rationals!             *)
(* ============================================ *)

CircTimes::usage = "CircTimes[t1, t2] = t1 + t2 + 7/4
Multiplication of circle parameters. Returns rational.
Infix: t1 \[CircleTimes] t2 (Esc c* Esc)
Also available as: t1 ⊗ t2";

CircPower::usage = "CircPower[t, n] = n*t + 7(n-1)/4
Power of circle parameter. Returns rational.
Infix: t \[CircleDot] n (Esc c. Esc)
Also available as: t ⊙ n";

CircInverse::usage = "CircInverse[t] = -t - 7/2
Multiplicative inverse. Returns rational.
Satisfies: CircTimes[t, CircInverse[t]] = CircIdentity";

CircShift::usage = "CircShift[t] = t + 1/2
Multiplication by i (90\[Degree] rotation). Returns rational.";

CircConjugate::usage = "CircConjugate[t] = 1/2 - t
Complex conjugate. Returns rational.
Postfix: SuperStar[t] displays as t* (Ctrl+^ then * in notebook)
Note: NOT -t (that's duality, not conjugation).";

CircDual::usage = "CircDual[t] = -t
Switch between frameworks A (+7/4) and B (-7/4). Returns rational.
In v2, duality is simple negation—maximally symmetric.";

CircNormalize::usage = "CircNormalize[t] reduces to canonical range [-1, 1).
Returns rational. Centered around self-dual point t = 0.";

CircRoot::usage = "CircRoot[n] or CircRoot[n, k] = 2k/n - 7/4
The k-th n-th root of unity (k defaults to 1 = primitive root).
Alias: \[Rho][n] (Esc r Esc)";

\[Rho]::usage = "\[Rho][n] = primitive n-th root of unity (k=1)
\[Rho][n, k] = k-th n-th root of unity = 2k/n - 7/4
Named after \[Rho]\[Iota]\[Zeta]\[Alpha] (rhiza) = root in Greek.
Type: Esc r Esc

Example - Gauss's 17-star (Braunschweig monument):
  Polygon[\[Kappa][\[Rho][17] \[CircleDot] 3#] & /@ Range[17]]";

(* Constants *)
CircIdentity::usage = "CircIdentity = -7/4, the multiplicative identity.
Equivalent to 1/4 (mod 2). Represents {1, 0}.";

CircImaginary::usage = "CircImaginary = 3/4, represents i.
Represents {0, 1} at angle π/2.";

CircFrameworkA::usage = "CircFrameworkA = 7/4, multiplication offset for framework A (main).";
CircFrameworkB::usage = "CircFrameworkB = -7/4, multiplication offset for framework B (dual).
Note: A and B are negatives—symmetric around the self-dual point t = 0.";

(* Framework B multiplication *)
CircTimesB::usage = "CircTimesB[t1, t2] = t1 + t2 - 7/4
Multiplication in framework B (dual). Returns rational.
Related to CircTimes via: CircTimesB[t1, t2] = -CircTimes[-t1, -t2]";

(* ============================================ *)
(* BRIDGES TO COORDINATES                       *)
(* These are the ONLY functions that evaluate   *)
(* ============================================ *)

\[Gamma]::usage = "\[Gamma][t] - rational circle function (inert symbolic form).
The primary representation. Use N[] for numeric, \[Alpha][] for classical trig.
\[Gamma][t] corresponds to Cos[5\[Pi]/4 + \[Pi]t] but stays symbolic.
Named after \[Gamma]\[Omega]\[Nu]\[Iota]\[Alpha] (gonia) = angle in Greek.
Type: Esc g Esc
Historical alias: Circ (for compatibility with earlier notebooks/docs)
v2: angle shifted from 3π/4 to 5π/4 for 7-centered parametrization.";

\[Alpha]::usage = "\[Alpha][expr] - reveal classical (ancient) trig form.
Converts \[Gamma] to Cos/Sin throughout expr.
Named after Activate and Ancient (classical) form.
Type: Esc a Esc";

(* γ: inert symbolic form *)
SetAttributes[\[Gamma], {NumericFunction}];
\[Gamma] /: N[\[Gamma][t_], args___] := N[Cos[5 Pi/4 + Pi t], args];

(* Simplification upvalues - v2 *)
\[Gamma] /: \[Gamma][t_ - 1/2] := \[Gamma][-t];              (* Half-shift symmetry *)
\[Gamma] /: \[Gamma][t_ + n_Integer /; Abs[n] >= 2] := \[Gamma][t + Mod[n, 2]];  (* Period 2: integers *)
\[Gamma] /: \[Gamma][t_ + r_Rational /; Abs[r] >= 2] := \[Gamma][t + Mod[r, 2]]; (* Period 2: rationals *)

(* Pythagorean identity via Plus upvalue *)
(* Works for: γ[t]² + γ[-t]², γ[1/4]² + γ[-1/4]² *)
(* Does NOT work for: γ[x+1]² + γ[-x-1]² (complex expressions) *)
Unprotect[Plus];
Plus /: \[Gamma][t_]^2 + \[Gamma][-t_]^2 := 1;
Plus /: \[Gamma][a_?NumericQ]^2 + \[Gamma][b_?NumericQ]^2 /; a + b == 0 := 1;
Protect[Plus];

(* α: reveal classical trig form *)
\[Alpha][expr_] := expr /. \[Gamma][t_] :> Cos[5 Pi/4 + Pi t];

(* Backward compatibility alias *)
Circ = \[Gamma];

\[Kappa]::usage = "\[Kappa][t] or \[Kappa][t, p] = point on unit L^p 'circle'
Default p = 2 (Euclidean). Other geometries:
  p = 1: Taxicab (diamond), \[Pi] = 4
  p = 2: Euclidean (circle), \[Pi] \[TildeTilde] 3.14159
  p = \[Infinity]: Chebyshev (square), \[Pi] = 4
Named after \[Kappa]\[Upsilon]\[Kappa]\[Lambda]\[Omicron]\[FinalSigma] (kyklos) = circle in Greek.
Type: Esc k Esc";

\[CurlyPhi]::usage = "\[CurlyPhi][t] or \[CurlyPhi][t, p] = unit L^p 'circle' point as complex number
Default p = 2 (Euclidean). Equivalent to \[Kappa][t, p] . {1, I}.
Named after \[CurlyPhi]\[Alpha]\[Nu]\[Tau]\[Alpha]\[Sigma]\[Iota]\[Alpha] (phantasia) = imagination in Greek.
Type: Esc j Esc (or Esc cph Esc)";

(* ============================================ *)
(* SQUARICAL: L^p GEOMETRY                     *)
(* ============================================ *)

\[Pi]Lp::usage = "\[Pi]Lp[p] = ratio of circumference to diameter in L^p geometry.
  \[Pi]Lp[1] = 4 (Taxicab)
  \[Pi]Lp[2] = \[Pi] (Euclidean)
  \[Pi]Lp[\[Infinity]] = 4 (Chebyshev)
General formula: \[Pi]Lp[p] = 2^(1+1/p) \[CapitalGamma](1+1/p)^2 / \[CapitalGamma](1+2/p)
The minimum is at p = 2 (Euclidean geometry).";

Begin["`Private`"];

(* ============================================ *)
(* RATIONAL ALGEBRA                             *)
(* ============================================ *)

(* Constants - v2: 7-centered *)
CircIdentity = -7/4;
CircImaginary = 3/4;
CircFrameworkA = 7/4;
CircFrameworkB = -7/4;

(* Operations - all return rationals - v2: 7-centered *)
CircTimes[t1_, t2_] := t1 + t2 + 7/4
CircTimesB[t1_, t2_] := t1 + t2 - 7/4
CircPower[t_, n_Integer] := n t + 7 (n - 1)/4
CircInverse[t_] := -t - 7/2
CircShift[t_] := t + 1/2  (* unchanged! *)
CircConjugate[t_] := 1/2 - t
CircDual[t_] := -t  (* v2: simple negation *)
CircNormalize[t_] := Mod[t + 1, 2] - 1  (* centered at 0 *)
(* Fully symbolic; formula threads via arithmetic *)
CircRoot[n_, k_: 1] := 2 k/n - 7/4
\[Rho][n_, k_: 1] := 2 k/n - 7/4

(* ============================================ *)
(* INFIX OPERATOR \[CircleTimes] = ⊗            *)
(* Type: Esc c* Esc                             *)
(* ============================================ *)

(* Binary case - v2 *)
CircleTimes[t1_, t2_] := t1 + t2 + 7/4

(* Variadic case for chaining: a ⊗ b ⊗ c *)
CircleTimes[t1_, t2_, rest__] := CircleTimes[CircleTimes[t1, t2], rest]

(* ============================================ *)
(* INFIX OPERATOR \[CircleDot] = ⊙ (power)      *)
(* Type: Esc c. Esc                             *)
(* Precedence 520 > CircleTimes 420             *)
(* Threads over lists via arithmetic            *)
(* ============================================ *)

CircleDot[t_, n:(_Integer|{__Integer})] := n t + 7 (n - 1)/4

(* ============================================ *)
(* POSTFIX SuperStar (conjugate)                *)
(* Type: Ctrl+^ then * in notebook              *)
(* Or just use: SuperStar[t]                    *)
(* ============================================ *)

SuperStar[t_] := 1/2 - t  (* v2: conjugate formula *)

(* ============================================ *)
(* BRIDGES - EVALUATE TO COORDINATES            *)
(* ============================================ *)

(* φ: delegates to κ, no duplicated logic *)
\[CurlyPhi][t_] := \[Kappa][t] . {1, I}
\[CurlyPhi][t_, p_] := \[Kappa][t, p] . {1, I}
\[CurlyPhi][t_, p_List] := \[CurlyPhi][t, #] & /@ p

(* ============================================ *)
(* κ: L^p GEOMETRY BRIDGE                       *)
(* κ[t] = Euclidean (p=2), κ[t, p] = general    *)
(* ============================================ *)

(* List threading - MUST come first! - v2: note minus on x-component *)
\[Kappa][t_List] := Transpose[{-\[Gamma] /@ (-t), \[Gamma] /@ t}]
\[Kappa][t_List, p_] := \[Kappa][#, p] & /@ t
\[Kappa][t_, p_List] := \[Kappa][t, #] & /@ p

(* Symbolic absolute value of γ - v2 *)
(* Sign[Cos[x]] = (-1)^Floor[x/π + 1/2] *)
(* For γ[t] = Cos[5π/4 + πt]: Sign[γ[t]] = (-1)^Floor[t + 7/4] *)
(* |γ[t]| = Sign[γ[t]] × γ[t] *)
absGamma[t_?NumericQ] := With[{sign = (-1)^Floor[t + 7/4]}, sign * \[Gamma][t]]
absGamma[t_] := (-1)^Floor[t + 7/4] * \[Gamma][t]  (* symbolic fallback *)

(* p = 2 (default): Euclidean circle - v2: minus on x-component *)
\[Kappa][t_] := {-\[Gamma][-t], \[Gamma][t]}
\[Kappa][t_, 2] := {-\[Gamma][-t], \[Gamma][t]}

(* p = 1: Taxicab diamond - v2 *)
\[Kappa][t_, 1] := {-\[Gamma][-t], \[Gamma][t]} / (absGamma[-t] + absGamma[t])

(* p = ∞: Chebyshev square - v2 *)
\[Kappa][t_, DirectedInfinity[1]] := \[Kappa][t, Infinity]
\[Kappa][t_, Infinity] := Module[{ag1 = absGamma[-t], ag2 = absGamma[t]},
  {-\[Gamma][-t], \[Gamma][t]} / If[ag1 >= ag2, ag1, ag2]
]

(* General p - integer: compute norm via Cos (avoids γ precision issues) - v2 *)
\[Kappa][t_?NumericQ, p_Integer] /; p >= 3 := Module[
  {c1 = Cos[5 Pi/4 - Pi t], c2 = Cos[5 Pi/4 + Pi t], norm},
  norm = (Abs[c1]^p + Abs[c2]^p)^(1/p);
  {-\[Gamma][-t], \[Gamma][t]} / norm
]

(* General p - non-integer - v2 *)
\[Kappa][t_, p_] /; p > 0 && p != 2 && !IntegerQ[p] :=
  {-\[Gamma][-t], \[Gamma][t]} / (absGamma[-t]^p + absGamma[t]^p)^(1/p)

(* ============================================ *)
(* NOTE: POLAR EXTENSION (not implemented)     *)
(* ============================================ *)
(*
   Considered extending to arbitrary complex numbers via (angle, magnitude)
   pairs where both components stay rational. Analysis (Dec 2025):

   WHAT WORKS (multiplicative operations):
     (t₁, m₁) × (t₂, m₂) = (t₁ ⊗ t₂, m₁ · m₂)
     (t₁, m₁) / (t₂, m₂) = (t₁ - t₂ - 7/4, m₁ / m₂)   (* v2: 7/4 offset *)
     (t, m)^n = (t ⊙ n, m^n)
     (t, m)* = (1/2 - t, m)   (* v2: conjugate formula *)

   WHAT BREAKS:
     Addition: z₁ + z₂ requires converting to Cartesian, producing
     irrational magnitude (√...) and angle (arctan). The "stays rational"
     property is lost.

   DECISION: Not worth the complexity. For roots of unity (main use case),
   magnitude is always 1. For general complex arithmetic, addition is
   fundamental and breaks the framework anyway.

   MANUAL WORKAROUND: User can track {t, m} pairs and apply operations:
     {t1 ⊗ t2, m1 * m2}           (* multiply *)
     {t1 - t2 - 7/4, m1 / m2}     (* divide - v2 *)
     {t ⊙ n, m^n}                 (* power *)
     m * κ[t] or m * φ[t]         (* convert to coordinates *)

   Note: κ[t, p] already uses second parameter for L^p geometry.
*)

(* ============================================ *)
(* πLp: π as function of L^p geometry          *)
(* ============================================ *)

(* Special cases - exact symbolic *)
\[Pi]Lp[1] = 4;                      (* Taxicab *)
\[Pi]Lp[2] = Pi;                     (* Euclidean *)
\[Pi]Lp[Infinity] = 4;               (* Chebyshev *)
\[Pi]Lp[DirectedInfinity[1]] = 4;

(* General case: numerical integration of L^p arc length *)
(* Circumference / Diameter, measuring in L^p metric *)
\[Pi]Lp[p_?NumericQ] /; p > 0 && p != 1 && p != 2 := Module[
  {pts, diffs},
  pts = Table[N[\[Kappa][t, p]], {t, 0, 2, 1/1000}];
  diffs = Differences[pts];
  Total[(Abs[#[[1]]]^p + Abs[#[[2]]]^p)^(1/p) & /@ diffs] / 2
]

End[];

EndPackage[];
