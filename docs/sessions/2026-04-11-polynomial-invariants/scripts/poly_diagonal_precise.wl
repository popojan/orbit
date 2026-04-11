(* Fast DP for diagonal counts *)
diagonalCount[k_Integer, nMax_Integer] := Module[{dp, stairH, newDp, result},
  dp = ConstantArray[0, nMax + 1];
  dp[[1]] = 1;
  Do[If[y <= k, dp[[y + 1]] += dp[[y]]], {y, 1, Min[k, nMax]}];
  result = {dp[[2]]};
  Do[
    stairH = k x;
    newDp = ConstantArray[0, nMax + 1];
    Do[If[y <= stairH, newDp[[y + 1]] = dp[[y + 1]]], {y, 0, Min[stairH, nMax]}];
    Do[If[y <= stairH, newDp[[y + 1]] += newDp[[y]]], {y, 1, Min[stairH, nMax]}];
    dp = newDp;
    If[x <= nMax, AppendTo[result, dp[[x + 1]]]],
    {x, 2, nMax}
  ];
  result
]

nMax = 2000;

Do[
  Print["=== k=", k, " ==="];
  t1 = AbsoluteTime[];
  vals = diagonalCount[k, nMax];
  t2 = AbsoluteTime[];
  Print["  Computed ", nMax, " terms in ", Round[t2 - t1, 0.1], "s"];

  (* Estimates at several points for polynomial extrapolation *)
  (* C(n) = C + a/n + b/n^2 + c/n^3 *)
  (* Use 6 points to fit 6 unknowns *)
  pts = Table[n, {n, nMax - 50, nMax, 10}];  (* 6 points *)
  cEsts = Table[N[vals[[n]] Sqrt[Pi n] / 4^n, 60], {n, pts}];

  (* Fit: C(n) = C + a/n + b/n^2 + c/n^3 + d/n^4 + e/n^5 *)
  vars = {cVar, aVar, bVar, ccc, dVar, eVar};
  eqs = Table[
    cEsts[[i]] == cVar + aVar/pts[[i]] + bVar/pts[[i]]^2 +
      ccc/pts[[i]]^3 + dVar/pts[[i]]^4 + eVar/pts[[i]]^5,
    {i, 1, 6}
  ];
  sol = Solve[eqs, vars][[1]];
  cBest = cVar /. sol;

  Print["  C_", k, " = ", cBest];
  Print["  RootApproximant(2): ", RootApproximant[cBest, 2]];
  Print["  RootApproximant(3): ", RootApproximant[cBest, 3]];
  Print["  RootApproximant(4): ", RootApproximant[cBest, 4]];

  mp2 = MinimalPolynomial[RootApproximant[cBest, 2], x];
  mp3 = MinimalPolynomial[RootApproximant[cBest, 3], x];
  Print["  MinPoly(2): ", mp2];
  Print["  MinPoly(3): ", mp3];
  Print[""];,
  {k, 2, 5}
];
