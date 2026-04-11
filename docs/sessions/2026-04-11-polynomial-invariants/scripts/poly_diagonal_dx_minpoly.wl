<< Orbit`

(* For step (dx, 1): compute asymptotic constants and find minimal polynomials *)

nMax = 500;
dx = 2;
rho = N[(dx + 1)^(dx + 1) / dx^dx, 60];  (* 27/4 for dx=2 *)

Print["=== dx=", dx, ", growth rate rho=", rho, " ==="];
Print[""];

Do[
  vals = Table[BeattyBallotCount[1/k, {dx n, n}], {n, 1, nMax}];

  pts = Table[n, {n, nMax - 70, nMax, 10}];
  cEsts = Table[N[vals[[n]] Sqrt[Pi n] / rho^n, 60], {n, pts}];

  vars = Table[Symbol["z" <> ToString[k] <> ToString[i]], {i, 1, Length[pts]}];
  eqs = Table[
    cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
    {i, 1, Length[pts]}
  ];
  sol = Quiet@Solve[eqs, vars];
  If[sol === {} || !ListQ[sol], Print["k=", k, ": failed"]; Continue[]];
  cBest = vars[[1]] /. sol[[1]];

  Print["k=", k, ": C = ", N[cBest, 30]];

  (* Brute force minimal polynomial, degree up to k, coeffs up to 30 *)
  bestDeg = {};
  Do[
    best = {Infinity, {}};
    Do[
      coeffs = Table[Symbol["a" <> ToString[j]], {j, 0, deg}];
      val = Sum[coeffs[[j + 1]] cBest^j, {j, 0, deg}];
      0,  (* placeholder *)
      {dummy, 0, 0}
    ];
    (* Direct brute force for each degree *)
    If[deg == 1,
      best1 = {Infinity, {}};
      Do[
        val = a cBest + b;
        If[Abs[val] < Abs[best1[[1]]] && a != 0, best1 = {val, {a, b}}],
        {a, -30, 30}, {b, -30, 30}
      ];
      AppendTo[bestDeg, {deg, best1}];
    ];
    If[deg == 2,
      best2 = {Infinity, {}};
      Do[
        val = a cBest^2 + b cBest + cc;
        If[Abs[val] < Abs[best2[[1]]] && a != 0, best2 = {val, {a, b, cc}}],
        {a, -30, 30}, {b, -30, 30}, {cc, -30, 30}
      ];
      AppendTo[bestDeg, {deg, best2}];
    ];
    If[deg == 3,
      best3 = {Infinity, {}};
      Do[
        val = a cBest^3 + b cBest^2 + cc cBest + dd;
        If[Abs[val] < Abs[best3[[1]]] && a != 0, best3 = {val, {a, b, cc, dd}}],
        {a, -20, 20}, {b, -20, 20}, {cc, -20, 20}, {dd, -20, 20}
      ];
      AppendTo[bestDeg, {deg, best3}];
    ];,
    {deg, 1, Min[k, 3]}
  ];

  Do[
    {deg, res} = bd;
    Print["  deg ", deg, ": coeffs=", res[[2]], " residual=", res[[1]]];,
    {bd, bestDeg}
  ];
  Print[""];,
  {k, 2, 5}
];
