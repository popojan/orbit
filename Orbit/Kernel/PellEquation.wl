(* ::Package:: *)

(* PellEquation: Core Pell solver, regulator, and fundamental extraction *)
(* Consolidates: PellRegulator.wl, PellSolution from SquareRootRationalizations *)

BeginPackage["Orbit`"];

PellSolve::usage = "PellSolve[d] returns {x, y} — the fundamental solution to x^2 - d y^2 = 1.
Uses Wildberger's algorithm (O(L) where L is the CF period).";

PellSolution::usage = "PellSolution[d] finds the fundamental solution {x, y} to the Pell equation x^2 - d y^2 = 1.

Returns: {x -> value, y -> value}

Backward-compatible wrapper around PellSolve.";

PellRegulator::usage = "PellRegulator[n] computes the regulator R = Log[x + y Sqrt[n]] of the fundamental unit.
Returns <|\"R\" -> regulator, \"Digits\" -> precision, \"Steps\" -> baby+giant count|>.
Uses infrastructure BSGS (Buchmann-Williams) with O(Sqrt[L]) steps.
Convention: returns R for fundamental unit, even if norm = -1 (PARI convention).";

PellRegulatorInteger::usage = "PellRegulatorInteger[n] computes Round[R] where R is the Pell regulator.
Single-pass BSGS at pp=50, minimal disambiguation. Fastest variant.
Returns <|\"R\" -> Round[R], \"Steps\" -> count|>.";

PellRegulatorPARI::usage = "PellRegulatorPARI[n] computes the Pell regulator via PARI/GP quadunit(4n). Requires gp on PATH.";

PellFundamentalExtract::usage = "PellFundamentalExtract[x, y, d] extracts the fundamental solution from (x + y Sqrt[d])^k.

Given any Pell solution (x, y) with x^2 - d y^2 = 1, finds the minimal positive
solution by generating CF convergents of Sqrt[d].

Returns: {fx, fy}";

PellBallotCount::usage = "PellBallotCount[d, {x, y}] counts monotonic lattice paths from (1,0) to (x,y)
that stay above the Pell hyperbola u^2 - d*v^2 >= 1.

Uses dynamic programming. Every visited lattice point must satisfy the constraint.
Steps are unit right (+1,0) and unit up (0,+1).

The Pell-Ballot conjecture states that for points (x,y) on the CF path of Sqrt[d],
this count equals the ballot number Binomial[x+y-1, y]/x.

Examples:
  PellBallotCount[2, {3, 2}]    (* -> 2 = C_2 *)
  PellBallotCount[13, {4, 1}]   (* -> 1, norm 3 point on CF path *)";

PellBallotQ::usage = "PellBallotQ[d, {x, y}] returns True if the lattice path count from (1,0) to (x,y)
above x^2 - d*y^2 >= 1 equals the ballot number Binomial[x+y-1, y]/x.

Points on the CF path of Sqrt[d] (convergents and semi-convergents) satisfy this.
Points NOT on the CF path do not.

Examples:
  PellBallotQ[2, {3, 2}]    (* -> True, Pell solution *)
  PellBallotQ[13, {5, 1}]   (* -> False, not on CF path *)";

Begin["`Private`"];

