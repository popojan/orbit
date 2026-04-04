(* ::Package:: *)

(* PellCompactEncoding: Compact representations and NUDUPL reconstruction *)
(* Consolidates: PellCompact.wl, PellSeedRegulator.wl, PellChebyshevCompact.wl *)

BeginPackage["Orbit`"];

(* --- NUDUPL Reconstruction --- *)

PellReconstruct::usage = "PellReconstruct[d, roundR] reconstructs {x, y} \
with x^2 - d y^2 = 1 from squarefree d and Round[Log[x + y Sqrt[d]]].
Uses O(Log[R]) NUDUPL steps — polynomial time in Log[d].
Example: PellReconstruct[61, 11] gives {1766319049, 226153980}.";

PellReconstruct::fail = "Reconstruction failed for d=`1`.";

PellCompactEncode::usage = "PellCompactEncode[d] returns Round[R_d] via PellRegulatorInteger.";

(* --- Seed Regulator --- *)

PellSeedEncode::usage =
"PellSeedEncode[n] encodes the Pell regulator for non-square n as a compact \
pair (seed, C). Returns \
<|\"Seed\" -> p/q, \"C\" -> c, \"R\" -> R, \"Norm\" -> nm, \"Delta\" -> delta|>. \
The regulator satisfies R = C * Delta exactly.";

PellSeedDecode::usage =
"PellSeedDecode[n, seed, c] recovers the regulator R = c * delta(seed) \
where delta = 2*Log[p + q*Sqrt[n]] - Log|nm(seed)|.";

PellSeedFind::usage =
"PellSeedFind[n] returns the Wildberger seed for non-square n: the smallest \
element on the Stern-Brocot path whose Newton orbit stays on the principal cycle.";

PellSeedOrbit::usage =
"PellSeedOrbit[seed, n] traces the norm orbit of seed under f(x) = (x^2+n)/(2x). \
Returns a list of norms until stabilization or nm = +/-1.";

(* --- Chebyshev Compact Encoding --- *)

PellChebyshevEncode::usage =
"PellChebyshevEncode[n] encodes the Pell regulator as a compact tuple \
<|\"s\", \"z2\", \"nm\", \"C\", \"R\", \"Target\", \"Digits\"|>. \
O(Log[n]) bits regardless of Pell solution size.";

PellChebyshevDecode::usage =
"PellChebyshevDecode[n, s, z2, nm, c] recovers the Pell regulator from \
compact encoding.";

PellChebyshevTarget::usage =
"PellChebyshevTarget[n, s, z2] recovers the target convergent from (s, z^2). \
Formula: target = (s^2 + n)/(2s) + (s^2 - n)/(2s) * 1/(4z2 - 1)";

Begin["`Private`"];

(* ================================================================== *)
(* PART 1: NUDUPL Reconstruction (from PellCompact.wl)                *)
(* ================================================================== *)

(* Q(Sqrt[d]) arithmetic: {a, b, c} = (a + b Sqrt[d]) / c *)

rqS[{a_, b_, c_}] := With[{g = GCD[Abs[a], Abs[b], Abs[c]]},
  If[g > 1, {a/g, b/g, c/g}, {a, b, c}]]

rqMul[d_, {a1_, b1_, c1_}, {a2_, b2_, c2_}] :=
  rqS[{a1 a2 + b1 b2 d, a1 b2 + a2 b1, c1 c2}]

rqSqr[d_, e_] := rqMul[d, e, e]

rqInv[d_, {a_, b_, c_}] := rqS[{c a, -c b, a^2 - d b^2}]

(* Indefinite form reduction (Zagier criterion) *)

isReduced[sD_, {u_, v_, _}] := (v > 0 && v <= sD && sD - 2 Abs[u] < v)

rhoStep[dDisc_, sD_, {u_, v_, w_}] := Module[{q, vn, un, wn},
  q = Quotient[sD + v, 2 Abs[w]];
  vn = 2 Abs[w] q - v;
  un = w;
  wn = (vn^2 - dDisc)/(4 w);
  {un, vn, wn}]

qfbRedSL2[dDisc_, form_] := Module[
  {sD = Floor[Sqrt[dDisc]], f = form, fn,
   m = {{1, 0}, {0, 1}}, q, sgn},
  While[!isReduced[sD, f] && f[[3]] != 0,
    q = Quotient[sD + f[[2]], 2 Abs[f[[3]]]];
    sgn = Sign[f[[3]]];
    fn = rhoStep[dDisc, sD, f];
    m = m . {{0, -sgn}, {sgn, q sgn}};
    f = fn];
  {f, m}]

