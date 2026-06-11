(* 10_dp_revalidation.wl -- corrected DP validation (2026-06-11).
   Script 07's K=50 points had Beatty-word periods (652..701) larger than
   the DP horizon n=350, so the DP read a parent-contaminated crossover,
   not C(x) -- a mirage, not a slow mode (it returned ~C(19/13) for
   953/652). Proper test: family member with period << n.
   Target: 149/102 (K=7 member of the 19/13 below-family, period 149;
   window n = 740..800 gives ~5.4 periods).
   RESULT (2026-06-11): DP C(149/102) = 0.22097496 vs exactCVal
   0.220974763 -- agreement 2e-7, decisively distinct from the parent
   C(19/13) = 0.221704714. The q=13 row values stand.
   Lesson: DP validation requires n >> word period. *)
<< Orbit`

pts = Table[{1.0/k, N[BeattyBallotCount[102/149, {k, k}] Sqrt[Pi k]/4^k, 25]},
  {k, 740, 800}];
Print["DP C(149/102), window n=740..800: ",
  NumberForm[Fit[pts, {1, x}, x] /. x -> 0, 9],
  "   (exactCVal: 0.220974763, parent C(19/13): 0.221704714)"];
