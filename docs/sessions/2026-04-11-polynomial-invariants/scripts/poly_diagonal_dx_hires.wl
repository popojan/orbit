<< Orbit`

(* High-precision identification for dx=2 *)
(* Strategy: large nMax, many extrapolation points, aggressive precision *)

nMax = 1000;
dx = 2;
rho = (dx + 1)^(dx + 1)/dx^dx;  (* 27/4 exact *)

Print["=== dx=", dx, ", rho=", rho, ", nMax=", nMax, " ===\n"];

Do[
  Print["--- k=", k, " ---"];
  vals = Table[BeattyBallotCount[1/k, {dx n, n}], {n, 1, nMax}];

  (* Use many points for Richardson extrapolation *)
  pts = Table[n, {n, nMax - 120, nMax, 10}];
  nPts = Length[pts];
  cEsts = Table[N[vals[[n]] Sqrt[Pi n]/rho^n, 120], {n, pts}];

  (* Polynomial extrapolation *)
  vars = Table[Unique["w"], {nPts}];
  eqs = Table[
    cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, nPts - 1}],
    {i, 1, nPts}
  ];
  sol = Quiet@Solve[eqs, vars];
  If[sol === {} || !ListQ[sol],
    Print["  Extrapolation failed"]; Continue[]
  ];
  cBest = vars[[1]] /. sol[[1]];

  Print["  C = ", N[cBest, 50]];

  (* RootApproximant with high precision *)
  cHi = N[cBest, 60];
  Do[
    ra = Quiet@RootApproximant[cHi, deg];
    If[ra =!= $Failed && ra =!= Null,
      mp = MinimalPolynomial[ra, x];
      res = Abs[N[ra - cBest, 40]];
      degMP = Exponent[mp, x];
      maxCoeff = Max[Abs[CoefficientList[mp, x]]];
      If[res < 10^-10 && maxCoeff < 1000,
        Print["  deg ", deg, ": MinPoly = ", mp, "  (deg ", degMP, ", max coeff ", maxCoeff, ")"];
        Print["    Residual = ", res];
        Print["    Root = ", N[ra, 20]];

        (* Decode: u = 1+dx*C *)
        uVal = 1 + dx ra;
        mpU = Factor[MinimalPolynomial[uVal, u]];
        Print["    u=1+", dx, "C: MinPoly = ", mpU];
        Break[];
      ];
    ];,
    {deg, 2, 8}
  ];
  Print[""];,
  {k, 1, 6}
];
