(* Hierarchical structure of DP/B ratios for Pi *)
(* Between semi-convergents 25 and 47, step = p1 = 22 *)
(* Question: is there sub-structure with period p0 = 3? *)

B[n_, q_] := If[q == 0, 1, Binomial[n + q - 1, q]/n]

dpUnderBeatty[alpha_, nMax_Integer] := Module[
  {S, dp},
  S = Table[Floor[x/alpha], {x, 1, nMax}];
  dp = Table[0, {nMax}, {Max[S] + 2}];
  dp[[1, 1]] = 1;
  Do[Do[
    If[y <= S[[x]],
      dp[[x, y + 1]] =
        If[x == 1 && y == 0, 1, 0] +
        If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
        If[y > 0 && y - 1 <= S[[x]], dp[[x, y]], 0]],
    {y, 0, S[[x]]}], {x, 1, nMax}];
  Table[{x, S[[x]], dp[[x, S[[x]] + 1]]}, {x, 1, nMax}]
]

data = dpUnderBeatty[Pi, 70];

(* Focus on x=22..47 (between p1=22 and semi-conv 47) *)
Print["=== Ratios between semi-convergents 22 and 47 (step p1=22) ==="];
Print["x | S(x) | DP/B(x,S(x)) | x mod 3 | step# in stair"];
Print[StringJoin[Table["-", 70]]];

Do[
  With[{x = d[[1]], sx = d[[2]], dpx = d[[3]]},
    If[22 <= x <= 47,
      With[{b1 = B[x, sx], ratio = dpx / B[x, sx]},
        (* Position within width-3 stair *)
        With[{stairStart = Ceiling[sx * Pi]},
          Print[x, " | ", sx, " | ", ratio, " | ",
            Mod[x, 3], " | ", x - stairStart, " (stair from ", stairStart, ")"]
        ]
      ]
    ]
  ],
  {d, data}];

(* Now: check if DP(x) = DP(prev_semi_conv) * (something simple) *)
Print[""];
Print["=== Ratio DP(x)/DP(x-1) ==="];
prevDP = 1;
Do[
  With[{x = d[[1]], sx = d[[2]], dpx = d[[3]]},
    If[22 <= x <= 50 && prevDP > 0,
      Print[x, " | DP=", dpx, " | DP/DP(x-1) = ", N[dpx/prevDP, 6],
        " | S(x)-S(x-1)=", If[x > 22, sx - data[[x-1, 2]], 0]]
    ];
    prevDP = dpx;
  ],
  {d, data}];

(* Check: within each stair (constant S), is ratio DP(x)/DP(stair_start) linear? *)
Print[""];
Print["=== Within-stair ratios (consecutive x with same S(x)) ==="];
stairDP = {};
stairX = {};
prevS = -1;
Do[
  With[{x = d[[1]], sx = d[[2]], dpx = d[[3]]},
    If[x >= 4,
      If[sx != prevS,
        If[Length[stairDP] > 1,
          Print["Stair S=", prevS, " x=", stairX,
            " ratios from start: ", Table[stairDP[[i]]/stairDP[[1]], {i, Length[stairDP]}]]
        ];
        stairDP = {dpx}; stairX = {x};,
        AppendTo[stairDP, dpx]; AppendTo[stairX, x];
      ];
      prevS = sx;
    ]
  ],
  {d, data}];
(* Print last stair *)
If[Length[stairDP] > 1,
  Print["Stair S=", prevS, " x=", stairX,
    " ratios from start: ", Table[stairDP[[i]]/stairDP[[1]], {i, Length[stairDP]}]]
];
