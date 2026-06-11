(* 14_right_flatness_rate.wl -- exponential right-flatness rate (2026-06-11).
   Pre-registered (BEFORE running):
   H-R1: delta_K = C(x_K^above) - C(p/q) is asymptotically geometric in q_K;
         per-column rate mu < Chernoff bound lambda*(alpha)^2
         (3/2: bound 0.9605; 5/3: bound 0.9389; 4/3: bound 0.9797).
   H-R2: the below-family approach to C~ (sharpened-barrier limit) has a
         comparable geometric rate.
   Deep uniform above-ladders K = {26, 30, 34, 38} for 3/2; {18,21,24,27}
   for 5/3 and 4/3. Reference values: exact C(p/q) and C~(p/q). *)

exactCValCore[pp_Integer, qq_Integer, wp_, thr_] := Module[
  {alpha = pp/qq, steps, poly, allRoots, subUnit, nR, rts,
   fMat, cumMat, sol, coeffs},
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
exactCVal[pp_, qq_] := Module[{r}, r = exactCValCore[pp, qq, 50, 10^-10];
  If[r === $Failed, r = exactCValCore[pp, qq, 80, 10^-25]]; r];

Off[General::stop]; Off[N::precsm];

chernoffRate[alpha_] := Module[{th},
  th = th /. FindRoot[-alpha Exp[-alpha th] + Exp[th], {th, 0.1},
    WorkingPrecision -> 20];
  N[((Exp[-alpha th] + Exp[th])/2)^2, 10]];

Do[
  Module[{p0 = tg[[1]], q0 = tg[[2]], ks = tg[[3]], alpha0, c0, cf, repB,
    aboveRep, qstep, deltas = {}},
    alpha0 = tg[[1]]/tg[[2]];
    c0 = exactCVal[p0, q0];
    cf = ContinuedFraction[alpha0];
    repB = Join[Most[cf], {Last[cf] - 1, 1}];
    aboveRep = If[FromContinuedFraction[Join[cf, {3}]] > alpha0, cf, repB];
    qstep = Denominator[alpha0];
    Print["=== ", p0, "/", q0, " above-family, Chernoff bound per column = ",
      chernoffRate[N[alpha0, 20]], " ==="];
    Do[
      Module[{x, cc, dK},
        x = FromContinuedFraction[Join[aboveRep, {kk}]];
        cc = exactCVal[Numerator[x], Denominator[x]];
        If[NumberQ[cc],
          dK = cc - c0;
          AppendTo[deltas, {kk, Denominator[x], dK}];
          Print["  K=", kk, "  q_K=", Denominator[x], "  delta=",
            NumberForm[N[dK, 6], 6]]]],
      {kk, ks}];
    If[Length[deltas] >= 2,
      Do[
        Module[{a = deltas[[i]], b = deltas[[i + 1]], mu},
          mu = (b[[3]]/a[[3]])^(1/(b[[2]] - a[[2]]));
          Print["  per-column rate (K=", a[[1]], "->", b[[1]], "): ",
            NumberForm[N[mu, 6], 6]]],
        {i, Length[deltas] - 1}]]],
  {tg, {{3, 2, {26, 30, 34, 38}}, {5, 3, {18, 21, 24, 27}},
        {4, 3, {18, 21, 24, 27}}}}];
