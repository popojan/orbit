(* 10 -- Jan's plot challenge: ReImPlot of the m=11 prime sum vs Log[Zeta] AT sigma=1/2,
   t in (10,30) "looks cleaner than standard zeta log (smoothed)" -- is it really that off?
   HYPOTHESES (stated before running):
   H1: BETWEEN zeros the truncated sum tracks log zeta well: median |Re diff| and |Im diff|
       of order 0.1-0.4 on t in (10,30) at m=11 -- i.e. Jan's "smoothed log zeta" reading is
       correct; the residual is concentrated at the zeros.
   H2: AT the zeros the Re-difference diverges (Re log zeta ~ log|t-gamma| -> -infinity,
       truncated stays O(1)): |Re diff| grows like -log|t-gamma| as t -> gamma_k.
   H3: increasing m (11 -> 100) improves the between-zeros medians only mildly
       (the series does not converge at sigma=1/2; Selberg-slow, cf. SS3's RMS 0.089 -> 0.05).
   H4: no principal-branch wraps on this window (|Im diff| < Pi throughout), so the
       comparison is branch-safe here.
   Context: this is the visual content of the hybrid Euler-Hadamard decomposition
   (zeta ~ truncated-Euler-product x zero-local factor, Gonek-Hughes-Keating; attribution
   recalled, standard): Jan's plot displays the first factor; the spikes ARE the second. *)

logZetaTr[sig_, t_, m_] := -Sum[Log[1 - Prime[k]^(-sig - I t)], {k, 1, m}];
gams = {14.134725141734694, 21.022039638771555, 25.010857580145688};

grid = Range[10.025, 29.975, 0.05];
d[m_] := Table[logZetaTr[1/2, t, m] - Log[Zeta[1/2 + I t]], {t, grid}];

Print["=== H1/H3: between-zeros tracking, m = 11 vs 100 ==="];
Do[
  dd = d[m];
  Print["m=", m,
    "  median|Re|=", N[Median[Abs[Re[dd]]], 3],
    "  90th pct|Re|=", N[Quantile[Abs[Re[dd]], 0.9], 3],
    "  median|Im|=", N[Median[Abs[Im[dd]]], 3],
    "  90th pct|Im|=", N[Quantile[Abs[Im[dd]], 0.9], 3]],
  {m, {11, 100}}
];
Print["at inter-zero midpoints t = 17.5, 23.0, 27.5 (m=11): ",
  Table[N[Abs[logZetaTr[1/2, t, 11] - Log[Zeta[1/2 + I t]]], 3], {t, {17.5, 23.0, 27.5}}]];

Print["\n=== H2: divergence at the zeros (m=11) ==="];
Do[
  Print["gamma=", N[g, 8], ":  |Re diff| at offsets 0.1/0.01/0.001: ",
    Table[N[Abs[Re[logZetaTr[1/2, g + off, 11] - Log[Zeta[1/2 + I (g + off)]]]], 3],
      {off, {0.1, 0.01, 0.001}}],
    "   (-Log[off] = ", Table[N[-Log[off], 3], {off, {0.1, 0.01, 0.001}}], ")"],
  {g, gams}
];

Print["\n=== H4: branch safety on this window ==="];
Print["points with |Im diff| > Pi (m=11): ", Count[Abs[Im[d[11]]], x_ /; x > Pi], " of ", Length[grid]];
