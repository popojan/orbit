(* 08a_sum_rule.wl -- local jump-mass sum rule on (27/20, 29/20] (2026-06-11).
   Since C is monotone right-continuous:
     C(29/20) - C(27/20) = Sum of J(r) over rationals r in (1.35, 1.45]
                           + continuous-part increase.
   Known jumps inside: 7/5 = 5.505e-3, 10/7 = 2.854e-3, 18/13 = 8.75e-4.
   This script supplies the missing q <= 13 jumps (11/8, 13/9, 15/11, 17/12)
   and the exact endpoint values C(27/20), C(29/20).
   Uniform K-ladder {3,4,5,6,7}; geometric fit on last three values
   (lesson from 06: Aitken on uneven ladders is invalid). *)

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

(* geometric fit on three consecutive uniform-ladder values *)
geoLimit[{v1_, v2_, v3_}] := Module[{r = (v3 - v2)/(v2 - v1)},
  If[0 < r < 1, v3 + (v3 - v2) r/(1 - r), $Failed]];

Print["C(27/20) = ", N[exactCVal[27, 20], 12]];
Print["C(29/20) = ", N[exactCVal[29, 20], 12]];

ladder = {3, 4, 5, 6, 7};

Do[
  Module[{p0 = tg[[1]], q0 = tg[[2]], alpha0, c0, cf, repB, belowRep,
    vals = {}, lim1, lim2},
    alpha0 = tg[[1]]/tg[[2]];
    c0 = exactCVal[p0, q0];
    cf = ContinuedFraction[alpha0];
    repB = Join[Most[cf], {Last[cf] - 1, 1}];
    belowRep = If[FromContinuedFraction[Join[cf, {3}]] < alpha0, cf, repB];
    Print["=== ", p0, "/", q0, "  CF ", cf, "  C = ", N[c0, 12], " ==="];
    Do[
      Module[{x, cc},
        x = FromContinuedFraction[Join[belowRep, {kk}]];
        cc = exactCVal[Numerator[x], Denominator[x]];
        If[cc =!= $Failed && NumberQ[cc],
          AppendTo[vals, cc];
          Print["  K=", kk, "  C=", NumberForm[N[cc, 11], 11]]]],
      {kk, ladder}];
    If[Length[vals] == 5,
      lim1 = geoLimit[vals[[2 ;; 4]]]; lim2 = geoLimit[vals[[3 ;; 5]]];
      Print["  geo limits (4,5,6)/(5,6,7): ", NumberForm[N[lim1, 9], 9],
        " / ", NumberForm[N[lim2, 9], 9]];
      If[NumberQ[lim2],
        Print["  J = ", NumberForm[N[c0 - lim2, 6], 6],
          "   q^2 J = ", NumberForm[N[q0^2 (c0 - lim2), 5], 5]]]]],
  {tg, {{11, 8}, {13, 9}, {15, 11}, {17, 12}}}];
