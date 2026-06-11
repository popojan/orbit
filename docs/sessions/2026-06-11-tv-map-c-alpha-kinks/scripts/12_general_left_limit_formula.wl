(* 12_general_left_limit_formula.wl -- closed-form candidate for C^-(p/q)
   (2026-06-11, continuation session).
   Derivation: for x = p/q - eps, floor(x m) = floor((p/q) m) - 1 exactly at
   columns q | m (frac = 0 drops for any eps > 0). The eps -> 0+ limit object
   is the SAME periodic Sturmian walk with a sharpened absorbing barrier:
   level 0 at phase j = 0, level -1 at phases j = 1..q-1.
   Pre-registered prediction (BEFORE running):
     C^-(p/q) = (1 - rho~(s0, j0))/2,  s0 = floor(p/q), j0 = 1,
   where rho~ uses the same roots t_i and amplitudes A_j^(i) but boundary
   rows  Sum_i c_i A_0^(i) = 1  (phase 0, level 0)  and
         Sum_i c_i A_j^(i)/t_i = 1  (phases j = 1..q-1, level -1).
   Integer check (q = 1): rho~(s) = rho^s => C^-(k) = (1 - rho^k)/2 -- the
   machine-precision-verified integer closed form.
   Validation: reproduce C(p/q) first (standard boundary), then compare the
   modified system against all measured left limits. *)

ruinSystems[pp_Integer, qq_Integer, wp_] := Module[
  {alpha = pp/qq, rise, poly, allRoots, rts, amps, mat, matMod, cStd, cMod,
   s0 = Floor[pp/qq], rhoStd, rhoMod},
  rise = Table[Floor[alpha (j + 1)] - Floor[alpha j], {j, 0, qq - 1}];
  poly = (2 tVar - 1)^qq - tVar^(pp + qq);
  allRoots = tVar /. NSolve[poly == 0, tVar, WorkingPrecision -> wp];
  rts = Select[allRoots, Abs[#] < 1 - 10^-10 &];
  If[Length[rts] != qq, Return[$Failed]];
  (* amplitudes A_j^(i), A_0 = 1, paper eq. (amplitudes) *)
  amps = Table[
    If[j == 0, 1, Product[(2 rts[[i]] - 1)/rts[[i]]^(rise[[m + 1]] + 1),
      {m, 0, j - 1}]],
    {j, 0, qq - 1}, {i, qq}] // N[#, wp - 10] &;
  (* standard system: rho(-1, j) = 1 for all j *)
  mat = Table[amps[[j + 1, i]]/rts[[i]], {j, 0, qq - 1}, {i, qq}];
  cStd = LinearSolve[mat, ConstantArray[1, qq]];
  rhoStd[s_, j_] := Sum[cStd[[i]] amps[[j + 1, i]] rts[[i]]^s, {i, qq}];
  (* modified system: rho(0, 0) = 1 (phase-0 absorbing level 0),
     rho(-1, j) = 1 for j = 1..q-1 *)
  matMod = Table[
    If[j == 0, amps[[1, i]], amps[[j + 1, i]]/rts[[i]]],
    {j, 0, qq - 1}, {i, qq}];
  cMod = LinearSolve[matMod, ConstantArray[1, qq]];
  rhoMod[s_, j_] := Sum[cMod[[i]] amps[[j + 1, i]] rts[[i]]^s, {i, qq}];
  {Re[(1 - rhoStd[s0, Mod[1, qq]])/2], Re[(1 - rhoMod[s0, Mod[1, qq]])/2]}
];

Off[General::stop]; Off[N::precsm];

(* {p, q, measured C, measured left limit} from scripts 02/04/06/08/09 *)
targets = {
  {3, 2, 0.2518482, 0.224566}, {4, 3, 0.1908589, 0.177042},
  {5, 3, 0.2841230, 0.272354}, {6, 5, 0.1305095, 0.125130},
  {7, 5, 0.2093269, 0.203822}, {8, 5, 0.2674141, 0.262786},
  {10, 7, 0.2157644, 0.212911}, {11, 8, 0.2004144, 0.198050},
  {13, 9, 0.2188660, 0.217186}, {15, 11, 0.1967899, 0.195504},
  {17, 12, 0.2119306, 0.210959}, {29, 20, 0.2193720, 0.219101},
  {41, 29, 0.2108663, 0.210747},
  {14, 13, 0.0595235, 0.058580}, {15, 13, 0.1049844, 0.103928},
  {16, 13, 0.1420549, 0.140996}, {17, 13, 0.1730038, 0.172023},
  {18, 13, 0.2022108, 0.201335}, {19, 13, 0.2217047, 0.220975},
  {20, 13, 0.2548979, 0.254264}, {21, 13, 0.2684041, 0.267903},
  {22, 13, 0.2851630, 0.284766}, {23, 13, 0.2960110, 0.295707},
  {24, 13, 0.3039540, 0.303725}, {25, 13, 0.3084475, 0.308279}};

Print["p/q | C reproduced? | C~ (predicted left limit) | measured | diff"];
Do[
  Module[{p = t[[1]], q = t[[2]], res},
    res = ruinSystems[p, q, 40];
    If[res === $Failed, Print[p, "/", q, "  FAILED"],
      Print[p, "/", q, "  C_std=", NumberForm[N[res[[1]], 10], 10],
        " (ref ", t[[3]], ")   C~=", NumberForm[N[res[[2]], 10], 10],
        "   measured C- = ", t[[4]],
        "   diff = ", NumberForm[N[res[[2]] - t[[4]], 3], 3]]]],
  {t, targets}];
