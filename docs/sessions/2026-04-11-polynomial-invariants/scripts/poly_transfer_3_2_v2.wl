<< Orbit`

(* Transfer matrix saddle point for slope 3/2 — clean version *)

D0 = 40;

(* Build numerical period matrix directly *)
periodMatrix[y0_?NumericQ] := Module[{t1, t2, d, dp},
  t1 = Table[
    If[1 <= dp <= d + 1, y0^(d + 1 - dp), 0],
    {d, 0, D0}, {dp, 0, D0}
  ];
  t2 = Table[
    If[2 <= dp <= d + 2, y0^(d + 2 - dp), 0],
    {d, 0, D0}, {dp, 0, D0}
  ];
  t2 . t1
];

domEig[y0_?NumericQ] := Max[Abs[Eigenvalues[N[periodMatrix[y0], 25]]]];

(* Scan *)
Print["=== lambda(y)/y^2 scan ==="];
Do[
  lam = domEig[y0];
  Print["y=", PaddedForm[y0, {3, 2}], "  lam/y^2=", N[lam/y0^2, 8]];,
  {y0, 0.30, 0.80, 0.05}
];
Print[""];

(* Solve lambda/y^2 = 16 *)
Print["Solving lambda/y^2 = 16..."];
yStar = y /. FindRoot[domEig[y]/y^2 - 16, {y, 0.5}, WorkingPrecision -> 20];
Print["y* = ", N[yStar, 18]];
Print["lambda(y*)/y*^2 = ", N[domEig[yStar]/yStar^2, 12]];
Print[""];

(* Direct computation of C *)
nMax = 300;
vals = Table[BeattyBallotCount[2/3, {n, n}], {n, 1, nMax}];
pts = Table[n, {n, nMax - 40, nMax, 5}];
cEsts = Table[N[vals[[n]] Sqrt[Pi n]/4^n, 40], {n, pts}];
vars = Table[Unique["w"], {Length[pts]}];
eqs = Table[
  cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
  {i, 1, Length[pts]}
];
sol = Quiet@Solve[eqs, vars];
cDirect = vars[[1]] /. sol[[1]];

Print["C (BeattyBallot) = ", N[cDirect, 18]];
Print["1-C = ", N[1 - cDirect, 18]];
Print["y* = ", N[yStar, 18]];
Print["y* == 1-C? ", Abs[N[yStar - (1 - cDirect), 15]] < 10^-5];
Print[""];

(* Identify C algebraically *)
Do[
  ra = Quiet@RootApproximant[N[cDirect, 35], maxDeg];
  If[ra =!= $Failed && ra =!= Null,
    mp = MinimalPolynomial[ra, x];
    deg = Exponent[mp, x];
    maxCoeff = Max[Abs[CoefficientList[mp, x]]];
    res = Abs[N[ra - cDirect, 25]];
    If[res < 10^-8 && maxCoeff < 200,
      Print["C identified (deg ", deg, "): ", mp, " = 0"];
      Print["  C = ", ra];
      Print["  Residual: ", res];
      Print["  Factor: ", Factor[mp]];
      Break[];
    ];
  ];,
  {maxDeg, 2, 8}
];
