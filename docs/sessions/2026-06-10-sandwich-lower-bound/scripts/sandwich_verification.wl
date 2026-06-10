(* Verify: L(alpha) <= C_exact(p/q) <= U(alpha), with
   L = (1 - Exp[-4 a (a-1)/(a+1)^2])/2          (Lundberg lower bound)
   U = (1 - rho0^(a+2))/2, rho0^(a+1) = 2 rho0 - 1  (coupling upper bound)
   and L >= g = 1/2 - 2^-a on (1, 3/2].
   Exact C via master equation + q x q boundary system (paper Sec. 5). *)

prec = 50;

cExact[p_, q_] := Module[{rise, poly, roots, sub, amps, mat, cs, s0, j0, val},
  rise = Table[Floor[p (j + 1)/q] - Floor[p j/q], {j, 0, q - 1}];
  poly = Expand[(2 t - 1)^q - t^(p + q)];
  roots = t /. NSolve[poly == 0, t, WorkingPrecision -> prec];
  sub = Select[roots, Abs[#] < 1 - 10^-10 &];
  If[Length[sub] != q, Print["WARN: ", {p, q}, " sub-unit roots: ",
    Length[sub]]];
  amps = Table[Product[(2 ti - 1)/ti^(rise[[m + 1]] + 1), {m, 0, j - 1}],
      {ti, sub}, {j, 0, q - 1}];  (* amps[[i, j+1]] = A_j^(i) *)
  mat = Table[amps[[i, j + 1]]/sub[[i]], {j, 0, q - 1}, {i, q}];
  cs = LinearSolve[mat, Table[1, {q}]];
  s0 = Floor[p/q]; j0 = Mod[1, q];
  val = (1 - Sum[cs[[i]] amps[[i, j0 + 1]] sub[[i]]^s0, {i, q}])/2;
  Re[Chop[val, 10^-30]]]

rho0[alpha_] := rho /. FindRoot[rho^(alpha + 1) - 2 rho + 1,
  {rho, 7/10, 1/2 + 10^-8, 1 - 10^-8},
  WorkingPrecision -> prec, MaxIterations -> 200]

lBound[alpha_] := (1 - Exp[-4 alpha (alpha - 1)/(alpha + 1)^2])/2
uBound[alpha_] := (1 - rho0[alpha]^(alpha + 2))/2
gLower[alpha_] := 1/2 - 2^-alpha

Print["=== Implementation cross-check vs paper table ==="];
tbl = {{3, 2, 0.251848165836}, {5, 2, 0.412376117412},
  {5, 3, 0.284123009123}, {7, 3, 0.398094901320},
  {4, 3, 0.190858929}, {7, 4, 0.295424544708}};
Do[
  Module[{cv = cExact[r[[1]], r[[2]]]},
    Print["C(", r[[1]], "/", r[[2]], ") = ", N[cv, 12], "  paper: ",
      r[[3]], "  ", If[Abs[cv - r[[3]]] < 10^-8, "OK", "MISMATCH"]]],
  {r, tbl}];
Print[""];

Print["=== Integer-slope sanity: C(k) = 1 - 1/tau_k ==="];
Do[
  Module[{cv = cExact[k, 1], cs = 1 - rho0[k]},
    Print["C(", k, ") = ", N[cv, 12], "  1-rho0 = ", N[cs, 12], "  ",
      If[Abs[cv - cs] < 10^-20, "OK", "MISMATCH"]]],
  {k, 2, 5}];
Print[""];

Print["=== Sandwich sweep: coprime p/q, q <= 8, 1 < p/q <= 4 ==="];
fails = {}; minSlackL = Infinity; minSlackU = Infinity; nTested = 0;
Do[
  Do[
    If[GCD[p, q] == 1 && p/q > 1 && p/q <= 4,
      Module[{a = p/q, cv, lo, hi},
        cv = cExact[p, q]; lo = N[lBound[a], prec]; hi = N[uBound[a], prec];
        nTested++;
        If[cv < lo, AppendTo[fails, {"L violated", p, q, N[cv, 15],
          N[lo, 15]}]];
        If[cv > hi, AppendTo[fails, {"U violated", p, q, N[cv, 15],
          N[hi, 15]}]];
        minSlackL = Min[minSlackL, cv - lo];
        minSlackU = Min[minSlackU, hi - cv]]],
    {p, q + 1, 4 q}],
  {q, 1, 8}];
Print["tested: ", nTested, "  failures: ", Length[fails]];
If[fails =!= {}, Print[Take[fails, UpTo[8]]]];
Print["min slack C - L: ", N[minSlackL, 6]];
Print["min slack U - C: ", N[minSlackU, 6]];
Print[""];

Print["=== L >= g on (1, 3/2]: h(alpha) = 4 alpha - ln2 (alpha+1)^2 ==="];
Print["h(1)   = ", N[4 - Log[2] 4, 20], " > 0: ", 4 - Log[2] 4 > 0];
Print["h(3/2) = ", N[6 - Log[2] 25/4, 20], " > 0: ", 6 - Log[2] 25/4 > 0];
Print["h concave (h'' = -2 ln2 < 0) => h > 0 on [1, 3/2]. Roots: ",
  N[alpha /. Solve[4 alpha - Log[2] (alpha + 1)^2 == 0, alpha], 6]];
gridFail = Select[Table[{a, N[lBound[a] - gLower[a], 20]},
  {a, 101/100, 3/2, 1/100}], #[[2]] < 0 &];
Print["grid check L - g on (1, 3/2], failures: ", Length[gridFail]];
Print[""];

Print["=== Bound quality snapshot (alpha, g, L, C, U, C_smooth) ==="];
Do[
  Module[{a = r[[1]]/r[[2]], cv = cExact[r[[1]], r[[2]]]},
    Print[N[a, 4], "  g=", N[gLower[a], 5], "  L=", N[lBound[a], 5],
      "  C=", N[cv, 5], "  U=", N[uBound[a], 5],
      "  Csm=", N[1 - rho0[a], 5]]],
  {r, {{21, 20}, {9, 8}, {6, 5}, {4, 3}, {3, 2}, {5, 3}, {2, 1}, {5, 2},
    {3, 1}, {7, 2}}}];
Print[""];
Print["===== DONE ====="];