(* ================================================================== *)
(* PellSolve: Wildberger's algorithm                                   *)
(* https://cs.uwaterloo.ca/journals/JIS/VOL13/Wildberger/wildberger2.pdf *)
(* ================================================================== *)

PellSolve[d_Integer /; d > 1 && !IntegerQ[Sqrt[d]]] := Module[
  {a = 1, b = 0, c = -d, t, u = 1, v = 0, r = 0, s = 1},
  While[t = a + b + b + c; If[t > 0,
    a = t; b += c; u += v; r += s,
    b += a; c = t; v += u; s += r];
    Not[a == 1 && b == 0 && c == -d]
  ]; {u, r}]

(* Backward-compatible wrapper *)
PellSolution[d_] := Module[{xy = PellSolve[d]},
  {Global`x -> xy[[1]], Global`y -> xy[[2]]}]

(* ================================================================== *)
(* PellFundamentalExtract: find fundamental from any power             *)
(* ================================================================== *)

(* Square root in Z[Sqrt[d]] for norm +/-1 elements *)
pellSqrtInt[x_, y_, d_] := Catch[Module[{a2, a, b2},
  If[y == 0, Throw[$Failed]];
  Do[
    a2 = (x + sign)/2;
    If[IntegerQ[a2] && a2 > 0,
      a = Quiet[Sqrt[a2]];
      If[IntegerQ[a] && a > 0,
        b2 = y/(2*a);
        If[IntegerQ[b2] && a^2 + d*b2^2 == x && 2*a*b2 == y,
          Throw[{a, b2}]]]],
  {sign, {1, -1}}];
  $Failed]]

(* Extract via CF convergents — finds first convergent with norm = 1 *)
PellFundamentalExtract[x0_, y0_, dd_] := Catch[Module[
  {cf, a0, period, pPrev2, pPrev1, qPrev2, qPrev1, p, q, a, maxIter},

  cf = ContinuedFraction[Sqrt[dd]];
  a0 = cf[[1]];
  period = cf[[2]];

  pPrev2 = 1; pPrev1 = a0;
  qPrev2 = 0; qPrev1 = 1;

  If[a0^2 - dd == 1, Throw[{a0, 1}]];

  maxIter = 2 * Length[period] + 2;
  Do[
    a = period[[Mod[k - 1, Length[period]] + 1]];
    p = a*pPrev1 + pPrev2;
    q = a*qPrev1 + qPrev2;
    If[p^2 - dd*q^2 == 1, Throw[{p, q}]];
    pPrev2 = pPrev1; pPrev1 = p;
    qPrev2 = qPrev1; qPrev1 = q;
  , {k, 1, maxIter}];

  {x0, y0}]]

(* ================================================================== *)
(* BSGS Infrastructure for Pell Regulator                              *)
(* Binary quadratic forms {a, b, c, dist} of discriminant delta = 4n   *)
(* ================================================================== *)

pellStartForm[delta_, pp_] := Module[{sqd, b0, c0},
  sqd = N[Sqrt[delta], pp];
  b0 = Floor[sqd];
  If[Mod[b0, 2] != Mod[delta, 2], b0--];
  c0 = (b0^2 - delta)/4;
  {sqd, {1, b0, c0, N[0, pp]}}]

pellRho[sqd_, delta_, {a_, b_, c_, dist_}, pp_] :=
  Module[{ac = Abs[c], q, b2, c2, dd},
  If[ac == 0, Return[{a, b, c, dist}]];
  q = Floor[(sqd + b)/(2 ac)];
  b2 = 2 ac q - b;
  c2 = (b2^2 - delta)/(4 ac);
  dd = N[Log[Abs[(b + sqd)/(2 ac)]], pp];
  {ac, b2, c2, dist + dd}]

pellIsReduced[sqd_, {a_, b_, _, _}] :=
  a > 0 && b > 0 && sqd - b < 2 a < sqd + b

pellReduce[sqd_, delta_, form_, pp_] := Module[{f = form},
  Do[If[pellIsReduced[sqd, f], Return[f, Module]];
    f = pellRho[sqd, delta, f, pp], {500}]; f]

(* Gauss composition with corrected distance: d3 = d1 + d2 + Log[g] *)

pellCompose[sqd_, delta_, f1_, f2_, pp_] :=
  Module[{a1, b1, c1, d1, a2, b2, c2, d2,
          g1, u1, v1, g, p, q, lam, a3, b3, c3},
  {a1, b1, c1, d1} = f1;
  {a2, b2, c2, d2} = f2;
  {g1, {u1, v1}} = ExtendedGCD[a1, a2];
  {g, {p, q}} = ExtendedGCD[g1, (b1 + b2)/2];
  a3 = (a1 a2)/g^2;
  lam = Mod[v1 p (b1 - b2)/2 - q c2, a1/g];
  b3 = b2 + 2 (a2/g) lam;
  b3 = Mod[b3 - Mod[delta, 2], 2 a3] + Mod[delta, 2];
  Module[{sd = Floor[sqd]},
    While[b3 < sd - a3, b3 += 2 a3];
    While[b3 > sd + a3, b3 -= 2 a3]];
  c3 = (b3^2 - delta)/(4 a3);
  If[!IntegerQ[c3], Return[$Failed]];
  pellReduce[sqd, delta, {a3, b3, c3, d1 + d2 + N[Log[g], pp]}, pp]]

(* Two-pass BSGS *)

bsgsPass[n_, pp_] := Module[
  {delta = 4 n, sqd, f0, b0, f, bigB,
   babyTab, genForm, curForm, found = False,
   reg, giantSteps = 0, babySteps, babyCollisionIndex = 0},

  {sqd, f0} = pellStartForm[delta, pp];
  b0 = f0[[2]];
  bigB = Max[3, Ceiling[N[n]^(1/4)]];

  f = f0; babyTab = <||>;
  Do[
    f = pellRho[sqd, delta, f, pp];
    If[f[[1]] == 1 && f[[2]] == b0, found = True; reg = f[[4]]; babySteps = i; Break[]];
    babyTab[f[[1]]] = {f[[2]], f[[4]], i};
  , {i, 1, bigB}];
  If[!found, babySteps = bigB];

  If[!found,
    genForm = f; curForm = genForm;
    Do[
      curForm = pellCompose[sqd, delta, curForm, genForm, pp];
      giantSteps++;
      If[curForm === $Failed, Continue[]];
      If[curForm[[1]] == 1 && curForm[[2]] == b0,
        found = True; reg = curForm[[4]]; Break[]];
      If[KeyExistsQ[babyTab, curForm[[1]]] &&
         babyTab[curForm[[1]]][[1]] == curForm[[2]],
        babyCollisionIndex = babyTab[curForm[[1]]][[3]];
        reg = curForm[[4]] - babyTab[curForm[[1]]][[2]];
        found = True; Break[]];
    , {k, 1, 10 bigB}]];

  If[!found, Return[$Failed]];
  {reg, babySteps, giantSteps, babyCollisionIndex}]

PellRegulator[n_] := Module[
  {pass1, reg1, babySteps, giantSteps, babyIdx,
   ppFinal, pass2, reg, R, digits, xr, yr, norm},

  (* Pass 1: discover collision at pp=50 *)
  pass1 = bsgsPass[n, 50];
  If[pass1 === $Failed, Return[$Failed]];
  {reg1, babySteps, giantSteps, babyIdx} = pass1;

  (* Pass 2: replay at full precision *)
  ppFinal = Ceiling[Abs[reg1]/Log[10]] + 50;
  pass2 = Module[{delta = 4 n, sqd, f0, f, genForm, curForm, fb},
    {sqd, f0} = pellStartForm[delta, ppFinal];
    f = f0;
    Do[f = pellRho[sqd, delta, f, ppFinal], {babySteps}];
    If[giantSteps > 0,
      genForm = f; curForm = genForm;
      Do[curForm = pellCompose[sqd, delta, curForm, genForm, ppFinal], {giantSteps}];
      If[babyIdx > 0,
        fb = f0;
        Do[fb = pellRho[sqd, delta, fb, ppFinal], {babyIdx}];
        curForm[[4]] - fb[[4]],
        curForm[[4]]],
      f[[4]]]];
  reg = pass2;

  (* Disambiguation: norm check via cosh — PARI convention (keep norm -1) *)
  R = reg;
  Do[
    xr = Round[N[Cosh[c], ppFinal]];
    yr = Round[N[Sinh[c]/Sqrt[n], ppFinal]];
    norm = xr^2 - n yr^2;
    If[norm == 1 && xr > 1, R = c; Break[]];
    If[norm == -1 && xr > 1, R = c; Break[]];
  , {c, Select[{reg/3, reg/2, reg}, # > 0.5 &]}];

  digits = Max[1, Floor[ppFinal - Ceiling[Abs[R]/Log[10]]] - 2];

  <|"R" -> R,
    "Digits" -> digits,
    "Steps" -> babySteps + giantSteps,
    "BabySteps" -> babySteps,
    "GiantSteps" -> giantSteps|>]

(* Integer regulator: single pass, minimal disambiguation *)

PellRegulatorInteger[n_] := Module[
  {pass1, reg1, babySteps, giantSteps, babyIdx,
   ppD, reg, R, xr, yr, norm},

  pass1 = bsgsPass[n, 50];
  If[pass1 === $Failed, Return[$Failed]];
  {reg1, babySteps, giantSteps, babyIdx} = pass1;

  ppD = Ceiling[Abs[reg1]/Log[10]] + 5;
  If[ppD <= 50,
    reg = reg1,
    reg = Module[{delta = 4 n, sqd, f0, f, genForm, curForm, fb},
      {sqd, f0} = pellStartForm[delta, ppD];
      f = f0;
      Do[f = pellRho[sqd, delta, f, ppD], {babySteps}];
      If[giantSteps > 0,
        genForm = f; curForm = genForm;
        Do[curForm = pellCompose[sqd, delta, curForm, genForm, ppD], {giantSteps}];
        If[babyIdx > 0,
          fb = f0;
          Do[fb = pellRho[sqd, delta, fb, ppD], {babyIdx}];
          curForm[[4]] - fb[[4]],
          curForm[[4]]],
        f[[4]]]]];

  R = reg;
  Do[
    xr = Round[N[Cosh[c], ppD]];
    yr = Round[N[Sinh[c]/Sqrt[n], ppD]];
    norm = xr^2 - n yr^2;
    If[norm == 1 && xr > 1, R = c; Break[]];
    If[norm == -1 && xr > 1, R = c; Break[]];
  , {c, Select[{reg/3, reg/2, reg}, # > 0.5 &]}];

  <|"R" -> Round[R],
    "Rfloat" -> R,
    "Steps" -> babySteps + giantSteps|>]

(* PARI oracle *)

PellRegulatorPARI[n_] := Module[{cmd, raw},
  cmd = "echo 'print(my(u=quadunit(4*" <> ToString[n] <>
    "),a=component(u,2),b=component(u,3));log(abs(a+b*sqrt(" <>
    ToString[n] <> ".))))' | gp -q 2>/dev/null";
  raw = StringTrim[RunProcess[{"bash", "-c", cmd}, "StandardOutput"]];
  If[StringLength[raw] > 0, ToExpression[raw], $Failed]]

(* ================================================================== *)
(* PellBallotCount: lattice paths above Pell hyperbola (DP)            *)
(* ================================================================== *)

PellBallotCount[d_Integer, {x1_Integer, y1_Integer}] /; d > 1 && x1 >= 1 && y1 >= 0 :=
  Module[{dp},
    If[y1 == 0, Return[If[x1 >= 1, 1, 0]]];
    dp = Table[0, {x1}, {y1 + 1}];
    Do[
      Do[
        If[u^2 - d r^2 >= 1,
          dp[[u, r + 1]] =
            If[u == 1 && r == 0, 1, 0] +
            If[u > 1, dp[[u - 1, r + 1]], 0] +
            If[r > 0, dp[[u, r]], 0],
          dp[[u, r + 1]] = 0
        ],
      {r, 0, y1}],
    {u, 1, x1}];
    dp[[x1, y1 + 1]]
  ]

(* ================================================================== *)
(* PellBallotQ: test if path count = ballot number                     *)
(* ================================================================== *)

PellBallotQ[d_Integer, {x1_Integer, y1_Integer}] /; d > 1 && x1 >= 2 && y1 >= 1 :=
  Module[{ballot, count},
    ballot = Binomial[x1 + y1 - 1, y1] / x1;
    If[!IntegerQ[ballot], Return[False]];
    count = PellBallotCount[d, {x1, y1}];
    count === ballot
  ]

End[];

EndPackage[];
