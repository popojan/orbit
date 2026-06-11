(* 09_q29_discriminator.wl -- J(41/29) at alpha = 1.4138 (2026-06-11).
   Discriminates the summability scenarios from the local sum rule:
   - if q^2 J ~ 0.14 (the alpha~1.4 plateau value): no decay yet at q=29
     => decay must be abrupt near q~46, continuous part ~ 0;
   - if q^2 J << 0.14: decay underway => room for a continuous part.
   41/29 = [1;2,2,2,2] (a sqrt(2) convergent). Below family:
   [1;2,2,2,1,1,K]. Uniform ladder {3,4,5}; geometric-fit limit. *)

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

exactCVal[pp_Integer, qq_Integer] := Module[{r},
  r = exactCValCore[pp, qq, 40, 10^-10];
  If[r === $Failed, r = exactCValCore[pp, qq, 70, 10^-25]];
  r];

Off[General::stop]; Off[N::precsm];

geoLimit[{v1_, v2_, v3_}] := Module[{r = (v3 - v2)/(v2 - v1)},
  If[0 < r < 1, v3 + (v3 - v2) r/(1 - r), $Failed]];

c0 = exactCVal[41, 29];
Print["C(41/29) = ", N[c0, 12]];

belowRep = {1, 2, 2, 2, 1, 1};
Print["check below: ", N[FromContinuedFraction[Join[belowRep, {3}]] - 41/29, 5]];

vals = {};
Do[
  Module[{x, cc},
    x = FromContinuedFraction[Join[belowRep, {kk}]];
    cc = exactCVal[Numerator[x], Denominator[x]];
    If[cc =!= $Failed && NumberQ[cc],
      AppendTo[vals, cc];
      Print["  K=", kk, "  x=", Numerator[x], "/", Denominator[x],
        "  C=", NumberForm[N[cc, 11], 11]]]],
  {kk, {3, 4, 5}}];

If[Length[vals] == 3,
  Module[{lim = geoLimit[vals]},
    If[NumberQ[lim],
      Print["left limit = ", NumberForm[N[lim, 9], 9],
        "   J = ", NumberForm[N[c0 - lim, 6], 6],
        "   q^2 J = ", NumberForm[N[841 (c0 - lim), 5], 5]]]]];
