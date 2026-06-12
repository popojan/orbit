(* 19_fib_family_rate.wl -- independent confirmation of Theorem E (rate)
   on the GOLDEN RATIO convergent family (2026-06-12).
   Pre-registered H-T1: exact jumps J(F_{k+1}/F_k) for q = 5..89 follow
   mu(phi)^q q^(-3/2) with mu(phi) = (phi+1)^(phi+1)/(2^(phi+1) phi^phi)
   = 0.929050 -- a second CF family, away from the sqrt2 test. *)

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
Print["mu(phi) = ", N[muF[GoldenRatio], 8]];

js = {};
Do[
  Module[{p = Fibonacci[k + 1], q = Fibonacci[k], res, jj},
    res = ruinSystems[p, q, If[q > 40, 60, 40]];
    If[res === $Failed, Print[p, "/", q, " FAILED"],
      jj = res[[1]] - res[[2]];
      AppendTo[js, {q, jj}];
      Print[p, "/", q, "  J = ", NumberForm[N[jj, 7], 7],
        "  q^2 J = ", NumberForm[N[q^2 jj, 5], 5]]]],
  {k, 5, 11}];

Print["--- per-column rates (q^(-3/2)-corrected) vs mu(phi) ---"];
Do[
  Module[{a = js[[i]], b = js[[i + 1]], mu},
    mu = ((b[[2]]/a[[2]]) (b[[1]]/a[[1]])^(3/2))^(1/(b[[1]] - a[[1]]));
    Print["q ", a[[1]], " -> ", b[[1]], ":  mu_emp = ",
      NumberForm[N[mu, 6], 6]]],
  {i, Length[js] - 1}];
