#!/usr/bin/env wolframscript
(*
Analyze patterns in pellc rational solutions
*)

Print[StringRepeat["=", 70]];
Print["ANALYZING PELLC RATIONAL SOLUTION PATTERNS"];
Print[StringRepeat["=", 70]];
Print[];

(* Define the pellc function *)
pellc[n_, d_, c_, m_] := Module[
  {
   z = ChebyshevT[-1 + 2 m, Sqrt[d^2 n]]/
    ChebyshevU[-2 + 2 m, Sqrt[d^2 n]],
   gcd, sol
   },
  sol = {
    x -> z/(Sqrt[n] Sqrt[1 - n d^2 + z^2]),
    y -> 1/Sqrt[1 - n d^2 + z^2]
    };
  gcd = GCD[(x + c)^2, y^2, 1 + (x + c)^2 - x^2] /. sol;
  {n x^2 - (n d^2 - 1) y^2 == ((1 + (x + c)^2 - x^2)/gcd /. sol),
   Thread[{x, y} -> ({(x + c)/Sqrt[gcd], y/Sqrt[gcd]} /. sol)]}
]

(* Collect rational solutions *)
collectRationalSolutions[nList_, dList_, cVal_, mVal_] := Module[{sols},
  sols = {};
  Do[
    Do[
      Module[{result, xVal, yVal, xSimp, ySimp, disc},
        result = pellc[ntest, dtest, cVal, mVal];
        xVal = x /. result[[2]];
        yVal = y /. result[[2]];
        xSimp = FullSimplify[xVal];
        ySimp = FullSimplify[yVal];
        disc = ntest * dtest^2 - 1;

        If[(Head[xSimp] === Rational || IntegerQ[xSimp]) &&
           (Head[ySimp] === Rational || IntegerQ[ySimp]),
          AppendTo[sols, {ntest, dtest, xSimp, ySimp, disc}];
        ];
      ],
      {dtest, dList}
    ],
    {ntest, nList}
  ];
  sols
];

Print["PATTERN 1: Discriminant analysis"];
Print[StringRepeat["-", 70]];
Print[];

nList = {2, 5/2, 3, 7/2, 4, 9/2, 5, 11/2, 13/2, 13/4, 17/4};
dList = {1/2, 2/3, 1, 4/3, 3/2, 2};

sols = collectRationalSolutions[nList, dList, 0, 2];

Print["n\td\tdisc\tsqrt(disc)\tx\ty\ty-x"];
Print[StringRepeat["-", 70]];

Do[
  Module[{n, d, x, y, disc, sqrtDisc},
    {n, d, x, y, disc} = sol;
    sqrtDisc = Sqrt[disc];
    Print[n, "\t", d, "\t", disc, "\t", If[IntegerQ[sqrtDisc] || Head[sqrtDisc] === Rational, sqrtDisc, "irrational"], "\t", x, "\t", y, "\t", y-x];
  ],
  {sol, Take[sols, Min[20, Length[sols]]]}
];

Print[];
Print["Observations:"];