qfbRed[dDisc_, form_] := Module[
  {sD = Floor[Sqrt[dDisc]], f = form},
  While[!isReduced[sD, f] && f[[3]] != 0,
    f = rhoStep[dDisc, sD, f]];
  f]

formDup[dDisc_, {a_, b_, c_}] := Module[{g, u, v, l, a3, b3, c3},
  {g, {u, v}} = ExtendedGCD[a, b];
  l = Mod[v (-c), a/g];
  a3 = (a/g)^2;
  b3 = Mod[b + 2 (a/g) l, 2 a3];
  If[b3 > a3, b3 -= 2 a3];
  c3 = (b3^2 - dDisc)/(4 a3);
  {a3, b3, c3}]

(* NUDUPL with distance tracking *)

nuduplDist[d_, form_, tau_] := Module[
  {dDisc = 4 d, bigL = Max[1, Floor[d^(1/4)]],
   u = form[[1]], v = form[[2]], w = form[[3]],
   g, xg, yg, bBy, dDy, bBx,
   bx, by, x, y, z = 0, q, t,
   ax, ay, dx, dy, u3, v3, w3,
   sD, corr, corrInv, tauSq, tauSqG, tau3, newForm},

  {g, {xg, yg}} = ExtendedGCD[u, v];
  bBy = u/g; dDy = v/g;
  bBx = Mod[yg w, bBy];

  bx = bBx; by = bBy; x = -1; y = 0;
  While[Abs[bx] > bigL,
    q = Quotient[by, bx];
    t = by - q bx; by = bx; bx = t;
    t = y - q x; y = x; x = t; z++];
  If[OddQ[z], by = -by; y = -y];
  ax = g x; ay = g y;

  dx = (bx dDy - w ax)/bBy;
  dy = If[x != 0, (dx y + dDy)/x, dDy];
  u3 = by^2 - ay dy;
  w3 = bx^2 - ax dx;
  v3 = -(ax dy + ay dx) - 2 bx by;

  If[!AllTrue[{u3, v3, w3}, IntegerQ],
    Return[{qfbRed[dDisc, {u, v, w}], tau}]];

  sD = Floor[Sqrt[dDisc]];
  While[!(v3 > 0 && v3 <= sD && sD - 2 Abs[u3] < v3) && w3 != 0,
    q = Quotient[sD + v3, 2 Abs[w3]];
    Module[{vn = 2 Abs[w3] q - v3, un = w3, wn},
      wn = (vn^2 - dDisc)/(4 w3);
      u3 = un; v3 = vn; w3 = wn]];

  corr = rqS[{2 x u3 + y v3, 2 y, 2 u3}];
  corrInv = rqInv[d, corr];
  tauSq = rqSqr[d, tau];
  tauSqG = rqS[{tauSq[[1]], tauSq[[2]], tauSq[[3]] g}];
  tau3 = rqMul[d, tauSqG, corrInv];

  {{u3, v3, w3}, tau3}]

(* Reconstruction run *)

pellRun[d_, nSq_] := Module[
  {dDisc = 4 d, sD = Floor[Sqrt[4 d]],
   red, f0, t0, u0, v0, w0, xn, yn, tau,
   form, nbaby = 0, q, vn, un, wn, psi, res,
   a, b, c, x, y},

  {f0, t0} = qfbRedSL2[dDisc, {1, 0, -d}];
  {u0, v0, w0} = f0;
  xn = t0[[1, 1]]; yn = t0[[2, 1]];
  tau = rqS[{2 u0 xn - yn v0, 2 yn, 2 u0}];
  form = f0;

  Do[{form, tau} = nuduplDist[d, form, tau], {nSq}];

  Module[{uu = form[[1]], vv = form[[2]], ww = form[[3]]},
    While[nbaby < 500,
      If[ww == 0, Break[]];
      q = Quotient[sD + vv, 2 Abs[ww]];
      vn = 2 Abs[ww] q - vv; un = ww;
      wn = (vn^2 - dDisc)/(4 ww);
      psi = rqS[{vv, 2, 2 Abs[uu]}];
      tau = rqMul[d, tau, psi];
      uu = un; vv = vn; ww = wn; nbaby++;
      If[uu == u0 && vv == v0, Break[]];
      If[Abs[uu] == 1, Break[]]]];

  {a, b, c} = tau;
  If[c == 0 || Mod[a, c] != 0 || Mod[b, c] != 0, Return[{0, 0}]];
  x = Abs[Quotient[a, c]]; y = Abs[Quotient[b, c]];
  If[x^2 - d y^2 == 1, Return[{x, y}]];
  If[x^2 - d y^2 == -1, Return[{2 x^2 + 1, 2 x y}]];
  {0, 0}]

