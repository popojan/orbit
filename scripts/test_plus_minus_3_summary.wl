#!/usr/bin/env wolframscript
(* SUMMARY: p = k² ± 3 patterns (parity only, no deep analysis) *)

Print[StringRepeat["=", 80]];
Print["QUICK SUMMARY: p = k² ± 3"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

(* Test both +3 and -3 *)
Print["Testing k² + 3 vs k² - 3 period parity..."];
Print[];

plus3 = DeleteCases[Table[
  Module[{p, period},
    p = k^2 + 3;
    If[PrimeQ[p],
      period = CFPeriod[p];
      {k, p, period, If[EvenQ[period], "EVEN", "ODD"]},
      Nothing
    ]
  ],
  {k, 1, 40}
], Nothing];

minus3 = DeleteCases[Table[
  Module[{p, period},
    p = k^2 - 3;
    If[p > 2 && PrimeQ[p],
      period = CFPeriod[p];
      {k, p, period, If[EvenQ[period], "EVEN", "ODD"]},
      Nothing
    ]
  ],
  {k, 2, 40}
], Nothing];

Print[StringRepeat["=", 80]];
Print["p = k² + 3"];
Print[StringRepeat["=", 80]];
Print[];

Print["Found ", Length[plus3], " primes"];
Print[];
Print["k    p      period  parity"];
Print[StringRepeat["-", 40]];
Do[
  {k, p, per, parity} = plus3[[i]];
  Print[
    StringPadRight[ToString[k], 5],
    StringPadRight[ToString[p], 7],
    StringPadRight[ToString[per], 8],
    parity
  ];
  ,
  {i, Length[plus3]}
];

Print[];
parities = plus3[[All, 4]];
Print["All EVEN? ", AllTrue[parities, # == "EVEN" &]];
Print["All ODD?  ", AllTrue[parities, # == "ODD" &]];

Print[];
Print[StringRepeat["=", 80]];
Print["p = k² - 3"];
Print[StringRepeat["=", 80]];
Print[];

Print["Found ", Length[minus3], " primes"];
Print[];
Print["k    p      period  parity"];
Print[StringRepeat["-", 40]];
Do[
  {k, p, per, parity} = minus3[[i]];
  Print[
    StringPadRight[ToString[k], 5],
    StringPadRight[ToString[p], 7],
    StringPadRight[ToString[per], 8],
    parity
  ];
  ,
  {i, Length[minus3]}
];

Print[];
parities = minus3[[All, 4]];
Print["All EVEN? ", AllTrue[parities, # == "EVEN" &]];
Print["All ODD?  ", AllTrue[parities, # == "ODD" &]];

Print[];
Print[StringRepeat["=", 80]];
Print["PARITY PATTERN SUMMARY"];
Print[StringRepeat["=", 80]];
Print[];

Print["Distance from k²:"];
Print[];
Print["  k² - 3: ", If[AllTrue[minus3[[All, 4]], # == "ODD" &], "ALL ODD ✓", "MIXED"]];
Print["  k² - 2: period = 4 (EVEN, constant) ✓"];
Print["  k² - 1: period = 2 or composite"];
Print["  ─────── k² ───────"];
Print["  k² + 1: period = 1 (ODD, trivial) ✓"];
Print["  k² + 2: period = 2 (EVEN, constant) ✓"];
Print["  k² + 3: ", If[AllTrue[plus3[[All, 4]], # == "EVEN" &], "ALL EVEN ✓", "MIXED"]];

Print[];
Print["OBSERVATION: Parity flips around k²!"];
Print["  Below k² (c=-3): periods are ODD"];
Print["  Above k² (c=+3): periods are EVEN");
Print[];

Print["Connection to our half-period formula:"];
Print["  EVEN period → can use ((xh²+p·yh²)/2, xh·yh) speedup ✓"];
Print["  ODD period → different structure (Pell -1 at end)"];

Print[];
Print["TEST COMPLETE"];
