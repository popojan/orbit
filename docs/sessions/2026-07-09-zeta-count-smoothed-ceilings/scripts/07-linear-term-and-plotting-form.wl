(* 07 -- Jan's two questions (2026-07-09):
   (a) is the linear term t theta(p_m)/(2 Pi) a standard ANT object?
   (b) why does the bare sum -Sum ceilSmoothS[t Log p/(2 Pi), 1/Sqrt p] LOOK discontinuous?
   HYPOTHESES (stated before running):
   H1: ceilSmoothS (ArcCot/Cot/Csc form) == ceilSmooth (SS8.9 ArcTan form, denominator
       1 - r Cos[2 Pi x] > 0, pole-free) identically for 0 < r < 1 -- same function,
       different representation.
   H2: the ArcCot/Cot/Csc representation is Indeterminate at every half-period point
       x = k/2 (Cot and Csc poles); the FUNCTION is real-analytic there (side limits
       agree, ArcTan form evaluates fine). Plot breaks are a representation artifact
       (failed samples / auto-Exclusions at the Cot/Csc poles), not discontinuity.
   H3: the ArcCot argument u = Cot[2 Pi x] - Csc[2 Pi x]/r NEVER vanishes for 0 < r < 1
       (numerator r Cos - 1 < 0), so no ArcCot branch jump inside a period; the only
       trouble points are x = k/2, and those are removable.
   H4: linear-term context: nt7'(t) = Log[t/(2 Pi)]/(2 Pi) exactly, so the truncated
       counter's constant density theta(p_m)/(2 Pi) equals zeta's local zero density
       EXACTLY at t = 2 Pi p_m# (primorial). And the zeros of the truncated Euler
       product Prod(1 - p^{-s}) on sigma = 0 are the AP union {2 Pi j/Log p}:
       count in (0,T] = Sum Floor[T Log p/(2 Pi)] = T theta(p_m)/(2 Pi) + O(m). *)

ceilSmoothS[x_, r_] := 1/2 + x - ArcCot[Cot[2 Pi x] - Csc[2 Pi x]/r]/Pi;
ceilSmooth[x_, r_]  := x + 1/2 + ArcTan[r Sin[2 Pi x]/(1 - r Cos[2 Pi x])]/Pi;
nt7[t_] := t/(2 Pi) Log[t/(2 Pi E)] + 7/8;

Print["=== H1: ceilSmoothS == ceilSmooth (pole-free SS8.9 form) ==="];
(* plain Simplify stalls (needs case analysis in x); prove on each half-period cell *)
Print["piecewise symbolic, 0<x<1/2: ",
  FullSimplify[ceilSmoothS[x, r] - ceilSmooth[x, r], Assumptions -> 0 < r < 1 && 0 < x < 1/2]];
Print["piecewise symbolic, 1/2<x<1: ",
  FullSimplify[ceilSmoothS[x, r] - ceilSmooth[x, r], Assumptions -> 0 < r < 1 && 1/2 < x < 1]];
SeedRandom[3];
Print["numeric sweep max|diff| (500 random x in (-5,5), r in (0,1)): ",
  Max @ Table[With[{x0 = RandomReal[{-5, 5}], r0 = RandomReal[{0.01, 0.99}]},
     Abs[N[ceilSmoothS[x0, r0] - ceilSmooth[x0, r0]]]], {500}]];

Print["\n=== H2: representation vs function at the half-period points ==="];
Print["ceilSmoothS[1, 1/2]   = ", Quiet[ceilSmoothS[1, 1/2]],
  "   ceilSmooth[1, 1/2]   = ", ceilSmooth[1, 1/2]];
Print["ceilSmoothS[3/2, 1/2] = ", Quiet[ceilSmoothS[3/2, 1/2]],
  "   ceilSmooth[3/2, 1/2] = ", ceilSmooth[3/2, 1/2]];
Print["side limits of ceilSmoothS at x=1 (r=1/2): ",
  {Limit[ceilSmoothS[x, 1/2], x -> 1, Direction -> "FromBelow"],
   Limit[ceilSmoothS[x, 1/2], x -> 1, Direction -> "FromAbove"]}, "  (both = 3/2: removable)"];
Print["side limits at x=3/2: ",
  {Limit[ceilSmoothS[x, 1/2], x -> 3/2, Direction -> "FromBelow"],
   Limit[ceilSmoothS[x, 1/2], x -> 3/2, Direction -> "FromAbove"]}, "  (removable)"];

Print["\n=== H3: the ArcCot argument never crosses 0 (no branch jump inside a period) ==="];
Print["Reduce[Cot[th] - Csc[th]/r == 0, 0<r<1, 0<th<2Pi]: ",
  Reduce[Cot[th] - Csc[th]/r == 0 && 0 < r < 1 && 0 < th < 2 Pi, th]];

Print["\n=== H4: the linear term is the RvM law of the truncated Euler product ==="];
Print["nt7'(t) == Log[t/(2Pi)]/(2Pi): ", FullSimplify[D[nt7[t], t] - Log[t/(2 Pi)]/(2 Pi), t > 0]];
Do[
  thetam = Sum[Log[Prime[k]], {k, m}]; primorial = Product[Prime[k], {k, m}];
  Print["m=", m, "  density match nt7'(2 Pi p_m#) - theta/(2Pi) = ",
    FullSimplify[(D[nt7[t], t] /. t -> 2 Pi primorial) - thetam/(2 Pi)],
    "   (t* = 2 Pi * ", primorial, " = ", N[2 Pi primorial, 6], ")"],
  {m, {3, 5, 8}}
];
Print["AP-union zero count of Prod(1-p^{-s}) on sigma=0 vs T theta/(2Pi)  (diff, bound m):"];
Do[
  thetam = Sum[Log[Prime[k]], {k, m}];
  Print["  m=", m, ": ", Table[
     {T, Sum[Floor[T Log[Prime[k]]/(2 Pi)], {k, m}] - T thetam/(2 Pi) // N[#, 3] &},
     {T, {100, 1000}}]],
  {m, {5, 20}}
];
