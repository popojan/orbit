#!/usr/bin/env wolframscript
(* SUM OF TWO SQUARES: n = a² + b² *)

Print[StringRepeat["=", 80]];
Print["SUM OF TWO SQUARES ANALYSIS"];
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

(* Check if n can be written as sum of two squares *)
(* n = a² + b² for some integers a, b >= 0 *)
IsSumOfTwoSquares[n_] := Module[{a, b2, maxA, found},
  maxA = Floor[Sqrt[n]];
  found = False;
  Do[
    b2 = n - a^2;
    If[b2 >= 0 && IntegerQ[Sqrt[b2]], found = True; Break[]];
    ,
    {a, 0, maxA}
  ];
  found
]

(* Find representation *)
FindSumOfSquares[n_] := Module[{a, b, b2, maxA, result},
  maxA = Floor[Sqrt[n]];
  result = Nothing;
  Do[
    b2 = n - a^2;
    If[b2 >= 0 && IntegerQ[Sqrt[b2]],
      b = Floor[Sqrt[b2]];
      result = {a, b};
      Break[];
    ];
    ,
    {a, 0, maxA}
  ];
  result
]

(* Collect data *)
data = Table[
  If[!IntegerQ[Sqrt[n]],
    Module[{R, isSOS, rep, mod4, mod8},
      R = Reg[n];
      isSOS = IsSumOfTwoSquares[n];
      rep = If[isSOS, FindSumOfSquares[n], Nothing];
      mod4 = Mod[n, 4];
      mod8 = Mod[n, 8];

      If[R > 0,
        {n, R, isSOS, rep, mod4, mod8},
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

(* Split *)
sosData = Select[data, #[[3]] == True &];
nonSosData = Select[data, #[[3]] == False &];

Print["SPLIT:"];
Print[StringRepeat["-", 60]];
Print["Sum of two squares:     ", Length[sosData], " cases"];
Print["NOT sum of two squares: ", Length[nonSosData], " cases"];
Print[];

(* Compare R *)
Rsos = sosData[[All, 2]];
RnonSos = nonSosData[[All, 2]];

Print["COMPARISON:"];
Print[StringRepeat["-", 60]];
Print["Sum of two squares:"];
Print["  Mean R:   ", N[Mean[Rsos], 4]];
Print["  Median R: ", N[Median[Rsos], 4]];
Print[];
Print["NOT sum of two squares:"];
Print["  Mean R:   ", N[Mean[RnonSos], 4]];
Print["  Median R: ", N[Median[RnonSos], 4]];
Print[];

diff = Mean[Rsos] - Mean[RnonSos];
Print["Difference: ", N[diff, 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* Examples *)
Print["EXAMPLES (n = a² + b²):"];
Print[StringRepeat["-", 70]];
Print["n       a    b      R(n)     mod 4  mod 8"];
Print[StringRepeat["-", 70]];

Do[
  {n, R, isSOS, rep, mod4, mod8} = sosData[[i]];
  {a, b} = rep;

  Print[
    StringPadRight[ToString[n], 8],
    StringPadRight[ToString[a], 5],
    StringPadRight[ToString[b], 7],
    StringPadRight[ToString[N[R, 4]], 9],
    StringPadRight[ToString[mod4], 7],
    mod8
  ];
  ,
  {i, Min[30, Length[sosData]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* By mod 4 *)
Print["BY MOD 4:"];
Print[StringRepeat["-", 60]];

For[mod = 1, mod <= 3, mod++,
  subset = Select[sosData, #[[5]] == mod &];
  Print["mod 4 = ", mod, ": ", Length[subset], " cases, mean R = ",
        N[Mean[subset[[All, 2]]], 4]];
];

Print[];

(* Fermat theorem check: primes p ≡ 1 (mod 4) *)
Print["PRIMES p ≡ 1 (mod 4):"];
Print[StringRepeat["-", 60]];

primesData = Select[sosData, PrimeQ[#[[1]]] &];
primesMod1 = Select[primesData, Mod[#[[1]], 4] == 1 &];

Print["Found ", Length[primesMod1], " primes p ≡ 1 (mod 4) as sum of squares"];
Print["Examples:"];

Do[
  {n, R, isSOS, rep, mod4, mod8} = primesMod1[[i]];
  {a, b} = rep;
  Print["  ", n, " = ", a, "² + ", b, "², R = ", N[R, 4]];
  ,
  {i, Min[10, Length[primesMod1]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print[];

Print["FERMAT'S THEOREM CONNECTION:"];
Print[StringRepeat["-", 60]];
Print[];
Print["Prime p can be written as p = a² + b² if and only if:"];
Print["  p = 2, or p ≡ 1 (mod 4)"];
Print[];
Print["This is connected to:"];
Print["  - Gaussian primes in Z[i]"];
Print["  - Quadratic reciprocity"];
Print["  - Class field theory"];
Print[];
Print["Question: Does this special structure affect CF(√p)?"];
Print["          Does it explain why p ≡ 1 has higher R?"];
Print[];

Print[StringRepeat["=", 80]];
