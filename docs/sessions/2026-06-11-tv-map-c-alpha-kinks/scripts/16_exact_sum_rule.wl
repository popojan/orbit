(* 16_exact_sum_rule.wl -- EXACT jump sum rule on (27/20, 29/20] (2026-06-11,
   direction 1: pure-jump question).
   Now that J(p/q) = (rho~ - rho)/2 is computable exactly, sum ALL jumps with
   q <= 60 in the interval and compare with
   Delta C = C(29/20) - C(27/20) = 0.026314245.
   Pre-registered H-S1: coverage reaches >= ~85%; per-q masses M(q) decay
   exponentially beyond q ~ 20; tail extrapolation consistent with zero
   continuous part. *)

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

deltaC = 0.026314245;
total = 0;
Do[
  Module[{mass = 0, cnt = 0},
    Do[
      If[GCD[p, q] == 1 && 27/20 < p/q <= 29/20,
        Module[{res = ruinSystems[p, q, 40]},
          If[res =!= $Failed,
            mass += (res[[1]] - res[[2]]); cnt++]]],
      {p, Ceiling[27 q/20], Floor[29 q/20]}];
    If[cnt > 0,
      total += mass;
      Print["q=", q, "  #", cnt, "  M(q) = ", NumberForm[N[mass, 5], 5],
        "  cumulative = ", NumberForm[N[total, 6], 6],
        "  coverage = ", NumberForm[N[100 total/deltaC, 5], 5], "%"]]],
  {q, 2, 60}];
Print["FINAL: total jump mass (q<=60) = ", NumberForm[N[total, 7], 7],
  "  vs Delta C = ", deltaC,
  "  residual = ", NumberForm[N[deltaC - total, 5], 5]];
