(* Staircase Hypothesis Test
   ==========================
   Hypothesis: Ballot matches depend ONLY on the staircase function
   y*(x) = Floor[x/sqrt(d)], not on the boundary shape.

   Test 1: Compare y*(x) across boundaries — find where they DIFFER
   Test 2: When y*(x) is identical, are ballot counts always identical?
   Test 3: Use a COMPLETELY ARTIFICIAL staircase (no curve) and check ballot
   Test 4: Use boundary with different asymptote and check its convergents
*)

<< Orbit`

(* --- Generic DP with explicit staircase --- *)
(* Constraint: point (u,r) is feasible iff r <= staircase[u] *)
StaircaseDP[staircase_, {x1_Integer, y1_Integer}] :=
  Module[{dp},
    If[y1 == 0, Return[If[x1 >= 1, 1, 0]]];
    If[y1 < 0, Return[0]];
    dp = Table[0, {x1}, {y1 + 1}];
    Do[
      Do[
        If[r <= staircase[u],
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

BallotNumber[x_, y_] := If[y == 0, 1, Binomial[x + y - 1, y] / x]

(* ================================================================ *)
Print["============================================================"];
Print["TEST 1: Compare y*(x) across boundary types for d=2,5,7"];
Print["============================================================"];
Print[""];

Do[
  Module[{sd = Sqrt[d], diffs = {}},
    Print["d=", d, ":"];
    Do[
      Module[{
        yPell = Floor[Sqrt[(x^2 - 1) / d]],
        yRelax = Floor[x / Sqrt[d]],
        yCubic = Floor[((x^3 - 1) / d^(3/2))^(1/3)],
        yShift = Floor[(x - 1) / Sqrt[d]]
      },
        If[!( yPell == yRelax == yCubic ),
          AppendTo[diffs, {x, yPell, yRelax, yCubic, yShift}];
          Print["  x=", x, " yPell=", yPell, " yRelax=", yRelax,
            " yCubic=", yCubic, " yShift=", yShift]
        ]
      ],
    {x, 1, 100}];
    If[Length[diffs] == 0,
      Print["  All y*(x) IDENTICAL for Pell/Relaxed/Cubic in x=1..100"]
    ];
    Print[""];
  ],
{d, {2, 3, 5, 7, 10, 13}}];

(* ================================================================ *)
Print["============================================================"];
Print["TEST 2: Pure staircase DP — use y*(x) = Floor[x/sqrt(d)]"];
Print["         directly (no curve at all), check ballot matches"];
Print["============================================================"];
Print[""];

Do[
  Module[{staircase, ballotHits = {}, sd = N[Sqrt[d]], y, dp, bl},
    staircase = Function[u, Floor[u / sd]];
    Do[
      y = staircase[x];
      If[y >= 1,
        dp = StaircaseDP[staircase, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp}]
        ]
      ],
    {x, 2, 50}];
    Print["d=", d, " pure staircase Floor[x/sqrt(d)] ballot hits: ",
      ballotHits];
  ],
{d, {2, 3, 5, 7, 10, 13}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["TEST 3: Different asymptote — v ~ x/sqrt(alpha) for alpha != d"];
Print["         Do we get ballot matches at convergents of sqrt(alpha)?"];
Print["============================================================"];
Print[""];

Do[
  Module[{staircase, ballotHits = {}, sa = N[Sqrt[alpha]], y, dp, bl,
    conv},
    (* convergents of sqrt(alpha) *)
    conv = If[IntegerQ[Sqrt[alpha]], {},
      Table[
        {Numerator[#], Denominator[#]} &@
          FromContinuedFraction[ContinuedFraction[Sqrt[alpha], k]],
      {k, 2, 15}]];

    staircase = Function[u, Floor[u / sa]];
    Do[
      y = staircase[x];
      If[y >= 1,
        dp = StaircaseDP[staircase, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp}]
        ]
      ],
    {x, 2, 60}];

    Print["alpha=", alpha, " convergents(sqrt): ",
      Select[conv, #[[1]] <= 60 &]];
    Print["  ballot hits: ", ballotHits];
    (* check overlap *)
    If[Length[conv] > 0 && Length[ballotHits] > 0,
      Module[{hitX = ballotHits[[All, 1]],
              convX = Select[conv, #[[1]] <= 60 &][[All, 1]]},
        Print["  convergent x-values in hits: ",
          Intersection[hitX, convX], " / ", convX]
      ]
    ];
    Print[""];
  ],
{alpha, {2, 3, 5, 6, 7, 8, 10, 11, 13, 15}}];

(* ================================================================ *)
Print["============================================================"];
Print["TEST 4: NON-ALGEBRAIC slope — v ~ x/pi, v ~ x/e"];
Print["         Do ballot matches correspond to convergents of pi, e?"];
Print["============================================================"];
Print[""];

Do[
  Module[{staircase, ballotHits = {}, y, dp, bl, conv},
    (* convergents of the constant *)
    conv = Table[
      {Numerator[#], Denominator[#]} &@
        FromContinuedFraction[ContinuedFraction[c, k]],
    {k, 2, 20}];

    staircase = Function[u, Floor[u / N[c]]];
    Do[
      y = staircase[x];
      If[y >= 1,
        dp = StaircaseDP[staircase, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp}]
        ]
      ],
    {x, 2, 80}];

    Print["constant=", cName, " (", N[c, 6], ")"];
    Print["  convergent (p,q): ",
      Select[conv, #[[1]] <= 80 &]];
    Print["  ballot hits: ", ballotHits];
    If[Length[conv] > 0 && Length[ballotHits] > 0,
      Module[{hitX = ballotHits[[All, 1]],
              convX = Select[conv, #[[1]] <= 80 &][[All, 1]]},
        Print["  overlap: ", Intersection[hitX, convX],
          " out of ", convX]
      ]
    ];
    Print[""];
  ],
{c, {Pi, E, GoldenRatio, Sqrt[2] + 1}},
{cName, {"Pi", "E", "GoldenRatio", "1+sqrt(2)"}}];

(* ================================================================ *)
Print["============================================================"];
Print["TEST 5: Perturbation test — add noise to staircase"];
Print["         y*(x) = Floor[x/sqrt(d)] + delta(x) for random delta"];
Print["============================================================"];
Print[""];

SeedRandom[42];
Do[
  Module[{staircase, ballotHits = {}, y, dp, bl,
    baseStaircase, perturbations},
    baseStaircase = Function[u, Floor[u / N[Sqrt[d]]]];
    (* random perturbation: flip some y*(x) values by +1 or -1 *)
    perturbations = Table[RandomChoice[{0, 0, 0, 0, 1, -1}], {60}];
    staircase = Function[u,
      Max[0, baseStaircase[u] + If[u <= 60, perturbations[[u]], 0]]];

    Do[
      y = staircase[x];
      If[y >= 1,
        dp = StaircaseDP[staircase, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp}]
        ]
      ],
    {x, 2, 50}];

    Print["d=", d, " perturbed staircase ballot hits: ", ballotHits];
    (* compare with unperturbed *)
    Module[{cleanHits = {}},
      Do[
        y = baseStaircase[x];
        If[y >= 1,
          dp = StaircaseDP[baseStaircase, {x, y}];
          bl = BallotNumber[x, y];
          If[dp === bl && IntegerQ[bl],
            AppendTo[cleanHits, {x, y, dp}]
          ]
        ],
      {x, 2, 50}];
      Print["  (clean staircase: ", cleanHits, ")"];
      Print["  perturbation changed: ",
        Complement[cleanHits[[All, 1]], ballotHits[[All, 1]]], " lost, ",
        Complement[ballotHits[[All, 1]], cleanHits[[All, 1]]], " gained"];
    ];
  ],
{d, {2, 5, 7}}];

Print[""];
Print["Done."];
