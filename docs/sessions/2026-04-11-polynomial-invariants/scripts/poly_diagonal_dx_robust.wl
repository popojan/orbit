<< Orbit`

(* Robust identification of asymptotic constants for step (dx, 1) *)
(* Uses RootApproximant instead of brute-force coefficient search *)

nMax = 600;

Print["=== Asymptotic constants for BeattyBallotCount[1/k, {dx*n, n}] ==="];
Print["Format: a(n) ~ C * rho^n / Sqrt[Pi*n]"];
Print[""];

Do[
  rho = (dx + 1)^(dx + 1) / dx^dx;
  Print["--- dx=", dx, ", rho=", rho, " ---"];

  Do[
    vals = Table[BeattyBallotCount[1/k, {dx n, n}], {n, 1, nMax}];

    (* Richardson extrapolation: estimate C from multiple n values *)
    pts = Table[n, {n, nMax - 80, nMax, 10}];
    cEsts = Table[N[vals[[n]] Sqrt[Pi n] / rho^n, 80], {n, pts}];

    (* Polynomial extrapolation to eliminate 1/n corrections *)
    nPts = Length[pts];
    vars = Table[Unique["w"], {nPts}];
    eqs = Table[
      cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, nPts - 1}],
      {i, 1, nPts}
    ];
    sol = Quiet@Solve[eqs, vars];
    If[sol === {} || !ListQ[sol],
      Print["  k=", k, ": extrapolation failed"];
      Continue[]
    ];
    cBest = vars[[1]] /. sol[[1]];

    Print["  k=", k, ": C = ", N[cBest, 25]];

    (* Try RootApproximant *)
    ra = Quiet@RootApproximant[N[cBest, 40], 8];
    If[ra =!= $Failed && ra =!= Null,
      mp = MinimalPolynomial[ra, x];
      residual = Abs[N[ra - cBest, 30]];
      Print["    RootApproximant: ", ra];
      Print["    MinimalPolynomial: ", mp];
      Print["    Residual: ", residual];

      (* Check: (1+dx*C)^{k+1} = 1 + f*C for what f? *)
      fVal = FullSimplify[((1 + dx ra)^(k + 1) - 1) / ra];
      Print["    (1+", dx, "*C)^", k+1, " = 1 + f*C, f = ", fVal];

      (* Check: (1-C)^{k+1} = 1 - g*C for what g? *)
      gVal = FullSimplify[((1 - ra)^(k + 1) - 1) / (-ra)];
      Print["    (1-C)^", k+1, " = 1 - g*C, g = ", gVal];
      ,
      Print["    RootApproximant failed"];
    ];
    Print[""];,
    {k, 1, 7}
  ];
  Print["==========\n"];,
  {dx, 1, 3}
];
