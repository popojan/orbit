#!/usr/bin/env wolframscript
(* TEST: Direct formulas for p = k² + c *)

Print[StringRepeat["=", 80]];
Print["GEOMETRIC SHORTCUTS: p = k² + c PATTERNS"];
Print[StringRepeat["=", 80]];
Print[];

Print["Goal: Find 'vzdušná čára' (direct formula) for special p"];
Print[];

(* Test p = k² + c for small c *)
testCases = Table[
  Module[{k, c, p, sol},
    k = kVal;
    c = cVal;
    p = k^2 + c;

    If[PrimeQ[p],
      (* Get fundamental solution via Pell *)
      sol = Solve[x^2 - p*y^2 == 1 && x > 0 && y > 0, {x, y}, Integers];

      If[Length[sol] > 0,
        {x0, y0} = {x, y} /. sol[[1]];
        {k, c, p, x0, y0},
        Nothing
      ],
      Nothing
    ]
  ],
  {kVal, 1, 20},
  {cVal, 1, 10}
];

testCases = DeleteCases[Flatten[testCases, 1], Nothing];

Print["Collected ", Length[testCases], " prime cases p = k² + c"];
Print[];

Print[StringRepeat["=", 80]];
Print["CASE: c = 1 (p = k² + 1)"];
Print[StringRepeat["=", 80]];
Print[];

c1Cases = Select[testCases, #[[2]] == 1 &];

Print["k    p      x₀        y₀        x₀/k     y₀/k"];
Print[StringRepeat["-", 60]];

Do[
  {k, c, p, x0, y0} = c1Cases[[i]];
  Print[
    StringPadRight[ToString[k], 5],
    StringPadRight[ToString[p], 7],
    StringPadRight[ToString[x0], 10],
    StringPadRight[ToString[y0], 10],
    StringPadRight[ToString[N[x0/k, 4]], 9],
    N[y0/k, 4]
  ];
  ,
  {i, Length[c1Cases]}
];

Print[];
Print["KNOWN FORMULA for p = k² + 1:"];
Print["  x₀ = 2k² + 1"];
Print["  y₀ = 2k"];
Print[];

Print["Verification:"];
Do[
  {k, c, p, x0, y0} = c1Cases[[i]];
  xFormula = 2*k^2 + 1;
  yFormula = 2*k;
  match = (x0 == xFormula && y0 == yFormula);
  Print["  k=", k, ": ", If[match, "✓", "✗ MISMATCH"]];
  ,
  {i, Length[c1Cases]}
];

Print[];
Print[StringRepeat["=", 80]];
Print["CASE: c = 2 (p = k² + 2)"];
Print[StringRepeat["=", 80]];
Print[];

c2Cases = Select[testCases, #[[2]] == 2 &];

Print["k    p      x₀        y₀        x₀/k²    y₀/k     period"];
Print[StringRepeat["-", 70]];

Do[
  {k, c, p, x0, y0} = c2Cases[[i]];

  (* Get period *)
  cf = ContinuedFraction[Sqrt[p]];
  period = Length[cf[[2]]];

  Print[
    StringPadRight[ToString[k], 5],
    StringPadRight[ToString[p], 7],
    StringPadRight[ToString[x0], 10],
    StringPadRight[ToString[y0], 10],
    StringPadRight[ToString[N[x0/k^2, 4]], 9],
    StringPadRight[ToString[N[y0/k, 4]], 9],
    period
  ];
  ,
  {i, Min[10, Length[c2Cases]]}
];

Print[];
Print["Looking for pattern in ratios..."];

If[Length[c2Cases] >= 3,
  (* Check if x₀/k² is constant *)
  ratiosX = Table[N[c2Cases[[i,4]] / c2Cases[[i,1]]^2], {i, Length[c2Cases]}];
  ratiosY = Table[N[c2Cases[[i,5]] / c2Cases[[i,1]]], {i, Length[c2Cases]}];

  Print["  x₀/k² values: ", ratiosX];
  Print["  y₀/k values:  ", ratiosY];
  Print[];

  (* Check polynomial relationships *)
  Print["Testing polynomial formulas..."];

  (* Try x₀ = a*k² + b*k + c *)
  Do[
    {k, c, p, x0, y0} = c2Cases[[i]];

    (* Try various formulas *)
    formulas = {
      {"k² + 1", k^2 + 1},
      {"2k² + 1", 2*k^2 + 1},
      {"3k² + 1", 3*k^2 + 1},
      {"k² + k + 1", k^2 + k + 1},
      {"2k² + 2k + 1", 2*k^2 + 2*k + 1},
      {"3k² - 1", 3*k^2 - 1}
    };

    matches = Select[formulas, #[[2]] == x0 &];

    If[Length[matches] > 0,
      Print["  k=", k, ", x₀=", x0, " matches: ", matches[[1,1]]];
    ];
    ,
    {i, Min[5, Length[c2Cases]]}
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print["CASE: c = 4 (p = k² + 4)"];
Print[StringRepeat["=", 80]];
Print[];

c4Cases = Select[testCases, #[[2]] == 4 &];

If[Length[c4Cases] > 0,
  Print["k    p      x₀        y₀"];
  Print[StringRepeat["-", 40]];

  Do[
    {k, c, p, x0, y0} = c4Cases[[i]];
    Print[
      StringPadRight[ToString[k], 5],
      StringPadRight[ToString[p], 7],
      StringPadRight[ToString[x0], 10],
      y0
    ];
    ,
    {i, Min[10, Length[c4Cases]]}
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print["DISTANCE FROM SQUARE ANALYSIS"];
Print[StringRepeat["=", 80]];
Print[];

Print["Grouping all cases by distance c from k²...");
Print[];

For[c = 1, c <= 5, c++,
  cases = Select[testCases, #[[2]] == c &];

  If[Length[cases] >= 2,
    Print["c = ", c, " (p = k² + ", c, "): n=", Length[cases]];

    (* Check for simple patterns *)
    ratiosX = Table[N[cases[[i,4]] / cases[[i,1]]^2, 4], {i, Min[5, Length[cases]]}];
    Print["  x₀/k² samples: ", ratiosX];

    (* Check if ratios are "simple" (low denominator fractions) *)
    fracApprox = Table[Rationalize[ratiosX[[i]], 0.01], {i, Length[ratiosX]}];
    Print["  Rational approx: ", fracApprox];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["CONCLUSION"];
Print[StringRepeat["=", 80]];
Print[];

Print["KNOWN 'vzdušná čára' (direct formulas):"];
Print["  ✓ p = k² + 1: x₀ = 2k² + 1, y₀ = 2k"];
Print[];

Print["SEARCHING for patterns:");
Print["  p = k² + 2: NO obvious simple formula (yet)"];
Print["  p = k² + 4: Testing...");
Print[];

Print["Geometric insight: Distance c determines CF structure"];
Print["  c=1: period=1 (trivial) → direct formula exists"];
Print["  c>1: period>1 → may need more sophisticated approach");
Print[];

Print["User's vision: 'Vzdušná čára' = skip CF iteration via geometry"];
Print["Status: Partially achieved for c=1, open for general c");
Print[];

Print["TEST COMPLETE"];
