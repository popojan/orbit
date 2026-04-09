(* General Boundary Ballot Experiment
   ===================================
   Generalize PellBallotCount to arbitrary nonlinear boundaries.
   For each boundary, count lattice paths from (1,0) staying in the
   feasible region, targeting the nearest lattice point to the boundary
   at each x-coordinate.  Check if counts match ballot numbers. *)

(* --- Generic DP: paths from (1,0) to (xMax, yMax) above boundary --- *)
(* constraint[u, r] returns True if point (u,r) is in feasible region *)
GeneralBallotCount[constraint_, {x1_Integer, y1_Integer}] :=
  Module[{dp},
    If[y1 == 0, Return[If[x1 >= 1 && constraint[1, 0], 1, 0]]];
    If[y1 < 0, Return[0]];
    dp = Table[0, {x1}, {y1 + 1}];
    Do[
      Do[
        If[constraint[u, r],
          dp[[u, r + 1]] =
            If[u == 1 && r == 0, 1, 0] +
            If[u > 1, dp[[u - 1, r + 1]], 0] +
            If[r > 0, dp[[u, r]], 0],
          dp[[u, r + 1]] = 0
        ],
      {r, 0, y1}],
    {u, 1, x1}];
    dp[[x1, y1 + 1]]
  ]

(* --- Ballot number formula --- *)
BallotNumber[x_, y_] := If[y == 0, 1, Binomial[x + y - 1, y] / x]

(* --- Nearest feasible y at given x (from below boundary) --- *)
NearestFeasibleY[constraint_, x_, yMax_: 200] :=
  Module[{y = 0},
    While[y <= yMax && constraint[x, y + 1], y++];
    y
  ]

(* ================================================================== *)
(* BOUNDARY 1: Pell hyperbola (baseline) u^2 - d*v^2 >= 1            *)
(* ================================================================== *)

Print["=== BOUNDARY 1: Pell hyperbola u^2 - d*v^2 >= 1 (baseline) ==="];
Print[""];

