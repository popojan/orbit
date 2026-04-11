<< Orbit`

(* Saddle point analysis for slope 3/2 via transfer matrix *)

(* Per-column transfer matrices *)
(* Column with staircase increase s: *)
(* T_s(d, d') = y^(d+s-d') for s <= d' <= d+s *)

D0 = 40;  (* truncation *)

T1mat[y_] := SparseArray[
  Flatten@Table[
    {d + 1, dp + 1} -> y^(d + 1 - dp),
    {d, 0, D0}, {dp, 1, d + 1}
  ],
  {D0 + 1, D0 + 1}
];

T2mat[y_] := SparseArray[
  Flatten@Table[
    {d + 1, dp + 1} -> y^(d + 2 - dp),
    {d, 0, D0}, {dp, 2, Min[d + 2, D0]}
  ],
  {D0 + 1, D0 + 1}
];

(* One period: first s=1 column, then s=2 column *)
Tperiod[y_] := T2mat[y] . T1mat[y];

(* Dominant eigenvalue *)
lambda[y_?NumericQ] := Module[{mat, evals},
  mat = N[Normal[Tperiod[y]], 30];
  evals = Eigenvalues[mat];
  Max[Abs[evals]]
];

Print["=== Saddle point for slope 3/2 ==="];
Print["Equations: lambda(y*) = 16 y*^2 and y* lambda'(y*) = 2 lambda(y*)"];
Print[""];

(* Scan to find approximate saddle *)
Print["Scan:"];
Do[
  lam = lambda[y0];
  ratio = lam/y0^2;
  Print["  y=", N[y0, 6], "  lambda=", N[lam, 8], "  lambda/y^2=", N[ratio, 8]];,
  {y0, 0.3, 0.8, 0.05}
];
Print[""];

(* Solve lambda(y)/y^2 = 16 *)
Print["Finding y* where lambda/y^2 = 16..."];
yStar = y /. FindRoot[lambda[y]/y^2 == 16, {y, 0.5}, WorkingPrecision -> 25];
Print["  y* = ", N[yStar, 20]];
Print["  lambda(y*) = ", N[lambda[yStar], 20]];
Print["  lambda/y*^2 = ", N[lambda[yStar]/yStar^2, 15]];
Print[""];

(* Now compute C from the prefactor *)
(* a(n,n) ~ C * 4^n / sqrt(pi*n) *)
(* From saddle: a(n,n) ~ lambda(y*)^(n/2) * y*^(-n) * prefactor / sqrt(n) *)
(* lambda^(n/2) * y*^(-n) = (lambda/y*^2)^(n/2) = 16^(n/2) = 4^n *)
(* So C = prefactor / sqrt(pi) *)
(* Prefactor involves the eigenvector and second derivative *)

(* Let's verify by direct computation *)
Print["=== Verification: compare transfer matrix prediction with BeattyBallot ==="];
Print[""];

nTest = 200;
vals = Table[BeattyBallotCount[2/3, {n, n}], {n, 1, nTest}];

(* Estimate C directly *)
pts = Table[n, {n, nTest - 30, nTest, 5}];
cEsts = Table[N[vals[[n]] Sqrt[Pi n]/4^n, 30], {n, pts}];
vars = Table[Unique["w"], {Length[pts]}];
eqs = Table[
  cEsts[[i]] == vars[[1]] + Sum[vars[[j + 1]]/pts[[i]]^j, {j, 1, Length[pts] - 1}],
  {i, 1, Length[pts]}
];
sol = Solve[eqs, vars];
cDirect = vars[[1]] /. sol[[1]];
Print["C (direct from BeattyBallot) = ", N[cDirect, 20]];

(* Try to identify *)
ra = Quiet@RootApproximant[N[cDirect, 30], 6];
If[ra =!= $Failed,
  mp = MinimalPolynomial[ra, x];
  Print["RootApproximant: ", ra];
  Print["MinimalPolynomial: ", mp];
  Print["Factor: ", Factor[mp]];
  Print["Degree: ", Exponent[mp, x]];
  Print["Residual: ", Abs[N[ra - cDirect, 20]]];
];
Print[""];

(* Also identify y* *)
Print["y* = ", N[yStar, 20]];
raY = Quiet@RootApproximant[N[yStar, 20], 6];
If[raY =!= $Failed,
  mpY = MinimalPolynomial[raY, x];
  Print["y* RootApproximant: ", raY];
  Print["y* MinimalPolynomial: ", mpY];
];

(* For integer slope k, the saddle point y* = 1-C_k *)
(* (since u = 1-C is the variable in the equation Sigma u^j = 2) *)
(* Check if y* = 1-C for slope 3/2: *)
Print[""];
Print["1-C = ", N[1 - cDirect, 15]];
Print["y* = ", N[yStar, 15]];
Print["Match: ", Abs[N[1 - cDirect - yStar, 15]] < 10^-5];
