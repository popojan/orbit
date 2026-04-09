(* Focused boundary experiment: which boundaries give ballot numbers?
   ================================================================
   Key question: Is it the SHAPE u^2-dv^2 that matters,
   or just the ASYMPTOTE v ~ u/sqrt(d)?

   Test:
   A) Pell hyperbola u^2-dv^2 >= 1 (baseline)
   B) Relaxed Pell u^2-dv^2 >= 0  (same asymptote, different shape)
   C) Linear boundary v <= u/sqrt(d) (same asymptote, straight line)
   D) Perturbed: v <= u/sqrt(d) - epsilon (slightly tighter)
   E) Cubic: u^3 - d^(3/2) v^3 >= 1 (same asymptote, different curvature)
   F) Smooth: v <= (u-1)/sqrt(d) (shifted)
*)

<< Orbit`

(* --- Generic DP --- *)
BallotDP[constraint_, {x1_Integer, y1_Integer}] :=
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

BallotNumber[x_, y_] := If[y == 0, 1, Binomial[x + y - 1, y] / x]

(* y*(x) for each boundary type *)
yStarPell[d_, x_] := Floor[Sqrt[(x^2 - 1)/d]]
yStarRelaxed[d_, x_] := Floor[x / Sqrt[d]]   (* u^2 - dv^2 >= 0 *)
yStarLinear[d_, x_] := Floor[x / Sqrt[d]]     (* same as relaxed on integers *)
yStarShifted[d_, x_] := Floor[(x - 1) / Sqrt[d]]

(* Get convergents of sqrt(d) *)
cfConvergents[d_, n_: 30] :=
  Module[{cf = ContinuedFraction[Sqrt[d], n]},
    Table[Convergents[ContinuedFraction[Sqrt[d], k]][[-1]], {k, 2, n}]
  ]

(* ================================================================ *)
Print["============================================================"];
Print["EXPERIMENT A: Pell hyperbola vs CF convergents (baseline)"];
Print["============================================================"];
Print[""];

Do[
  Module[{conv, constraint, ballotHits = {}, x, y, dp, bl},
    conv = Table[
      {Numerator[#], Denominator[#]} &@
        FromContinuedFraction[ContinuedFraction[Sqrt[d], k]],
    {k, 2, 20}];
    constraint = Function[{u, r}, u^2 - d r^2 >= 1];

    (* Check all x from 2 to max convergent x *)
    Do[
      y = yStarPell[d, x];
      If[y >= 1,
        dp = BallotDP[constraint, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp, x^2 - d y^2}]
        ]
      ],
    {x, 2, Min[50, Max[conv[[All, 1]]]]}];

    Print["d=", d, " convergents p/q: ",
      Select[conv, #[[1]] <= 50 &]];
    Print["  ballot hits: ", ballotHits];
    Print["  (x values that match: ",
      ballotHits[[All, 1]], ")"];
    Print[""];
  ],
{d, {2, 3, 5, 7, 10, 13}}];

(* ================================================================ *)
Print["============================================================"];
Print["EXPERIMENT B: Relaxed boundary u^2 - d*v^2 >= 0"];
Print["============================================================"];
Print[""];

Do[
  Module[{constraint, ballotHits = {}, x, y, dp, bl},
    constraint = Function[{u, r}, u^2 - d r^2 >= 0];
    Do[
      y = yStarRelaxed[d, x];
      If[y >= 1,
        dp = BallotDP[constraint, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp, x^2 - d y^2}]
        ]
      ],
    {x, 2, 50}];
    Print["d=", d, " ballot hits (relaxed): ", ballotHits];
  ],
{d, {2, 3, 5, 7, 10, 13}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["EXPERIMENT C: Shifted boundary v <= (u-1)/sqrt(d)"];
Print["============================================================"];
Print[""];

Do[
  Module[{constraint, ballotHits = {}, x, y, dp, bl},
    constraint = Function[{u, r}, r <= (u - 1) / Sqrt[d]];
    Do[
      y = yStarShifted[d, x];
      If[y >= 1,
        dp = BallotDP[constraint, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp, x^2 - d y^2}]
        ]
      ],
    {x, 2, 50}];
    Print["d=", d, " ballot hits (shifted): ", ballotHits];
  ],
{d, {2, 3, 5, 7, 10, 13}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["EXPERIMENT D: Cubic boundary u^3 - d^(3/2) v^3 >= 1"];
Print["Same asymptote v ~ u/sqrt(d), different curvature"];
Print["============================================================"];
Print[""];

Do[
  Module[{constraint, ballotHits = {}, x, y, dp, bl, sd = N[Sqrt[d]]},
    constraint = Function[{u, r}, u^3 - d^(3/2) r^3 >= 1];
    Do[
      (* nearest y below cubic boundary *)
      y = Floor[x / sd];  (* approximate, refine *)
      While[y >= 0 && !(x^3 - d^(3/2) y^3 >= 1), y--];
      If[y >= 1,
        dp = BallotDP[constraint, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp, N[x^3 - d^(3/2) y^3]}]
        ]
      ],
    {x, 2, 50}];
    Print["d=", d, " ballot hits (cubic): ", ballotHits];
  ],
{d, {2, 3, 5, 7}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["EXPERIMENT E: Comparison — same y*(x) for different constraints"];
Print["Does changing constraint but keeping SAME target change count?"];
Print["============================================================"];
Print[""];

Do[
  Module[{yPell, yRelax, cPell, cRelax, dp1, dp2, bl, conv},
    conv = Table[
      {Numerator[#], Denominator[#]} &@
        FromContinuedFraction[ContinuedFraction[Sqrt[d], k]],
    {k, 2, 15}];
    Print["d=", d, "  CF convergents: ",
      Select[conv, #[[1]] <= 50 &]];

    Do[
      yPell = yStarPell[d, x];
      yRelax = yStarRelaxed[d, x];
      If[yPell >= 1 || yRelax >= 1,
        (* Count paths to SAME target under different constraints *)
        cPell = Function[{u, r}, u^2 - d r^2 >= 1];
        cRelax = Function[{u, r}, u^2 - d r^2 >= 0];
        dp1 = If[yPell >= 1, BallotDP[cPell, {x, yPell}], "-"];
        dp2 = If[yRelax >= 1, BallotDP[cRelax, {x, yRelax}], "-"];
        bl = BallotNumber[x, If[yRelax >= 1, yRelax, yPell]];
        If[yPell != yRelax || dp1 =!= dp2,
          Print["  x=", x, " yPell=", yPell, " yRelax=", yRelax,
            " dpPell=", dp1, " dpRelax=", dp2,
            " ballot(relax)=", bl,
            If[dp2 === bl && IntegerQ[bl], " <-- MATCH", ""]]
        ]
      ],
    {x, 2, 40}];
    Print[""];
  ],
{d, {2, 3, 5, 7}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["EXPERIMENT F: Linear boundary v <= floor(u*p/q) for CF p/q"];
Print["Use slope = convergent p_k/q_k as boundary slope"];
Print["============================================================"];
Print[""];

Do[
  Module[{cf, pk, qk, constraint, ballotHits = {}, x, y, dp, bl},
    cf = ContinuedFraction[Sqrt[d], 6];
    {pk, qk} = {Numerator[#], Denominator[#]} &@
      FromContinuedFraction[Take[cf, 3]];  (* 3rd convergent *)
    Print["d=", d, " using slope p/q=", pk, "/", qk,
      " (3rd convergent of sqrt(", d, "))"];
    constraint = Function[{u, r}, r <= u qk / pk];
    Do[
      y = Floor[x qk / pk];
      If[y >= 1 && y <= 60,
        dp = BallotDP[constraint, {x, y}];
        bl = BallotNumber[x, y];
        If[dp === bl && IntegerQ[bl],
          AppendTo[ballotHits, {x, y, dp}]
        ]
      ],
    {x, 2, 50}];
    Print["  ballot hits: ", ballotHits];
  ],
{d, {2, 3, 5, 7, 10}}];

Print[""];
Print["Done."];
