(* Generalized Pell for irrational d
   ==================================
   Question: For irrational d (like Pi, E, GoldenRatio^2, etc),
   do convergents of sqrt(d) give "approximate Pell solutions"
   x^2 - d*y^2 ≈ small?

   And does the STAIRCASE Floor[x/sqrt(d)] still produce ballot hits
   at these "approximate Pell" points?
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
Print["SECTION 1: Convergents of sqrt(d) for irrational d"];
Print["  Compute 'norms' p^2 - d*q^2 — are they bounded?"];
Print["============================================================"];
Print[""];

Module[{testCases = {
    {"Pi", Pi},
    {"E", E},
    {"GoldenRatio^2", GoldenRatio^2},
    {"Pi^2", Pi^2},
    {"2*Pi", 2 Pi},
    {"Sqrt[2]", Sqrt[2]},  (* d = sqrt(2), so alpha = 2^(1/4) *)
    {"3/2", 3/2}  (* rational d *)
  }},
  Do[
    Module[{dName = pair[[1]], d = pair[[2]],
      sd, cf, convs, norms},
      sd = N[Sqrt[d], 30];
      cf = ContinuedFraction[Sqrt[d], 25];

      Print[dName, " = ", N[d, 10], "  sqrt = ", N[sd, 10]];
      Print["  CF(sqrt(d)) = ", Take[cf, Min[12, Length[cf]]]];
      Print[""];

      (* Convergents and their "norms" *)
      convs = Table[
        Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
          {Numerator[r], Denominator[r]}
        ],
      {k, 2, Min[20, Length[cf]]}];
      convs = DeleteDuplicatesBy[convs, First];

      Print[StringForm["  `1`",
        StringPadRight["p/q", 16] <>
        StringPadRight["p^2-d*q^2", 20] <>
        StringPadRight["|norm|", 12] <>
        "bound 2*sqrt(d)"]];

      Do[
        Module[{p = c[[1]], q = c[[2]], norm},
          norm = N[p^2 - d q^2, 20];
          If[p <= 500,
            Print[StringForm["  `1`",
              StringPadRight[ToString[p] <> "/" <> ToString[q], 16] <>
              StringPadRight[ToString[NumberForm[norm, 8]], 20] <>
              StringPadRight[ToString[NumberForm[Abs[norm], 6]], 12] <>
              ToString[NumberForm[N[2 Sqrt[d]], 6]]]]
          ]
        ],
      {c, convs}];
      Print["  Max |norm| = ",
        NumberForm[N[Max[Abs[#[[1]]^2 - d #[[2]]^2] & /@
          Select[convs, #[[1]] <= 500 &]]], 8]];
      Print["  Hurwitz bound = ", NumberForm[N[2 Sqrt[d] / Sqrt[5]], 6]];
      Print[""];
    ],
  {pair, testCases}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 2: Ballot hits for Floor[x/sqrt(d)] with irrational d"];
Print["  Do ballot hits still correspond to conv of sqrt(d)?"];
Print["============================================================"];
Print[""];

Module[{testCases = {
    {"Pi", Pi},
    {"E", E},
    {"2*Pi", 2 Pi},
    {"Pi^2", Pi^2}
  }},
  Do[
    Module[{dName = pair[[1]], d = pair[[2]],
      sd, staircase, conv, convSet, allHits = {},
      x, y, dp, bl, blS},

      sd = N[Sqrt[d]];
      staircase = Function[u, Floor[u / sd]];

      conv = Table[
        Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
          {Numerator[r], Denominator[r]}
        ],
      {k, 2, 25}];
      conv = DeleteDuplicatesBy[conv, First];
      convSet = Association[# -> True & /@ conv[[All, 1]]];

      Do[
        y = staircase[x];
        If[y >= 1,
          dp = CeilingDP[staircase, {x, y}];
          bl = BallotNumber[x, y];
          blS = BallotNumber[x, y + 1];
          If[(dp === bl && IntegerQ[bl]) || (dp === blS && IntegerQ[blS]),
            Module[{qEff = If[dp === bl && IntegerQ[bl], y, y + 1],
                    type = If[dp === bl && IntegerQ[bl], "D", "S"]},
              AppendTo[allHits, {x, qEff, type,
                N[x^2 - d qEff^2],
                KeyExistsQ[convSet, x]}]
            ]
          ]
        ],
      {x, 2, 80}];

      Print["d = ", dName, "  alpha = sqrt(d) = ", NumberForm[sd, 8]];
      Do[
        Print["  (", h[[1]], ",", h[[2]], ") ", h[[3]],
          " norm=", NumberForm[h[[4]], 6],
          If[h[[5]], " CONV", " semi"]],
      {h, allHits}];
      Print[""];
    ],
  {pair, testCases}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 3: Egyptian sqrt connection"];
Print["  EgyptianSqrt uses: sqrt(d) ≈ x/y - 1/(2xy(x^2-dy^2-1))"];
Print["  For Pell: x^2-dy^2=1 gives exact formula"];
Print["  For irrational d: x^2-dy^2 ≈ N gives approx formula"];
Print["============================================================"];
Print[""];

(* For Pell solution (x,y) with x^2-dy^2=1:
   sqrt(d) = (x/y) * (1 - 1/(2x^2) + ...) exactly via CF

   For approximate Pell (x,y) with x^2-dy^2 = N:
   sqrt(d) = sqrt((x^2-N)/y^2) = (x/y)*sqrt(1-N/x^2)
           ≈ x/y - N/(2xy) - N^2/(8x^3y) - ...

   Error of truncation at first term:
   |sqrt(d) - x/y| ≈ |N|/(2xy)
*)

Module[{testCases = {
    {"Pi", Pi},
    {"E", E}
  }},
  Do[
    Module[{dName = pair[[1]], d = pair[[2]], sd, conv},
      sd = N[Sqrt[d], 30];
      conv = Table[
        Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
          {Numerator[r], Denominator[r]}
        ],
      {k, 2, 18}];
      conv = DeleteDuplicatesBy[conv, First];

      Print["Egyptian sqrt approximation for d = ", dName];
      Print["  sqrt(", dName, ") = ", NumberForm[sd, 20]];
      Print[""];

      Do[
        Module[{p = c[[1]], q = c[[2]], norm, approx1, approx2, err1, err2},
          norm = N[p^2 - d q^2, 30];
          (* First approximation: p/q *)
          approx1 = N[p/q, 30];
          err1 = Abs[approx1 - sd];
          (* Egyptian correction: p/q - N/(2pq) *)
          approx2 = N[p/q - norm/(2 p q), 30];
          err2 = Abs[approx2 - sd];

          If[p <= 200,
            Print["  (", p, ",", q, ") norm=",
              NumberForm[norm, 8]];
            Print["    p/q = ", NumberForm[approx1, 15],
              "  err=", ScientificForm[err1, 4]];
            Print["    p/q - N/(2pq) = ", NumberForm[approx2, 15],
              "  err=", ScientificForm[err2, 4],
              "  (", NumberForm[N[err1/err2], 3], "x better)"];
            Print[""];
          ]
        ],
      {c, conv}];
    ],
  {pair, testCases}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 4: The user's hypothesis: x^2 - d y^2 = 1 ± 1/d"];
Print["  Is 1/d the right error bound?"];
Print["  Or is it 2*sqrt(d) (from Hurwitz/Lagrange)?"];
Print["  What's the ACTUAL minimum |norm| for each d?"];
Print["============================================================"];
Print[""];

Module[{testCases = {
    {"2 (integer)", 2, 20},
    {"3 (integer)", 3, 20},
    {"Pi", Pi, 25},
    {"E", E, 25},
    {"Sqrt[2]", Sqrt[2], 25},
    {"GoldenRatio", GoldenRatio, 25},
    {"GoldenRatio^2", GoldenRatio^2, 25},
    {"7.5", 15/2, 25},
    {"100", 100, 20},
    {"1000", 1000, 20}
  }},

  Print[StringForm["`1`",
    StringPadRight["d", 20] <>
    StringPadRight["min|norm|", 14] <>
    StringPadRight["2*sqrt(d)", 12] <>
    StringPadRight["1/d", 12] <>
    StringPadRight["at (p,q)", 16] <>
    "norm value"]];
  Print[""];

  Do[
    Module[{dName = triple[[1]], d = triple[[2]], nCF = triple[[3]],
      conv, norms, minNorm, minIdx, p, q, normVal},
      conv = Table[
        Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
          {Numerator[r], Denominator[r]}
        ],
      {k, 2, nCF}];
      conv = DeleteDuplicatesBy[conv, First];
      (* skip trivial p_0 *)
      conv = Select[conv, #[[2]] >= 1 &];

      norms = N[#[[1]]^2 - d #[[2]]^2] & /@ conv;
      minNorm = Min[Abs /@ norms];
      minIdx = Position[Abs /@ norms, minNorm][[1, 1]];
      {p, q} = conv[[minIdx]];
      normVal = norms[[minIdx]];

      Print[StringForm["`1`",
        StringPadRight[dName, 20] <>
        StringPadRight[ToString[NumberForm[minNorm, 6]], 14] <>
        StringPadRight[ToString[NumberForm[N[2 Sqrt[d]], 6]], 12] <>
        StringPadRight[ToString[NumberForm[N[1/d], 6]], 12] <>
        StringPadRight[ToString[{p, q}], 16] <>
        ToString[NumberForm[normVal, 8]]]];
    ],
  {triple, testCases}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 5: Spectrum of achievable norms — Markov-like"];
Print["  For each d, what's the infimum of |x^2-d*y^2| / sqrt(d)?"];
Print["  (normalized by sqrt(d) for comparison)"];
Print["============================================================"];
Print[""];

Module[{testCases = {
    {"2", 2}, {"3", 3}, {"5", 5}, {"7", 7}, {"10", 10},
    {"Pi", Pi}, {"E", E}, {"GoldenRatio^2", GoldenRatio^2},
    {"Sqrt[2]", Sqrt[2]}, {"Pi^2", Pi^2}
  }},
  Do[
    Module[{dName = pair[[1]], d = pair[[2]], conv, normsSorted},
      conv = Table[
        Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
          {Numerator[r], Denominator[r]}
        ],
      {k, 2, 30}];
      conv = DeleteDuplicatesBy[conv, First];

      (* All norms, normalized *)
      normsSorted = Sort[
        N[#[[1]]^2 - d #[[2]]^2] & /@ Select[conv, #[[2]] >= 1 &]
      ];

      Print["d=", dName, " norms: ",
        NumberForm[#, 6] & /@ Take[normsSorted, Min[10, Length[normsSorted]]]];
      Print["  normalized |N|/sqrt(d): ",
        NumberForm[#, 4] & /@
          Sort[Abs[#] / N[Sqrt[d]] & /@ Take[normsSorted, Min[10, Length[normsSorted]]]]];
      Print["  min |N|/sqrt(d) = ",
        NumberForm[Min[Abs[#] / N[Sqrt[d]] & /@ normsSorted], 6]];
      Print[""];
    ],
  {pair, testCases}]
];

Print["Done."];
