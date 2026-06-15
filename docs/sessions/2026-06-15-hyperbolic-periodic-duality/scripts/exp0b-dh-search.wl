(* DH off-line zero search, finer grid (machine precision scan -> hi-prec refine). *)
kappa = (Sqrt[10 - 2 Sqrt[5]] - 2)/(Sqrt[5] - 1);            (* validated value *)
kN    = N[kappa, 40];
fDH[s_] := 5^(-s) (HurwitzZeta[s, 1/5] + kN HurwitzZeta[s, 2/5]
                    - kN HurwitzZeta[s, 3/5] - HurwitzZeta[s, 4/5]);

Print["=== fine machine-precision scan of |f| (off-line cells) ==="];
absf[sig_, t_] := Abs[fDH[sig + I t]];
cells = Reap[
   Do[Module[{v = absf[sig, t]},
      If[v < 0.12 && Abs[sig - 0.5] > 0.03, Sow[{sig, t, v}]]],
     {sig, 0.30, 1.60, 0.05}, {t, 0.5, 120, 0.1}]][[2]];
cells = If[cells === {}, {}, SortBy[cells[[1]], Last]];
Print["  off-line candidate cells: ", Length[cells]];
Do[Print["    ", N[cells[[i]], 6]], {i, 1, Min[15, Length[cells]]}];

Print["\n=== FindRoot refinement (hi precision) ==="];
refine[sig0_, t0_] := Quiet@Check[
   Module[{sol},
    sol = FindRoot[{Re[fDH[sig + I t]] == 0, Im[fDH[sig + I t]] == 0},
       {sig, sig0}, {t, t0}, WorkingPrecision -> 30, AccuracyGoal -> 24,
       MaxIterations -> 100];
    {sig, t} /. sol], $Failed];
seen = {};
Do[Module[{c = cells[[i]], r},
   r = refine[c[[1]], c[[2]]];
   If[r =!= $Failed,
    With[{sig = r[[1]], t = r[[2]]},
     If[Abs[sig - 1/2] > 0.02 && t > 0.4 && Im[sig] == 0 &&
        Not[Or @@ (Abs[#[[1]] - sig] < 0.01 && Abs[#[[2]] - t] < 0.01 & /@ seen)],
      AppendTo[seen, {sig, t}];
      Print["  ZERO  s = ", N[sig, 14], " + ", N[t, 14], " I",
        "   |f|=", ScientificForm[N[Abs[fDH[sig + I t]], 4]],
        "   |sig-1/2|=", N[Abs[sig - 1/2], 5]]]]]],
  {i, 1, Length[cells]}];

(* also try a handful of literature-ish targeted seeds *)
Print["\n=== targeted seeds ==="];
Do[Module[{r = refine[sd[[1]], sd[[2]]]},
   If[r =!= $Failed && Abs[r[[1]] - 1/2] > 0.02,
    Print["  seed ", sd, " -> s=", N[r[[1]], 12], " + ", N[r[[2]], 12], " I",
       "  |f|=", ScientificForm[N[Abs[fDH[r[[1]] + I r[[2]]]], 4]]]]],
  {sd, {{0.808, 85.7}, {1.1, 8.0}, {1.18, 18.0}, {0.65, 18.0}, {0.85, 60.0}}}];

Print["\n", Length[seen], " distinct off-line zeros from scan."];
Print["DONE."];
