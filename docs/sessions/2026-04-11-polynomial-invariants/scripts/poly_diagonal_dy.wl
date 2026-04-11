<< Orbit`

(* Diagonal step (1, dy): paths from (1,0) to (n, dy*n) under y <= kx *)
(* Integer k, staircase exactly y = kx *)

nMax = 300;

Print["=== Family (k, dy): asymptotic constants ==="];
Print[""];

Do[
  Print["--- k=", k, " ---"];
  Do[
    If[dy >= k, Continue[]];  (* dy = k is the boundary case *)
    vals = Table[BeattyBallotCount[1/k, {n, dy n}], {n, 1, nMax}];

    (* Growth rate: C((1+dy)n-1, dy*n) ~ rho^n / n^{1/2} *)
    (* rho = (1+dy)^(1+dy) / dy^dy  for dy >= 1 *)
    rho = If[dy == 0, 1, (1 + dy)^(1 + dy) / dy^dy];

    (* Estimate constant: a(n) * sqrt(pi*n) / rho^n *)
    pts = Table[n, {n, nMax - 50, nMax, 10}];
    cEsts = Table[N[vals[[n]] Sqrt[Pi n] / rho^n, 40], {n, pts}];

    (* Polynomial extrapolation *)
    vars = Table[Symbol["u" <> ToString[k] <> ToString[dy] <> ToString[i]], {i, 1, Length[pts]}];
    eqs = Table[
      cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
      {i, 1, Length[pts]}
    ];
    sol = Quiet@Solve[eqs, vars];
    If[sol === {} || !ListQ[sol], Print["  dy=", dy, ": extrapolation failed"]; Continue[]];
    cBest = vars[[1]] /. sol[[1]];

    (* Test (1-x)^{k+1} = 1 - (1+dy)*x *)
    lhs = (1 - cBest)^(k + 1);
    rhs = 1 - (1 + dy) cBest;
    match1 = Abs[N[lhs - rhs, 30]] < 10^-6;

    (* Also try (1-x)^{k+1} = (1 - dy*x)^? or other forms *)
    Print["  dy=", dy, ": C=", N[cBest, 12],
      "  (1-C)^", k+1, "=", N[lhs, 12],
      "  1-", 1+dy, "C=", N[rhs, 12],
      "  match:", match1];,
    {dy, 1, k - 1}
  ];
  Print[""];,
  {k, 2, 5}
];
