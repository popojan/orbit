(* 17_sqrt2_family_decay.wl -- exact J along sqrt(2)-convergent slopes
   (2026-06-11, directions 2+3).
   Pre-registered H-S2: J follows A mu^q q^(-3/2) with
   mu(sqrt2) = (a+1)^(a+1)/(2^(a+1) a^a) = 0.96489 (Cramer tilt of the
   column chain), NOT the plateau law c/q^2.
   Predictions: J(99/70) ~ 7e-6 (mu-law) vs ~2e-5 (1/q^2 law);
   J(239/169) ~ 3e-8-ish vs 3.5e-6 -- decisive.
   Known exact anchors: J(17/12) = 9.7166e-4, J(41/29) = 1.19632e-4. *)

ruinSystems[pp_Integer, qq_Integer, wp_] := Module[
  {alpha = pp/qq, rise, poly, rts, amps, mat, matMod, cStd, cMod,
   s0 = Floor[pp/qq], j0},
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
  Re[{(1 - Sum[cStd[[i]] amps[[j0 + 1, i]] rts[[i]]^s0, {i, qq}])/2,
      (1 - Sum[cMod[[i]] amps[[j0 + 1, i]] rts[[i]]^s0, {i, qq}])/2}]];

Off[General::stop]; Off[N::precsm];

muF[a_] := (a + 1)^(a + 1)/(2^(a + 1) a^a);
Print["mu(sqrt2) = ", N[muF[Sqrt[2]], 8]];

(* sqrt2 convergents: 17/12, 41/29, 99/70, 239/169 *)
Do[
  Module[{res, jj},
    res = ruinSystems[t[[1]], t[[2]], t[[3]]];
    If[res === $Failed, Print[t[[1]], "/", t[[2]], " FAILED"],
      jj = res[[1]] - res[[2]];
      Print[t[[1]], "/", t[[2]], "  C = ", NumberForm[N[res[[1]], 11], 11],
        "  C- = ", NumberForm[N[res[[2]], 11], 11],
        "  J = ", NumberForm[N[jj, 7], 7],
        "  q^2 J = ", NumberForm[N[t[[2]]^2 jj, 5], 5]]]],
  {t, {{17, 12, 40}, {41, 29, 40}, {99, 70, 50}, {239, 169, 60}}}];