(* Entry point *)

PellReconstruct[d_Integer, roundR_Integer] := Module[
  {s = Floor[Sqrt[d]], dist0, tsq, res, trySq},
  dist0 = N[Log[s + Sqrt[d]], 20];
  tsq = Max[0, Floor[Log[2, Max[1, roundR/dist0]]]];
  Catch[
    Do[
      If[trySq < 0, Continue[]];
      res = pellRun[d, trySq];
      If[res[[1]] > 1, Throw[res]],
      {trySq, tsq, 0, -1}];
    res = pellRun[d, tsq + 1];
    If[res[[1]] > 1, Throw[res]];
    Message[PellReconstruct::fail, d]; {0, 0}
  ]]

PellCompactEncode[d_Integer] := PellRegulatorInteger[d]["R"]

(* ================================================================== *)
(* PART 2: Seed Regulator (from PellSeedRegulator.wl)                 *)
(* ================================================================== *)

(* Wildberger path: Stern-Brocot walk toward sqrt(n) *)

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

(* Norm in Z[sqrt(n)] *)

iNorm[x_, n_] := With[{pq = NumeratorDenominator[x]},
  pq[[1]]^2 - n pq[[2]]^2]

(* Seed validity: f-orbit norms stay bounded *)

iValidSeedQ[x_, n_] := Catch[Module[{c = x, m},
  Do[
    m = iNorm[c, n];
    If[Abs[m] > n, Throw[False]];
    If[Abs[m] <= 1, Throw[True]];
    c = (c^2 + n)/(2 c),
  {20}];
  Throw[True]]]

