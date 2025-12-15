(* Pell DNA Database Generator v3 *)
(* With scaling optimization: find (r/s)² to minimize Zeckendorf complexity *)

(* Fibonacci numbers *)
fibs = Module[{f = {1, 2}},
  While[Last[f] < 10^20, AppendTo[f, f[[-1]] + f[[-2]]]];
  f
];

phi = GoldenRatio // N[#, 50] &;

(* Zeckendorf representation *)
zeckendorf[0] := {}
zeckendorf[n_Integer] := Module[{result = {}, remaining = n, idx},
  idx = Length[fibs];
  While[remaining > 0 && idx >= 1,
    If[fibs[[idx]] <= remaining,
      AppendTo[result, idx];
      remaining -= fibs[[idx]];
      idx -= 2;
    , idx--]
  ];
  result
]

(* Pell fundamental solution *)
pellFundamental[d_] := Module[{cf, n, p, q},
  If[IntegerQ[Sqrt[d]], Return[{0, 0}]];
  cf = ContinuedFraction[Sqrt[d], 500];
  For[n = 2, n <= Length[cf], n++,
    {p, q} = {Numerator[#], Denominator[#]} &@ FromContinuedFraction[Take[cf, n]];
    If[p^2 - d*q^2 == 1, Return[{p, q}]];
    If[p^2 - d*q^2 == -1, Return[{p^2 + d*q^2, 2*p*q}]];
  ];
  {0, 0}
];

(* Find optimal scaling (r/s)² to minimize |zeck| *)
(* Idea: (r/s)²D ≈ φ², so r/s ≈ φ/√D *)
findOptimalScaling[d_, x_, y_] := Module[
  {target, best, bestLen, r, s, scaledX, scaledY, zx, len, g},

  target = phi / Sqrt[N[d, 30]];
  best = {1, 1};
  bestLen = Length[zeckendorf[x]];

  (* Search small rationals close to target *)
  Do[
    r = Numerator[Rationalize[target * s, 1/s]];
    If[r > 0 && GCD[r, s] == 1,
      (* Scaled solution: x' = x*s², y' = y*r² *)
      (* Check: x'² - (D*r⁴/s⁴)y'² = x²s⁴ - D*r⁴*y² = s⁴(x² - Dy²*(r⁴/s⁴)) *)
      (* Actually simpler: we're looking at x/y → (x*s)/(y*r) *)
      scaledX = x * s;
      scaledY = y * r;
      g = GCD[scaledX, scaledY];
      scaledX = scaledX / g;
      scaledY = scaledY / g;
      (* Only consider if scaledX is integer *)
      If[IntegerQ[scaledX] && scaledX > 0,
        zx = zeckendorf[scaledX];
        len = Length[zx];
        If[len < bestLen,
          best = {r, s};
          bestLen = len;
        ]
      ]
    ],
    {s, 1, 50}
  ];

  best
];

(* CF period *)
cfPeriod[d_] := Module[{cf},
  If[IntegerQ[Sqrt[d]], Return[0]];
  cf = ContinuedFraction[Sqrt[d]];
  If[ListQ[cf] && Length[cf] >= 2 && ListQ[cf[[2]]],
    Length[cf[[2]]], 0]
];

(* Generate database *)
Print["=== PELL DNA DATABASE v3 (with scaling) ===\n"];
Print["D\tperiod\t|zeck|\t|scaled|\t(r,s)\tx"];
Print[StringJoin[Table["-", 70]]];

results = {};
Do[
  If[!IntegerQ[Sqrt[d]],
    {x, y} = pellFundamental[d];
    If[x > 0,
      period = cfPeriod[d];
      zx = zeckendorf[x];
      origLen = Length[zx];

      (* Find optimal scaling *)
      {r, s} = findOptimalScaling[d, x, y];
      scaledX = (x * s) / GCD[x * s, y * r];
      scaledZeck = If[IntegerQ[scaledX], zeckendorf[scaledX], {}];
      scaledLen = Length[scaledZeck];

      AppendTo[results, <|
        "D" -> d,
        "period" -> period,
        "x" -> x,
        "y" -> y,
        "origZeck" -> zx,
        "origLen" -> origLen,
        "r" -> r,
        "s" -> s,
        "scaledLen" -> scaledLen,
        "scaledZeck" -> scaledZeck,
        "improvement" -> origLen - scaledLen
      |>];

      Print[d, "\t", period, "\t", origLen, "\t", scaledLen, "\t",
        "(", r, ",", s, ")\t",
        If[x < 10^5, x, ToString[IntegerLength[x]] <> "dig"]
      ]
    ]
  ],
  {d, 2, 100}
];

(* Summary *)
Print["\n=== SUMMARY ==="];
Print["Total D: ", Length[results]];
improvements = Select[results, #["improvement"] > 0 &];
Print["Improved by scaling: ", Length[improvements], " (", N[100 Length[improvements]/Length[results], 3], "%)"];
totalOrig = Total[#["origLen"] & /@ results];
totalScaled = Total[#["scaledLen"] & /@ results];
Print["Total |zeck| original: ", totalOrig];
Print["Total |zeck| scaled: ", totalScaled];
Print["Overall reduction: ", N[100 (totalOrig - totalScaled) / totalOrig, 3], "%"];

(* Best improvements *)
Print["\n=== TOP IMPROVEMENTS ==="];
sorted = SortBy[improvements, -#["improvement"] &];
Do[
  r = sorted[[i]];
  Print["D=", r["D"], ": ", r["origLen"], " → ", r["scaledLen"],
    " (scale ", r["r"], "/", r["s"], ")"];
  , {i, Min[10, Length[sorted]]}
];
