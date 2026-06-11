(* 11_integer_closed_form.wl -- high-precision test of the conjecture
   C^-(k) = (tau_k - 1)/2, equivalently rho^- = rho_k^k (2026-06-11).
   Discovered from script 08b: C^-(3) matched (tau_3-1)/2 to 7 digits.
   Here: k = 2, 3, 4 with uniform ladders K = {28, 34, 40, 46},
   geometric fit on last three + stability check on first three. *)

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
  r = exactCValCore[pp, qq, 50, 10^-10];
  If[r === $Failed, r = exactCValCore[pp, qq, 80, 10^-25]];
  r];
Off[General::stop]; Off[N::precsm];

geoLimit[{v1_, v2_, v3_}] := Module[{r = (v3 - v2)/(v2 - v1)},
  If[0 < r < 1, v3 + (v3 - v2) r/(1 - r), $Failed]];

Do[
  Module[{tau, pred, vals = {}, lim1, lim2},
    tau = Root[#^(k + 1) - 2 #^k + 1 &, 2];
    (* tau_k = the root in (1,2); Root index 2 after t=1; verify numerically *)
    tau = SelectFirst[t /. NSolve[t^(k + 1) - 2 t^k + 1 == 0, t, Reals],
      1 < # < 2 &];
    pred = N[(tau - 1)/2, 15];
    Do[
      Module[{x, cc},
        x = FromContinuedFraction[{k - 1, 1, bigK}];
        cc = exactCVal[Numerator[x], Denominator[x]];
        If[cc =!= $Failed && NumberQ[cc],
          AppendTo[vals, cc];
          Print["k=", k, "  K=", bigK, "  C=", NumberForm[N[cc, 13], 13]]]],
      {bigK, {28, 34, 40, 46}}];
    If[Length[vals] == 4,
      lim1 = geoLimit[vals[[1 ;; 3]]]; lim2 = geoLimit[vals[[2 ;; 4]]];
      Print["k=", k, ":  geo limits = ", NumberForm[N[lim1, 12], 12], " / ",
        NumberForm[N[lim2, 12], 12]];
      Print["      (tau_k - 1)/2 = ", NumberForm[pred, 12],
        "   residual = ", NumberForm[N[lim2 - (tau - 1)/2, 3], 3]]]],
  {k, {2, 3, 4}}];