Do[
  Module[{constraint, sol, x1, y1, dpCount, ballot},
    constraint = Function[{u, r}, u^2 - d r^2 >= 1];
    sol = {x1, y1} = PellSolve[d];
    dpCount = GeneralBallotCount[constraint, {x1, y1}];
    ballot = BallotNumber[x1, y1];
    Print["d=", d, "  sol=", sol, "  DP=", dpCount,
      "  Ballot=", ballot, "  ", If[dpCount === ballot, "OK", "FAIL"]]
  ],
{d, Select[Range[2, 30], !IntegerQ[Sqrt[#]] &]}];

(* ================================================================== *)
(* BOUNDARY 2: Shifted hyperbola u^2 - d*v^2 >= c  (c != 1)          *)
(* ================================================================== *)

Print[""];
Print["=== BOUNDARY 2: u^2 - d*v^2 >= c  for various c ==="];
Print[""];

Do[
  Module[{constraint, ystar, dpCount, ballot},
    constraint = Function[{u, r}, u^2 - d r^2 >= c];
    (* scan x = 2..40, find nearest feasible y, check ballot *)
    Do[
      ystar = NearestFeasibleY[constraint, x];
      If[ystar >= 1,
        dpCount = GeneralBallotCount[constraint, {x, ystar}];
        ballot = BallotNumber[x, ystar];
        If[dpCount === ballot,
          Print["d=", d, " c=", c, "  (", x, ",", ystar, ")  DP=",
            dpCount, "  Ballot=", ballot, "  MATCH  norm=", x^2 - d ystar^2]
        ]
      ],
    {x, 2, 40}]
  ],
{d, {2, 3, 5, 7}}, {c, {0, 2, 3, -1}}];

(* ================================================================== *)
(* BOUNDARY 3: Rectangular hyperbola  u*v >= N                        *)
(* (paths staying ABOVE the curve v = N/u)                            *)
(* ================================================================== *)

Print[""];
Print["=== BOUNDARY 3: u*v >= N (rectangular hyperbola) ==="];
Print[""];

Do[
  Module[{constraint, ystar, dpCount, ballot},
    constraint = Function[{u, r}, u r >= nn || r == 0];
    (* Include r==0 so start (1,0) is feasible; paths must reach
       the region u*v >= N *)
    Do[
      ystar = If[x == 0, 0, Ceiling[nn / x]];
      If[ystar >= 1 && ystar <= 50,
        dpCount = GeneralBallotCount[constraint, {x, ystar}];
        ballot = BallotNumber[x, ystar];
        Print["N=", nn, "  (", x, ",", ystar, ")  DP=", dpCount,
          "  Ballot=", ballot, "  ",
          If[dpCount === ballot, "MATCH", "miss"]]
      ],
    {x, 2, 30}]
  ],
{nn, {2, 3, 5, 6, 10}}];

(* ================================================================== *)
(* BOUNDARY 4: Power-law boundary  v <= x^alpha / beta                *)
(* (paths staying BELOW the curve)                                    *)
(* ================================================================== *)

Print[""];
Print["=== BOUNDARY 4: v <= x^alpha / beta (power-law ceiling) ==="];
Print[""];

Do[
  Module[{constraint, ystar, dpCount, ballot},
    constraint = Function[{u, r}, r <= u^alpha / beta];
    Do[
      ystar = Floor[x^alpha / beta];
      If[ystar >= 1 && ystar <= 60,
        dpCount = GeneralBallotCount[constraint, {x, ystar}];
        ballot = BallotNumber[x, ystar];
        If[dpCount === ballot,
          Print["alpha=", alpha, " beta=", beta, "  (", x, ",", ystar,
            ")  DP=", dpCount, "  Ballot=", ballot, "  MATCH"]
        ]
      ],
    {x, 2, 40}]
  ],
{alpha, {1/2, 2/3, 3/2}}, {beta, {1, 2, 3}}];

(* ================================================================== *)
(* BOUNDARY 5: Elliptic boundary  u^2/a^2 + v^2/b^2 <= 1            *)
(* (paths staying INSIDE ellipse)                                     *)
(* ================================================================== *)

Print[""];
Print["=== BOUNDARY 5: u^2/a^2 + v^2/b^2 <= 1 (inside ellipse) ==="];
Print[""];

Do[
  Module[{constraint, ystar, dpCount, ballot},
    constraint = Function[{u, r}, u^2/a^2 + r^2/b^2 <= 1];
    Do[
      ystar = Floor[b Sqrt[1 - x^2/a^2]];
      If[ystar >= 1,
        dpCount = GeneralBallotCount[constraint, {x, ystar}];
        ballot = BallotNumber[x, ystar];
        If[dpCount === ballot,
          Print["a=", a, " b=", b, "  (", x, ",", ystar, ")  DP=",
            dpCount, "  Ballot=", ballot, "  MATCH"]
        ]
      ],
    {x, 1, a - 1}]
  ],
{a, {5, 10, 15, 20}}, {b, {3, 5, 8, 10, 15}}];

(* ================================================================== *)
(* BOUNDARY 6: Logarithmic  v <= c * Log[u]                          *)
(* ================================================================== *)

Print[""];
Print["=== BOUNDARY 6: v <= c * Log[u] (logarithmic ceiling) ==="];
Print[""];

Do[
  Module[{constraint, ystar, dpCount, ballot},
    constraint = Function[{u, r}, r <= c Log[u]];
    Do[
      ystar = Floor[c Log[x]];
      If[ystar >= 1 && ystar <= 40,
        dpCount = GeneralBallotCount[constraint, {x, ystar}];
        ballot = BallotNumber[x, ystar];
        If[dpCount === ballot,
          Print["c=", c, "  (", x, ",", ystar, ")  DP=", dpCount,
            "  Ballot=", ballot, "  MATCH"]
        ]
      ],
    {x, 2, 50}]
  ],
{c, {1, 2, 3, 5}}];

(* ================================================================== *)
(* COMPREHENSIVE SCAN: all x,y for each boundary, report ALL matches  *)
(* ================================================================== *)

Print[""];
Print["=== COMPREHENSIVE: Pell d=2..10 — fraction of ballot matches ==="];
Print[""];

Do[
  Module[{constraint, ystar, total = 0, matches = 0, dpCount, ballot},
    constraint = Function[{u, r}, u^2 - d r^2 >= 1];
    Do[
      ystar = Floor[Sqrt[(x^2 - 1)/d]];
      If[ystar >= 1,
        total++;
        dpCount = GeneralBallotCount[constraint, {x, ystar}];
        ballot = BallotNumber[x, ystar];
        If[dpCount === ballot, matches++]
      ],
    {x, 2, 30}];
    Print["Pell d=", d, ": ", matches, "/", total, " ballot matches"]
  ],
{d, Select[Range[2, 10], !IntegerQ[Sqrt[#]] &]}];

Print[""];
Print["=== COMPREHENSIVE: power-law alpha=1/2, beta=1 — all points ==="];
Print[""];

Module[{constraint, ystar, total = 0, matches = 0, dpCount, ballot},
  constraint = Function[{u, r}, r <= Sqrt[u]];
  Do[
    ystar = Floor[Sqrt[x]];
    If[ystar >= 1,
      total++;
      dpCount = GeneralBallotCount[constraint, {x, ystar}];
      ballot = BallotNumber[x, ystar];
      Print["(", x, ",", ystar, ")  DP=", dpCount, "  Ballot=", ballot,
        "  ", If[dpCount === ballot, "MATCH", "miss"]];
      If[dpCount === ballot, matches++]
    ],
  {x, 2, 40}];
  Print["Total: ", matches, "/", total, " ballot matches"]
];

Print[""];
Print["Done."];
