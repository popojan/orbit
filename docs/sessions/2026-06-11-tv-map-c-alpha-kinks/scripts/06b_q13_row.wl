(* 06b_q13_row.wl -- jump row J(p/13) for p = 20..25 (2026-06-11).
   Purpose: resolve the summability paradox direction. At fixed q = 13 the
   CF words vary in depth (1..5) and quotient size; the c/q^2 law with
   constant c cannot hold for all rationals (divergent jump mass), so J
   must vary with the word at fixed q.
   Pre-registered H-E1: J(p/13) varies by MORE than the 0.106-0.140 band
   seen at q <= 7 (i.e., word complexity, not just q, controls c).
   Left limits via Aitken on K-ladder {3,4,5,7}, below side only. *)

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

aitken[v_List] := v[[-1]] - (v[[-1]] - v[[-2]])^2/
   ((v[[-1]] - v[[-2]]) - (v[[-2]] - v[[-3]]));

ladder = {3, 4, 5, 7};

Do[
  Module[{q0 = 13, alpha0, c0, cf, repB, belowRep, qs, vals = {}},
    alpha0 = p0/13;
    c0 = exactCVal[p0, 13];
    cf = ContinuedFraction[alpha0];
    repB = Join[Most[cf], {Last[cf] - 1, 1}];
    belowRep = If[FromContinuedFraction[Join[cf, {3}]] < alpha0, cf, repB];
    qs = Denominator[FromContinuedFraction[Most[cf]]];
    Print["=== ", p0, "/13  CF ", cf, "  qs=", qs, "  C = ", N[c0, 12], " ==="];
    Do[
      Module[{x, pp, qq, cc},
        x = FromContinuedFraction[Join[belowRep, {kk}]];
        pp = Numerator[x]; qq = Denominator[x];
        cc = exactCVal[pp, qq];
        If[cc =!= $Failed && NumberQ[cc],
          AppendTo[vals, cc];
          Print["  K=", kk, "  x=", pp, "/", qq, "  C=",
            NumberForm[N[cc, 11], 11]]]],
      {kk, ladder}];
    If[Length[vals] >= 3,
      Module[{lim = aitken[vals]},
        Print["  left limit (Aitken) = ", NumberForm[N[lim, 9], 9],
          "   J = ", NumberForm[N[c0 - lim, 6], 6],
          "   q^2 J = ", NumberForm[N[169 (c0 - lim), 5], 5]]]]],
  {p0, {20, 21, 22, 23, 24, 25}}];
