#!/usr/bin/env wolframscript
(* TEST: Taylor expansion → first CF term prediction *)

Print[StringRepeat["=", 80]];
Print["TAYLOR EXPANSION: Predicting a₁ without CF iteration"];
Print[StringRepeat["=", 80]];
Print[];

(* For D = k² + c, Taylor expansion gives:
   √D = k + c/(2k) - c²/(8k³) + ...
   α₁ = √D - k ≈ c/(2k)
   a₁ = floor(1/α₁) ≈ floor(2k/c)
*)

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

GetFirstCFTerm[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[Null]];
  cf = ContinuedFraction[Sqrt[D]];
  If[Length[cf] >= 2 && Length[cf[[2]]] > 0,
    cf[[2, 1]],
    Null
  ]
]

Print["Testing prediction accuracy for p = k² + c with small |c|"];
Print[];

(* Test for c ∈ {1..10, -1..-10} to find boundary *)
For[c = -10, c <= 10, c++,
  If[c == 0, Continue[]];

  cases = DeleteCases[Table[
    Module[{p, a1actual, a1pred, k, error},
      k = kval;
      p = k^2 + c;
      If[p > 2 && PrimeQ[p],
        a1actual = GetFirstCFTerm[p];
        a1pred = Floor[2*k / Abs[c]];
        error = If[a1actual =!= Null, Abs[a1actual - a1pred], Null];
        {k, p, c, a1actual, a1pred, error},
        Nothing
      ]
    ],
    {kval, 2, 50}
  ], Nothing];

  If[Length[cases] > 0,
    Print[StringRepeat["=", 80]];
    Print["CASE: c = ", c, " (p = k² ", If[c > 0, "+", ""], c, ")"];
    Print[StringRepeat["=", 80]];
    Print[];

    Print["Found ", Length[cases], " primes"];
    Print[];

    Print["k    p      a₁(actual)  a₁(pred)  error"];
    Print[StringRepeat["-", 60]];

    Do[
      {k, p, cval, a1act, a1pred, err} = cases[[i]];
      Print[
        StringPadRight[ToString[k], 5],
        StringPadRight[ToString[p], 7],
        StringPadRight[ToString[a1act], 12],
        StringPadRight[ToString[a1pred], 10],
        If[err =!= Null, err, "N/A"]
      ];
      ,
      {i, Min[15, Length[cases]]}
    ];

    Print[];

    (* Statistics *)
    errors = DeleteCases[cases[[All, 6]], Null];
    If[Length[errors] > 0,
      perfectMatch = Count[errors, 0];
      off1 = Count[errors, 1];
      off2 = Count[errors, 2];

      Print["Prediction accuracy:"];
      Print["  Perfect match (error=0): ", perfectMatch, "/", Length[errors],
            " (", N[100.0 * perfectMatch / Length[errors], 3], "%)"];
      Print["  Off by 1: ", off1, "/", Length[errors],
            " (", N[100.0 * off1 / Length[errors], 3], "%)"];
      Print["  Off by 2+: ", off2, "/", Length[errors],
            " (", N[100.0 * off2 / Length[errors], 3], "%)"];

      If[Length[errors] > 1,
        Print["  Mean error: ", N[Mean[errors], 3]];
        Print["  Max error: ", Max[errors]];
      ];

      Print[];

      If[perfectMatch == Length[errors],
        Print["★★★ PERFECT: a₁ = floor(2k/|c|) is EXACT for c = ", c];
      ,
        If[perfectMatch + off1 == Length[errors],
          Print["★ EXCELLENT: Prediction within ±1 for all cases"];
        ,
          If[N[perfectMatch / Length[errors]] > 0.8,
            Print["✓ GOOD: Prediction accurate for >80% of cases"];
          ,
            Print["⚠ WEAK: Prediction has significant errors"];
          ];
        ];
      ];
    ];

    Print[];
  ];
];

Print[StringRepeat["=", 80]];
Print["TAYLOR APPROXIMATION QUALITY"];
Print[StringRepeat["=", 80]];
Print[];

Print["Testing Taylor remainder for small c..."];
Print[];

(* For first few k values, show actual vs Taylor approximation *)
testCases = {{2, 3}, {3, 2}, {4, 3}, {5, 2}};

Print["k    c    √(k²+c) (exact)           Taylor: k+c/(2k)          Error"];
Print[StringRepeat["-", 80]];

Do[
  {k, c} = testCases[[i]];
  D = k^2 + c;
  exact = N[Sqrt[D], 20];
  taylor1 = N[k + c/(2.0*k), 20];
  taylor2 = N[k + c/(2.0*k) - c^2/(8.0*k^3), 20];
  err1 = Abs[exact - taylor1];
  err2 = Abs[exact - taylor2];

  Print[k, "    ", c, "    ",
        NumberForm[exact, {10, 8}], "    ",
        NumberForm[taylor1, {10, 8}], "    ",
        NumberForm[err1, {8, 6}]];
  ,
  {i, Length[testCases]}
];

Print[];
Print["Conclusion: Taylor approximation √(k²+c) ≈ k + c/(2k) gives"];
Print["           α₁ ≈ c/(2k), thus a₁ = floor(2k/c)"];
Print[];

Print[StringRepeat["=", 80]];
Print["HYPOTHESIS ASSESSMENT"];
Print[StringRepeat["=", 80]];
Print[];

Print["H: First CF term can be predicted from geometric position"];
Print["   without any CF iteration"];
Print[];
Print["Method: a₁ ≈ floor(2k/c) for p = k² + c"];
Print[];
Print["Result: [see accuracy statistics above]"];
Print[];

Print["Implications:"];
Print["  1. Geometric position (k,c) → algebraic prediction"];
Print["  2. NO iteration needed for first step"];
Print["  3. 'Vzdušná čára' partially realized!");
Print["  4. Accuracy degrades for large |c| (as expected from Taylor)"];
Print[];

Print["TEST COMPLETE"];
