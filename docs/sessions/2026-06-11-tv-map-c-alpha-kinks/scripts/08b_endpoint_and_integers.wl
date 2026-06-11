(* 08b_endpoint_and_integers.wl -- J(29/20) for the sum rule, plus the
   integer-slope jumps J(2), J(3) for the record (2026-06-11).
   Uniform ladders; geometric fit on last three values. *)

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

geoLimit[{v1_, v2_, v3_}] := Module[{r = (v3 - v2)/(v2 - v1)},
  If[0 < r < 1, v3 + (v3 - v2) r/(1 - r), $Failed]];

(* --- J(29/20), below family, ladder {3,4,5,6} (degree cap) --- *)
Module[{p0 = 29, q0 = 20, alpha0 = 29/20, c0, cf, repB, belowRep,
  vals = {}, lim},
  c0 = exactCVal[29, 20];
  cf = ContinuedFraction[alpha0];
  repB = Join[Most[cf], {Last[cf] - 1, 1}];
  belowRep = If[FromContinuedFraction[Join[cf, {3}]] < alpha0, cf, repB];
  Print["=== 29/20  CF ", cf, "  C = ", N[c0, 12], " ==="];
  Do[
    Module[{x, cc},
      x = FromContinuedFraction[Join[belowRep, {kk}]];
      cc = exactCVal[Numerator[x], Denominator[x]];
      If[cc =!= $Failed && NumberQ[cc],
        AppendTo[vals, cc];
        Print["  K=", kk, "  C=", NumberForm[N[cc, 11], 11]]]],
    {kk, {3, 4, 5, 6}}];
  If[Length[vals] >= 3,
    lim = geoLimit[vals[[-3 ;;]]];
    If[NumberQ[lim],
      Print["  left limit = ", NumberForm[N[lim, 9], 9],
        "   J = ", NumberForm[N[c0 - lim, 6], 6],
        "   q^2 J = ", NumberForm[N[400 (c0 - lim), 5], 5]]]]];

(* --- integer jumps J(2), J(3): families (kK+K+... ) -> k from below --- *)
Do[
  Module[{k = kk, c0, vals = {}, lim},
    c0 = exactCVal[kk, 1];
    Print["=== integer ", k, "  C(", k, ") = ", N[c0, 12], " ==="];
    Do[
      Module[{x, cc},
        x = FromContinuedFraction[{k - 1, 1, bigK}];
        cc = exactCVal[Numerator[x], Denominator[x]];
        If[cc =!= $Failed && NumberQ[cc],
          AppendTo[vals, cc];
          Print["  K=", bigK, "  x=", Numerator[x], "/", Denominator[x],
            "  C=", NumberForm[N[cc, 11], 11]]]],
      {bigK, {10, 14, 18, 22}}];
    If[Length[vals] >= 3,
      lim = geoLimit[vals[[-3 ;;]]];
      If[NumberQ[lim],
        Print["  left limit = ", NumberForm[N[lim, 9], 9],
          "   J(", k, ") = ", NumberForm[N[c0 - lim, 6], 6]]]]],
  {kk, {2, 3}}];
