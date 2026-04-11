<< Orbit`

(* Compare staircases and path counts near integer slope k=3 *)

(* Rise sequence: Delta s(x) = Floor[alpha*x] - Floor[alpha*(x-1)] *)
riseSeq[alpha_, xMax_] := Table[Floor[alpha * x] - Floor[alpha * (x - 1)], {x, 1, xMax}]

(* Show staircase details for several slopes near k=3 *)
slopes = {11/4, 23/8, 3, 25/8, 13/4};
labels = {"11/4 = 2.75", "23/8 = 2.875", "3/1 = 3", "25/8 = 3.125", "13/4 = 3.25"};

Print["=== Rise sequences (first 20 steps) ==="];
Do[
  alpha = slopes[[ii]];
  rises = riseSeq[alpha, 20];
  Print[labels[[ii]], ":"];
  Print["  rises = ", rises];
  Print["  heights = ", Accumulate[rises]];
  Print["  period = ", Denominator[alpha]];
  Print["  avg rise = ", N[alpha, 5]];
  Print[""];,
  {ii, 1, Length[slopes]}
];

(* Now compute path counts to small diagonals and compare *)
Print["=== Path counts to (n,n) ==="];
Print["n\t11/4\t23/8\t3\t25/8\t13/4"];
Do[
  counts = Table[
    BeattyBallotCount[1/slopes[[ii]], {nn, nn}],
    {ii, 1, Length[slopes]}
  ];
  Print[nn, "\t", StringRiffle[ToString /@ counts, "\t"]];,
  {nn, {1, 2, 3, 4, 5, 8, 10, 15, 20}}
];

(* Key question: at x where Floor[3x] = Floor[(3-eps)x],
   i.e. where the staircases agree -- do the path counts differ? *)
Print["\n=== Staircase comparison: 3 vs 11/4 ==="];
Print["x\tFloor[3x]\tFloor[11x/4]\tDiff"];
Do[
  h3 = Floor[3 * x];
  h114 = Floor[11 * x / 4];
  Print[x, "\t", h3, "\t\t", h114, "\t\t", h3 - h114];,
  {x, 1, 20}
];

Print["\n=== Staircase comparison: 3 vs 13/4 ==="];
Print["x\tFloor[3x]\tFloor[13x/4]\tDiff"];
Do[
  h3 = Floor[3 * x];
  h134 = Floor[13 * x / 4];
  Print[x, "\t", h3, "\t\t", h134, "\t\t", h3 - h134];,
  {x, 1, 20}
];

(* Transfer matrix perspective:
   For integer k, each step is L_k (lower triangular, all 1s, size (k+1))
   For rational p/q, the steps alternate between L_k and L_{k-1} or L_{k+1}
   in a Sturmian pattern *)

Print["\n=== Transfer matrix structure ==="];
Do[
  alpha = slopes[[ii]];
  rises = riseSeq[alpha, Denominator[alpha]];
  Print[labels[[ii]], ": one period = ", rises,
    "  sizes = ", (# + 1) & /@ rises,
    "  product of L_", rises];,
  {ii, 1, Length[slopes]}
];
