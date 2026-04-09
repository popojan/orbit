(* DP(x) between convergents of alpha *)
(* Question: does DP(x) factor as sum/product of ballot numbers? *)

(* DP counter for paths from (1,0) to (n, S(n)) under staircase S(x) = Floor[x/alpha] *)
dpUnderBeatty[alpha_, nMax_Integer] := Module[
  {S, dp, n, y},
  S = Table[Floor[x/alpha], {x, 1, nMax}];
  (* dp[[x, y+1]] = number of paths from (1,0) to (x,y) under S *)
  dp = Table[0, {nMax}, {Max[S] + 2}];
  dp[[1, 1]] = 1; (* (1,0) is the start *)
  Do[
    Do[
      If[y <= S[[x]],
        dp[[x, y + 1]] =
          If[x == 1 && y == 0, 1, 0] +
          If[x > 1 && y <= S[[x - 1]], dp[[x - 1, y + 1]], 0] +
          If[y > 0 && y - 1 <= S[[x]], dp[[x, y]], 0]
      ],
      {y, 0, S[[x]]}],
    {x, 1, nMax}];
  (* Return {x, S(x), DP(x)} for each x *)
  Table[{x, S[[x]], dp[[x, S[[x]] + 1]]}, {x, 1, nMax}]
]

(* Ballot number *)
B[n_, q_] := If[q == 0, 1, Binomial[n + q - 1, q]/n]

(* Find convergent and semi-convergent numerators of alpha *)
cfNumerators[alpha_, depth_: 20] := Module[
  {cf, convs, semis, allNums},
  cf = ContinuedFraction[alpha, depth];
  convs = Convergents[alpha, depth];
  allNums = DeleteDuplicates[Sort[
    Flatten[{
      Numerator /@ convs,
      (* semi-convergents *)
      Table[
        With[{pk1 = Numerator[convs[[k]]], qk1 = Denominator[convs[[k]]],
              pk = If[k > 1, Numerator[convs[[k-1]]], 1],
              qk = If[k > 1, Denominator[convs[[k-1]]], 0]},
          Table[pk + j * pk1, {j, 0, If[k < Length[cf], cf[[k+1]] - 1, 0]}]
        ],
        {k, 1, Min[Length[convs], depth]}
      ]
    }]
  ]];
  allNums
]

(* Main analysis *)
analyzeAlpha[alpha_, nMax_Integer: 100] := Module[
  {data, cfNums, isCF},
  Print["alpha = ", alpha, " ≈ ", N[alpha, 6]];
  Print[""];

  data = dpUnderBeatty[alpha, nMax];
  cfNums = cfNumerators[alpha, 15];

  Print["x | S(x) | DP(x) | B(x,S(x)) | B(x,S(x)+1) | CF? | ratio DP/B"];
  Print[StringJoin[Table["-", 75]]];

  Do[
    With[{x = d[[1]], sx = d[[2]], dpx = d[[3]]},
      With[{
        b1 = B[x, sx],
        b2 = B[x, sx + 1],
        cf = MemberQ[cfNums, x]},
        If[x > Floor[alpha] && dpx > 1, (* skip trivial region *)
          Print[
            x, " | ", sx, " | ", dpx, " | ",
            b1, " | ", b2, " | ",
            If[cf, "CF", "  "], " | ",
            If[dpx == b1, "=B(q)",
              If[dpx == b2, "=B(q+1)",
                (* Check if DP factors over ballot numbers *)
                With[{factors = Select[cfNums, # < x && # > Floor[alpha] &]},
                  With[{found = Select[
                    Tuples[{factors, factors}],
                    B[#[[1]], Floor[#[[1]]/alpha]] * B[#[[2]], Floor[#[[2]]/alpha]] == dpx &,
                    1]},
                    If[Length[found] > 0,
                      "B(" <> ToString[found[[1,1]]] <> ")·B(" <> ToString[found[[1,2]]] <> ")",
                      ToString[N[dpx/b1, 4]] <> "×B(q)"
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ],
    {d, data}];

  Print[""];
  Print["CF numerators up to ", nMax, ": ", Select[cfNums, # <= nMax &]];
]

(* Test with sqrt(7) — well-studied case *)
Print["=== alpha = sqrt(7) ==="];
analyzeAlpha[Sqrt[7], 50];

Print[""];
Print["=== alpha = golden ratio ==="];
analyzeAlpha[GoldenRatio, 40];

Print[""];
Print["=== alpha = pi ==="];
analyzeAlpha[Pi, 30];
