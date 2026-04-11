<< Orbit`

(* High-precision identification of C for slope 3/2 using integer relations *)

nMax = 500;
alpha = 2/3;
vals = Table[BeattyBallotCount[alpha, {n, n}], {n, 1, nMax}];

(* High-precision extrapolation *)
pts = Table[n, {n, nMax - 50, nMax, 5}];
cEsts = Table[N[vals[[n]] Sqrt[Pi n]/4^n, 80], {n, pts}];
vars = Table[Unique["w"], {Length[pts]}];
eqs = Table[
  cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
  {i, 1, Length[pts]}
];
sol = Quiet@Solve[eqs, vars];
c = vars[[1]] /. sol[[1]];

Print["slope 3/2: C = ", N[c, 40]];
Print[""];

(* PSLQ-style: find integer relation [a0, a1, ..., ad] such that *)
(* a0 + a1*C + a2*C^2 + ... + ad*C^d = 0 *)

Do[
  powers = Table[N[c^k, 60], {k, 0, deg}];
  nullVec = Quiet@FindIntegerNullVector[powers, 100];
  If[nullVec =!= $Failed && nullVec =!= {} && Length[nullVec] > 0,
    poly = Sum[nullVec[[k + 1]] x^k, {k, 0, deg}];
    maxC = Max[Abs[nullVec]];
    res = Abs[N[poly /. x -> c, 40]];
    If[res < 10^-15 && maxC < 10000,
      Print["deg ", deg, ": ", poly, " = 0"];
      Print["  coeffs: ", nullVec];
      Print["  max coeff: ", maxC];
      Print["  residual: ", res];
      Print["  factor: ", Factor[poly]];
      Print[""];
    ];
  ];,
  {deg, 2, 12}
];

(* Also try for other slopes *)
Print["=== slope 5/2 ==="];
vals52 = Table[BeattyBallotCount[2/5, {n, n}], {n, 1, nMax}];
cEsts52 = Table[N[vals52[[n]] Sqrt[Pi n]/4^n, 80], {n, pts}];
vars52 = Table[Unique["v"], {Length[pts]}];
eqs52 = Table[
  cEsts52[[i]] == vars52[[1]] + Sum[vars52[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
  {i, 1, Length[pts]}
];
sol52 = Quiet@Solve[eqs52, vars52];
c52 = vars52[[1]] /. sol52[[1]];
Print["C = ", N[c52, 40]];

Do[
  powers = Table[N[c52^k, 60], {k, 0, deg}];
  nullVec = Quiet@FindIntegerNullVector[powers, 100];
  If[nullVec =!= $Failed && nullVec =!= {} && Length[nullVec] > 0,
    poly = Sum[nullVec[[k + 1]] x^k, {k, 0, deg}];
    maxC = Max[Abs[nullVec]];
    res = Abs[N[poly /. x -> c52, 40]];
    If[res < 10^-15 && maxC < 10000,
      Print["deg ", deg, ": ", poly, " = 0"];
      Print["  coeffs: ", nullVec];
      Print["  residual: ", res];
      Print[""];
    ];
  ];,
  {deg, 2, 12}
];
