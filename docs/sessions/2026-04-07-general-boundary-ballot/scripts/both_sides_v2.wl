(* Both-Sides V2: Complete ballot detection for ALL convergents
   =============================================================

   KEY INSIGHT from Shadow Test:
   - Positive-norm convergents (p/q > sqrt(d)): y*(p)=q, direct match DP=B(p,q)
   - Negative-norm convergents (p/q < sqrt(d)): y*(p)=q-1, SHADOW: DP=B(p,q) not B(p,q-1)!

   This means the ABOVE staircase ALREADY captures both sides via Shadow.

   But can we also capture the "below" convergents with a TRANSPOSED lattice?
   If we swap (x,y) -> (y,x) and use staircase x*(y) = Floor[y*sqrt(d)],
   we should get the complementary set.

   Also: fix the non-algebraic test (zip, not cross product).
*)

<< Orbit`

BallotNumber[x_, y_] := If[y == 0, 1, Binomial[x + y - 1, y] / x]

(* --- Standard DP (ceiling constraint) --- *)
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

(* --- Transposed DP: paths in (q,p) space with ceiling x*(q)=Floor[q*sqrt(d)] --- *)
(* Paths from (1,0) going right(+1,0) or up(0,+1), staying r<=ceiling[u] *)
(* At target (q, p): returns path count *)
TransposedDP[ceiling_, {q1_Integer, p1_Integer}] :=
  CeilingDP[ceiling, {q1, p1}]

(* ================================================================ *)
Print["============================================================"];
Print["MASTER TABLE: All convergents, both sides, for d=2..13"];
Print["============================================================"];
Print[""];

Do[
  Module[{sd = N[Sqrt[d]], conv, x, y, ystar, dpAbove, blDirect, blShadow},
    conv = Table[
      Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
        {Numerator[r], Denominator[r]}
      ],
    {k, 2, 20}];
    conv = DeleteDuplicatesBy[conv, First];
    conv = Select[conv, #[[1]] <= 60 &];

    Print["d=", d, "  sqrt(d)=", N[Sqrt[d], 8]];
    Print[StringForm["  `1`", StringPadRight["(p, q)", 12] <>
      StringPadRight["norm", 8] <>
      StringPadRight["y*", 6] <>
      StringPadRight["DP", 24] <>
      StringPadRight["B(p,y*)", 24] <>
      StringPadRight["B(p,q)", 24] <>
      "Match"]];

    Do[
      {x, y} = c;
      ystar = Floor[x / sd];
      dpAbove = CeilingDP[Function[u, Floor[u / sd]], {x, Max[ystar, 1]}];
      blDirect = BallotNumber[x, ystar];
      blShadow = BallotNumber[x, y];

      Print[StringForm["  `1`", StringPadRight[ToString[{x, y}], 12] <>
        StringPadRight[ToString[x^2 - d y^2], 8] <>
        StringPadRight[ToString[ystar], 6] <>
        StringPadRight[ToString[dpAbove], 24] <>
        StringPadRight[ToString[blDirect], 24] <>
        StringPadRight[ToString[blShadow], 24] <>
        Which[
          ystar == y && dpAbove === blDirect && IntegerQ[blDirect], "DIRECT",
          ystar != y && dpAbove === blShadow && IntegerQ[blShadow], "SHADOW (y*!=q)",
          dpAbove === blDirect && IntegerQ[blDirect], "direct",
          dpAbove === blShadow && IntegerQ[blShadow], "shadow",
          True, "MISS"
        ]]],
    {c, conv}];
    Print[""];
  ],
{d, Select[Range[2, 20], !IntegerQ[Sqrt[#]] &]}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["TRANSPOSED LATTICE: paths in (q,p) space"];
Print["  ceiling = Floor[q * sqrt(d)], target = (q, p)"];
Print["============================================================"];
Print[""];

Do[
  Module[{sd = N[Sqrt[d]], conv, q, p, pstar, dpTrans, blDirect, blShadow},
    conv = Table[
      Module[{r = FromContinuedFraction[ContinuedFraction[Sqrt[d], k]]},
        {Numerator[r], Denominator[r]}
      ],
    {k, 2, 20}];
    conv = DeleteDuplicatesBy[conv, First];
    conv = Select[conv, #[[2]] <= 40 &];

    Print["d=", d, "  (transposed: q is horizontal, p is vertical)"];

    Do[
      {p, q} = c;
      pstar = Floor[q * sd];
      If[pstar >= 1 && q >= 2,
        dpTrans = TransposedDP[Function[u, Floor[u * sd]], {q, pstar}];
        blDirect = BallotNumber[q, pstar];
        blShadow = BallotNumber[q, p];

        Print["  conv (", p, ",", q, ") norm=", p^2 - d q^2,
          "  p*=Floor[", q, "*sqrt(", d, ")]=", pstar,
          "  DP=", dpTrans,
          "  B(q,p*)=", blDirect,
          "  B(q,p)=", blShadow,
          Which[
            pstar == p && dpTrans === blDirect && IntegerQ[blDirect],
              "  DIRECT",
            pstar != p && dpTrans === blShadow && IntegerQ[blShadow],
              "  SHADOW",
            dpTrans === blDirect && IntegerQ[blDirect],
              "  direct",
            True, "  miss"
          ]]
      ],
    {c, conv}];
    Print[""];
  ],
{d, {2, 3, 5, 7, 10, 13}}];

(* ================================================================ *)
Print[""];
Print["============================================================"];
Print["NON-ALGEBRAIC CONSTANTS (fixed zipping)"];
Print["============================================================"];
Print[""];

Module[{constants = {
    {"Pi", Pi},
    {"E", E},
    {"GoldenRatio", GoldenRatio},
    {"1+Sqrt[2]", 1 + Sqrt[2]},
    {"Sqrt[2]", Sqrt[2]},
    {"CubeRoot[2]", 2^(1/3)}
  }},
  Do[
    Module[{cName = pair[[1]], c = pair[[2]], cv, conv,
      aboveHits = {}, x, yUp, dpUp, blUp, shadowHits = {}},
      cv = N[c];
      conv = Table[
        Module[{r = FromContinuedFraction[ContinuedFraction[c, k]]},
          {Numerator[r], Denominator[r], N[Numerator[r]/Denominator[r] - c]}
        ],
      {k, 2, 25}];
      conv = DeleteDuplicatesBy[conv, First];
      conv = Select[conv, #[[1]] <= 80 &];

      Print[cName, " = ", N[c, 10]];

      Do[
        yUp = Floor[x / cv];
        If[yUp >= 1,
          dpUp = CeilingDP[Function[u, Floor[u / cv]], {x, yUp}];
          blUp = BallotNumber[x, yUp];
          If[dpUp === blUp && IntegerQ[blUp],
            AppendTo[aboveHits, {x, yUp, dpUp, "DIRECT"}],
            (* check shadow: is there a convergent (x, q) with q = yUp+1? *)
            Module[{blShadow = BallotNumber[x, yUp + 1]},
              If[dpUp === blShadow && IntegerQ[blShadow],
                AppendTo[shadowHits, {x, yUp + 1, dpUp, "SHADOW"}]
              ]
            ]
          ]
        ],
      {x, 2, 80}];

      Print["  Convergents: ",
        {#[[1]], #[[2]], If[#[[3]] > 0, "+", "-"]} & /@ conv];
      Print["  Direct ballot hits: ", aboveHits[[All, {1, 2}]]];
      Print["  Shadow ballot hits: ", shadowHits[[All, {1, 2}]]];

      (* Check: are shadow hits the negative-norm convergents? *)
      Module[{
        directX = aboveHits[[All, 1]],
        shadowX = shadowHits[[All, 1]],
        convPlusX = Select[conv, #[[3]] > 0 &][[All, 1]],
        convMinusX = Select[conv, #[[3]] < 0 &][[All, 1]]},
        Print["  Direct ∩ conv(+): ", Intersection[directX, convPlusX],
          " / ", convPlusX];
        Print["  Shadow ∩ conv(-): ", Intersection[shadowX, convMinusX],
          " / ", convMinusX];
        Print["  Extra direct (non-convergent): ",
          Complement[directX, convPlusX, convMinusX]];
        Print["  Extra shadow (non-convergent): ",
          Complement[shadowX, convPlusX, convMinusX]];
      ];
      Print[""];
    ],
  {pair, constants}]
];

Print["Done."];
