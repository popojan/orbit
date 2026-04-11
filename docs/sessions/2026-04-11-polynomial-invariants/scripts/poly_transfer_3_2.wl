<< Orbit`

(* Transfer matrix approach for slope 3/2 *)
(* Staircase Floor[3x/2], increases [1,2,1,2,...], period 2 *)

(* === Part 1: Verify the transfer matrix formula === *)
Print["=== Transfer matrix for slope 3/2 ===\n"];

(* T(d, d') = min(d+1, d+4-d') for 2 <= d' <= d+3  *)
(* Weighted by y^j where j = d+3-d' = number of up-steps in period *)

Tentry[d_, dp_] := If[2 <= dp <= d + 3,
  Min[d + 1, d + 4 - dp],
  0
];

(* Print small transfer matrix *)
Print["Transfer matrix T(d,d') for d,d' = 0..6:"];
Do[
  Print["  d=", d, ": ",
    Table[Tentry[d, dp], {dp, 0, 8}]],
  {d, 0, 6}
];
Print[""];

(* === Part 2: Weighted transfer matrix eigenvalue === *)
(* T_y(d,d') = T(d,d') * y^(d+3-d') *)
(* For diagonal (n,n): n/2 periods, n total up-steps *)
(* Average 2 up-steps per period -> saddle at y where avg=2 *)

(* Truncate at deficit D *)
D0 = 30;

TmatY[y_] := Table[
  Tentry[d, dp] y^(d + 3 - dp),
  {d, 0, D0}, {dp, 0, D0}
];

(* The diagonal coefficient comes from: *)
(* a(n,n) ~ lambda(y_star)^(n/2) * y_star^n / sqrt(n) *)
(* Growth rate 4^n means lambda(y_star) * y_star^2 = 16 *)

(* Saddle point determines the asymptotic constant *)

(* Let me try a different approach: direct eigenvalue computation *)

Print["=== Eigenvalues of T_y for various y ==="];
Print[""];
Do[
  mat = N[TmatY[y0], 20];
  evals = Sort[Eigenvalues[mat], Abs[#1] < Abs[#2] &];
  lam = Last[evals];  (* dominant eigenvalue *)
  Print["y=", y0, ": lambda=", lam, "  lambda*y^2=", lam y0^2];,
  {y0, {0.5, 0.8, 1.0, 1.2, 1.5, 2.0}}
];
Print[""];

(* === Part 3: Alternative — Lindstrom formula for slope 3/2 === *)
(* For integer k: a(n) = Sum_j (-1)^j C(2n-1, n-j(k+1)) *)
(* For slope 3/2: test if a(n) = Sum_j c_j C(2n-1, n - 5j) *)
(* where c_j involves the Sturmian pattern *)

Print["=== Lindstrom-type formula for slope 3/2 ==="];
Print[""];

nTest = 20;
aVals = Table[BeattyBallotCount[2/3, {n, n}], {n, 1, nTest}];

(* Test: a(n) = Sum_j (-1)^j C(2n-1, n-5j) for j in Z *)
Do[
  exact = aVals[[n]];
  lindstrom5 = Sum[
    (-1)^j Binomial[2 n - 1, n - 5 j],
    {j, -n, n}
  ];

  (* Also test period 3 (= p = 3?) and period 5 (= p+q) *)
  lindstrom3 = Sum[(-1)^j Binomial[2 n - 1, n - 3 j], {j, -n, n}];

  If[n <= 8,
    Print["n=", n, ": a=", exact,
      "  L5=", lindstrom5, " ", If[exact == lindstrom5, "✓", "✗"],
      "  L3=", lindstrom3, " ", If[exact == lindstrom3, "✓", "✗"]];
  ];,
  {n, 1, nTest}
];
Print[""];

(* Test generalized formula with weighted reflections *)
(* For slope p/q, maybe: a(n) = Sum_j w(j) C(2n-1, n - j) *)
(* where w has period p+q = 5 *)

(* Extract w by solving: *)
Print["=== Extracting reflection weights w(j) ==="];
(* a(n) = Sum_{j=-N..N} w(j) C(2n-1, n-j) *)
(* w(j) has period 5 and w(0)=1 *)
(* Use n=1..10 to determine w(1)..w(4) (one period) *)

maxJ = 10;
wVars = Table[w[j], {j, -maxJ, maxJ}];
(* Assume w has period 5: w(j) = w(j mod 5) *)
(* And w(5m) = (-1)^m (like integer case with period p+q) *)
(* Actually let's not assume, just solve *)

(* Small system: n=1..5 with w(-5..5) *)
(* a(n) = Sum_{j=-5}^5 w(j) C(2n-1, n-j) *)
eqs = Table[
  aVals[[n]] == Sum[w[j] Binomial[2 n - 1, n - j], {j, -5, 5}],
  {n, 1, 8}
];
wSyms = Table[w[j], {j, -5, 5}];
(* Add symmetry: w(-j) = w(j) (or -w(j)?) *)
(* For integer k: w is supported on multiples of k+1 *)
(* Try: w(0) = 1, solve for w(1)..w(5) with w(-j) = w(j) *)

eqsSym = eqs /. Table[w[-j] -> w[j], {j, 1, 5}];
wFree = {w[0], w[1], w[2], w[3], w[4], w[5]};
sol = Solve[eqsSym[[1 ;; 6]], wFree];
If[sol =!= {},
  Print["Solution: ", sol[[1]]];
  wFunc = Table[w[j] /. sol[[1]], {j, -5, 5}];
  Print["w(-5..5) = ", wFunc];

  (* Verify on remaining n values *)
  Do[
    pred = Sum[(w[j] /. sol[[1]]) Binomial[2 n - 1, n - j], {j, -5, 5}];
    Print["  n=", n, ": predicted=", pred, " actual=", aVals[[n]],
      " ", If[pred == aVals[[n]], "✓", "✗"]];,
    {n, 1, Min[nTest, 12]}
  ];
];
