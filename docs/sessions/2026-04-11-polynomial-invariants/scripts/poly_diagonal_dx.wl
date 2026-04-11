<< Orbit`

nMax = 300;

Print["=== Step (dx, 1): paths from (1,0) to (dx*n, n) under y <= kx ==="];
Print[""];

Do[
  Print["--- k=", k, " ---"];
  Do[
    vals = Table[BeattyBallotCount[1/k, {dx n, n}], {n, 1, nMax}];

    (* Growth rate: C((dx+1)n-1, n) ~ rho^n *)
    rho = N[(dx + 1)^(dx + 1) / dx^dx, 40];

    (* Estimate constant *)
    pts = Table[n, {n, nMax - 50, nMax, 10}];
    cEsts = Table[N[vals[[n]] Sqrt[Pi n] / rho^n, 40], {n, pts}];

    vars = Table[Symbol["w" <> ToString[k] <> ToString[dx] <> ToString[i]], {i, 1, Length[pts]}];
    eqs = Table[
      cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
      {i, 1, Length[pts]}
    ];
    sol = Quiet@Solve[eqs, vars];
    If[sol === {} || !ListQ[sol], Print["  dx=", dx, ": failed"]; Continue[]];
    cBest = vars[[1]] /. sol[[1]];

    (* Test: (1-x)^{k+1} = 1 - (dx+1)/dx * x *)
    coeff = (dx + 1)/dx;
    lhs = (1 - cBest)^(k + 1);
    rhs = 1 - coeff cBest;
    match = Abs[N[lhs - rhs, 20]] < 10^-5;

    Print["  dx=", dx, ": C=", N[cBest, 10],
      "  (1-C)^", k+1, "=", N[lhs, 10],
      "  1-", N[coeff, 4], "C=", N[rhs, 10],
      "  match:", match];,
    {dx, 1, 4}
  ];
  Print[""];,
  {k, 2, 4}
];
