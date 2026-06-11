(* 04_jump_depth_law.wl -- jump magnitudes J(p/q) = C(p/q) - lim_{x->p/q-} C(x)
   for deeper/varied rationals (2026-06-11).
   Pre-registered (BEFORE running):
   H-C1 summability: since C is monotone bounded, total jump mass is finite,
        so J cannot be ~0.12/q^2 for ALL p/q; J must decay with CF depth.
        Prediction: J(10/7) noticeably below 0.12/49 = 0.0024.
   H-C2 p-dependence: J(8/5) vs J(7/5) (same q=5, same qs=2) differ.
   Targets: 10/7 (=[1;2,3]), 8/5 (=[1;1,1,2]), 6/5 deeper ladder. *)

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

targets = {{10, 7}, {8, 5}, {6, 5}};
ladders = <|{10, 7} -> {4, 6, 8, 11, 13}, {8, 5} -> {4, 6, 8, 11, 16},
  {6, 5} -> {6, 8, 11, 16, 19}|>;

aitken[v_List] := v[[-1]] - (v[[-1]] - v[[-2]])^2/
   ((v[[-1]] - v[[-2]]) - (v[[-2]] - v[[-3]]));

Do[
  Module[{p0, q0, alpha0, c0, cf, repB, qs, vals},
    {p0, q0} = tg; alpha0 = p0/q0;
    c0 = exactCVal[p0, q0];
    cf = ContinuedFraction[alpha0];
    repB = Join[Most[cf], {Last[cf] - 1, 1}];
    qs = Denominator[FromContinuedFraction[Most[cf]]];
    Print["=== target ", p0, "/", q0, " (CF ", cf, ")  C = ", N[c0, 13], " ==="];
    Do[
      vals = {};
      Do[
        Module[{x, pp, qq, cc},
          x = FromContinuedFraction[Join[rep, {kk}]];
          pp = Numerator[x]; qq = Denominator[x];
          If[pp + qq <= 235,
            cc = exactCVal[pp, qq];
            If[cc =!= $Failed && NumberQ[cc],
              AppendTo[vals, {kk, Sign[N[x - alpha0]], cc}];
              Print["  K=", kk, " side=", Sign[N[x - alpha0]], "  x=", pp,
                "/", qq, "  C=", NumberForm[N[cc, 12], 12]]]]],
        {kk, ladders[tg]}];
      If[Length[vals] >= 3,
        Module[{side = vals[[1, 2]], lim},
          lim = aitken[vals[[All, 3]]];
          Print["  side ", side, " Aitken limit = ", NumberForm[N[lim, 10], 10],
            "   value - limit = ", NumberForm[N[c0 - lim, 8], 8]]]],
      {rep, {cf, repB}}]],
  {tg, targets}];
