(* ::Package:: *)

(* CircFunctions: Rational Circle Algebra

   The unit circle parametrized so that multiplication is just addition:
     t1 \[Cross] t2 = t1 + t2 + 5/4

   All operations stay in rationals until explicitly converted to coordinates.

   Two dual frameworks exist (5/4 vs 7/4), related by t \[LeftRightArrow] 1-t.

   Reference: docs/sessions/2025-12-07-circ-hartley-exploration/README.md
*)

BeginPackage["Orbit`"];

(* ============================================ *)
(* CORE: RATIONAL PARAMETER ALGEBRA             *)
(* All operations return rationals!             *)
(* ============================================ *)

CircTimes::usage = "CircTimes[t1, t2] = t1 + t2 + 5/4
Multiplication of circle parameters. Returns rational.
Infix: t1 \[CircleTimes] t2 (Esc c* Esc)
Also available as: t1 ⊗ t2";

CircPower::usage = "CircPower[t, n] = n*t + 5(n-1)/4
Power of circle parameter. Returns rational.
Infix: t \[CircleDot] n (Esc c. Esc)
Also available as: t ⊙ n";

CircInverse::usage = "CircInverse[t] = -t - 5/2
Multiplicative inverse. Returns rational.
Satisfies: CircTimes[t, CircInverse[t]] = CircIdentity";

CircShift::usage = "CircShift[t] = t + 1/2
Multiplication by i (90\[Degree] rotation). Returns rational.";

CircConjugate::usage = "CircConjugate[t] = 3/2 - t
Complex conjugate. Returns rational.
Postfix: SuperStar[t] displays as t* (Ctrl+^ then * in notebook)
Note: NOT -t (that swaps coordinates).";

CircDual::usage = "CircDual[t] = 1 - t
Switch between frameworks A (5/4) and B (7/4). Returns rational.";

CircNormalize::usage = "CircNormalize[t] reduces to canonical range [-1/4, 7/4).
Returns rational.";

CircRoot::usage = "CircRoot[n] or CircRoot[n, k] = 2k/n - 5/4
The k-th n-th root of unity (k defaults to 1 = primitive root).
Alias: \[Rho][n] (Esc r Esc)";

\[Rho]::usage = "\[Rho][n] = primitive n-th root of unity (k=1)
\[Rho][n, k] = k-th n-th root of unity = 2k/n - 5/4
Named after \[Rho]\[Iota]\[Zeta]\[Alpha] (rhiza) = root in Greek.
Type: Esc r Esc

