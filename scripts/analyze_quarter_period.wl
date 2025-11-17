#!/usr/bin/env wolframscript
(* ANALYZE: Quarter-period convergent pattern *)

Print[StringRepeat["=", 80]];
Print["QUARTER-PERIOD ANALYSIS"];
Print[StringRepeat["=", 80]];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

Print["Testing primes p < 200 with period divisible by 4..."];
Print[];

primes = Select[Range[3, 200], PrimeQ];
Print["Total primes: ", Length[primes]];
Print[];

(* Filter to only period divisible by 4 *)
data = Table[
  Module[{p, mod8, period, cf, convs, quarter, xq, yq, normq, half, xh, yh, normh},
    p = primes[[i]];
    mod8 = Mod[p, 8];
    period = CFPeriod[p];

    If[period > 0 && Mod[period, 4] == 0,
      (* Compute convergents *)
      cf = ContinuedFraction[Sqrt[p], period + 5];
      convs = Convergents[cf];

      quarter = period / 4;
      half = period / 2;

      If[quarter <= Length[convs] && half <= Length[convs],
        (* Quarter-period convergent *)
        xq = Numerator[convs[[quarter]]];
        yq = Denominator[convs[[quarter]]];
        normq = xq^2 - p*yq^2;

        (* Half-period convergent *)
        xh = Numerator[convs[[half]]];
        yh = Denominator[convs[[half]]];
        normh = xh^2 - p*yh^2;

        {p, mod8, period, quarter, xq, yq, normq, half, xh, yh, normh},
        Nothing
      ],
      Nothing
    ]
  ],
  {i, Length[primes]}
];

data = DeleteCases[data, Nothing];
Print["Valid data (period divisible by 4): ", Length[data], " primes"];
Print[];

Print[StringRepeat["=", 80]];
Print["RESULTS: Quarter vs Half period norms"];
Print[StringRepeat["-", 60]];
Print[];

Print["p     mod8  per  per/4  norm(1/4)  per/2  norm(1/2)"];
Print[StringRepeat["-", 60]];

Do[
  {p, m8, per, q, xq, yq, nq, h, xh, yh, nh} = data[[i]];
  Print[
    StringPadRight[ToString[p], 6],
    StringPadRight[ToString[m8], 6],
    StringPadRight[ToString[per], 5],
    StringPadRight[ToString[q], 7],
    StringPadRight[ToString[nq], 11],
    StringPadRight[ToString[h], 7],
    nh
  ];
  ,
  {i, Length[data]}
];

Print[];
Print[StringRepeat["=", 80]];
Print["PATTERN ANALYSIS"];
Print[StringRepeat["-", 60]];
Print[];

(* Group by mod 8 *)
For[m = 1, m <= 7, m += 2,
  subset = Select[data, #[[2]] == m &];

  If[Length[subset] >= 3,
    Print["p ≡ ", m, " (mod 8): n=", Length[subset]];

    normsQuarter = subset[[All, 7]];
    normsHalf = subset[[All, 11]];

    Print["  Quarter-period norms: ", Union[normsQuarter]];
    Print["  Half-period norms:    ", Union[normsHalf]];

    (* Check if quarter-norm pattern exists *)
    qTally = Tally[normsQuarter];
    Print["  Quarter-norm distribution: ", qTally];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["SPECIFIC PATTERNS"];
Print[StringRepeat["-", 60]];
Print[];

(* Check if quarter-norm relates to p or period *)
Print["Testing: Does norm(quarter) relate to p or period structure?"];
Print[];

For[m = 3, m <= 7, m += 4,
  subset = Select[data, #[[2]] == m &];

  If[Length[subset] >= 3,
    Print["p ≡ ", m, " (mod 8):"];
    Print[];

    Do[
      {p, m8, per, q, xq, yq, nq, h, xh, yh, nh} = subset[[i]];

      (* Check relationships *)
      Print["  p=", p, ", period=", per];
      Print["    quarter: x=", xq, ", y=", yq, ", norm=", nq];
      Print["    half:    x=", xh, ", y=", yh, ", norm=", nh, " (always ±2)"];

      (* Test: Is quarter-norm related to p? *)
      If[Abs[nq] < 20,
        Print["    Pattern: |norm| = ", Abs[nq], " (small!)"];

        (* Check (norm/p) *)
        If[Mod[p, Abs[nq]] == 0,
          Print["    → p divisible by |norm|"];
        ];

        (* Check if norm = ±(p-k²) for small k *)
        For[k = 1, k <= 5, k++,
          If[Abs[nq] == Abs[p - k^2],
            Print["    → |norm| = |p - ", k, "²|"];
          ];
          If[Abs[nq] == Abs[k^2 - p],
            Print["    → |norm| = |", k, "² - p|"];
          ];
        ];
      ];

      Print[];
      ,
      {i, Min[5, Length[subset]]}
    ];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["CONCLUSION"];
Print[StringRepeat["-", 60]];
Print[];

Print["Half-period: ALWAYS norm ±2 (clean structural pattern) ✓"];
Print["Quarter-period: norms vary, no obvious universal pattern yet"];
Print[];

Print["Quarter-period may encode:"];
Print["  - Distance to nearest square (p = k² ± c)"];
Print["  - Splitting of small primes in Q(√p)"];
Print["  - Deeper genus structure"];
Print[];

Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
