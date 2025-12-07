(* ::Package:: *)

(* Symmetrized Trigonometric Functions via circ
   Key insight: Both Sin and Cos derive from a single function circ[t] = Cos[3π/4 + πt]
   via the same formula with opposite argument signs.

   Core identity: circ[t]² + circ[-t]² = 1 (unit circle)
   Spread connection: spread = (1 - circ)/2 (Wildberger's rational trigonometry)

   Reference: docs/sessions/2025-12-04-beta-functions-analysis/README.md
              docs/sessions/2025-12-07-chebyshev-integral-identity/README.md
*)

BeginPackage["Orbit`"];

(* Core circ function *)
Circ::usage = "Circ[t] is the symmetrized trigonometric function satisfying:
  Circ[t] = Cos[3π/4 + πt] = 1 - 2 Sin[π/2 (3/4 + t)]²

Key properties:
  - Circ[t]² + Circ[-t]² = 1 (unit circle identity)
  - Sin[θ] = Circ[(θ - 5π/4)/π]
  - Cos[θ] = Circ[-(θ - 5π/4)/π]
  - spread = (1 - Circ[t])/2 (connection to rational trigonometry)

Special values:
  Circ[0] = -1/√2, Circ[1/4] = -1, Circ[1/2] = -1/√2
  Circ[3/4] = 0, Circ[1] = 1/√2

The 5π/4 phase places the 'origin' at a symmetric point where
both sin and cos have the same formula structure.";

(* Standard trig via circ *)
CircSin::usage = "CircSin[t] computes Sin[t] via the Circ function.
  CircSin[t] = Circ[(t - 5π/4)/π]

This demonstrates that Sin is just Circ with a phase shift.";

CircCos::usage = "CircCos[t] computes Cos[t] via the Circ function.
  CircCos[t] = Circ[-(t - 5π/4)/π]

This demonstrates that Cos is Circ with negated argument and same phase shift.
The unification: Sin[t] = Circ[u], Cos[t] = Circ[-u] for appropriate u.";

(* Unit circle parametrization *)
CircPoint::usage = "CircPoint[t] returns {Circ[t], Circ[-t]} - a point on the unit circle.

This symmetric parametrization satisfies:
  CircPoint[t][[1]]² + CircPoint[t][[2]]² = 1

Key points:
  CircPoint[0] = {-1/√2, -1/√2}  (225°)
  CircPoint[1/4] = {-1, 0}       (180°)
  CircPoint[1/2] = {-1/√2, 1/√2} (135°)
  CircPoint[3/4] = {0, 1}        (90°)
  CircPoint[1] = {1/√2, 1/√2}    (45°)";

(* Spread connections (Wildberger's rational trigonometry) *)
CircToSpread::usage = "CircToSpread[c] converts a Circ value to spread.
  spread = (1 - c)/2

The spread is sin²(θ) in traditional notation, but defined algebraically
as a ratio of quadrances in Wildberger's rational trigonometry.

Bijection for rational spreads:
  Circ = 1   → spread = 0   (parallel)
  Circ = 1/2 → spread = 1/4 (30°)
  Circ = 0   → spread = 1/2 (45°)
  Circ = -1/2 → spread = 3/4 (60°)
  Circ = -1  → spread = 1   (perpendicular)";

SpreadToCirc::usage = "SpreadToCirc[s] converts a spread value to Circ value.
  Circ = 1 - 2s

Inverse of CircToSpread.";

(* Taylor series *)
CircTaylor::usage = "CircTaylor[t, n] returns the degree-n Taylor expansion of Circ[t] around t=0.

The series has a nice structure related to Circ[0] = -1/√2.";

(* Alternative representations *)
CircAlt::usage = "CircAlt[t] is an equivalent form: -(Cos[πt] + Sin[πt])/√2

Useful for verifying the Circ definition.";

(* Shifted Circ - cleaner for Chebyshev *)
CircS::usage = "CircS[t] is the shifted Circ function with cleaner properties:
  CircS[t] = Circ[t + 1/4] = -Cos[πt]

Key properties:
  - CircS is EVEN: CircS[t] = CircS[-t]
  - Simpler trig: Cos[πu] = -CircS[u], Sin[πu] = -CircS[1/2 - u]
  - Chebyshev: T_n(cos πu) = -CircS[nu]

Chebyshev recurrence via CircS:
  CircS[(n+1)u] = -2 CircS[u] CircS[nu] - CircS[(n-1)u]

Special values:
  CircS[0] = -1, CircS[±1/4] = -1/√2, CircS[±1/3] = -1/2
  CircS[±1/2] = 0, CircS[±2/3] = 1/2, CircS[±1] = 1";

CircSSin::usage = "CircSSin[t] computes Sin[t] via CircS.
  CircSSin[t] = -CircS[t/π - 1/2]

Cleaner than CircSin since CircS = -Cos[πt].";

CircSCos::usage = "CircSCos[t] computes Cos[t] via CircS.
  CircSCos[t] = -CircS[t/π]

Cleaner than CircCos since CircS = -Cos[πt].";

Begin["`Private`"];

(* Core definition *)
Circ[t_] := Cos[3 Pi/4 + Pi t]

(* Equivalent form for verification *)
CircAlt[t_] := -(Cos[Pi t] + Sin[Pi t])/Sqrt[2]

(* Standard trig via circ *)
CircSin[t_] := Circ[(t - 5 Pi/4)/Pi]
CircCos[t_] := Circ[-((t - 5 Pi/4)/Pi)]

(* Unit circle parametrization *)
CircPoint[t_] := {Circ[t], Circ[-t]}

(* Spread conversions *)
CircToSpread[c_] := (1 - c)/2
SpreadToCirc[s_] := 1 - 2 s

(* Taylor series *)
CircTaylor[t_, n_Integer] := Normal[Series[Circ[t], {t, 0, n}]]

(* Shifted Circ - cleaner for Chebyshev *)
CircS[t_] := Circ[t + 1/4]  (* = -Cos[Pi t] *)

(* Standard trig via CircS *)
CircSSin[t_] := -CircS[t/Pi - 1/2]
CircSCos[t_] := -CircS[t/Pi]

End[];

EndPackage[];
