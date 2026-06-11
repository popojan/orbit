(* 18_renewal_identity.wl -- verify the Sherman-Morrison/renewal formula
   (2026-06-11, direction 2).
   Pre-registered H-S3 (an identity, expect machine precision):
     J(p/q) = H0(s0,j0) * (1 - rho(0,0)) / (2 h(0,0))
   where, with M the standard boundary matrix and w = M^{-1} e_0:
     H0 = sum_i w_i A_{j0}^(i) t_i^{s0}   (hit phase-0 boundary from start)
     h00 = sum_i w_i                       (same from the dip state (0,0))
     rho00 = sum_i c_i                     (ruin from (0,0))
   Verified algebraically for q = 1: J = rho^k (1-rho)/(2 rho). *)

renewalCheck[pp_Integer, qq_Integer, wp_] := Module[
  {alpha = pp/qq, rise, poly, rts, amps, mat, matMod, cStd, cMod, w,
   s0 = Floor[pp/qq], j0, jDirect, h0, h00, rho00, jFormula},
  j0 = Mod[1, qq];
  rise = Table[Floor[alpha (j + 1)] - Floor[alpha j], {j, 0, qq - 1}];
  poly = (2 tVar - 1)^qq - tVar^(pp + qq);
  rts = Select[tVar /. NSolve[poly == 0, tVar, WorkingPrecision -> wp],
    Abs[#] < 1 - 10^-12 &];
  If[Length[rts] != qq, Return[$Failed]];
  amps = Table[
    If[j == 0, 1, Product[(2 rts[[i]] - 1)/rts[[i]]^(rise[[m + 1]] + 1),
      {m, 0, j - 1}]], {j, 0, qq - 1}, {i, qq}];
  mat = Table[amps[[j + 1, i]]/rts[[i]], {j, 0, qq - 1}, {i, qq}];
  cStd = LinearSolve[mat, ConstantArray[1, qq]];
  matMod = Table[If[j == 0, amps[[1, i]], amps[[j + 1, i]]/rts[[i]]],
    {j, 0, qq - 1}, {i, qq}];
  cMod = LinearSolve[matMod, ConstantArray[1, qq]];
  jDirect = Re[(Sum[(cMod[[i]] - cStd[[i]]) amps[[j0 + 1, i]] rts[[i]]^s0,
      {i, qq}])/(-2)];
  w = LinearSolve[mat, UnitVector[qq, 1]];
  h0 = Re[Sum[w[[i]] amps[[j0 + 1, i]] rts[[i]]^s0, {i, qq}]];
  h00 = Re[Total[w]];
  rho00 = Re[Total[cStd]];
  jFormula = h0 (1 - rho00)/(2 h00);
  {jDirect, jFormula, h0, rho00, h00}];

Off[General::stop]; Off[N::precsm];

Print["p/q | J direct | J renewal | diff | H0 | rho(0,0) | h(0,0)"];
Do[
  Module[{r = renewalCheck[t[[1]], t[[2]], 40]},
    If[r === $Failed, Print[t, " FAILED"],
      Print[t[[1]], "/", t[[2]], "  ",
        NumberForm[N[r[[1]], 8], 8], "  ", NumberForm[N[r[[2]], 8], 8],
        "  diff=", NumberForm[N[r[[1]] - r[[2]], 2], 2],
        "  H0=", NumberForm[N[r[[3]], 5], 5],
        "  rho00=", NumberForm[N[r[[4]], 5], 5],
        "  h00=", NumberForm[N[r[[5]], 5], 5]]]],
  {t, {{3, 2}, {4, 3}, {5, 3}, {7, 5}, {8, 5}, {10, 7}, {17, 12},
       {19, 13}, {25, 13}, {41, 29}}}];