Example - Gauss's 17-star (Braunschweig monument):
  Polygon[\[Kappa][\[Rho][17] \[CircleDot] 3#] & /@ Range[17]]";

(* Constants *)
CircIdentity::usage = "CircIdentity = -5/4, the multiplicative identity.
Equivalent to 3/4 (mod 2). Represents {1, 0}.";

CircImaginary::usage = "CircImaginary = -3/4, represents i.
Equivalent to 5/4 (mod 2). Represents {0, 1}.";

CircFrameworkA::usage = "CircFrameworkA = 5/4, multiplication offset for framework A.";
CircFrameworkB::usage = "CircFrameworkB = 7/4, multiplication offset for framework B.";

(* Framework B multiplication *)
CircTimesB::usage = "CircTimesB[t1, t2] = t1 + t2 + 7/4
Multiplication in framework B. Returns rational.";

(* ============================================ *)
(* BRIDGES TO COORDINATES                       *)
(* These are the ONLY functions that evaluate   *)
(* ============================================ *)

\[Gamma]::usage = "\[Gamma][t] - rational circle function (inert symbolic form).
The primary representation. Use N[] for numeric, \[Alpha][] for classical trig.
\[Gamma][t] corresponds to Cos[3\[Pi]/4 + \[Pi]t] but stays symbolic.
Named after \[Gamma]\[Omega]\[Nu]\[Iota]\[Alpha] (gonia) = angle in Greek.
Type: Esc g Esc
Historical alias: Circ (for compatibility with earlier notebooks/docs)";

\[Alpha]::usage = "\[Alpha][expr] - reveal classical (ancient) trig form.
Converts \[Gamma] to Cos/Sin throughout expr.
Named after Activate and Ancient (classical) form.
Type: Esc a Esc";

(* γ: inert symbolic form *)
SetAttributes[\[Gamma], {NumericFunction}];
\[Gamma] /: N[\[Gamma][t_], args___] := N[Cos[3 Pi/4 + Pi t], args];

(* Simplification upvalues *)
\[Gamma] /: \[Gamma][t_ + 1/2] := \[Gamma][-t];              (* Shift = negation *)
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
\[Alpha][expr_] := expr /. \[Gamma][t_] :> Cos[3 Pi/4 + Pi t];

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

(* Constants *)
CircIdentity = -5/4;
CircImaginary = -3/4;
CircFrameworkA = 5/4;
CircFrameworkB = 7/4;

(* Operations - all return rationals *)
CircTimes[t1_, t2_] := t1 + t2 + 5/4
CircTimesB[t1_, t2_] := t1 + t2 + 7/4
CircPower[t_, n_Integer] := n t + 5 (n - 1)/4
CircInverse[t_] := -t - 5/2
CircShift[t_] := t + 1/2
CircConjugate[t_] := 3/2 - t
CircDual[t_] := 1 - t
CircNormalize[t_] := Mod[t + 1/4, 2] - 1/4
(* Accepts integer or list of integers; formula threads via arithmetic *)
CircRoot[n_Integer, k:(_Integer|{__Integer}): 1] := 2 k/n - 5/4
\[Rho][n_Integer, k:(_Integer|{__Integer}): 1] := CircRoot[n, k]

(* ============================================ *)
(* INFIX OPERATOR \[CircleTimes] = ⊗            *)
(* Type: Esc c* Esc                             *)
(* ============================================ *)

(* Binary case *)
CircleTimes[t1_, t2_] := t1 + t2 + 5/4

(* Variadic case for chaining: a ⊗ b ⊗ c *)
CircleTimes[t1_, t2_, rest__] := CircleTimes[CircleTimes[t1, t2], rest]

(* ============================================ *)
(* INFIX OPERATOR \[CircleDot] = ⊙ (power)      *)
(* Type: Esc c. Esc                             *)
(* Precedence 520 > CircleTimes 420             *)
(* Threads over lists via arithmetic            *)
(* ============================================ *)

CircleDot[t_, n:(_Integer|{__Integer})] := n t + 5 (n - 1)/4

(* ============================================ *)
(* POSTFIX SuperStar (conjugate)                *)
(* Type: Ctrl+^ then * in notebook              *)
(* Or just use: SuperStar[t]                    *)
(* ============================================ *)

SuperStar[t_] := 3/2 - t

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

(* List threading - MUST come first! *)
\[Kappa][t_List] := Transpose[{\[Gamma] /@ (-t), \[Gamma] /@ t}]
\[Kappa][t_List, p_] := \[Kappa][#, p] & /@ t
\[Kappa][t_, p_List] := \[Kappa][t, #] & /@ p

(* p = 2 (default): Euclidean circle - γ stays inert *)
\[Kappa][t_] := {\[Gamma][-t], \[Gamma][t]}
\[Kappa][t_, 2] := {\[Gamma][-t], \[Gamma][t]}

(* p = 1: Taxicab diamond - symbolic with γ *)
\[Kappa][t_, 1] := {\[Gamma][-t], \[Gamma][t]} / (Abs[\[Gamma][-t]] + Abs[\[Gamma][t]])

(* p = ∞: Chebyshev square - symbolic with γ *)
\[Kappa][t_, DirectedInfinity[1]] := \[Kappa][t, Infinity]
\[Kappa][t_, Infinity] := {\[Gamma][-t], \[Gamma][t]} / Max[Abs[\[Gamma][-t]], Abs[\[Gamma][t]]]

(* General p - symbolic with γ *)
\[Kappa][t_, p_] /; p > 0 && p != 2 :=
  {\[Gamma][-t], \[Gamma][t]} (Abs[\[Gamma][-t]]^p + Abs[\[Gamma][t]]^p)^(-1/p)

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
