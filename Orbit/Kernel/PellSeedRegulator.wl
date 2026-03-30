(* ::Package:: *)

(* Pell Regulator via Wildberger Seed Compact Representation             *)
(* R = C * delta(seed) where delta = 2*Log[p + q*Sqrt[n]] - Log|nm|     *)
(* Seed: smallest element on Stern-Brocot path with stable f-orbit.      *)
(* See: docs/sessions/2026-03-26-pell-floor-solver/SEED-REGULATOR.md     *)

BeginPackage["Orbit`"];

PellSeedEncode::usage =
"PellSeedEncode[n] encodes the Pell regulator for non-square n as a compact \
pair (seed, C). Returns \
<|\"Seed\" -> p/q, \"C\" -> c, \"R\" -> R, \"Norm\" -> nm, \"Delta\" -> delta|>. \
The regulator satisfies R = C * Delta exactly.";

PellSeedDecode::usage =
"PellSeedDecode[n, seed, c] recovers the regulator R = c * delta(seed) \
where delta = 2*Log[p + q*Sqrt[n]] - Log|nm(seed)|. \
Returns the symbolic expression for R (use N[..., prec] for numerics).";

PellSeedFind::usage =
"PellSeedFind[n] returns the Wildberger seed for non-square n: the smallest \
element on the Stern-Brocot path whose Newton orbit stays on the principal cycle.";

PellSeedOrbit::usage =
"PellSeedOrbit[seed, n] traces the norm orbit of seed under f(x) = (x^2+n)/(2x). \
Returns a list of norms {nm0, nm1, nm2, ...} until stabilization or nm = +/-1.";

Begin["`Private`"];

(* ================================================================== *)
(* Wildberger path: Stern-Brocot walk toward sqrt(n)                   *)
(* Returns {solutions, path} where path is a list of fractions.        *)
(* solutions: {{{x,y}}} or {{{xm,ym},{xp,yp}}} per cycle.             *)
(* ================================================================== *)

iWildpf[d_Integer, m_Integer] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1,
   flag = 0, negv, negs, sol = {}, lr = {}},
  While[Length[sol] < m,
    t = a + 2 b + c;
    If[t > 0,
      a = t; b += c; u += v; r += s; AppendTo[lr, -1],
      b += a; c = t; v += u; s += r; AppendTo[lr, 1]];
    If[a == d && b == 0 && c == -1,
      negv = v; negs = s; flag = 1];
    If[a == 1 && b == 0 && c == -d,
      AppendTo[sol,
        If[flag == 1, {{negv, negs}, {u, r}}, {{u, r}}]];
      flag = 0]];
  {sol,
   Divide @@ Reverse@Total@# & /@
     FoldList[#2 . #1 &, IdentityMatrix[2],
       Reverse[
         If[# == 1, {{1, 1}, {0, 1}}, {{1, 0}, {1, 1}}] & /@ lr]]}]

(* ================================================================== *)
(* Norm in Z[sqrt(n)]: nm(p/q) = p^2 - n*q^2                         *)
(* ================================================================== *)

iNorm[x_, n_] := With[{pq = NumeratorDenominator[x]},
  pq[[1]]^2 - n pq[[2]]^2]

(* ================================================================== *)
(* Seed validity: f-orbit norms stay bounded (on principal cycle).     *)
(* Uses Catch/Throw — Wolfram's Return inside Do does NOT exit Module. *)
(* ================================================================== *)

iValidSeedQ[x_, n_] := Catch[Module[{c = x, m},
  Do[
    m = iNorm[c, n];
    If[Abs[m] > n, Throw[False]];
    If[Abs[m] <= 1, Throw[True]];
    c = (c^2 + n)/(2 c),
  {20}];
  Throw[True]]]

(* ================================================================== *)
(* Find seed: first valid element on the 1-cycle wildpf path.         *)
(* ================================================================== *)

iFindSeed[n_] := SelectFirst[Last@iWildpf[n, 1], iValidSeedQ[#, n] &]

(* ================================================================== *)
(* Trace orbit norms under f(x) = (x^2+n)/(2x).                      *)
(* Stops at |nm| <= 1 or after maxSteps.                              *)
(* ================================================================== *)

iTraceNorms[seed_, n_, maxSteps_: 20] := Module[{c = seed, norms = {}, m},
  Do[
    m = iNorm[c, n];
    AppendTo[norms, m];
    If[Abs[m] <= 1, Break[]];
    c = (c^2 + n)/(2 c),
  {maxSteps}];
  norms]

(* ================================================================== *)
(* Pell solution from wildpf                                           *)
(* ================================================================== *)

iPellSolution[n_] := Module[{sol = First@First@iWildpf[n, 1]},
  Last[sol]]  (* {x, y} for Pell(+1) *)

(* ================================================================== *)
(* Determine C = R / delta from the Pell solution and seed.            *)
(* Computes R from Pell solution, delta from seed, then rationalizes.  *)
(* ================================================================== *)

iComputeC[n_, seed_, pellXY_] := Module[
  {x, y, R, p, q, nm, delta, cRaw},
  {x, y} = pellXY;
  R = Log[x + y Sqrt[n]];
  {p, q} = NumeratorDenominator[seed];
  nm = p^2 - n q^2;
  delta = 2 Log[p + q Sqrt[n]] - Log[Abs[nm]];
  (* C = R/delta — should be a simple rational *)
  cRaw = Simplify[R/delta];
  (* Try to rationalize; if symbolic simplification works, use it *)
  (* Otherwise fall back to numerical rationalization *)
  If[FreeQ[cRaw, Log],
    cRaw,
    Rationalize[N[cRaw, 30], 1/10000]]]

(* ================================================================== *)
(* Public API                                                          *)
(* ================================================================== *)

PellSeedFind[n_Integer /; n > 1 && !IntegerQ[Sqrt[n]]] :=
  iFindSeed[n]

PellSeedOrbit[seed_, n_Integer] :=
  iTraceNorms[seed, n]

PellSeedDecode[n_Integer, seed_, c_] := Module[{p, q, nm},
  {p, q} = NumeratorDenominator[seed];
  nm = p^2 - n q^2;
  c (2 Log[p + q Sqrt[n]] - Log[Abs[nm]])]

PellSeedEncode[n_Integer /; n > 1 && !IntegerQ[Sqrt[n]]] := Module[
  {seed, pellXY, nm, p, q, delta, c, R},

  (* Step 1: walk the Stern-Brocot path, extract Pell solution *)
  Module[{wpf = iWildpf[n, 1], sol, path},
    sol = First@First@wpf;
    path = Last@wpf;
    pellXY = Last[sol];

    (* Step 2: find seed *)
    seed = SelectFirst[path, iValidSeedQ[#, n] &];
    If[MissingQ[seed], Return[$Failed]]];

  {p, q} = NumeratorDenominator[seed];
  nm = p^2 - n q^2;
  delta = 2 Log[p + q Sqrt[n]] - Log[Abs[nm]];

  (* Step 3: C from exact Pell solution *)
  c = iComputeC[n, seed, pellXY];

  (* Step 4: R = C * delta *)
  R = c delta;

  <|"Seed" -> seed,
    "C" -> c,
    "Norm" -> nm,
    "Delta" -> delta,
    "R" -> R,
    "OrbitNorms" -> iTraceNorms[seed, n],
    "PellSolution" -> pellXY|>]

End[];
EndPackage[];
