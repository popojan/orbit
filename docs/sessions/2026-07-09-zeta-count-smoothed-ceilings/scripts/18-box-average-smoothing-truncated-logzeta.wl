(* 18 -- Jan's box-average smoothing of the truncated critical-line log sum:
   (1/2w) Integrate[Sum_p Log[1-p^(-It)/Sqrt[p]], {x,t-w,t+w}], w=1/2 heuristic.
   "Unusually well" approximates Log[Zeta[1/2+it]] on t in (13,33) (zeros 1-5).
   HYPOTHESES (stated before running):
   H1: the box average has a clean closed form in dilogs, matching Jan's own
       ReImPlot expression exactly (sign convention: log zeta = -Sum Log[1-p^-s],
       so the "+I" prefactor in Jan's formula, not "-I", is the one that sums
       correctly to approximate log zeta -- verified against -NIntegrate).
   H2: away from the true zeros, box-smoothing (w=1/2, m=50 primes) gives a
       real, substantial (not illusory) error reduction vs. the unsmoothed
       (w->0) truncated sum, measured against the true Log[Zeta[1/2+it]].
   H3 (Jan's correction): near a zero, AMPLITUDE comparison against the true
       (divergent) log zeta is the wrong test -- neither construction can
       reach -Infinity. The right test is LOCATION: does the approximation's
       own local minimum sit closer to the true zero? *)

closedFormTerm[p_?NumericQ, t_?NumericQ, w_?NumericQ] := (1/(2 w)) (I/Log[p]) (
    PolyLog[2, p^(-1/2 - I t - I w)] - PolyLog[2, p^(-1/2 - I t + I w)]);
boxSmoothed[t_?NumericQ, w_?NumericQ, m_] := Sum[closedFormTerm[p, t, w], {p, Prime /@ Range[m]}];
unsmoothed[t_?NumericQ, m_] := -Sum[Log[1 - p^(-1/2 - I t)], {p, Prime /@ Range[m]}];

Print["=== H1: closed form matches -NIntegrate ground truth (sign check) ==="];
Print["|closedFormTerm[3,15.7,0.5] - (-NIntegrate[Log[1-3^-.5 3^-Ix],{x,15.2,16.2}])|: ",
  Abs[closedFormTerm[3, 15.7, 0.5] -
     (-NIntegrate[Log[1 - 3^(-1/2) 3^(-I x)], {x, 15.2, 16.2}])]];

m0 = 50; w0 = 0.5;
trueZeros = N[Im[ZetaZero[Range[10]]]];
zerosInRange = Select[trueZeros, 13 < # < 33 &];
grid = Range[13.2, 32.8, 0.1];
trueVals = Log[Zeta[0.5 + I #]] & /@ grid;
nearMask = Table[Min[Abs[g - zerosInRange]] < 0.5, {g, grid}];
awayGrid = Pick[grid, Not /@ nearMask];
awayTrue = Pick[trueVals, Not /@ nearMask];

Print["\n=== H2: away-from-zeros error, box-smoothed vs unsmoothed (m=50, w=1/2) ==="];
smoothVals = boxSmoothed[#, w0, m0] & /@ awayGrid;
rawVals = unsmoothed[#, m0] & /@ awayGrid;
Print["median|diff| box-smoothed: ", N[Median[Abs[smoothVals - awayTrue]], 4],
  "   unsmoothed: ", N[Median[Abs[rawVals - awayTrue]], 4]];

Print["\n=== H3: corrected near-zero test -- LOCATION of nearest local minimum ==="];
findNearestLocalMin[f_, gam_, halfWindow_] := Module[{fineT, vals, mins},
   fineT = Range[gam - halfWindow, gam + halfWindow, 0.01];
   vals = f /@ fineT;
   mins = Table[
     If[vals[[i]] < vals[[i - 1]] && vals[[i]] < vals[[i + 1]], fineT[[i]], Nothing],
     {i, 2, Length[vals] - 1}];
   If[mins === {}, Missing["NoLocalMin"], First[SortBy[mins, Abs[# - gam] &]]]
   ];
Do[
  reBox = Re[boxSmoothed[#, w0, m0]] &;
  reUn = Re[unsmoothed[#, m0]] &;
  bMin = findNearestLocalMin[reBox, z, 1.5];
  uMin = findNearestLocalMin[reUn, z, 1.5];
  Print["gamma=", N[z, 6], "  box dist=", N[Abs[bMin - z], 4],
    "   unsmoothed dist=", N[Abs[uMin - z], 4]],
  {z, zerosInRange}
];

Print["\n=== w-sweep: where does the away-from-zeros error bottom out? ==="];
Do[
  vals = boxSmoothed[#, w, m0] & /@ awayGrid;
  Print["w=", w, "  median|diff|: ", N[Median[Abs[vals - awayTrue]], 5]],
  {w, {0.3, 0.4, 0.44, 0.46, 0.48, 0.5, 0.52, 0.54, 0.56, 0.6, 0.8, 1.0, 1.5, 2.0, 3.0}}
];
