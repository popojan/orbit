(* 13_formula_precision_test.wl -- precision test of the left-limit closed
   form C^-(p/q) = (1 - rho~(s0, j0))/2 (2026-06-11).
   Deep uniform ladders K = {22, 26, 30} for 5/3 and 8/5, geometric-fit
   limits to ~10 digits, compared against the modified boundary system.
   Plus: exact algebraic value of J(3/2) via symbolic root computation. *)

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

(* modified-boundary prediction, high precision *)
cTilde[pp_Integer, qq_Integer, wp_] := Module[
  {alpha = pp/qq, rise, poly, rts, amps, matMod, cMod, s0 = Floor[pp/qq]},
  rise = Table[Floor[alpha (j + 1)] - Floor[alpha j], {j, 0, qq - 1}];
  poly = (2 tVar - 1)^qq - tVar^(pp + qq);
  rts = Select[tVar /. NSolve[poly == 0, tVar, WorkingPrecision -> wp],
    Abs[#] < 1 - 10^-10 &];
  If[Length[rts] != qq, Return[$Failed]];
  amps = Table[
    If[j == 0, 1, Product[(2 rts[[i]] - 1)/rts[[i]]^(rise[[m + 1]] + 1),
      {m, 0, j - 1}]], {j, 0, qq - 1}, {i, qq}];
  matMod = Table[If[j == 0, amps[[1, i]], amps[[j + 1, i]]/rts[[i]]],
    {j, 0, qq - 1}, {i, qq}];
  cMod = LinearSolve[matMod, ConstantArray[1, qq]];
  Re[(1 - Sum[cMod[[i]] amps[[Mod[1, qq] + 1, i]] rts[[i]]^s0, {i, qq}])/2]];

Off[General::stop]; Off[N::precsm];

geoLimit[{v1_, v2_, v3_}] := v3 + (v3 - v2)^2/((v2 - v1) - (v3 - v2));

Do[
  Module[{p0 = tg[[1]], q0 = tg[[2]], alpha0, cf, repB, belowRep, vals, lim},
    alpha0 = tg[[1]]/tg[[2]];
    cf = ContinuedFraction[alpha0];
    repB = Join[Most[cf], {Last[cf] - 1, 1}];
    belowRep = If[FromContinuedFraction[Join[cf, {3}]] < alpha0, cf, repB];
    vals = Table[
      exactCVal[Numerator[#], Denominator[#]] &[
        FromContinuedFraction[Join[belowRep, {kk}]]], {kk, {22, 26, 30}}];
    lim = geoLimit[vals];
    Print[p0, "/", q0, ":  ladder limit = ", NumberForm[N[lim, 11], 11],
      "   C~ formula = ", NumberForm[N[cTilde[p0, q0, 50], 11], 11],
      "   diff = ", NumberForm[N[lim - cTilde[p0, q0, 50], 3], 3]]],
  {tg, {{5, 3}, {8, 5}}}];

(* exact algebra for 3/2: roots of t^4+2t^3-2t^2-2t+1, 2x2 modified system *)
Print["--- exact J(3/2) ---"];
rtsEx = Select[tVar /. Solve[tVar^4 + 2 tVar^3 - 2 tVar^2 - 2 tVar + 1 == 0,
   tVar], Abs[N[#]] < 1 &];
riseEx = {1, 2};
ampsEx = Table[If[j == 0, 1, Product[(2 t - 1)/t^(riseEx[[m + 1]] + 1),
    {m, 0, j - 1}]] /. t -> rtsEx[[i]], {j, 0, 1}, {i, 2}];
matStd = Table[ampsEx[[j + 1, i]]/rtsEx[[i]], {j, 0, 1}, {i, 2}];
matMod = Table[If[j == 0, ampsEx[[1, i]], ampsEx[[j + 1, i]]/rtsEx[[i]]],
  {j, 0, 1}, {i, 2}];
cS = LinearSolve[matStd, {1, 1}]; cM = LinearSolve[matMod, {1, 1}];
s0 = 1; j0 = 1;
cVal = (1 - Sum[cS[[i]] ampsEx[[j0 + 1, i]] rtsEx[[i]]^s0, {i, 2}])/2;
cLeft = (1 - Sum[cM[[i]] ampsEx[[j0 + 1, i]] rtsEx[[i]]^s0, {i, 2}])/2;
jEx = RootReduce[cVal - cLeft];
Print["J(3/2) exact = ", jEx];
Print["J(3/2) numeric = ", N[jEx, 20]];
Print["MinimalPolynomial: ", MinimalPolynomial[jEx, x]];
