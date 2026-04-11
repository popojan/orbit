<< Orbit`

(* TEST: Does (1-C)^{p+q} = (1-2C)^q hold for rational alpha = q/p? *)
(* If yes: C(alpha) depends DIRECTLY on alpha, not through CF *)

nMax = 600;

Print["=== Testing (1-C)^{p+q} = (1-2C)^q for rational alpha = q/p ==="];
Print["Paths from (1,0) to (n,n) under Floor[p*x/q]"];
Print[""];

(* Test cases: various rationals with slope p/q > 1 *)
testCases = {
  (* Integer slopes (known to work) *)
  {2, 1, "k=2 (known)"},
  {3, 1, "k=3 (known)"},
  {4, 1, "k=4 (known)"},
  {5, 1, "k=5 (known)"},
  (* Half-integer slopes *)
  {3, 2, "k=3/2"},
  {5, 2, "k=5/2"},
  {7, 2, "k=7/2"},
  (* Third-integer slopes *)
  {4, 3, "k=4/3"},
  {5, 3, "k=5/3"},
  {7, 3, "k=7/3"},
  (* Other rationals *)
  {5, 4, "k=5/4"},
  {7, 5, "k=7/5"},
  {8, 3, "k=8/3"},
  {7, 4, "k=7/4"}
};

Do[
  {p, q, label} = tc;
  alpha = q/p;  (* BeattyBallotCount parameter *)

  vals = Table[BeattyBallotCount[alpha, {n, n}], {n, 1, nMax}];

  (* Estimate asymptotic constant *)
  pts = Table[n, {n, nMax - 80, nMax, 10}];
  cEsts = Table[N[vals[[n]] Sqrt[Pi n] / 4^n, 80], {n, pts}];

  vars = Table[Unique["w"], {Length[pts]}];
  eqs = Table[
    cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
    {i, 1, Length[pts]}
  ];
  sol = Quiet@Solve[eqs, vars];
  If[sol === {} || !ListQ[sol], Print[label, ": FAILED"]; Continue[]];
  cBest = vars[[1]] /. sol[[1]];

  (* Test the hypothesis *)
  u = 1 - cBest;
  lhs = u^(p + q);
  rhs = (2 u - 1)^q;
  residual = Abs[N[lhs - rhs, 40]];

  (* Also try RootApproximant *)
  ra = Quiet@RootApproximant[N[cBest, 50], 8];
  mpStr = If[ra =!= $Failed && ra =!= Null,
    ToString[MinimalPolynomial[ra, x]],
    "failed"
  ];

  Print[label, " (alpha=", alpha, ", p+q=", p+q, "):"];
  Print["  C = ", N[cBest, 15]];
  Print["  (1-C)^", p+q, " - (1-2C)^", q, " = ", N[residual, 4],
    If[residual < 10^-10, "  ✓ MATCH", "  ✗ FAIL"]];
  Print["  MinPoly: ", mpStr];
  Print[""];,
  {tc, testCases}
];
