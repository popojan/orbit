<< Orbit`

(* FAST test: (1-C)^{p+q} = (1-2C)^q for rational alpha = q/p *)
nMax = 300;

Print["=== FAST test: (1-C)^{p+q} = (1-2C)^q ===\n"];

testCases = {
  {2, 1}, {3, 1}, {4, 1}, {5, 1},        (* integer slopes *)
  {3, 2}, {5, 2}, {7, 2},                  (* half-integer *)
  {4, 3}, {5, 3}, {7, 3},                  (* third-integer *)
  {5, 4}, {7, 4}, {7, 5}, {8, 3}           (* misc *)
};

Do[
  {p, q} = pq;
  alpha = q/p;
  vals = Table[BeattyBallotCount[alpha, {n, n}], {n, 1, nMax}];

  pts = Table[n, {n, nMax - 40, nMax, 5}];
  cEsts = Table[N[vals[[n]] Sqrt[Pi n]/4^n, 40], {n, pts}];

  vars = Table[Unique["w"], {Length[pts]}];
  eqs = Table[
    cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
    {i, 1, Length[pts]}
  ];
  sol = Quiet@Solve[eqs, vars];
  If[sol === {} || !ListQ[sol], Print[p, "/", q, ": FAILED"]; Continue[]];
  cBest = vars[[1]] /. sol[[1]];
  u = 1 - cBest;

  lhs = u^(p + q);
  rhs = (2 u - 1)^q;
  residual = Abs[N[lhs - rhs, 30]];
  match = residual < 10^-8;

  Print[p, "/", q, " (deg ", p + q - 1, "): C=", N[cBest, 10],
    "  resid=", N[residual, 3],
    If[match, "  \[Checkmark]", "  FAIL"]];,
  {pq, testCases}
];
