(* Fast diagonal computation: BeattyBallotCount[1/k, {n, n}] *)
(* Staircase Floor[k*x], paths from (1,0) to (n,n) *)
(* Direct DP without loading Orbit — just the core algorithm *)

diagonalCount[k_Integer, nMax_Integer] := Module[
  {stair, dp, m},
  (* staircase at position x: Floor[k*x] *)
  (* DP: dp[x, y+1] = paths from (1,0) to (x,y) under staircase *)
  (* We only need the column at x=n, height n *)
  (* But we need the full DP table up to (nMax, nMax) *)

  (* Optimized: only keep current and previous x-column *)
  (* dp[y+1] = count at current position x, height y *)
  dp = ConstantArray[0, nMax + 1];  (* indices 1..nMax+1 for heights 0..nMax *)
  dp[[1]] = 1;  (* at position 1, height 0: one path *)

  (* Process position 1: stair height = k*1 = k *)
  (* Can go up from height 0 to min(k, nMax) *)
  Do[
    If[y <= k, dp[[y + 1]] = dp[[y + 1]] + dp[[y]]];,
    {y, 1, Min[k, nMax]}
  ];

  result = {dp[[2]]};  (* count at (1,1) — but we start from (1,0) *)

  Do[
    stairH = k x;  (* Floor[k*x] = k*x for integer k *)
    (* New column: first copy previous (right step) *)
    newDp = ConstantArray[0, nMax + 1];
    Do[
      If[y <= stairH, newDp[[y + 1]] = dp[[y + 1]]];,
      {y, 0, Min[stairH, nMax]}
    ];
    (* Then accumulate up steps *)
    Do[
      If[y <= stairH, newDp[[y + 1]] = newDp[[y + 1]] + newDp[[y]]];,
      {y, 1, Min[stairH, nMax]}
    ];
    dp = newDp;
    If[x <= nMax, AppendTo[result, dp[[x + 1]]]];  (* diagonal: height x at position x *)
    ,
    {x, 2, nMax}
  ];
  result
]

(* Test against Orbit for small values *)
Print["=== Verification ==="];
test3 = diagonalCount[3, 15];
Print["k=3 fast: ", test3];
Print["Expected: {1, 3, 10, 34, 121, 441, 1628, 6077, 22879, 86691, 330210, 1263274, 4850434, 18681112, 72140344}"];
Print["Match: ", test3 === {1, 3, 10, 34, 121, 441, 1628, 6077, 22879, 86691, 330210, 1263274, 4850434, 18681112, 72140344}];

Print[""];
Print["=== Speed test ==="];
t1 = AbsoluteTime[];
v100 = diagonalCount[3, 100];
t2 = AbsoluteTime[];
Print["k=3, n=100: ", t2 - t1, "s, last value has ", IntegerLength[v100[[-1]]], " digits"];

t1 = AbsoluteTime[];
v200 = diagonalCount[3, 200];
t2 = AbsoluteTime[];
Print["k=3, n=200: ", t2 - t1, "s, last value has ", IntegerLength[v200[[-1]]], " digits"];

t1 = AbsoluteTime[];
v500 = diagonalCount[3, 500];
t2 = AbsoluteTime[];
Print["k=3, n=500: ", t2 - t1, "s, last value has ", IntegerLength[v500[[-1]]], " digits"];

Print[""];
Print["=== Asymptotic constant from large n ==="];
Print[""];

(* Use n=400..500 for Richardson *)
estimates = Table[
  {n, N[v500[[n]] Sqrt[Pi n] / 4^n, 50]},
  {n, 480, 500}
];
Do[Print["  n=", e[[1]], ": ", e[[2]]], {e, estimates}];

(* Aitken delta-squared acceleration *)
Print[""];
Print["=== Aitken acceleration ==="];
cn = Table[N[v500[[n]] Sqrt[Pi n] / 4^n, 50], {n, 450, 500}];
aitken = Table[
  Module[{s0 = cn[[i]], s1 = cn[[i+1]], s2 = cn[[i+2]], d},
    d = s2 - 2 s1 + s0;
    If[Abs[d] > 10^-40, s0 - (s1 - s0)^2 / d, s0]
  ],
  {i, 1, Length[cn] - 2}
];
Print["Aitken estimates (last 5):"];
Do[Print["  ", aitken[[-i]]], {i, 5, 1, -1}];

Print[""];
best = aitken[[-1]];
Print["Best estimate C_3: ", best];
Print[""];
Print["RootApproximant (degree 2): ", RootApproximant[best, 2]];
Print["RootApproximant (degree 3): ", RootApproximant[best, 3]];
Print["RootApproximant (degree 4): ", RootApproximant[best, 4]];
Print["RootApproximant (degree 6): ", RootApproximant[best, 6]];
Print["RootApproximant (degree 8): ", RootApproximant[best, 8]];

Print[""];
Print["=== Same for k=2 (verify: should find 1/phi^2) ==="];
v500k2 = diagonalCount[2, 500];
cn2 = Table[N[v500k2[[n]] Sqrt[Pi n] / 4^n, 50], {n, 450, 500}];
aitken2 = Table[
  Module[{s0 = cn2[[i]], s1 = cn2[[i+1]], s2 = cn2[[i+2]], d},
    d = s2 - 2 s1 + s0;
    If[Abs[d] > 10^-40, s0 - (s1 - s0)^2 / d, s0]
  ],
  {i, 1, Length[cn2] - 2}
];
best2 = aitken2[[-1]];
Print["Best estimate C_2: ", best2];
Print["1/phi^2 = ", N[1/GoldenRatio^2, 50]];
Print["RootApproximant: ", RootApproximant[best2, 4]];

Print[""];
Print["=== k=4,5 constants ==="];
Do[
  v500k = diagonalCount[k, 500];
  cnk = Table[N[v500k[[n]] Sqrt[Pi n] / 4^n, 50], {n, 450, 500}];
  aitkenk = Table[
    Module[{s0 = cnk[[i]], s1 = cnk[[i+1]], s2 = cnk[[i+2]], d},
      d = s2 - 2 s1 + s0;
      If[Abs[d] > 10^-40, s0 - (s1 - s0)^2 / d, s0]
    ],
    {i, 1, Length[cnk] - 2}
  ];
  bestk = aitkenk[[-1]];
  Print["k=", k, ": C ~ ", bestk];
  Print["  RootApproximant(4): ", RootApproximant[bestk, 4]];
  Print["  RootApproximant(6): ", RootApproximant[bestk, 6]];,
  {k, 4, 5}
];
