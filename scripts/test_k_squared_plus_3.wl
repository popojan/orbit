#!/usr/bin/env wolframscript
(* TEST: p = k² + 3 period pattern *)

Print[StringRepeat["=", 80]];
Print["VZDUŠNÁ ČÁRA TEST: p = k² + 3"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

(* Find all primes p = k² + 3 *)
cases = Table[
  Module[{p, period, cf, convs, x0, y0},
    p = k^2 + 3;

    If[PrimeQ[p],
      period = CFPeriod[p];

      (* Get fundamental solution *)
      cf = ContinuedFraction[Sqrt[p], period + 5];
      convs = Convergents[cf];

      If[period > 0 && period <= Length[convs],
        x0 = Numerator[convs[[period]]];
        y0 = Denominator[convs[[period]]];

        {k, p, period, x0, y0, cf[[2]]},
        Nothing
      ],
      Nothing
    ]
  ],
  {k, 1, 30}
];

cases = DeleteCases[cases, Nothing];

Print["Found ", Length[cases], " primes p = k² + 3"];
Print[];

Print[StringRepeat["=", 80]];
Print["PERIOD ANALYSIS"];
Print[StringRepeat["=", 80]];
Print[];

Print["k    p      period  x₀        y₀"];
Print[StringRepeat["-", 60]];

Do[
  {k, p, per, x0, y0, cfTerms} = cases[[i]];
  Print[
    StringPadRight[ToString[k], 5],
    StringPadRight[ToString[p], 7],
    StringPadRight[ToString[per], 8],
    StringPadRight[ToString[x0], 10],
    y0
  ];
  ,
  {i, Length[cases]}
];

Print[];

(* Check period pattern *)
periods = cases[[All, 3]];
uniquePeriods = Union[periods];

Print["Unique periods: ", uniquePeriods];
Print["Period distribution:"];
periodTally = Tally[periods];
Do[
  {per, count} = periodTally[[i]];
  pct = N[100.0 * count / Length[cases], 3];
  Print["  period = ", per, ": ", count, "/", Length[cases], " (", pct, "%)"];
  ,
  {i, Length[periodTally]}
];

Print[];

(* Check if period is constant *)
If[Length[uniquePeriods] == 1,
  Print["★★★ PATTERN FOUND: All p = k² + 3 have period = ", uniquePeriods[[1]], "!"];
  Print["    This is UNIVERSAL like p = k² + 2!"];
  ,
  Print["Period varies: ", uniquePeriods];
  Print["No simple universal pattern.");
];

Print[];
Print[StringRepeat["=", 80]];
Print["CF STRUCTURE ANALYSIS"];
Print[StringRepeat["=", 80]];
Print[];

Print["First 10 cases - CF periodic part:");
Print[];

Do[
  {k, p, per, x0, y0, cfTerms} = cases[[i]];
  Print["k=", k, ", p=", p, " (period ", per, "):"];
  Print["  CF terms: ", cfTerms];
  Print[];
  ,
  {i, Min[10, Length[cases]]}
];

Print[StringRepeat["=", 80]];
Print["COMPARISON: p = k² + 2 vs p = k² + 3"];
Print[StringRepeat["=", 80]];
Print[];

(* Test k² + 2 for comparison *)
cases2 = DeleteCases[Table[
  Module[{p, period},
    p = k^2 + 2;
    If[PrimeQ[p],
      period = CFPeriod[p];
      {k, p, period},
      Nothing
    ]
  ],
  {k, 1, 30}
], Nothing];

Print["p = k² + 2:"];
Print["  Cases: ", Length[cases2]];
Print["  Periods: ", Union[cases2[[All, 3]]]];

Print[];
Print["p = k² + 3:"];
Print["  Cases: ", Length[cases]];
Print["  Periods: ", uniquePeriods];

Print[];
If[Length[uniquePeriods] == 1 && Length[Union[cases2[[All, 3]]]] == 1,
  Print["★ BOTH have constant period! Vzdušná čára exists for c=2,3"];
];

Print[];
Print[StringRepeat["=", 80]];
Print["LOOKING FOR FORMULA"];
Print[StringRepeat["=", 80]];
Print[];

If[Length[uniquePeriods] == 1,
  constantPeriod = uniquePeriods[[1]];
  Print["Period is constant: ", constantPeriod];
  Print[];

  Print["Testing relationships between k and (x₀, y₀)...");
  Print[];

  (* Check simple ratios *)
  ratiosX = Table[N[cases[[i,4]] / cases[[i,1]]^2, 5], {i, Min[10, Length[cases]]}];
  ratiosY = Table[N[cases[[i,5]] / cases[[i,1]], 5], {i, Min[10, Length[cases]]}];

  Print["x₀/k² samples: ", ratiosX];
  Print["y₀/k samples:  ", ratiosY];
  Print[];

  (* Check if ratios grow polynomially *)
  Print["Testing polynomial growth.."];
  Do[
    {k, p, per, x0, y0, _} = cases[[i]];

    (* Try simple formulas *)
    tests = {
      {"k²", k^2},
      {"2k²", 2*k^2},
      {"3k²", 3*k^2},
      {"k²+k", k^2 + k},
      {"2k²+k", 2*k^2 + k}
    };

    matchesX = Select[tests, Abs[#[[2]] - x0] < 5 &];
    If[Length[matchesX] > 0,
      Print["  k=", k, ", x₀=", x0, " ≈ ", matchesX[[1,1]]];
    ];
    ,
    {i, Min[5, Length[cases]]}
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print["CONCLUSION"];
Print[StringRepeat["=", 80]];
Print[];

If[Length[uniquePeriods] == 1,
  Print["✓ Pattern confirmed: p = k² + 3 has constant period"];
  Print["✓ 'Vzdušná čára' exists: Can predict period without CF iteration"];
  Print["Next: Find explicit formula for (x₀, y₀)"];
  ,
  Print["✗ No constant period pattern for p = k² + 3"];
  Print["Need to test other values of c"];
];

Print[];
Print["TEST COMPLETE"];
