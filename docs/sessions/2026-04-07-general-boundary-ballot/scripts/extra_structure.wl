(* Deep analysis of extra ballot hit structure
   =============================================
   1. For quadratic sqrt(d): which norms appear and WHY?
      - Norms from CF partial quotients
      - Completeness: are ALL small norms represented?
   2. For transcendental: precise formula for arithmetic step
   3. Semi-convergent connection
*)

<< Orbit`

BallotNumber[x_, y_] := If[y == 0, 1, Binomial[x + y - 1, y] / x]

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

(* ================================================================ *)
Print["============================================================"];
Print["SECTION 1: Semi-convergents and ballot hits"];
Print["  Semi-convergents: h_{k-1} + j*h_k for j=1..a_{k+1}-1"];
Print["  Are extras exactly the semi-convergents?"];
Print["============================================================"];
Print[""];

Do[
  Module[{cf, convs, semiConvs = {}, allBallotHits = {},
    sd = N[Sqrt[d]], staircase, x, y, dp, bl, blS},

    cf = ContinuedFraction[Sqrt[d], 20];
    (* Build all convergents and semi-convergents *)
    convs = Table[
      FromContinuedFraction[Take[cf, k]],
    {k, 1, Min[15, Length[cf]]}];

    (* Semi-convergents between consecutive convergents *)
    Do[
      Module[{pk1 = Numerator[convs[[k-1]]], qk1 = Denominator[convs[[k-1]]],
              pk = Numerator[convs[[k]]], qk = Denominator[convs[[k]]],
              ak1 = cf[[k]]},
        Do[
          AppendTo[semiConvs,
            {pk1 + j pk, qk1 + j qk, "semi"}],
        {j, 1, ak1 - 1}]
      ],
    {k, 3, Min[12, Length[cf]]}];

    (* Convergents themselves *)
    Module[{convPairs = Table[
        {Numerator[convs[[k]]], Denominator[convs[[k]]], "conv"},
      {k, 2, Min[12, Length[cf]]}]},

      (* Now find all ballot hits *)
      staircase = Function[u, Floor[u / sd]];
      Do[
        y = staircase[x];
        If[y >= 1,
          dp = CeilingDP[staircase, {x, y}];
          bl = BallotNumber[x, y];
          blS = BallotNumber[x, y + 1];
          If[(dp === bl && IntegerQ[bl]) || (dp === blS && IntegerQ[blS]),
            Module[{qEff = If[dp === bl && IntegerQ[bl], y, y + 1],
                    type = If[dp === bl && IntegerQ[bl], "direct", "shadow"]},
              AppendTo[allBallotHits, {x, qEff, type}]
            ]
          ]
        ],
      {x, 2, 70}];

      Print["d=", d, "  CF=", Take[cf, Min[8, Length[cf]]]];
      Print["  Convergents (p): ",
        Select[convPairs, #[[1]] <= 70 &][[All, 1]]];
      Print["  Semi-convs (p): ",
        Select[semiConvs, #[[1]] <= 70 &][[All, 1]]];
      Print["  Ballot hits (p): ", allBallotHits[[All, 1]]];

      (* Check overlap *)
      Module[{hitX = allBallotHits[[All, 1]],
              convX = Select[convPairs, #[[1]] <= 70 &][[All, 1]],
              semiX = Select[semiConvs, #[[1]] <= 70 &][[All, 1]]},
        Print["  Hits that are convergents: ", Intersection[hitX, convX]];
        Print["  Hits that are semi-convergents: ", Intersection[hitX, semiX]];
        Print["  Hits that are NEITHER: ",
          Complement[hitX, convX, semiX]];
        Print["  Semi-convs NOT hit: ", Complement[semiX, hitX]];
      ];
      Print[""];
    ]
  ],
{d, {2, 3, 5, 7, 10, 13, 17}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 2: Transcendental — semi-convergent analysis"];
Print["============================================================"];
Print[""];

Module[{constants = {
    {"Pi", Pi, 15},
    {"E", E, 20},
    {"CubeRoot[2]", 2^(1/3), 15}
  }},
  Do[
    Module[{cName = triple[[1]], c = triple[[2]], nCF = triple[[3]],
      cf, convs, semiConvs = {}, allBallotHits = {},
      cv = N[triple[[2]]], staircase, x, y, dp, bl, blS},

      cf = ContinuedFraction[c, nCF];
      convs = Table[
        FromContinuedFraction[Take[cf, k]],
      {k, 1, Length[cf]}];

      (* Semi-convergents *)
      Do[
        Module[{pk1 = Numerator[convs[[k-1]]], qk1 = Denominator[convs[[k-1]]],
                pk = Numerator[convs[[k]]], qk = Denominator[convs[[k]]],
                ak1 = cf[[k]]},
          Do[
            AppendTo[semiConvs, {pk1 + j pk, qk1 + j qk}],
          {j, 1, ak1 - 1}]
        ],
      {k, 3, Length[cf]}];

      staircase = Function[u, Floor[u / cv]];
      Do[
        y = staircase[x];
        If[y >= 1,
          dp = CeilingDP[staircase, {x, y}];
          bl = BallotNumber[x, y];
          blS = BallotNumber[x, y + 1];
          If[(dp === bl && IntegerQ[bl]) || (dp === blS && IntegerQ[blS]),
            Module[{qEff = If[dp === bl && IntegerQ[bl], y, y + 1],
                    type = If[dp === bl && IntegerQ[bl], "direct", "shadow"]},
              AppendTo[allBallotHits, {x, qEff, type}]
            ]
          ]
        ],
      {x, 2, 100}];

      Print[cName, "  CF=", cf];
      Print["  Convergents (p): ",
        Table[Numerator[convs[[k]]], {k, 2, Length[cf]}]];
      Print["  Semi-convs (p≤100): ",
        Select[semiConvs, #[[1]] <= 100 &][[All, 1]]];
      Print["  Ballot hits: ",
        {#[[1]], #[[3]]} & /@ allBallotHits];

      Module[{hitX = allBallotHits[[All, 1]],
              convX = Table[Numerator[convs[[k]]], {k, 2, Length[cf]}],
              semiX = Select[semiConvs, #[[1]] <= 100 &][[All, 1]]},
        Print["  Hits ∩ convergents: ", Intersection[hitX, convX]];
        Print["  Hits ∩ semi-convs: ", Intersection[hitX, semiX]];
        Print["  Hits that are NEITHER: ",
          Complement[hitX, convX, semiX]];
      ];
      Print[""];
    ],
  {triple, constants}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 3: Completeness — which Pell norms give ballot hits?"];
Print["  For d=2..10, enumerate ALL norm orbits with |N| <= d"];
Print["  and check which produce ballot hits"];
Print["============================================================"];
Print[""];

Do[
  Module[{sd = N[Sqrt[d]], staircase, normHits = <||>},
    staircase = Function[u, Floor[u / sd]];

    (* Find all ballot hits up to x=100 *)
    Do[
      Module[{y = staircase[x], dp, bl, blS, qEff, norm},
        If[y >= 1,
          dp = CeilingDP[staircase, {x, y}];
          bl = BallotNumber[x, y];
          blS = BallotNumber[x, y + 1];
          If[dp === bl && IntegerQ[bl],
            qEff = y; norm = x^2 - d qEff^2;
            normHits[norm] = Append[Lookup[normHits, norm, {}], {x, qEff}],
            If[dp === blS && IntegerQ[blS],
              qEff = y + 1; norm = x^2 - d qEff^2;
              normHits[norm] = Append[Lookup[normHits, norm, {}], {x, qEff}]
            ]
          ]
        ]
      ],
    {x, 2, 100}];

    Print["d=", d];
    Do[
      Print["  norm ", n, ": ", Lookup[normHits, n, {}]],
    {n, Sort[Keys[normHits]]}];

    (* Which norms <= d exist as solutions but DON'T appear? *)
    Module[{existingNorms = {},
            hitNorms = Sort[Keys[normHits]]},
      Do[
        If[Length[Solve[x^2 - d y^2 == n && x > 0 && y > 0 &&
          x <= 100, {x, y}, Integers]] > 0,
          AppendTo[existingNorms, n]
        ],
      {n, Join[Range[-d, -1], Range[1, d]]}];
      Print["  Existing norms with |N|<=d: ", existingNorms];
      Print["  Hit norms: ", hitNorms];
      Print["  Missing: ", Complement[existingNorms, hitNorms]];
    ];
    Print[""];
  ],
{d, {2, 3, 5, 7}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 4: Density of ballot hits per band"];
Print["  For d with long CF period, how many hits per CF period?"];
Print["============================================================"];
Print[""];

Do[
  Module[{sd = N[Sqrt[d]], staircase, hitCount = 0, cfPeriod,
    sol, xMax},
    sol = PellSolve[d];
    cfPeriod = Length[ContinuedFraction[Sqrt[d], 50]] - 1;
    (* count hits up to 2*Pell solution x-value *)
    xMax = Min[sol[[1]], 200];
    staircase = Function[u, Floor[u / sd]];
    Do[
      Module[{y = staircase[x], dp, bl, blS},
        If[y >= 1,
          dp = CeilingDP[staircase, {x, y}];
          bl = BallotNumber[x, y];
          blS = BallotNumber[x, y + 1];
          If[(dp === bl && IntegerQ[bl]) || (dp === blS && IntegerQ[blS]),
            hitCount++
          ]
        ]
      ],
    {x, 2, xMax}];
    Print["d=", d, "  CF period=", cfPeriod, "  Pell x=", sol[[1]],
      "  hits in x≤", xMax, ": ", hitCount,
      "  density=", N[hitCount / xMax]];
  ],
{d, Select[Range[2, 30], !IntegerQ[Sqrt[#]] &]}];

Print[""];
Print["Done."];
