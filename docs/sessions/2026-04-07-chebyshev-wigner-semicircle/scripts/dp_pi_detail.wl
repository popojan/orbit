(* Detailed DP analysis for alpha = Pi *)
(* The ratio DP(x)/B(x,S(x)) appears to be exactly 2 or 3 between semi-convergents *)

B[n_, q_] := If[q == 0, 1, Binomial[n + q - 1, q]/n]

dpUnderBeatty[alpha_, nMax_Integer] := Module[
  {S, dp},
  S = Table[Floor[x/alpha], {x, 1, nMax}];
  dp = Table[0, {nMax}, {Max[S] + 2}];
  dp[[1, 1]] = 1;
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
  Table[{x, S[[x]], dp[[x, S[[x]] + 1]]}, {x, 1, nMax}]
]

(* Pi has CF = [3; 7, 15, 1, 292, ...] *)
(* Semi-convergent numerators from a1=7: 3+k*3 = 3,6,9,...,22 -> nope *)
(* Actually: p0=3, p1=22. Semi-convs: p_{-1}+j*p_0 = 1+3j for j=1..6: 4,7,10,13,16,19 *)
(* Then p1=22, and semi-convs between p0=3 and p2=333: 22+3j for j=1..14: 25,28,...,64 -> wait *)
(* Let me just compute and check *)

Print["=== Alpha = Pi, detailed ratios ==="];
Print[""];

data = dpUnderBeatty[Pi, 70];

(* CF of Pi *)
cf = ContinuedFraction[Pi, 6];
Print["CF(Pi) = ", cf];
convs = Convergents[Pi, 6];
Print["Convergents: ", convs];
Print[""];

Print["x | S(x) | DP(x) | B(x,S(x)) | exact ratio DP/B | FactorInteger[ratio]"];
Print[StringJoin[Table["-", 85]]];

Do[
  With[{x = d[[1]], sx = d[[2]], dpx = d[[3]]},
    With[{b1 = B[x, sx]},
      If[x > 3 && b1 > 0,
        With[{ratio = dpx/b1},
          Print[
            x, " | ", sx, " | ", dpx, " | ", b1, " | ",
            ratio,
            If[IntegerQ[ratio], " | " <> ToString[FactorInteger[ratio]], ""]
          ]
        ]
      ]
    ]
  ],
  {d, data}];
