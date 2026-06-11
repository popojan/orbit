(* 02_C_kink_at_rationals.wl -- one-sided limits/derivatives of C(alpha)
   at rational slopes (2026-06-11).
   Approach p0/q0 along CF-extension families x_K = [cf, K] (both reps,
   giving the two sides); measure difference quotients
   s_K = (C(x_K) - C(p0/q0)) / (x_K - p0/q0) and Richardson-extrapolate.
   Pre-registered hypotheses (documented BEFORE running):
   H-B1 continuity: lim C(x_K) = C(p0/q0) from BOTH sides (paper's claim).
   H-B2 kink: one-sided derivatives differ, kappa = D+ - D- != 0.
   H-B3 TV-template law: |kappa| ~ c * 2/((q-qs) q);
        discriminator kappa(6/5)/kappa(7/5) ~ 0.75 vs ~1.0 for q-only law.
   H-B4: C's one-sided limits agree although TV's differ by Theta(1)
        => C has no additive TV-like component.
   exactCVal adapted from
   docs/sessions/2026-04-13-boundary-correction/scripts/67_gap_survey.wl
   (added: adaptive precision retry, WP 40 base). *)

exactCValCore[pp_Integer, qq_Integer, wp_, thr_] := Module[
  {alpha = pp/qq, steps, poly, allRoots, subUnit, nR, rts,
   fMat, cumMat, sol, coeffs, rv},
  If[alpha <= 1, Return[0]];
  If[qq == 1,
    rv = rhoVar /. FindRoot[rhoVar^(alpha + 1) - (2 rhoVar - 1),
      {rhoVar, 1 - 1/alpha}, WorkingPrecision -> 30];
    Return[N[1 - rv, 15]]
  ];
  steps = Table[Floor[alpha*(j + 1)] - Floor[alpha*j], {j, 1, qq}];
  poly = (2 tVar - 1)^qq - tVar^(pp + qq);
  allRoots = tVar /. NSolve[poly == 0, tVar, WorkingPrecision -> wp];
  subUnit = Select[allRoots, Abs[#] < 1 - thr &];
  subUnit = SortBy[subUnit, -Abs[#] &];
  nR = Min[Length[subUnit], qq];
  If[nR < qq, Return[$Failed]];
  rts = subUnit[[1 ;; nR]];
  fMat = Table[(2 ri - 1)/ri^(steps[[j]] + 1),
    {ri, rts}, {j, 1, qq}] // N[#, wp - 10] &;
  cumMat = Table[
    If[ph == 0, 1, Product[fMat[[i, j]], {j, 1, ph}]],
    {ph, 0, qq - 1}, {i, nR}] // N[#, wp - 15] &;
  sol = LinearSolve[cumMat, Table[1, qq]];
  coeffs = sol*cumMat[[qq]];
  Re[1 - Sum[coeffs[[i]]*rts[[i]], {i, nR}]]
];

exactCVal[pp_Integer, qq_Integer] := Module[{r},
  r = exactCValCore[pp, qq, 40, 10^-10];
  If[r === $Failed, r = exactCValCore[pp, qq, 70, 10^-25]];
  r];

Off[FindRoot::precw]; Off[General::stop]; Off[N::precsm];

(* sanity: C(3/2) against the known degree-6 palindromic minimal polynomial *)
c32 = exactCVal[3, 2];
Print["C(3/2) = ", N[c32, 15]];
Print["minpoly residual: ",
  N[c32^6 - 10 c32^5 + 39 c32^4 - 69 c32^3 + 39 c32^2 - 10 c32 + 1, 5]];

targets = {{3, 2}, {4, 3}, {5, 3}, {6, 5}, {7, 5}};
ladder = {2, 3, 4, 6, 8, 11, 16, 22, 30};
maxDeg = 230;

results = {};
Do[
  Module[{p0, q0, alpha0, c0, cf, repB, qs},
    {p0, q0} = tg; alpha0 = p0/q0;
    c0 = exactCVal[p0, q0];
    cf = ContinuedFraction[alpha0];
    repB = Join[Most[cf], {Last[cf] - 1, 1}];
    qs = Denominator[FromContinuedFraction[Most[cf]]];
    Print["=== target ", p0, "/", q0, "  C = ", N[c0, 13],
      "  (qs = ", qs, ", TV-jump template 2/((q-qs)q) = ",
      N[2/((q0 - qs) q0), 4], ") ==="];
    Do[
      Module[{x, pp, qq, cc, gap, slope},
        x = FromContinuedFraction[Join[rep, {kk}]];
        pp = Numerator[x]; qq = Denominator[x];
        If[pp + qq <= maxDeg,
          cc = exactCVal[pp, qq];
          If[cc =!= $Failed && NumberQ[cc],
            gap = N[x - alpha0, 20];
            slope = N[(cc - c0)/gap, 12];
            AppendTo[results, {p0, q0, Sign[gap], kk, gap, cc, slope}];
            Print["  K=", kk, " side=", Sign[gap], "  x=", pp, "/", qq,
              "  C=", NumberForm[N[cc, 12], 12],
              "  slope=", NumberForm[N[slope, 10], 10]],
            Print["  K=", kk, " FAILED for ", pp, "/", qq]]]],
      {rep, {cf, repB}}, {kk, ladder}]],
  {tg, targets}];

(* Richardson extrapolation per (target, side): s = D + a*gap, two smallest gaps *)
Print["\n=== one-sided derivative estimates (Richardson on last two K) ==="];
kinkTable = {};
Do[
  Module[{p0, q0, dPlus, dMinus, sel, s1, s2, g1, g2, dd},
    {p0, q0} = tg;
    dd = <||>;
    Do[
      sel = SortBy[Cases[results, {p0, q0, side, _, _, _, _}], Abs[#[[5]]] &];
      If[Length[sel] >= 2,
        {g1, s1} = sel[[1, {5, 7}]]; {g2, s2} = sel[[2, {5, 7}]];
        dd[side] = (s1 g2 - s2 g1)/(g2 - g1)],
      {side, {1, -1}}];
    If[KeyExistsQ[dd, 1] && KeyExistsQ[dd, -1],
      dPlus = dd[1]; dMinus = dd[-1];
      AppendTo[kinkTable, {p0, q0, dPlus, dMinus, dPlus - dMinus}];
      Print[p0, "/", q0, ":  D+ = ", NumberForm[N[dPlus, 8], 8],
        "   D- = ", NumberForm[N[dMinus, 8], 8],
        "   kink = ", NumberForm[N[dPlus - dMinus, 8], 8]]]],
  {tg, targets}];

Print["\n=== H-B3 discriminator ==="];
Module[{k65, k75},
  k65 = Cases[kinkTable, {6, 5, _, _, k_} :> k];
  k75 = Cases[kinkTable, {7, 5, _, _, k_} :> k];
  If[k65 =!= {} && k75 =!= {},
    Print["kink(6/5)/kink(7/5) = ", N[First[k65]/First[k75], 6],
      "   (TV law predicts 0.75, q-only law predicts 1.0)"]]];
