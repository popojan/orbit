(* Both-sides ballot experiment
   ==============================
   For staircase from ABOVE: y*(x) = Floor[x/c], paths stay BELOW ceiling
   → matches convergents approaching c from ABOVE (overestimates)

   For staircase from BELOW: y*(x) = Ceiling[x/c], paths stay ABOVE floor
   → should match convergents approaching c from BELOW (underestimates)

   Question: Do the two sides together capture ALL convergents?
*)

<< Orbit`

(* --- DP: paths from (1,0) to (x1,y1) staying at or below ceiling --- *)
CeilingDP[ceiling_, {x1_Integer, y1_Integer}] :=
  Module[{dp},
    If[y1 == 0, Return[If[x1 >= 1, 1, 0]]];
    If[y1 < 0, Return[0]];
    dp = Table[0, {x1}, {y1 + 1}];
    Do[
      Do[
        If[r <= ceiling[u],
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

(* --- DP: paths from (1,0) to (x1,y1) staying at or above floor --- *)
(* Start at (1,0). Move right (+1,0) or up (0,+1). Stay >= floor. *)
FloorDP[floorFn_, {x1_Integer, y1_Integer}] :=
  Module[{dp},
    If[y1 < 0, Return[0]];
    dp = Table[0, {x1}, {y1 + 1}];
    Do[
      Do[
        If[r >= floorFn[u],
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
Print["EXPERIMENT: Both sides of sqrt(d) for d = 2,3,5,7,10,13"];
Print["============================================================"];
Print[""];

Do[
  Module[{sd = N[Sqrt[d]], conv, convAbove, convBelow,
    aboveHits = {}, belowHits = {}, x, yUp, yDown, dpUp, dpDown,
    blUp, blDown},

    (* Get ALL convergents of sqrt(d) up to suitable range *)
    conv = Table[
      Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
        {Numerator[r], Denominator[r], Numerator[r]^2 - d Denominator[r]^2}
      ],
    {k, 2, 25}];
    conv = DeleteDuplicatesBy[conv, #[[1]] &];

    (* Classify: above (p/q > sqrt(d), norm > 0) vs below (norm < 0) *)
    convAbove = Select[conv, #[[3]] > 0 &];
    convBelow = Select[conv, #[[3]] < 0 &];

    Print["d=", d, "  sqrt(d)=", N[Sqrt[d], 6]];
    Print["  Convergents above (norm>0): ",
      {#[[1]], #[[2]], #[[3]]} & /@ Select[convAbove, #[[1]] <= 60 &]];
    Print["  Convergents below (norm<0): ",
      {#[[1]], #[[2]], #[[3]]} & /@ Select[convBelow, #[[1]] <= 60 &]];

    (* --- ABOVE staircase: y*(x) = Floor[x/sqrt(d)] --- *)
    (* Paths stay below this ceiling. Target = ceiling at x. *)
    Do[
      yUp = Floor[x / sd];
      If[yUp >= 1,
        dpUp = CeilingDP[Function[u, Floor[u / sd]], {x, yUp}];
        blUp = BallotNumber[x, yUp];
        If[dpUp === blUp && IntegerQ[blUp],
          AppendTo[aboveHits, {x, yUp, dpUp}]
        ]
      ],
    {x, 2, 60}];

    (* --- BELOW staircase: floor = Ceiling[x/sqrt(d)] --- *)
    (* Paths stay above this floor. Target = floor at x. *)
    Do[
      yDown = Ceiling[x / sd];
      If[yDown >= 1 && yDown <= 60,
        dpDown = FloorDP[Function[u, Ceiling[u / sd]], {x, yDown}];
        blDown = BallotNumber[x, yDown];
        If[dpDown === blDown && IntegerQ[blDown],
          AppendTo[belowHits, {x, yDown, dpDown}]
        ]
      ],
    {x, 2, 60}];

    Print["  ABOVE staircase ballot hits: ", aboveHits];
    Print["  BELOW staircase ballot hits: ", belowHits];

    (* Check overlap with convergents *)
    Module[{aboveX = aboveHits[[All, 1]],
            belowX = belowHits[[All, 1]],
            convAboveX = Select[convAbove, #[[1]] <= 60 &][[All, 1]],
            convBelowX = Select[convBelow, #[[1]] <= 60 &][[All, 1]]},
      Print["  Above hits vs above convergents: ",
        Intersection[aboveX, convAboveX], " / ", convAboveX];
      If[Length[convBelowX] > 0,
        Print["  Below hits vs below convergents: ",
          Intersection[belowX, convBelowX], " / ", convBelowX],
        Print["  (no below convergents in range)"]
      ];
      Print["  Above hits that ARE below convergents: ",
        Intersection[aboveX, convBelowX]];
      Print["  Below hits that ARE above convergents: ",
        Intersection[belowX, convAboveX]];
    ];
    Print[""];
  ],
{d, {2, 3, 5, 7, 10, 13}}];

(* ================================================================ *)
Print["============================================================"];
Print["SHADOW TEST: At above-convergent x, does DP count equal"];
Print["  BallotNumber[x, q_convergent] (not y*(x))?"];
Print["============================================================"];
Print[""];

Do[
  Module[{sd = N[Sqrt[d]], conv, x, y, q, dpCount, blTarget, blConv},
    conv = Table[
      Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
        {Numerator[r], Denominator[r], Numerator[r]^2 - d Denominator[r]^2}
      ],
    {k, 2, 20}];
    conv = DeleteDuplicatesBy[conv, #[[1]] &];

    Print["d=", d];
    Do[
      {x, q} = {c[[1]], c[[2]]};
      If[x <= 50,
        y = Floor[x / sd];
        dpCount = CeilingDP[Function[u, Floor[u / sd]], {x, y}];
        blTarget = BallotNumber[x, y];
        blConv = BallotNumber[x, q];
        Print["  conv (", x, ",", q, ") norm=", c[[3]],
          "  y*=", y,
          "  DP=", dpCount,
          "  B(x,y*)=", blTarget,
          "  B(x,q)=", blConv,
          If[dpCount === blTarget && IntegerQ[blTarget], "  <-- y* MATCH", ""],
          If[dpCount === blConv && IntegerQ[blConv] && q != y,
            "  <-- SHADOW (q!=y* but B(x,q) matches!)", ""]]
      ],
    {c, conv}];
    Print[""];
  ],
{d, {2, 3, 5, 7, 10, 13}}];

(* ================================================================ *)
Print["============================================================"];
Print["NON-ALGEBRAIC: Both sides for Pi, E, GoldenRatio"];
Print["============================================================"];
Print[""];

Do[
  Module[{cv = N[c], conv, aboveHits = {}, belowHits = {},
    x, yUp, yDown, dpUp, dpDown, blUp, blDown},

    conv = Table[
      Module[{r = FromContinuedFraction[ContinuedFraction[c, k]]},
        {Numerator[r], Denominator[r], N[Numerator[r]/Denominator[r] - c]}
      ],
    {k, 2, 25}];
    conv = DeleteDuplicatesBy[conv, #[[1]] &];

    Print[cName, " = ", N[c, 10]];
    Print["  Convergents: ",
      {#[[1]], #[[2]], If[#[[3]] > 0, "+", "-"]} & /@
        Select[conv, #[[1]] <= 80 &]];

    (* ABOVE staircase *)
    Do[
      yUp = Floor[x / cv];
      If[yUp >= 1,
        dpUp = CeilingDP[Function[u, Floor[u / cv]], {x, yUp}];
        blUp = BallotNumber[x, yUp];
        If[dpUp === blUp && IntegerQ[blUp],
          AppendTo[aboveHits, {x, yUp, dpUp}]
        ]
      ],
    {x, 2, 80}];

    (* BELOW staircase *)
    Do[
      yDown = Ceiling[x / cv];
      If[yDown >= 1 && yDown <= 60,
        dpDown = FloorDP[Function[u, Ceiling[u / cv]], {x, yDown}];
        blDown = BallotNumber[x, yDown];
        If[dpDown === blDown && IntegerQ[blDown],
          AppendTo[belowHits, {x, yDown, dpDown}]
        ]
      ],
    {x, 2, 80}];

    Print["  ABOVE ballot hits: ", aboveHits];
    Print["  BELOW ballot hits: ", belowHits];

    Module[{
      convPlus = Select[conv, #[[3]] > 0 && #[[1]] <= 80 &][[All, 1]],
      convMinus = Select[conv, #[[3]] < 0 && #[[1]] <= 80 &][[All, 1]]},
      If[Length[aboveHits] > 0,
        Print["  Above hits ∩ conv(+): ",
          Intersection[aboveHits[[All, 1]], convPlus]]];
      If[Length[belowHits] > 0,
        Print["  Below hits ∩ conv(-): ",
          Intersection[belowHits[[All, 1]], convMinus]]];
    ];
    Print[""];
  ],
{c, {Pi, E, GoldenRatio, Sqrt[2], Sqrt[5], Sqrt[7]}},
{cName, {"Pi", "E", "GoldenRatio", "Sqrt[2]", "Sqrt[5]", "Sqrt[7]"}}];

Print["Done."];
