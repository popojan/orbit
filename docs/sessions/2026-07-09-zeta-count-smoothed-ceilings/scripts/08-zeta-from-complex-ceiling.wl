(* 08 -- Jan's question: can Zeta itself be rewritten in terms of the ceiling, and what
   does "varying r" mean inside the Euler product/sum?
   HYPOTHESES (stated before running):
   H1: complexified ceiling ceilC[x,r] := x + 1/2 + (I/Pi) Log[1 - r Exp[2 Pi I x]] has
       Re ceilC == ceilSmooth (the phase half) and Im ceilC == (1/Pi) Log Abs[1 - r e^{2Pi I x}]
       (the modulus half; r->1 limit = (1/Pi) Log[2|Sin[Pi x]|], the log-sin kernel).
   H2: derivative pair: d/dx Re ceilC == Poisson kernel P_r(2 Pi x),
       d/dx Im ceilC == conjugate Poisson kernel Q_r(2 Pi x) = 2 r Sin[2Pi x]/(1-2r Cos[2Pi x]+r^2).
   H3: the modulus half is the r-ray integral of the phase half's slope:
       Log Abs[1 - r0 e^{I th}] == -Integrate[(P_r(th) - 1)/(2r), {r, 0, r0}]
       (symbolic: d/dr of LHS == -(P_r - 1)/(2r); numeric spot check).
   H4: Cauchy-Riemann in (sigma, t): for u + I v = -Log[1 - p^{-sigma - I t}],
       D[u, sigma] == D[v, t] (so the sigma-ray of the ceiling family carries exactly the
       missing modulus information; (sigma,t) = (log-radial, angular) coordinates).
   H5: FULL zeta from the complex ceiling, sigma > 1:
       Log Zeta[sigma + I t] == -I Pi Sum_p Conj[ceilC[x_p, r_p] - x_p - 1/2],
       x_p = t Log[p]/(2 Pi), r_p = p^-sigma.  Check sigma=2 (tail ~1e-5) and sigma=1.5.
   H6: independent per-prime r's stay an Euler product -- but of the completely
       multiplicative weight system w_p = r_p (Beurling-type L_w); w_p = p^-sigma is the
       unique slice that is zeta's own family L_w = zeta(s + sigma0). (Statement; the
       numeric content is H5.) *)

ceilSmooth[x_, r_] := x + 1/2 + ArcTan[r Sin[2 Pi x]/(1 - r Cos[2 Pi x])]/Pi;
ceilC[x_, r_] := x + 1/2 + (I/Pi) Log[1 - r Exp[2 Pi I x]];

Print["=== H1: Re/Im of the complex ceiling ==="];
(* Re[ceilC] = x + 1/2 - Arg[1 - r e^{2 Pi I x}]/Pi; since Re[1 - r e^{2 Pi I x}]
   >= 1 - r > 0 the principal Arg[w] equals ArcTan[Im w/Re w], and the identity
   Arg[1-re^{2Pi I x}] = -ArcTan[r Sin[2Pi x]/(1-r Cos[2Pi x])] is immediate;
   FullSimplify does not expand Arg on its own, so check numerically: *)
SeedRandom[5];
Print["Re ceilC - ceilSmooth, numeric sweep max|diff|: ",
  Max @ Table[With[{x0 = RandomReal[{-3, 3}], r0 = RandomReal[{0.01, 0.99}]},
     Abs[N[Re[ceilC[x0, r0]] - ceilSmooth[x0, r0]]]], {500}]];
Print["Im ceilC - (1/Pi) Log|1-r e^{2 Pi I x}|: ",
  FullSimplify[ComplexExpand[Im[ceilC[x, r]]] - (1/(2 Pi)) Log[1 - 2 r Cos[2 Pi x] + r^2],
    Assumptions -> 0 < r < 1 && 0 < x < 1]];
Print["r->1 limit of Im ceilC vs (1/Pi) Log[2 Sin[Pi x]]: ",
  FullSimplify[(1/(2 Pi)) Log[2 - 2 Cos[2 Pi x]] - (1/Pi) Log[2 Sin[Pi x]],
    Assumptions -> 0 < x < 1]];

Print["\n=== H2: derivative pair = (Poisson, conjugate Poisson) ==="];
P[r_, th_] := (1 - r^2)/(1 - 2 r Cos[th] + r^2);
Q[r_, th_] := 2 r Sin[th]/(1 - 2 r Cos[th] + r^2);
Print["d/dx Re ceilC - P: ", FullSimplify[D[ceilSmooth[x, r], x] - P[r, 2 Pi x],
   Assumptions -> 0 < r < 1]];
Print["d/dx Im ceilC - Q: ", FullSimplify[D[(1/(2 Pi)) Log[1 - 2 r Cos[2 Pi x] + r^2], x] - Q[r, 2 Pi x],
   Assumptions -> 0 < r < 1]];

Print["\n=== H3: modulus = r-ray integral of the ceiling's slope ==="];
Print["d/dr Log|1-r e^{I th}| + (P-1)/(2r): ",
  Simplify[D[(1/2) Log[1 - 2 r Cos[th] + r^2], r] + (P[r, th] - 1)/(2 r)]];
Print["numeric: -NIntegrate[(P-1)/(2r)] vs Log|1-r0 e^{I th}| at (r0,th)=(0.7,1.3): ",
  {-NIntegrate[(P[r, 1.3] - 1)/(2 r), {r, 0, 0.7}], N[Log[Abs[1 - 0.7 Exp[1.3 I]]]]}];

Print["\n=== H4: Cauchy-Riemann in (sigma, t) ==="];
u = -(1/2) Log[1 - 2 p^-sig Cos[t Log[p]] + p^(-2 sig)];
v = ArcTan[1 - p^-sig Cos[t Log[p]], -p^-sig Sin[t Log[p]]];
(* v = Arg[1 - r e^{+I th}] = Im[-Log[1 - p^{-s}]] (conjugation flips the Arg sign) *)
Print["D[u,sigma] - D[v,t]: ", FullSimplify[D[u, sig] - D[v, t], Assumptions -> p > 1 && sig > 0]];

Print["\n=== H5: Log Zeta from the complex ceiling (Euler regime) ==="];
logZetaCeil[sig_, t_, pmax_] := -I Pi Total[
    Conj @ N[ceilC[t Log[#]/(2 Pi), #^-sig] - t Log[#]/(2 Pi) - 1/2] & /@
      Select[Range[2, pmax], PrimeQ]] /. Conj -> Conjugate;
Do[
  approx = logZetaCeil[sig, tt, 4000];
  exact = Log[Zeta[sig + I tt]];
  Print["sigma=", sig, " t=", tt, "  ceiling form=", N[approx, 8],
    "  Log Zeta=", N[exact, 8], "  |diff|=", N[Abs[approx - exact], 3]],
  {sig, {2, 3/2}}, {tt, {13.7, 50.3}}
];
