(* Optimized DP: avoid AppendTo, preallocate *)
diagonalCount[k_Integer, nMax_Integer] := Module[{dp, newDp, stairH, result},
  dp = ConstantArray[0, nMax + 1];
  dp[[1]] = 1;
  Do[If[y <= k, dp[[y + 1]] += dp[[y]]], {y, 1, Min[k, nMax]}];
  result = ConstantArray[0, nMax];
  result[[1]] = dp[[2]];
  Do[
    stairH = k x;
    newDp = ConstantArray[0, nMax + 1];
    Do[newDp[[y + 1]] = dp[[y + 1]], {y, 0, Min[stairH, nMax]}];
    Do[newDp[[y + 1]] += newDp[[y]], {y, 1, Min[stairH, nMax]}];
    dp = newDp;
    If[x <= nMax, result[[x]] = dp[[x + 1]]],
    {x, 2, nMax}
  ];
  result
]

nMax = 3000;

Do[
  Print["=== k=", k, " (n=", nMax, ") ==="];
  t1 = AbsoluteTime[];
  vals = diagonalCount[k, nMax];
  t2 = AbsoluteTime[];
  Print["  Time: ", Round[t2 - t1, 0.1], "s"];

  (* Polynomial extrapolation with 8 points *)
  pts = Table[n, {n, nMax - 70, nMax, 10}];
  cEsts = Table[N[vals[[n]] Sqrt[Pi n] / 4^n, 80], {n, pts}];
  vars = Table[Symbol["v" <> ToString[i]], {i, 1, Length[pts]}];
  eqs = Table[
    cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
    {i, 1, Length[pts]}
  ];
  sol = Solve[eqs, vars][[1]];
  cBest = vars[[1]] /. sol;

  Print["  C_", k, " = ", cBest];
  Print[""];

  (* Test specific guesses *)
  If[k == 2,
    Print["  Known: 1/phi^2 = ", N[1/GoldenRatio^2, 40]];
    Print["  Error: ", Abs[cBest - N[1/GoldenRatio^2, 80]]];
  ];

  (* Test x^2 - (k+1)x + 1 = 0 (naive generalization) *)
  naive = (k + 1 - Sqrt[(k+1)^2 - 4])/2;
  Print["  x^2-", k+1, "x+1=0 smaller root: ", N[naive, 20], "  match: ", Abs[cBest - N[naive, 80]] < 10^-6];

  (* RootApproximant with high precision *)
  Print["  RootApproximant(2): ", RootApproximant[cBest, 2]];
  ra3 = RootApproximant[cBest, 3];
  Print["  RootApproximant(3): ", ra3];
  If[ra3 =!= $Failed && Head[ra3] =!= RootApproximant,
    mp = MinimalPolynomial[ra3, x];
    Print["  MinPoly: ", mp, " degree=", Exponent[mp, x]];
    Print["  Verify: ", N[ra3, 30], " vs ", N[cBest, 30]];
  ];
  ra4 = RootApproximant[cBest, 4];
  Print["  RootApproximant(4): ", ra4];
  If[ra4 =!= $Failed && Head[ra4] =!= RootApproximant,
    mp4 = MinimalPolynomial[ra4, x];
    Print["  MinPoly: ", mp4, " degree=", Exponent[mp4, x]];
  ];

  Print[""];,
  {k, 2, 5}
];
