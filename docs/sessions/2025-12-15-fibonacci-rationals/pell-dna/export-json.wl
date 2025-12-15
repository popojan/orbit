(* Export Pell DNA as JSON for web viewer *)

(* Fibonacci sequence *)
fibs = Module[{f = {1, 2}},
  While[Last[f] < 10^50, AppendTo[f, f[[-1]] + f[[-2]]]];
  f
];

phi = GoldenRatio // N[#, 50] &;

(* Zeckendorf representation *)
zeckendorf[0] := {}
zeckendorf[n_Integer] := Module[{result = {}, remaining = n, idx},
  idx = Length[Select[fibs, # <= n &]];
  While[remaining > 0 && idx >= 1,
    If[fibs[[idx]] <= remaining,
      AppendTo[result, idx];
      remaining -= fibs[[idx]];
      idx -= 2;
    , idx--]
  ];
  result
]

(* Pell fundamental *)
pellFundamental[d_] := Module[{cf, n, p, q},
  If[IntegerQ[Sqrt[d]], Return[{0, 0}]];
  cf = ContinuedFraction[Sqrt[d], 1000];
  For[n = 2, n <= Length[cf], n++,
    {p, q} = {Numerator[#], Denominator[#]} &@ FromContinuedFraction[Take[cf, n]];
    If[p^2 - d*q^2 == 1, Return[{p, q}]];
    If[p^2 - d*q^2 == -1, Return[{p^2 + d*q^2, 2*p*q}]];
  ];
  {0, 0}
];

(* CF period *)
cfPeriod[d_] := Module[{cf},
  If[IntegerQ[Sqrt[d]], Return[0]];
  cf = ContinuedFraction[Sqrt[d]];
  If[ListQ[cf] && Length[cf] >= 2 && ListQ[cf[[2]]],
    Length[cf[[2]]], 0]
];

(* Find optimal scaling *)
findOptimalScaling[d_, x_, y_] := Module[
  {target, best, bestLen, r, s, scaledX, g, zx, len},
  target = phi / Sqrt[N[d, 30]];
  best = {1, 1};
  bestLen = Length[zeckendorf[x]];

  Do[
    r = Numerator[Rationalize[target * s, 1/s]];
    If[r > 0 && GCD[r, s] == 1,
      scaledX = x * s;
      g = GCD[scaledX, y * r];
      scaledX = scaledX / g;
      If[IntegerQ[scaledX] && scaledX > 0,
        zx = zeckendorf[scaledX];
        len = Length[zx];
        If[len < bestLen, best = {r, s}; bestLen = len]
      ]
    ],
    {s, 1, 30}
  ];
  best
];

(* Generate and export *)
Print["// Pell DNA Database - Generated ", DateString[]];
Print["// Format: {D, x, y, period, zeck, [r,s], scaledZeck}"];
Print["const PELL_DNA = ["];

Do[
  If[!IntegerQ[Sqrt[d]],
    {x, y} = pellFundamental[d];
    If[x > 0,
      period = cfPeriod[d];
      zeck = zeckendorf[x];
      {r, s} = findOptimalScaling[d, x, y];

      scaledX = (x * s) / GCD[x * s, y * r];
      scaledZeck = If[IntegerQ[scaledX], zeckendorf[scaledX], zeck];

      (* JSON format *)
      Print["  {\"d\":", d,
        ",\"x\":\"", x, "\"",
        ",\"y\":\"", y, "\"",
        ",\"p\":", period,
        ",\"z\":", zeck,
        If[{r, s} != {1, 1},
          StringJoin[",\"s\":[", ToString[r], ",", ToString[s], "]",
            ",\"sz\":", ToString[scaledZeck]],
          ""
        ],
        "},"]
    ]
  ],
  {d, 2, 200}
];

Print["];"];

(* Summary stats *)
Print["\n// Statistics:"];
Print["// D range: 2-200"];
Print["// Generated: ", DateString[]];
