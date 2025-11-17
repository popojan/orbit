#!/usr/bin/env wolframscript
(* CAUSAL MECHANISM: Continued Fraction Structure Analysis *)

Print[StringRepeat["=", 80]];
Print["CAUSAL ANALYSIS: Continued Fraction Structure by mod 8"];
Print[StringRepeat["=", 80]];
Print[];

(* Continued fraction for √n *)
CFStructure[n_] := Module[{cf, period, a0, quotients},
  If[IntegerQ[Sqrt[n]], Return[{}]];
  
  cf = ContinuedFraction[Sqrt[n], 100];
  a0 = First[cf];
  quotients = Rest[cf];
  period = Length[quotients];
  
  {a0, quotients, period}
]

(* Pell solution and regulator *)
PellSol[D_] := Module[{sol},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];
  sol = Solve[x^2 - D*y^2 == 1, {x, y}, PositiveIntegers] /. C[1] -> 1;
  If[sol === {}, {0, 0}, {x, y} /. First[sol]]
]

Reg[D_] := Module[{sol, x, y},
  sol = PellSol[D];
  {x, y} = sol;
  If[x > 1, N[Log[x + y*Sqrt[D]], 15], 0.0]
]

DistToK2[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  Min[n - k^2, (k+1)^2 - n]
]

(* === COLLECT CF DATA === *)
Print["Collecting CF structure for odd n ≤ 100..."];
Print[];

data = Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{cf, a0, quotients, period, R, dist, mod8},
      {a0, quotients, period} = CFStructure[n];
      R = Reg[n];
      dist = DistToK2[n];
      mod8 = Mod[n, 8];
      
      If[R > 0 && period > 0,
        {n, a0, quotients, period, R, dist, mod8},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 3, 100}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " odd n"];
Print[];

(* === FIRST TERM ANALYSIS === *)
Print[StringRepeat["=", 80]];
Print["FIRST TERM a₁ ANALYSIS (CAUSAL MECHANISM)"];
Print[StringRepeat["=", 80]];
Print[];

Print["For n = k² + c, theory: a₁ ≈ floor(2k/c)"];
Print[];

firstTerms = Table[
  {n, a0, quotients, period, R, dist, mod8} = data[[i]];
  a1 = If[Length[quotients] > 0, First[quotients], 0];
  {n, a1, dist, R, mod8},
  {i, Length[data]}
];

Print["By mod 8 class:"];
Print[StringRepeat["-", 60]];

For[mod = 1, mod <= 7, mod += 2,
  Module[{subset, a1vals, distVals, RVals},
    subset = Select[firstTerms, #[[5]] == mod &];
    If[Length[subset] > 5,
      a1vals = subset[[All, 2]];
      distVals = subset[[All, 3]];
      RVals = subset[[All, 4]];
      
      Print["n ≡ ", mod, " (mod 8): ", Length[subset], " points"];
      Print["  Mean a₁:     ", N[Mean[a1vals], 4]];
      Print["  a₁ ↔ dist:   ", N[Correlation[N[a1vals], N[distVals]], 4]];
      Print["  a₁ ↔ R:      ", N[Correlation[N[a1vals], N[RVals]], 4]];
      Print[];
    ]
  ]
];

(* === C DISTRIBUTION === *)
Print[StringRepeat["=", 80]];
Print["OFFSET c DISTRIBUTION BY MOD 8"];
Print[StringRepeat["-", 60]];
Print[];

cData = Table[
  {n, a0, quotients, period, R, dist, mod8} = data[[i]];
  k = Floor[Sqrt[n]];
  c = Min[n - k^2, (k+1)^2 - n];
  {n, c, R, mod8},
  {i, Length[data]}
];

For[mod = 1, mod <= 7, mod += 2,
  Module[{subset, cVals, RVals, corr},
    subset = Select[cData, #[[4]] == mod &];
    If[Length[subset] > 5,
      cVals = subset[[All, 2]];
      RVals = subset[[All, 3]];
      corr = Correlation[N[cVals], N[RVals]];
      
      Print["n ≡ ", mod, " (mod 8):"];
      Print["  Mean c:  ", N[Mean[cVals], 4]];
      Print["  c ↔ R:   ", N[corr, 4]];
      
      cMod8 = Map[Mod[#, 8] &, cVals];
      Print["  c mod 8: ", Tally[cMod8]];
      Print[];
    ]
  ]
];

Print[StringRepeat["=", 80]];
Print["CAUSAL CHAIN: n mod 8 → c distribution → a₁ → period → R"];