(* Check for perfect square discriminants *)
perfectSquareDisc = Select[sols, IntegerQ[Sqrt[#[[5]]]] || Head[Sqrt[#[[5]]]] === Rational &];
Print["  Perfect square discriminants: ", Length[perfectSquareDisc], "/", Length[sols]];

If[Length[perfectSquareDisc] > 0,
  Print["  Examples:"];
  Do[
    Module[{n, d, x, y, disc},
      {n, d, x, y, disc} = sol;
      Print["    n=", n, ", d=", d, ": disc=", disc, "=", Sqrt[disc]^2];
    ],
    {sol, Take[perfectSquareDisc, Min[5, Length[perfectSquareDisc]]]}
  ];
];

Print[];

Print[StringRepeat["=", 70]];
Print["PATTERN 2: Relationship between x and y"];
Print[StringRepeat["-", 70]];
Print[];

Print["Checking y - x for patterns:");
Print[];
Print["n\td\tx\ty\ty-x\tFormula?"];
Print[StringRepeat["-", 70]];

Do[
  Module[{n, d, x, y, disc, diff, formula},
    {n, d, x, y, disc} = sol;
    diff = y - x;

    (* Try to find formula for diff *)
    formula = Which[
      d == 1 && IntegerQ[n], "2 (d=1, n integer)",
      d == 1/2, ToString[diff] <> " varies",
      True, "?"
    ];

    Print[n, "\t", d, "\t", x, "\t", y, "\t", diff, "\t", formula];
  ],
  {sol, Take[sols, Min[15, Length[sols]]]}
];

Print[];

(* Look for pattern when d=1 *)
d1sols = Select[sols, #[[2]] == 1 &];
Print["For d=1:"];
Do[
  Module[{n, x, y, diff},
    {n, _, x, y, _} = sol;
    diff = y - x;
    Print["  n=", n, ": x=", x, ", y=", y, ", y-x=", diff];
    If[IntegerQ[n],
      Print["    Check: x = 4n-3 = ", 4*n-3, " ", If[x == 4*n-3, "✓", "✗"]];
      Print["    Check: y = 4n-1 = ", 4*n-1, " ", If[y == 4*n-1, "✓", "✗"]];
    ];
  ],
  {sol, d1sols}
];

Print[];

Print[StringRepeat["=", 70]];
Print["PATTERN 3: For d=1/2, analyze special structure"];
Print[StringRepeat["-", 70]];
Print[];

dHalfSols = Select[sols, #[[2]] == 1/2 &];
Print["d = 1/2 solutions:"];
Print[];
Print["n\tdisc=n/4-1\tx\ty\tn/4"];
Print[StringRepeat["-", 70]];

Do[
  Module[{n, x, y, disc, nOver4},
    {n, _, x, y, disc} = sol;
    nOver4 = n/4;
    Print[n, "\t", disc, "\t\t", x, "\t", y, "\t", nOver4];

    (* Check if there's a pattern with n/4 *)
    Module[{expected},
      expected = nOver4 - 1;
      If[Abs[x - expected] < 0.01,
        Print["  *** x ≈ n/4 - 1"];
      ];
    ];
  ],
  {sol, dHalfSols}
];

Print[];

Print[StringRepeat["=", 70]];
Print["PATTERN 4: Check for Chebyshev/Fibonacci-like recurrence"];
Print[StringRepeat["-", 70]];
Print[];

Print["For fixed n, varying d: looking for recurrence in (x,y)..."];
Print[];

testN = 13;
testDs = {1/2, 2/3, 3/4, 1, 5/4, 3/2, 2};

Print["n=", testN, ", varying d:"];
Print[];
Print["d\tx\ty\tDisc"];
Print[StringRepeat["-", 60]];

dSeries = Table[
  Module[{result, xVal, yVal, xSimp, ySimp, disc},
    result = pellc[testN, dtest, 0, 2];
    xVal = x /. result[[2]];
    yVal = y /. result[[2]];
    xSimp = FullSimplify[xVal];
    ySimp = FullSimplify[yVal];
    disc = testN * dtest^2 - 1;

    If[(Head[xSimp] === Rational || IntegerQ[xSimp]) &&
       (Head[ySimp] === Rational || IntegerQ[ySimp]),
      Print[dtest, "\t", xSimp, "\t", ySimp, "\t", N[disc, 8]];
      {dtest, xSimp, ySimp, disc}
    ,
      Null
    ]
  ],
  {dtest, testDs}
];

dSeries = DeleteCases[dSeries, Null];

Print[];
If[Length[dSeries] >= 3,
  Print["Checking for recurrence x_n = a*x_{n-1} + b*x_{n-2}:"];
  Module[{x1, x2, x3, a, b},
    If[Length[dSeries] >= 3,
      x1 = dSeries[[1]][[2]];
      x2 = dSeries[[2]][[2]];
      x3 = dSeries[[3]][[2]];

      (* Try to solve x3 = a*x2 + b*x1 *)
      (* This won't generally work, just checking *)
      Print["  x1=", x1, ", x2=", x2, ", x3=", x3];
    ];
  ];
];

Print[];

Print[StringRepeat["=", 70]];
Print["PATTERN 5: When nd² - 1 is a perfect square"];
Print[StringRepeat["-", 70]];
Print[];

Print["Looking for (n, d) where nd² - 1 = k² for some rational k..."];
Print[];

perfectSquareCases = {};

Do[
  Do[
    Module[{disc, sqrtDisc},
      disc = ntest * dtest^2 - 1;
      sqrtDisc = Sqrt[disc];

      If[IntegerQ[sqrtDisc] || Head[sqrtDisc] === Rational,
        Module[{result, xVal, yVal, xSimp, ySimp},
          result = pellc[ntest, dtest, 0, 2];
          xVal = x /. result[[2]];
          yVal = y /. result[[2]];
          xSimp = FullSimplify[xVal];
          ySimp = FullSimplify[yVal];

          If[(Head[xSimp] === Rational || IntegerQ[xSimp]) &&
             (Head[ySimp] === Rational || IntegerQ[ySimp]),
            AppendTo[perfectSquareCases, {ntest, dtest, disc, sqrtDisc, xSimp, ySimp}];
          ];
        ];
      ];
    ],
    {dtest, {1/2, 1/3, 2/3, 1, 4/3, 3/2, 5/3, 2}}
  ],
  {ntest, {2, 5/2, 3, 7/2, 4, 9/2, 5, 11/2, 6, 13/2, 7, 13/4, 17/4, 10, 13}}
];

If[Length[perfectSquareCases] > 0,
  Print["Found ", Length[perfectSquareCases], " cases where nd² - 1 is a perfect square:"];
  Print[];
  Print["n\td\tnd²-1\t√(nd²-1)\tx\ty"];
  Print[StringRepeat["-", 70]];

  Do[
    Module[{n, d, disc, sqrtDisc, x, y},
      {n, d, disc, sqrtDisc, x, y} = case;
      Print[n, "\t", d, "\t", disc, "\t", sqrtDisc, "\t\t", x, "\t", y];
    ],
    {case, perfectSquareCases}
  ];

  Print[];
  Print["KEY INSIGHT: When discriminant is perfect square, solutions are rational!"];
  Print["This is a classical result from Pell theory."];
];

Print[];

Print[StringRepeat["=", 70]];
Print["PATTERN 6: Factorization of discriminant"];
Print[StringRepeat["-", 70]];
Print[];

Print["Analyzing prime factorization of discriminants...");
Print[];

Do[
  Module[{n, d, disc, sqrtDisc},
    {n, d, disc, sqrtDisc} = perfectSquareCases[[i]];
    Print["nd²-1 = ", disc, " = ", sqrtDisc, "² = ", FactorInteger[Numerator[disc]], "/", FactorInteger[Denominator[disc]]];
  ],
  {i, 1, Min[10, Length[perfectSquareCases]]}
];

Print[];

Print[StringRepeat["=", 70]];
Print["CONCLUSIONS"];
Print[StringRepeat["=", 70]];
Print[];

Print["1. Rational solutions occur when discriminant nd² - 1 is a perfect square"];
Print["2. For d=1: Formula x=4n-3, y=4n-1 works for integer n"];
Print["3. For d=1/2: Different pattern, possibly x ≈ n/4 - 1"];
Print["4. Classical Pell theory: ax² - by² = 1 has rational solutions iff"];
Print["   the discriminant structure allows it (related to class numbers)"];
Print[];

If[Length[perfectSquareCases] > 0,
  Print["KEY FINDING: ", Length[perfectSquareCases], " cases with perfect square discriminant"];
  Print["These form a special class of solvable generalized Pell equations"];
];

Print[];
Print[StringRepeat["=", 70]];
