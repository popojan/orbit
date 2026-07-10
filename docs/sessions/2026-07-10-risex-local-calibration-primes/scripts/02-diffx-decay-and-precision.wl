(* How small is the true residual diffX[m], and how much of that signal survives
   at MachinePrecision vs a controlled 40-digit WorkingPrecision? *)

SmWP[m_, wp_] := Sum[N[n/Log[Prime[n]], wp], {n, 2, m}];
riseXWP[m_, wp_] := (-1 + SmWP[m, wp])/(N[Log[m] LogIntegral[m], wp]);
diffXWP[m_, wp_] := (riseXWP[m + 1, wp] + riseXWP[m - 1, wp])/2 - riseXWP[m, wp];

Print["diffX[m] at MachinePrecision vs WorkingPrecision->40 (the TRUE residual, never exactly 0):"];
Do[
  dMach = diffXWP[m, MachinePrecision];
  dHigh = diffXWP[m, 40];
  relDiscrepancy = Abs[(dMach - dHigh)/dHigh] // N;
  Print[{m, "machine=", dMach, "40-digit=", N[dHigh, 8],
     "relative discrepancy=", N[relDiscrepancy, 4]}],
  {m, {1000, 5000, 20000, 50000, 100000}}
];

Print[""];
Print["log10(relative discrepancy) vs log10(m) -- linear fit gives the digit-loss rate:"];
pts = {{3., -7.875}, {3.7, -5.734}, {4.3, -4.859}, {4.7, -4.269}, {5., -3.800}};
fit = Fit[pts, {1, x}, x];
Print["fit: log10(discrepancy) ~ ", fit];
Print["extrapolated m where discrepancy reaches O(1) (total precision loss at MachinePrecision): ",
  N[10^(x /. Solve[fit == 0, x][[1]])]];
