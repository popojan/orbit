#!/usr/bin/env wolframscript
(* ANALYZE RESIDUE STRUCTURE: When is c₁ a perfect square? *)

Print[StringRepeat["=", 80]];
Print["RESIDUE STRUCTURE ANALYSIS"];
Print[StringRepeat["=", 80]];
Print[];

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

(* n = k² + c *)
FirstResidue[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  n - k^2
]

(* Collect data *)
data = Table[
  If[!IntegerQ[Sqrt[n]],
    Module[{R, k, c1, c1Square, mod8},
      R = Reg[n];
      k = Floor[Sqrt[n]];
      c1 = n - k^2;
      c1Square = IntegerQ[Sqrt[c1]];
      mod8 = Mod[n, 8];

      If[R > 0,
        {n, R, c1, c1Square, mod8},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 2, 200}
];

data = DeleteCases[data, Nothing];

Print["Total: ", Length[data], " non-squares"];
Print[];

(* Split by c₁ being perfect square *)
squareCases = Select[data, #[[4]] == True &];
nonSquareCases = Select[data, #[[4]] == False &];

Print["SPLIT BY c₁ TYPE:"];
Print[StringRepeat["-", 60]];
Print["c₁ is perfect square:     ", Length[squareCases], " cases"];
Print["c₁ is NOT perfect square: ", Length[nonSquareCases], " cases"];
Print[];

(* Compare R values *)
RSquare = squareCases[[All, 2]];
RNonSquare = nonSquareCases[[All, 2]];

Print["COMPARISON:"];
Print[StringRepeat["-", 60]];
Print["c₁ = perfect square:"];
Print["  Mean R:   ", N[Mean[RSquare], 4]];
Print["  Median R: ", N[Median[RSquare], 4]];
Print[];
Print["c₁ ≠ perfect square:"];
Print["  Mean R:   ", N[Mean[RNonSquare], 4]];
Print["  Median R: ", N[Median[RNonSquare], 4]];
Print[];

(* Statistical test *)
diff = Mean[RSquare] - Mean[RNonSquare];
Print["Difference in means: ", N[diff, 4]];
Print["Ratio (square/non-square): ", N[Mean[RSquare]/Mean[RNonSquare], 3]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Show examples *)
Print["EXAMPLES WHERE c₁ = PERFECT SQUARE:"];
Print[StringRepeat["-", 70]];
Print["n       k    c₁   sqrt(c₁)  R(n)     mod 8"];
Print[StringRepeat["-", 70]];

Do[
  {n, R, c1, square, mod8} = squareCases[[i]];
  k = Floor[Sqrt[n]];
  sqrtC1 = Floor[Sqrt[c1]];

  Print[
    StringPadRight[ToString[n], 8],
    StringPadRight[ToString[k], 5],
    StringPadRight[ToString[c1], 5],
    StringPadRight[ToString[sqrtC1], 11],
    StringPadRight[ToString[N[R, 4]], 9],
    mod8
  ];
  ,
  {i, Min[20, Length[squareCases]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Pattern: c₁ = 1, 4, 9, etc? *)
Print["DISTRIBUTION OF c₁ VALUES (when perfect square):"];
Print[StringRepeat["-", 60]];

c1Values = squareCases[[All, 3]];
c1Tally = Tally[c1Values];
c1Tally = SortBy[c1Tally, First];

Do[
  {c1Val, count} = c1Tally[[i]];
  casesForC1 = Select[squareCases, #[[3]] == c1Val &];
  meanR = Mean[casesForC1[[All, 2]]];

  Print["c₁ = ", c1Val, " (√c₁ = ", Floor[Sqrt[c1Val]], "): ",
        count, " cases, mean R = ", N[meanR, 4]];
  ,
  {i, Length[c1Tally]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* By mod 8 *)
Print["BY MOD 8 (for c₁ = perfect square):"];
Print[StringRepeat["-", 60]];

For[mod = 1, mod <= 7, mod += 2,
  subset = Select[squareCases, #[[5]] == mod &];
  If[Length[subset] > 2,
    Print["mod ", mod, ": ", Length[subset], " cases, mean R = ",
          N[Mean[subset[[All, 2]]], 4]];
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["KEY INSIGHT:"];
Print[StringRepeat["-", 60]];
Print[];
Print["When n = k² + c₁ and c₁ is perfect square (c₁ = m²):"];
Print["  n = k² + m²  (sum of two squares!)"];
Print[];
Print["This is SPECIAL algebraic structure!"];
Print["  - Pythagorean-like"];
Print["  - CF(√n) has special symmetry?"];
Print["  - Relates to Gaussian integers Z[i]?"];
Print[];

Print[StringRepeat["=", 80]];
