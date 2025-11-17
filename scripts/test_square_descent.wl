#!/usr/bin/env wolframscript
(* RECURSIVE SQUARE DESCENT: n → c₁ → c₂ → ... → 0 *)

Print[StringRepeat["=", 80]];
Print["RECURSIVE SQUARE DESCENT ANALYSIS"];
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

(* Square descent: n = k² + c, recurse on c *)
SquareDescent[n_] := Module[{path, current, k, c},
  path = {n};
  current = n;

  While[current > 0,
    k = Floor[Sqrt[current]];
    c = current - k^2;

    If[c == 0, Break[]];

    AppendTo[path, c];
    current = c;

    (* Safety: stop if too deep *)
    If[Length[path] > 20, Break[]];
  ];

  path
]

(* Descent depth *)
DescentDepth[n_] := Length[SquareDescent[n]] - 1

(* Collect data *)
Print["Computing descent for n = 2..200..."];
Print[];

data = Table[
  If[!IntegerQ[Sqrt[n]],
    Module[{R, depth, path, mod8},
      R = Reg[n];
      path = SquareDescent[n];
      depth = Length[path] - 1;
      mod8 = Mod[n, 8];

      If[R > 0,
        {n, R, depth, path, mod8},
        Nothing
      ]
    ],
    Nothing
  ],
  {n, 2, 200}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " non-squares"];
Print[];

(* Show examples *)
Print["EXAMPLES OF SQUARE DESCENT:"];
Print[StringRepeat["-", 70]];

Do[
  {n, R, depth, path, mod8} = data[[i]];
  Print["n = ", n, " (mod 8 = ", mod8, ")"];
  Print["  Depth: ", depth];
  Print["  Path: ", path];
  Print["  R(n) = ", N[R, 4]];
  Print[];
  ,
  {i, Min[15, Length[data]]}
];

Print[StringRepeat["=", 80]];
Print[];

(* Correlations *)
RVals = data[[All, 2]];
depthVals = data[[All, 3]];

Print["CORRELATION ANALYSIS:"];
Print[StringRepeat["-", 60]];
Print["  Depth <-> R:  ", N[Correlation[N[depthVals], N[RVals]], 4]];
Print[];

(* By mod 8 *)
Print["BY MOD 8:"];
Print[StringRepeat["-", 60]];

For[mod = 1, mod <= 7, mod += 2,
  subset = Select[data, #[[5]] == mod &];
  If[Length[subset] > 10,
    RSubset = subset[[All, 2]];
    depthSubset = subset[[All, 3]];

    corr = Correlation[N[depthSubset], N[RSubset]];

    Print["mod ", mod, ": depth <-> R = ", N[corr, 4],
          ", mean depth = ", N[Mean[depthSubset], 2],
          ", mean R = ", N[Mean[RSubset], 2]];
  ]
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Depth distribution *)
Print["DEPTH DISTRIBUTION:"];
Print[StringRepeat["-", 60]];

depthTally = Tally[depthVals];
depthTally = SortBy[depthTally, First];

Do[
  {depth, count} = depthTally[[i]];
  Print["Depth ", depth, ": ", count, " cases (",
        N[100.0*count/Length[data], 2], "%)"];
  ,
  {i, Length[depthTally]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["INTERPRETATION:"];
Print[StringRepeat["-", 60]];
Print[];
Print["Square descent: n = k₁² + c₁, c₁ = k₂² + c₂, ..."];
Print[];
Print["Question: Does descent depth/pattern predict R(n)?"];
Print["  - Deeper descent → more complex CF → larger R?"];
Print["  - Or: residue pattern c₁, c₂, ... encodes CF structure?"];
Print[];

Print[StringRepeat["=", 80]];
