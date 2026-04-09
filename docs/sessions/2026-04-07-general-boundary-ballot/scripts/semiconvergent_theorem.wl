(* DEFINITIVE TEST: Ballot hits = Convergents ∪ Semi-convergents
   ================================================================
   For any irrational alpha, the staircase ⌊x/alpha⌋ produces
   ballot hits EXACTLY at x-values that are numerators of
   convergents or semi-convergents of alpha.

   Semi-convergent between p_{k-1}/q_{k-1} and p_{k+1}/q_{k+1}:
     s_j = p_{k-1} + j * p_k  for j = 1, ..., a_{k+1} - 1
     t_j = q_{k-1} + j * q_k

   Key property: gcd(s_j, t_j) = 1, so B(s_j, t_j) is always integer.
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

(* Proper generation of ALL convergents and semi-convergents *)
AllConvergentsAndSemi[alpha_, maxP_: 200] :=
  Module[{cf, nTerms, ps = {}, qs = {}, result = <||>,
    pm2, pm1, qm2, qm1, pk, qk, a},
    (* Get enough CF terms *)
    nTerms = 30;
    cf = ContinuedFraction[alpha, nTerms];

    (* Build convergent sequence manually including p_{-1}=1, q_{-1}=0 *)
    pm2 = 1; qm2 = 0;  (* p_{-1}, q_{-1} *)
    pm1 = cf[[1]]; qm1 = 1;  (* p_0, q_0 *)

    (* p_0 is a convergent *)
    If[pm1 <= maxP,
      result[pm1] = <|"q" -> qm1, "type" -> "conv", "index" -> 0|>
    ];

    Do[
      a = cf[[k]];
      pk = a pm1 + pm2;
      qk = a qm1 + qm2;

      (* Convergent p_k *)
      If[pk <= maxP,
        result[pk] = <|"q" -> qk, "type" -> "conv", "index" -> k - 1|>
      ];

      (* Semi-convergents between p_{k-2}/q_{k-2} and p_k/q_k *)
      (* s_j = p_{k-2} + j * p_{k-1} for j = 1..a_k - 1 *)
      Do[
        Module[{sp = pm2 + j pm1, sq = qm2 + j qm1},
          If[sp <= maxP && sp > 0,
            result[sp] = <|"q" -> sq, "type" -> "semi",
              "index" -> k - 1, "j" -> j|>
          ]
        ],
      {j, 1, a - 1}];

      pm2 = pm1; qm2 = qm1;
      pm1 = pk; qm1 = qk;
      If[pk > maxP, Break[]],
    {k, 2, nTerms}];

    result
  ]

(* ================================================================ *)
Print["============================================================"];
Print["THEOREM VERIFICATION: Ballot hits = Conv ∪ Semi-conv"];
Print["============================================================"];
Print[""];

Module[{testCases = {
    {"Sqrt[2]", Sqrt[2]},
    {"Sqrt[3]", Sqrt[3]},
    {"Sqrt[5]", Sqrt[5]},
    {"Sqrt[7]", Sqrt[7]},
    {"Sqrt[10]", Sqrt[10]},
    {"Sqrt[13]", Sqrt[13]},
    {"Sqrt[17]", Sqrt[17]},
    {"Sqrt[19]", Sqrt[19]},
    {"GoldenRatio", GoldenRatio},
    {"Pi", Pi},
    {"E", E},
    {"CubeRoot[2]", 2^(1/3)},
    {"1+Sqrt[2]", 1 + Sqrt[2]},
    {"Sqrt[2]+Sqrt[3]", Sqrt[2] + Sqrt[3]}
  }, maxX = 120},

  Do[
    Module[{cName = pair[[1]], alpha = pair[[2]],
      cv, staircase, csMap, ballotHits = {}, x, y, dp, bl, blS,
      missingConv = {}, missingHit = {}, perfectMatch = True},

      cv = N[alpha];
      staircase = Function[u, Floor[u / cv]];
      csMap = AllConvergentsAndSemi[alpha, maxX];

      (* Find all ballot hits via DP *)
      Do[
        y = staircase[x];
        If[y >= 1,
          dp = CeilingDP[staircase, {x, y}];
          bl = BallotNumber[x, y];
          blS = BallotNumber[x, y + 1];
          If[(dp === bl && IntegerQ[bl]) || (dp === blS && IntegerQ[blS]),
            AppendTo[ballotHits, x]
          ]
        ],
      {x, 2, maxX}];

      (* conv/semi x-values in range *)
      Module[{csKeys = Select[Keys[csMap], # <= maxX &]},
        (* Check: every ballot hit should be in csMap *)
        missingHit = Complement[ballotHits, csKeys];
        (* Check: every csMap entry should be a ballot hit *)
        missingConv = Complement[csKeys, ballotHits];

        Print[cName];
        Print["  CF: ", ContinuedFraction[alpha, Min[10, 30]]];
        Print["  Conv+Semi (", Length[csKeys], " pts): ", Sort[csKeys]];
        Print["  Ballot hits (", Length[ballotHits], " pts): ", ballotHits];

        If[Length[missingHit] > 0,
          Print["  !! HITS NOT IN CONV/SEMI: ", missingHit];
          perfectMatch = False
        ];
        If[Length[missingConv] > 0,
          Print["  !! CONV/SEMI NOT HIT: ", missingConv];
          perfectMatch = False
        ];
        If[perfectMatch,
          Print["  ✓ PERFECT MATCH: Ballot hits = Conv ∪ Semi"]
        ];
      ];
      Print[""];
    ],
  {pair, testCases}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["GCD VERIFICATION: gcd(p,q) = 1 for all conv and semi-conv"];
Print["============================================================"];
Print[""];

Do[
  Module[{alpha, csMap, allGCDs},
    alpha = Sqrt[d];
    csMap = AllConvergentsAndSemi[alpha, 200];
    allGCDs = Table[
      GCD[k, csMap[k]["q"]],
    {k, Keys[csMap]}];
    Print["d=", d, ": max gcd = ", Max[allGCDs],
      " (", Length[allGCDs], " points)",
      If[Max[allGCDs] == 1, "  ✓ all coprime", "  !! NON-COPRIME FOUND"]];
  ],
{d, Select[Range[2, 30], !IntegerQ[Sqrt[#]] &]}];

Print[""];

Do[
  Module[{csMap, allGCDs},
    csMap = AllConvergentsAndSemi[c, 200];
    allGCDs = Table[
      GCD[k, csMap[k]["q"]],
    {k, Keys[csMap]}];
    Print[cName, ": max gcd = ", Max[allGCDs],
      " (", Length[allGCDs], " points)",
      If[Max[allGCDs] == 1, "  ✓ all coprime", "  !! NON-COPRIME FOUND"]];
  ],
{c, {Pi, E, GoldenRatio, 2^(1/3)}},
{cName, {"Pi", "E", "GoldenRatio", "CubeRoot[2]"}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SHADOW CHARACTERIZATION: which are direct, which shadow?"];
Print["============================================================"];
Print[""];

Do[
  Module[{alpha = Sqrt[d], cv = N[Sqrt[d]], csMap, staircase},
    csMap = AllConvergentsAndSemi[alpha, 80];
    staircase = Function[u, Floor[u / cv]];

    Print["d=", d];
    Do[
      Module[{x = k, q = csMap[k]["q"], y = staircase[k],
        tp = csMap[k]["type"]},
        Print["  (", x, ",", q, ") ", tp,
          If[tp == "semi", " j=" <> ToString[csMap[k]["j"]], ""],
          "  y*=", y,
          If[y == q, "  DIRECT (y*=q)",
            If[y == q - 1, "  SHADOW (y*=q-1)",
              "  ??(y*=" <> ToString[y] <> ", q=" <> ToString[q] <> ")"]]]
      ],
    {k, Sort[Select[Keys[csMap], # <= 80 &]]}];
    Print[""];
  ],
{d, {2, 5, 7, 10}}];

Print["Done."];
