(* Verification of the ceilSmoothS-form of zetaZeroCount.
   HYPOTHESES (stated before running):
   H1: waveXX[t,p,r] == t Log[p]/(2Pi) + 1/2 - ceilSmoothS[t Log[p]/(2Pi), r]  -- definitional,
       should Simplify to 0 identically (pure substitution 2 Pi x = t Log p).
   H2: therefore zetaZeroCount[t,m] == nt7[t] + m/2 + t theta(p_m)/(2 Pi)
         - Sum ceilSmoothS[t Log[p_k]/(2 Pi), 1/Sqrt[p_k]]
       where theta(p_m) = Sum Log[p_k] is Chebyshev theta = Log[primorial].
       Numeric agreement to machine precision for random t, several m.
   H3: ceilSmoothS[x,1] == ceilBook[x] (the sharp atom is the r=1 member). *)

ceilBook[x_]       := x + 1/2 + ArcTan[Cot[Pi x]]/Pi;
ceilSmoothS[x_, r_] := 1/2 + x - ArcCot[Cot[2 Pi x] - Csc[2 Pi x]/r]/Pi;
waveXX[x_, p_, r_]  := 1/Pi ArcCot[Cot[x Log@p] - Csc[x Log@p]/r];
nt7[t_] := t/(2 Pi) Log[t/(2 Pi E)] + 7/8;

Print["=== H1: waveXX == linear + 1/2 - ceilSmoothS, symbolically ==="];
Print["Simplify: ",
  Simplify[waveXX[t, p, r] - (t Log[p]/(2 Pi) + 1/2 - ceilSmoothS[t Log[p]/(2 Pi), r])]];

zetaZeroCount[t_, m_]  := nt7[t] + Sum[waveXX[t, Prime[k], 1/Sqrt[Prime[k]]], {k, 1, m}];
zetaZeroCountS[t_, m_] := nt7[t] + m/2 + t Sum[Log[Prime[k]], {k, 1, m}]/(2 Pi) -
   Sum[ceilSmoothS[t Log[Prime[k]]/(2 Pi), 1/Sqrt[Prime[k]]], {k, 1, m}];

Print["\n=== H2: both forms agree numerically (random t, several m) ==="];
SeedRandom[7];
diffs = Table[
   With[{tt = RandomReal[{5, 500}], mm = RandomChoice[{1, 5, 20, 100}]},
     zetaZeroCount[tt, mm] - zetaZeroCountS[tt, mm]], {12}];
Print["max |difference|: ", Max[Abs[diffs]]];

Print["\n=== H3: ceilSmoothS[x,1] == ceilBook[x] ==="];
Print["numeric sweep: ", Max @ Table[Abs[N[ceilSmoothS[x0, 1] - ceilBook[x0]]],
    {x0, {0.05, 0.3, 0.49, 0.51, 0.7, 0.95, 1.05, 1.7, -0.3, -0.7, 3.14}}]];
Print["symbolic (both equal Pi/2 - t branch identity): ",
  FullSimplify[ArcCot[Tan[t]] - ArcTan[Cot[t]], 0 < t < Pi]];

Print["\n=== bonus: the linear slope is Chebyshev theta(p_m)/(2 Pi) = Log[primorial]/(2 Pi) ==="];
Do[Print["m=", m, "  slope Sum Log p_k /(2Pi) = ", N[Sum[Log[Prime[k]], {k, m}]/(2 Pi), 6],
    " = Log[", Product[Prime[k], {k, m}], "]/(2 Pi)"], {m, {3, 5}}];
