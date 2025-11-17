#!/usr/bin/env wolframscript
(* Test class number h(n) correlation with n mod 8 and R(n) *)

Print[StringRepeat["=", 80]];
Print["CLASS NUMBER h(n) vs MOD 8 and REGULATOR"];
Print[StringRepeat["=", 80]];
Print[];

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

(* Compute class number for square-free D *)
(* Using Wolfram's built-in *)
ClassNum[D_] := Module[{h},
  If[!SquareFreeQ[D] || IntegerQ[Sqrt[D]], Return[0]];
  h = NumberFieldClassNumber[Sqrt[D]];
  h
]

(* Collect data for square-free n ≤ 200 *)
Print["Computing h(n), R(n), and mod 8 class for square-free n ≤ 200..."];
Print[];

data = Table[
  If[SquareFreeQ[n] && !IntegerQ[Sqrt[n]],
    Module[{h, R, mod8},
      h = ClassNum[n];
      R = Reg[n];
      mod8 = Mod[n, 8];
      If[h > 0 && R > 0,
        {n, h, R, mod8},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 2, 200}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " square-free n"];
Print[];

(* Overall statistics *)
Print["=== OVERALL STATISTICS ==="];
Print[StringRepeat["-", 40]];

hVals = data[[All, 2]];
RVals = data[[All, 3]];

Print["Class number h:"];
Print["  Mean:   ", N[Mean[hVals], 4]];
Print["  Median: ", Median[hVals]];
Print["  Min:    ", Min[hVals]];
Print["  Max:    ", Max[hVals]];
Print[];

Print["Regulator R:"];
Print["  Mean:   ", N[Mean[RVals], 4]];
Print["  Median: ", N[Median[RVals], 4]];
Print[];

(* h ↔ R correlation *)
corrHR = Correlation[N[hVals], N[RVals]];
Print["h(n) ↔ R(n) correlation: ", N[corrHR, 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === BY MOD 8 CLASS === *)
Print["=== CLASS NUMBER BY MOD 8 ==="];
Print[StringRepeat["-", 40]];

For[mod = 1, mod <= 7, mod++,
  Module[{subset, hSub, RSub, corrSub},
    subset = Select[data, #[[4]] == mod &];
    If[Length[subset] > 5,
      hSub = subset[[All, 2]];
      RSub = subset[[All, 3]];
      corrSub = Correlation[N[hSub], N[RSub]];

      Print["n ≡ ", mod, " (mod 8):"];
      Print["  Count:     ", Length[subset]];
      Print["  Mean h(n): ", N[Mean[hSub], 4]];
      Print["  Mean R(n): ", N[Mean[RSub], 4]];
      Print["  h ↔ R:     ", N[corrSub, 4]];
      Print[];
    ]
  ]
];

Print[StringRepeat["=", 80]];
Print[];

(* === KEY QUESTION: Does h anti-correlate with R? === *)
Print["=== HYPOTHESIS TEST: h(n) · R(n) = constant? ==="];
Print[];

products = Table[data[[i, 2]] * data[[i, 3]], {i, Length[data]}];
Print["h(n) · R(n) products:"];
Print["  Mean:   ", N[Mean[products], 4]];
Print["  Median: ", N[Median[products], 4]];
Print["  Std:    ", N[StandardDeviation[products], 4]];
Print["  CV:     ", N[StandardDeviation[products]/Mean[products], 4], " (coefficient of variation)"];
Print[];

If[StandardDeviation[products]/Mean[products] < 0.3,
  Print["✅ RELATIVELY CONSTANT! h·R may have weak variance."];
  Print["   This suggests class number formula structure."],
  Print["❌ NOT CONSTANT. h·R varies significantly."];
  Print["   No simple inverse relationship."]
];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === ODD n ONLY (cleaner data) === *)
Print["=== ODD n ONLY (REFINED ANALYSIS) ==="];
Print[StringRepeat["-", 40]];

oddData = Select[data, OddQ[#[[1]]] &];
Print["Odd square-free n: ", Length[oddData]];
Print[];

hOdd = oddData[[All, 2]];
ROdd = oddData[[All, 3]];

corrOdd = Correlation[N[hOdd], N[ROdd]];
Print["h(n) ↔ R(n) (odd n only): ", N[corrOdd, 4]];
Print[];

(* By mod 8 for odd n *)
Print["By mod 8 class (odd n only):"];
Print[StringRepeat["-", 40]];

For[mod = 1, mod <= 7, mod += 2,  (* Only odd: 1,3,5,7 *)
  Module[{subset, hSub, RSub, corrSub},
    subset = Select[oddData, #[[4]] == mod &];
    If[Length[subset] > 5,
      hSub = subset[[All, 2]];
      RSub = subset[[All, 3]];
      corrSub = Correlation[N[hSub], N[RSub]];

      Print["n ≡ ", mod, " (mod 8):"];
      Print["  Count:     ", Length[subset]];
      Print["  Mean h(n): ", N[Mean[hSub], 4]];
      Print["  Mean R(n): ", N[Mean[RSub], 4]];
      Print["  h ↔ R:     ", N[corrSub, 4]];

      (* Does mean h vary by mod 8? *)
      If[mod == 1,
        meanH1 = Mean[hSub];
        meanR1 = Mean[RSub],
        If[mod == 3,
          meanH3 = Mean[hSub];
          meanR3 = Mean[RSub]
        ]
      ];
      Print[];
    ]
  ]
];

(* Compare mod classes *)
If[ValueQ[meanH1] && ValueQ[meanH3],
  Print["Comparison (n ≡ 1 vs n ≡ 3):"];
  Print["  h ratio (1/3): ", N[meanH1/meanH3, 4]];
  Print["  R ratio (1/3): ", N[meanR1/meanR3, 4]];
  Print[];

  If[meanH1 < meanH3 && meanR1 > meanR3,
    Print["✅ ANTI-CORRELATION PATTERN!"];
    Print["   n ≡ 1: low h, high R"];
    Print["   n ≡ 3: high h, low R"];
    Print["   This supports h·R ≈ constant hypothesis!"],
    Print["❌ No clear anti-correlation pattern"]
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print["ANALYSIS COMPLETE"];
