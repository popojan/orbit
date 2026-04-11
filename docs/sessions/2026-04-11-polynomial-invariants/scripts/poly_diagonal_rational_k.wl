<< Orbit`

(* Test: does (1-C)^{k+1} = 1-2C hold for non-integer k? *)

(* For rational slope k = p/q, use BeattyBallotCount[q/p, {n, n}] *)
(* Staircase: Floor[n / (q/p)] = Floor[np/q] *)

diagonalBeatty[alpha_, nMax_] := Table[
  BeattyBallotCount[alpha, {n, n}],
  {n, 1, nMax}
]

estimateC[vals_, nStart_: 0] := Module[{pts, cEsts, vars, eqs, sol, nn},
  nn = Length[vals];
  pts = Table[n, {n, nn - 50, nn, 10}];
  cEsts = Table[N[vals[[n]] Sqrt[Pi n] / 4^n, 60], {n, pts}];
  vars = Table[Symbol["vv" <> ToString[i]], {i, 1, Length[pts]}];
  eqs = Table[
    cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
    {i, 1, Length[pts]}
  ];
  sol = Solve[eqs, vars][[1]];
  vars[[1]] /. sol
]

nMax = 500;

(* Integer cases for verification *)
Print["=== Integer k (verification) ==="];
Do[
  vals = diagonalBeatty[1/k, nMax];
  cEst = estimateC[vals];
  lhs = (1 - cEst)^(k + 1);
  rhs = 1 - 2 cEst;
  Print["k=", k, ": C=", N[cEst, 15],
    "  (1-C)^", k+1, " = ", N[lhs, 15],
    "  1-2C = ", N[rhs, 15],
    "  match: ", Abs[lhs - rhs] < 10^-8];,
  {k, 2, 4}
];

Print[""];
Print["=== Rational k = 5/2 ==="];
(* k = 5/2: staircase Floor[5x/2], use alpha = 2/5 *)
vals52 = diagonalBeatty[2/5, nMax];
Print["First 15 values: ", Take[vals52, 15]];
c52 = estimateC[vals52];
Print["C_{5/2} = ", N[c52, 20]];

(* Test equation with real exponent *)
lhs52 = (1 - c52)^(5/2 + 1);
rhs52 = 1 - 2 c52;
Print["(1-C)^{7/2} = ", N[lhs52, 20]];
Print["1-2C        = ", N[rhs52, 20]];
Print["Match: ", Abs[N[lhs52 - rhs52, 20]] < 10^-6];

Print[""];
Print["=== Rational k = 3/2 ==="];
vals32 = diagonalBeatty[2/3, nMax];
Print["First 15 values: ", Take[vals32, 15]];
c32 = estimateC[vals32];
Print["C_{3/2} = ", N[c32, 20]];
lhs32 = (1 - c32)^(3/2 + 1);
rhs32 = 1 - 2 c32;
Print["(1-C)^{5/2} = ", N[lhs32, 20]];
Print["1-2C        = ", N[rhs32, 20]];
Print["Match: ", Abs[N[lhs32 - rhs32, 20]] < 10^-6];

Print[""];
Print["=== Rational k = 7/3 ==="];
vals73 = diagonalBeatty[3/7, nMax];
c73 = estimateC[vals73];
Print["C_{7/3} = ", N[c73, 20]];
lhs73 = (1 - c73)^(7/3 + 1);
rhs73 = 1 - 2 c73;
Print["(1-C)^{10/3} = ", N[lhs73, 20]];
Print["1-2C         = ", N[rhs73, 20]];
Print["Match: ", Abs[N[lhs73 - rhs73, 20]] < 10^-6];

Print[""];
Print["=== Irrational k = Sqrt[5] ==="];
valsSqrt5 = diagonalBeatty[1/Sqrt[5], nMax];
cSqrt5 = estimateC[valsSqrt5];
Print["C_{Sqrt5} = ", N[cSqrt5, 20]];
lhsS5 = (1 - cSqrt5)^(Sqrt[5] + 1);
rhsS5 = 1 - 2 cSqrt5;
Print["(1-C)^{1+Sqrt5} = ", N[lhsS5, 20]];
Print["1-2C             = ", N[rhsS5, 20]];
Print["Match: ", Abs[N[lhsS5 - rhsS5, 20]] < 10^-6];
