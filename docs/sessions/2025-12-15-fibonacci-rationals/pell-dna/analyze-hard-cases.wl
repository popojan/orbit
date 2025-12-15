(* Analyze Hard Pell Cases - Focus on Large Solutions *)
(* Where compression really matters *)

(* Fibonacci sequence *)
fibs = Module[{f = {1, 2}},
  While[Last[f] < 10^100, AppendTo[f, f[[-1]] + f[[-2]]]];
  f
];

(* Zeckendorf *)
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

(* Pell fundamental - handle large solutions *)
pellFundamental[d_] := Module[{cf, n, p, q},
  If[IntegerQ[Sqrt[d]], Return[{0, 0}]];
  cf = ContinuedFraction[Sqrt[d], 2000];
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

(* Analyze a single D *)
analyzeD[d_] := Module[{x, y, period, zx, xDigits, rawBits, zeckBits, ratio},
  {x, y} = pellFundamental[d];
  If[x == 0, Return[Nothing]];

  period = cfPeriod[d];
  zx = zeckendorf[x];
  xDigits = IntegerLength[x];

  (* Raw storage: bits for x and y *)
  rawBits = Ceiling[Log2[x + 1]] + Ceiling[Log2[y + 1]];

  (* Zeck storage: indices only *)
  (* Each index needs log2(max_index) bits *)
  zeckBits = If[Length[zx] > 0,
    Length[zx] * Ceiling[Log2[Max[zx] + 1]],
    1
  ];

  ratio = N[rawBits / zeckBits, 4];

  <|
    "D" -> d,
    "period" -> period,
    "xDigits" -> xDigits,
    "zeckLen" -> Length[zx],
    "rawBits" -> rawBits,
    "zeckBits" -> zeckBits,
    "ratio" -> ratio,
    "zeck" -> If[Length[zx] <= 10, zx, Join[Take[zx, 5], {"..."}]]
  |>
];

(* Find hard cases: solutions with many digits *)
Print["=== HARD PELL CASES (x > 10^6) ===\n"];
Print["D\tperiod\t|x|\t|zeck|\traw\tzeck\tratio"];
Print[StringJoin[Table["-", 60]]];

hardCases = {};
Do[
  If[!IntegerQ[Sqrt[d]],
    result = analyzeD[d];
    If[result["xDigits"] > 6,
      AppendTo[hardCases, result];
      Print[
        result["D"], "\t",
        result["period"], "\t",
        result["xDigits"], "\t",
        result["zeckLen"], "\t",
        result["rawBits"], "\t",
        result["zeckBits"], "\t",
        result["ratio"]
      ]
    ]
  ],
  {d, 2, 500}
];

(* Summary *)
Print["\n=== SUMMARY: ", Length[hardCases], " hard cases ==="];
Print["Best compression: ", MaximalBy[hardCases, #["ratio"] &][[1]]["D"],
      " (", Max[#["ratio"] & /@ hardCases], "x)"];
Print["Worst compression: ", MinimalBy[hardCases, #["ratio"] &][[1]]["D"],
      " (", Min[#["ratio"] & /@ hardCases], "x)"];

(* Total savings *)
totalRaw = Total[#["rawBits"] & /@ hardCases];
totalZeck = Total[#["zeckBits"] & /@ hardCases];
Print["Total raw bits: ", totalRaw];
Print["Total zeck bits: ", totalZeck];
Print["Overall compression: ", N[totalRaw/totalZeck, 4], "x"];

(* Export top 20 for database *)
Print["\n=== TOP 20 BY COMPRESSION ==="];
sorted = SortBy[hardCases, -#["ratio"] &];
Do[
  r = sorted[[i]];
  Print["D=", r["D"], ": ", r["ratio"], "x compression, |zeck|=", r["zeckLen"], ", zeck=", r["zeck"]];
  , {i, Min[20, Length[sorted]]}
];