iFindSeed[n_] := SelectFirst[Last@iWildpf[n, 1], iValidSeedQ[#, n] &]

(* Trace orbit norms *)

iTraceNorms[seed_, n_, maxSteps_: 20] := Module[{c = seed, norms = {}, m},
  Do[
    m = iNorm[c, n];
    AppendTo[norms, m];
    If[Abs[m] <= 1, Break[]];
    c = (c^2 + n)/(2 c),
  {maxSteps}];
  norms]

(* Determine C *)

iComputeC[n_, seed_, pellXY_] := Module[
  {x, y, R, p, q, nm, delta, cRaw},
  {x, y} = pellXY;
  R = Log[x + y Sqrt[n]];
  {p, q} = NumeratorDenominator[seed];
  nm = p^2 - n q^2;
  delta = 2 Log[p + q Sqrt[n]] - Log[Abs[nm]];
  cRaw = Simplify[R/delta];
  If[FreeQ[cRaw, Log],
    cRaw,
    Rationalize[N[cRaw, 30], 1/10000]]]

(* Public API: Seed *)

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

  Module[{wpf = iWildpf[n, 1], sol, path},
    sol = First@First@wpf;
    path = Last@wpf;
    pellXY = Last[sol];
    seed = SelectFirst[path, iValidSeedQ[#, n] &];
    If[MissingQ[seed], Return[$Failed]]];

  {p, q} = NumeratorDenominator[seed];
  nm = p^2 - n q^2;
  delta = 2 Log[p + q Sqrt[n]] - Log[Abs[nm]];
  c = iComputeC[n, seed, pellXY];
  R = c delta;

  <|"Seed" -> seed,
    "C" -> c,
    "Norm" -> nm,
    "Delta" -> delta,
    "R" -> R,
    "OrbitNorms" -> iTraceNorms[seed, n],
    "PellSolution" -> pellXY|>]

(* ================================================================== *)
(* PART 3: Chebyshev Compact Encoding (from PellChebyshevCompact.wl)  *)
(* ================================================================== *)

iChebNorm[x_, n_] := With[{pq = NumeratorDenominator[x]},
  pq[[1]]^2 - n pq[[2]]^2]

PellChebyshevTarget[n_Integer, s_, z2_] :=
  (s^2 + n)/(2 s) + (s^2 - n)/(2 s) * 1/(4 z2 - 1)

iZ2FromTarget[n_, target_, s_] := Module[{R},
  R = (2 s target - s^2 - n)/(s^2 - n);
  If[R == 0, $Failed, (1 + R)/(4 R)]]

iComplexity[x_Integer] := IntegerLength[Abs[x]]
iComplexity[x_Rational] := IntegerLength[Abs[Numerator[x]]] +
  IntegerLength[Abs[Denominator[x]]]

iComputeChebC[target_, n_] := Module[
  {cf, pellXY, R, p, q, nmVal, delta, cRaw},

  cf = ContinuedFraction[Sqrt[n], 200];
  pellXY = Catch[Do[
    Module[{conv = FromContinuedFraction[Take[cf, k]]},
      If[Abs[Numerator[conv]^2 - n Denominator[conv]^2] == 1,
        Throw[conv]]],
  {k, 2, Length[cf]}]; $Failed];
  If[pellXY === $Failed, Return[1]];

  R = Log[Numerator[pellXY] + Denominator[pellXY] Sqrt[n]];
  {p, q} = NumeratorDenominator[target];
  nmVal = p^2 - n q^2;
  delta = 2 Log[p + q Sqrt[n]] - Log[Abs[nmVal]];
  cRaw = Simplify[R/delta];
  If[FreeQ[cRaw, Log],
    cRaw,
    Rationalize[N[cRaw, 30], 1/10000]]]

iFindBestEncoding[n_] := Module[
  {s0 = Floor[Sqrt[n]], cf, pellXY, R, convs,
   best = None, bestTotal = Infinity},

  cf = ContinuedFraction[Sqrt[n], 200];

  pellXY = Catch[Do[
    Module[{conv = FromContinuedFraction[Take[cf, k]]},
      If[Abs[Numerator[conv]^2 - n Denominator[conv]^2] == 1,
        Throw[conv]]],
  {k, 2, Length[cf]}]; $Failed];
  If[pellXY === $Failed, Return[None]];
  R = Log[Numerator[pellXY] + Denominator[pellXY] Sqrt[n]];

  convs = Table[
    Module[{conv = FromContinuedFraction[Take[cf, k]]},
      {conv, iChebNorm[conv, n], k - 1}],
  {k, 2, Min[30, Length[cf]]}];

  Do[
    Module[{target = c[[1]], tgtNm = c[[2]], cfIdx = c[[3]],
            p, q, delta, cVal},
      {p, q} = NumeratorDenominator[target];
      delta = 2 Log[p + q Sqrt[n]] - Log[Abs[tgtNm]];
      cVal = TimeConstrained[FullSimplify[R/delta], 5, $Failed];
      If[cVal === $Failed, Continue[]];
      If[!FreeQ[cVal, Log], Continue[]];
      If[!(IntegerQ[cVal] || (Head[cVal] === Rational &&
           Denominator[cVal] <= 4)), Continue[]];

      Do[
        If[s^2 == n || s === target, Continue[]];
        Module[{z2, totalC},
          z2 = iZ2FromTarget[n, target, s];
          If[z2 === $Failed, Continue[]];
          z2 = FullSimplify[z2];
          totalC = iComplexity[z2] + iComplexity[s];
          If[totalC < bestTotal,
            bestTotal = totalC;
            best = <|"s" -> s, "z2" -> z2, "nm" -> tgtNm,
                     "C" -> cVal, "Target" -> target,
                     "cfIndex" -> cfIdx,
                     "totalDigits" -> totalC|>]],
      {s, Join[
        Range[Max[1, s0 - 3], s0 + 3],
        {(2 s0 + 1)/2, (2 s0 - 1)/2}]}]],
  {c, convs}];

  best]

(* Public API: Chebyshev Compact *)

PellChebyshevEncode[n_Integer /; n > 1 && !IntegerQ[Sqrt[n]]] := Module[
  {enc, target, p, q, nmVal, cVal, delta, R},

  enc = iFindBestEncoding[n];
  If[enc === None, Return[$Failed]];

  target = enc["Target"];
  {p, q} = NumeratorDenominator[target];
  nmVal = enc["nm"];
  cVal = enc["C"];
  delta = 2 Log[p + q Sqrt[n]] - Log[Abs[nmVal]];
  R = cVal * delta;

  <|"s" -> enc["s"],
    "z2" -> enc["z2"],
    "nm" -> nmVal,
    "C" -> cVal,
    "R" -> R,
    "Target" -> target,
    "Digits" -> enc["totalDigits"]|>]

PellChebyshevDecode[n_Integer, s_, z2_, nm_Integer, c_] := Module[
  {target, p, q},
  target = PellChebyshevTarget[n, s, z2];
  {p, q} = NumeratorDenominator[target];
  c * Log[(p + q Sqrt[n])^2 / Abs[nm]]]

End[];
EndPackage[];
