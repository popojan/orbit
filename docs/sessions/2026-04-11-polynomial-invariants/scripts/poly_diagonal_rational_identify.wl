<< Orbit`

(* Identify minimal polynomials for C at non-integer slopes *)
nMax = 400;

Print["=== Minimal polynomial identification for rational slopes ===\n"];

testCases = {
  {3, 2, "3/2"}, {5, 2, "5/2"}, {7, 2, "7/2"},
  {4, 3, "4/3"}, {5, 3, "5/3"}, {7, 3, "7/3"},
  {5, 4, "5/4"}, {7, 4, "7/4"}
};

Do[
  {p, q, label} = tc;
  alpha = q/p;
  vals = Table[BeattyBallotCount[alpha, {n, n}], {n, 1, nMax}];

  pts = Table[n, {n, nMax - 60, nMax, 5}];
  cEsts = Table[N[vals[[n]] Sqrt[Pi n]/4^n, 60], {n, pts}];

  vars = Table[Unique["w"], {Length[pts]}];
  eqs = Table[
    cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
    {i, 1, Length[pts]}
  ];
  sol = Quiet@Solve[eqs, vars];
  If[sol === {} || !ListQ[sol], Print[label, ": FAILED"]; Continue[]];
  cBest = vars[[1]] /. sol[[1]];

  Print["slope ", label, ": C = ", N[cBest, 20]];

  (* Try RootApproximant for each max degree *)
  found = False;
  Do[
    ra = Quiet@RootApproximant[N[cBest, 45], maxDeg];
    If[ra =!= $Failed && ra =!= Null,
      mp = MinimalPolynomial[ra, x];
      deg = Exponent[mp, x];
      maxC = Max[Abs[CoefficientList[mp, x]]];
      res = Abs[N[ra - cBest, 30]];
      If[res < 10^-10 && maxC < 500 && deg <= p + q,
        Print["  MinPoly (deg ", deg, "): ", mp];
        Print["  C = ", ra, "  resid = ", res];
        (* Factor *)
        Print["  Factor: ", Factor[mp]];
        found = True;
        Break[];
      ];
    ];,
    {maxDeg, 2, p + q + 2}
  ];
  If[!found, Print["  RootApproximant: no clean result up to deg ", p+q+2]];
  Print[""];,
  {tc, testCases}
];
