#!/usr/bin/env wolframscript
Print["M_odd test for even n..."];

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]
Modd[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] && OddQ[#] &]]

PellSol[D_] := Module[{sol},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];
  sol = Solve[x^2 - D*y^2 == 1, {x, y}, PositiveIntegers] /. C[1] -> 1;
  If[sol === {}, {0, 0}, {x, y} /. First[sol]]
]

Reg[D_] := Module[{sol, x, y},
  sol = PellSol[D];
  {x, y} = sol;
  If[x > 1, N[Log[x + y*Sqrt[D]], 10], 0.0]
]

(* Even n only *)
evenData = Select[
  Table[{n, M[n], Modd[n], Reg[n], Mod[n, 8]}, {n, 2, 200, 2}],
  #[[4]] > 0 && !IntegerQ[Sqrt[#[[1]]]] &
];

Print["Collected ", Length[evenData], " even n"];
Print[];

For[mod = 2, mod <= 6, mod += 2,
  Module[{subset, Mvals, Moddvals, Rvals, corrM, corrModd},
    subset = Select[evenData, #[[5]] == mod &];
    If[Length[subset] > 5,
      Mvals = subset[[All, 2]];
      Moddvals = subset[[All, 3]];
      Rvals = subset[[All, 4]];
      
      corrM = Correlation[N[Mvals], N[Rvals]];
      corrModd = Correlation[N[Moddvals], N[Rvals]];
      
      Print["n ≡ ", mod, " (mod 8): ", Length[subset], " points"];
      Print["  M ↔ R:     ", N[corrM, 4]];
      Print["  M_odd ↔ R: ", N[corrModd, 4]];
      
      If[Abs[corrModd] > Abs[corrM],
        Print["    → IMPROVED by ", N[100*(Abs[corrModd]/Abs[corrM] - 1), 1], "% ⭐"],
        Print["    → No improvement"]
      ];
      Print[];
    ]
  ]
]
