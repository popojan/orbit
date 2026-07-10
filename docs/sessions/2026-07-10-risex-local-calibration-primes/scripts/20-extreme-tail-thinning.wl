(* 20: the extreme tail of the gap distribution at accessible heights, empirically.
   Script 19 found window-max 176 vs naive Gumbel median 231 (nominal p ~ 5e-5):
   the exponential tail overpredicts extreme gaps.  Test decisively via tail counts
   at t = g/q in {5, 6, 7} across three heights, against two predictions:
     naive:  #(g >= tq) ~ N e^-t          (first-order hazard chain / Cramer)
     Wolf :  #(g >= tq) ~ (N/q) e^-t      (Wolf's refined max-gap heuristic, N -> x/q^2)
   Hypothesis before running: counts fall clearly below naive at t >= 6, between the
   two models at t = 5 (t-dependent thinning). *)

windows = {{5 10^8, 10^6}, {10^9, 10^6}, {4 10^9, 10^6}};
Do[
  {x0, W} = w; q = Log[N[x0]];
  p = NextPrime[x0]; gmax = 0; ngaps = 0; c5 = 0; c6 = 0; c7 = 0;
  While[p < x0 + W,
   pn = NextPrime[p]; g = pn - p;
   If[g > gmax, gmax = g];
   If[g >= 5 q, c5++]; If[g >= 6 q, c6++]; If[g >= 7 q, c7++];
   ngaps++; p = pn];
  Print["x0 = ", N[x0, 2], ": N = ", ngaps, ", max gap = ", gmax];
  Print["   counts g >= {5q, 6q, 7q}: ", {c5, c6, c7}];
  Print["   naive N e^-t          : ", Round[ngaps Exp[-#]] & /@ {5, 6, 7}];
  Print["   Wolf (N/q) e^-t       : ", Round[ngaps/q Exp[-#]] & /@ {5, 6, 7}];
  Print["   Gumbel median naive/Wolf: ", Round[q Log[ngaps/Log[2]]], " / ",
   Round[q Log[ngaps/(q Log[2])]]],
  {w, windows}];
