(* ::Package:: *)

(* Polynomial-Time Pell Equation Reconstruction from Compact Regulator *)
(* Pure Wolfram implementation of NUDUPL (van der Poorten 2003).       *)

BeginPackage["Orbit`"];

PellReconstruct::usage = "PellReconstruct[d, roundR] reconstructs {x, y} \
with x^2 - d y^2 = 1 from squarefree d and Round[Log[x + y Sqrt[d]]].
Uses O(Log[R]) NUDUPL steps — polynomial time in Log[d].
Example: PellReconstruct[61, 22] gives {1766319049, 226153980}.";

PellReconstruct::fail = "Reconstruction failed for d=`1`.";

PellCompactEncode::usage = "PellCompactEncode[d] returns Round[R_d].";

Begin["`Private`"];

(* === Q(Sqrt[d]) arithmetic: {a, b, c} = (a + b Sqrt[d]) / c === *)

rqS[{a_, b_, c_}] := With[{g = GCD[Abs[a], Abs[b], Abs[c]]},
  If[g > 1, {a/g, b/g, c/g}, {a, b, c}]]

rqMul[d_, {a1_, b1_, c1_}, {a2_, b2_, c2_}] :=
  rqS[{a1 a2 + b1 b2 d, a1 b2 + a2 b1, c1 c2}]

rqSqr[d_, e_] := rqMul[d, e, e]

rqInv[d_, {a_, b_, c_}] := rqS[{c a, -c b, a^2 - d b^2}]

(* === Indefinite form reduction (Zagier criterion) === *)
(* Reduced: 0 < b < Sqrt[D] AND Sqrt[D] - 2|a| < b *)

isReduced[sD_, {u_, v_, _}] := (v > 0 && v <= sD && sD - 2 Abs[u] < v)

(* Rho step: (a,b,c) -> (c, 2|c|q - b, ...) *)
rhoStep[dDisc_, sD_, {u_, v_, w_}] := Module[{q, vn, un, wn},
  q = Quotient[sD + v, 2 Abs[w]];
  vn = 2 Abs[w] q - v;
  un = w;
  wn = (vn^2 - dDisc)/(4 w);
  {un, vn, wn}]

(* Reduce form, tracking SL2 matrix *)
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

(* Reduce form without tracking *)
qfbRed[dDisc_, form_] := Module[
  {sD = Floor[Sqrt[dDisc]], f = form},
  While[!isReduced[sD, f] && f[[3]] != 0,
    f = rhoStep[dDisc, sD, f]];
  f]

(* === Form duplication (Gauss composition) === *)

formDup[dDisc_, {a_, b_, c_}] := Module[{g, u, v, l, a3, b3, c3},
  {g, {u, v}} = ExtendedGCD[a, b];
  l = Mod[v (-c), a/g];
  a3 = (a/g)^2;
  b3 = Mod[b + 2 (a/g) l, 2 a3];
  If[b3 > a3, b3 -= 2 a3];
  c3 = (b3^2 - dDisc)/(4 a3);
  {a3, b3, c3}]

(* === NUDUPL with Distance === *)

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

  (* Bail if non-integer form coefficients *)
  If[!AllTrue[{u3, v3, w3}, IntegerQ],
    Return[{qfbRed[dDisc, {u, v, w}], tau}]];

  (* Reduce *)
  sD = Floor[Sqrt[dDisc]];
  While[!(v3 > 0 && v3 <= sD && sD - 2 Abs[u3] < v3) && w3 != 0,
    q = Quotient[sD + v3, 2 Abs[w3]];
    Module[{vn = 2 Abs[w3] q - v3, un = w3, wn},
      wn = (vn^2 - dDisc)/(4 w3);
      u3 = un; v3 = vn; w3 = wn]];

  (* Distance *)
  corr = rqS[{2 x u3 + y v3, 2 y, 2 u3}];
  corrInv = rqInv[d, corr];
  tauSq = rqSqr[d, tau];
  tauSqG = rqS[{tauSq[[1]], tauSq[[2]], tauSq[[3]] g}];
  tau3 = rqMul[d, tauSqG, corrInv];

  {{u3, v3, w3}, tau3}]

(* === Reconstruction run === *)

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

(* === Entry point === *)

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
    (* Also try tsq+1 *)
    res = pellRun[d, tsq + 1];
    If[res[[1]] > 1, Throw[res]];
    Message[PellReconstruct::fail, d]; {0, 0}
  ]]

PellCompactEncode[d_Integer] := Module[{x, y, sol},
  sol = FindInstance[x^2 - d y^2 == 1, {x, y}, PositiveIntegers];
  {x, y} = {x, y} /. First[sol];
  Round[N[Log[x + y Sqrt[N[d, 50]]], 30]]]

End[];
EndPackage[];
