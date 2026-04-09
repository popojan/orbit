(* Extra (non-convergent) ballot hits classification
   ===================================================
   For quadratic irrationals sqrt(d):
     Extra hits have norm x^2-d*y^2 = N for small |N|.
     Hypothesis: these form Pell-like orbits with specific norms.

   For transcendental/non-quadratic alpha:
     What structure do the extras have?

   Also: systematic enumeration of ALL ballot hits up to large x,
   classified by norm orbit.
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
Print["SECTION 1: All ballot hits for sqrt(d), d=2..20"];
Print["  Classify each hit as DIRECT convergent, SHADOW convergent,"];
Print["  or EXTRA (with norm)"];
Print["============================================================"];
Print[""];

Do[
  Module[{sd = N[Sqrt[d]], conv, convSet, staircase,
    allHits = {}, x, y, dp, bl, blShadow, norm, tag},

    (* Get convergents as set of {p, q} *)
    conv = Table[
      Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
        {Numerator[r], Denominator[r]}
      ],
    {k, 2, 25}];
    conv = DeleteDuplicatesBy[conv, First];
    convSet = Association[# -> True & /@ conv[[All, 1]]];

    staircase = Function[u, Floor[u / sd]];

    Do[
      y = staircase[x];
      If[y >= 1,
        dp = CeilingDP[staircase, {x, y}];
        bl = BallotNumber[x, y];
        blShadow = BallotNumber[x, y + 1];
        norm = x^2 - d y^2;

        tag = Which[
          dp === bl && IntegerQ[bl] && KeyExistsQ[convSet, x],
            "DIRECT-conv",
          dp === bl && IntegerQ[bl],
            "DIRECT-extra",
          dp === blShadow && IntegerQ[blShadow] && KeyExistsQ[convSet, x],
            "SHADOW-conv",
          dp === blShadow && IntegerQ[blShadow],
            "SHADOW-extra",
          True,
            None
        ];

        If[tag =!= None,
          AppendTo[allHits,
            <|"x" -> x, "y" -> y, "q_eff" -> If[StringContainsQ[tag, "SHADOW"],
              y + 1, y],
              "norm" -> norm, "dp" -> dp, "tag" -> tag|>]
        ]
      ],
    {x, 2, 70}];

    Print["d=", d, "  (", Length[allHits], " hits in x=2..70)"];
    Do[
      Print["  (", h["x"], ",", h["q_eff"], ")  norm=",
        h["x"]^2 - d h["q_eff"]^2, "  DP=", h["dp"], "  ", h["tag"]],
    {h, allHits}];

    (* Norm distribution *)
    Module[{norms = #["x"]^2 - d #["q_eff"]^2 & /@ allHits,
            tags = #["tag"] & /@ allHits},
      Print["  Norms found: ", Union[norms]];
      Module[{extras = Select[allHits, StringContainsQ[#["tag"], "extra"] &]},
        If[Length[extras] > 0,
          Print["  EXTRA norms: ",
            Tally[#["x"]^2 - d #["q_eff"]^2 & /@ extras]]
        ]
      ]
    ];
    Print[""];
  ],
{d, Select[Range[2, 20], !IntegerQ[Sqrt[#]] &]}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 2: Extra hits form Pell orbits?"];
Print["  For d=2: extras should satisfy x^2-2y^2 = +/-2"];
Print["  Check: (x_n, y_n) = (x_1,y_1) * (3+2sqrt(2))^n"];
Print["============================================================"];
Print[""];

Module[{d = 2, fund = {3, 2}},
  Print["d=2, fundamental Pell solution: ", fund];
  Print[""];

  (* Generate norm-2 orbit: x^2-2y^2=2, seed (2,1) *)
  Print["Norm +2 orbit from seed (2,1):"];
  Module[{x = 2, y = 1, xn, yn},
    Do[
      Print["  n=", n, ": (", x, ",", y, ")  norm=", x^2 - 2 y^2];
      {xn, yn} = {x fund[[1]] + d y fund[[2]],
                   x fund[[2]] + y fund[[1]]};
      {x, y} = {xn, yn},
    {n, 0, 5}]
  ];
  Print[""];

  (* Generate norm -2 orbit: seed from x^2-2y^2=-2 => (0,1) no... *)
  (* Actually: 2^2 - 2*1^2 = 2, and norm -1: 1^2-2*1^2=-1 *)
  (* Multiply (1+sqrt(2)) * (3+2sqrt(2)) = 3+2sqrt(2)+3sqrt(2)+4 = 7+5sqrt(2) *)
  (* So norm -1 orbit: (1,1)=norm-1, (7,5)=norm-1, (41,29)=norm-1 *)
  (* norm -2: (0,1)? 0-2=-2... or multiply (1,1) by itself: *)
  (* Actually norm*norm = norm^2 under multiplication *)
  (* (a+b sqrt(2))(c+d sqrt(2)) = (ac+2bd) + (ad+bc)sqrt(2) *)
  (* norm(product) = norm(a)*norm(b) *)
  (* So to get norm -2, need seed with norm -2: x^2-2y^2=-2 has no solution *)
  (* x^2 = 2y^2-2 = 2(y^2-1), so x^2 even, x=2m, 4m^2=2y^2-2, 2m^2=y^2-1 *)
  (* y^2-2m^2=1, Pell! y=3,m=2: x=4, check 16-2*9=-2. But wait... *)
  (* 4^2-2*3^2=16-18=-2. Yes! Seed (4,3). *)
  Print["Norm -2 orbit from seed (4,3):"];
  Module[{x = 4, y = 3, xn, yn},
    Do[
      Print["  n=", n, ": (", x, ",", y, ")  norm=", x^2 - 2 y^2];
      {xn, yn} = {x fund[[1]] + d y fund[[2]],
                   x fund[[2]] + y fund[[1]]};
      {x, y} = {xn, yn},
    {n, 0, 5}]
  ];
  Print[""];

  Print["Comparison with ballot extra hits from Section 1:"];
  Print["  Direct extras should be on norm +2 orbit: (2,1),(10,7),(58,41),..."];
  Print["  Shadow extras should be on norm -2 orbit: (4,3),(24,17),(140,99),..."];
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 3: For d=5, identify extra hit structure"];
Print["  CF convergents include semi-convergents?"];
Print["============================================================"];
Print[""];

Module[{d = 5, sd = N[Sqrt[5]]},
  (* Full CF semiconvergents *)
  Module[{cf = ContinuedFraction[Sqrt[5], 15], allConv = {}},
    Do[
      Module[{r = FromContinuedFraction[Take[cf, k]]},
        AppendTo[allConv, {Numerator[r], Denominator[r],
          Numerator[r]^2 - 5 Denominator[r]^2}]
      ],
    {k, 2, 15}];
    allConv = DeleteDuplicatesBy[allConv, #[[1]] &];

    Print["d=5 full convergents: ", allConv];
    Print[""];

    (* Also get semiconvergents *)
    Print["Semiconvergents of sqrt(5):"];
    Module[{prev, curr, sc},
      prev = {1, 0};
      Do[
        curr = {Numerator[#], Denominator[#]} &@
          FromContinuedFraction[Take[cf, k]];
        (* semiconvergents between prev and curr *)
        Module[{a = cf[[k]]},
          Do[
            sc = prev + j {If[k > 2,
              Numerator[FromContinuedFraction[Take[cf, k-1]]],
              cf[[1]]],
              If[k > 2,
                Denominator[FromContinuedFraction[Take[cf, k-1]]],
                1]};
            (* Actually this is wrong. Use the proper formula. *)
            Null,
          {j, 1, a - 1}]
        ];
        prev = curr,
      {k, 2, 8}]
    ];

    (* Simpler: just list all (p,q) with p^2-5q^2 = small norms *)
    Print[""];
    Print["Points with |p^2-5q^2| <= 5, p<=50:"];
    Do[
      Do[
        Module[{norm = p^2 - 5 q^2},
          If[Abs[norm] <= 5 && norm != 0,
            Print["  (", p, ",", q, ")  norm=", norm,
              "  p/q=", N[p/q]]
          ]
        ],
      {q, 1, Floor[p / sd]}],
    {p, 2, 50}]
  ]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 4: Non-algebraic extras — structure of extra hits"];
Print["  For e, GoldenRatio, Pi: what pattern do extras follow?"];
Print["============================================================"];
Print[""];

Module[{constants = {
    {"GoldenRatio", GoldenRatio},
    {"E", E},
    {"Pi", Pi},
    {"CubeRoot[2]", 2^(1/3)}
  }},
  Do[
    Module[{cName = pair[[1]], c = pair[[2]], cv = N[pair[[2]]],
      staircase, conv, convSet,
      directHits = {}, shadowHits = {}, x, y, dp, bl, blS},

      conv = Table[
        Module[{r = FromContinuedFraction[ContinuedFraction[c, k]]},
          {Numerator[r], Denominator[r]}
        ],
      {k, 2, 30}];
      conv = DeleteDuplicatesBy[conv, First];
      convSet = Association[# -> True & /@ conv[[All, 1]]];

      staircase = Function[u, Floor[u / cv]];

      Do[
        y = staircase[x];
        If[y >= 1,
          dp = CeilingDP[staircase, {x, y}];
          bl = BallotNumber[x, y];
          blS = BallotNumber[x, y + 1];
          If[dp === bl && IntegerQ[bl],
            AppendTo[directHits,
              {x, y, !KeyExistsQ[convSet, x]}]
          ];
          If[dp =!= bl && dp === blS && IntegerQ[blS],
            AppendTo[shadowHits,
              {x, y + 1, !KeyExistsQ[convSet, x]}]
          ];
        ],
      {x, 2, 100}];

      Print[cName, " = ", N[c, 8]];
      Print["  Direct hits: ",
        {#[[1]], #[[2]], If[#[[3]], "EXTRA", "conv"]} & /@ directHits];
      Print["  Shadow hits: ",
        {#[[1]], #[[2]], If[#[[3]], "EXTRA", "conv"]} & /@ shadowHits];

      (* Analyze extras *)
      Module[{dExtras = Select[directHits, #[[3]] &][[All, 1]],
              sExtras = Select[shadowHits, #[[3]] &][[All, 1]]},
        If[Length[dExtras] > 1,
          Print["  Direct extra x-values: ", dExtras];
          Print["  Differences: ", Differences[dExtras]];
          Print["  Ratios: ", N[Ratios[dExtras]]]
        ];
        If[Length[sExtras] > 1,
          Print["  Shadow extra x-values: ", sExtras];
          Print["  Differences: ", Differences[sExtras]];
          Print["  Ratios: ", N[Ratios[sExtras]]]
        ];
      ];
      Print[""];
    ],
  {pair, constants}]
];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["SECTION 5: Are extras = higher CF convergents of RELATED α?"];
Print["  For sqrt(2): extras (2,1),(10,7),(58,41) satisfy x^2-2y^2=2"];
Print["  These are convergents of... what?"];
Print["============================================================"];
Print[""];

(* For d=2, norm-2 solutions: (2,1),(10,7),(58,41),(338,239),... *)
(* These satisfy x/y -> sqrt(2), but they're NOT convergents of sqrt(2) *)
(* They ARE convergents of sqrt(2) + something? *)
(* Actually: x^2-2y^2=2 => (x/y)^2 = 2 + 2/y^2 => x/y -> sqrt(2) *)
(* But best approximations to sqrt(2) are the convergents. *)
(* (2,1): 2/1=2, (10,7): 10/7≈1.4286, (58,41): 58/41≈1.4146 *)

(* Check: are these "second-best" approximations? *)
Print["Best approximations to sqrt(2):"];
Module[{sd = N[Sqrt[2], 20]},
  Do[
    Module[{y = q, x = Round[q sd]},
      Print["  q=", q, ": best x=", x, " x/q=", N[x/q],
        " |x/q-sqrt2|=", N[Abs[x/q - sd]],
        " norm=", x^2 - 2 q^2]
    ],
  {q, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 24, 29, 41}}]
];

Print[""];
Print["Key insight: for q=1, best x=1 (norm -1), but x=2 (norm +2) is the"];
Print["SECOND-best approximation. Similarly for other extras."];
Print[""];
Print["Extras = SECOND-BEST rational approximations (next after convergents)?"];

Print[""];
Print["Done."];
