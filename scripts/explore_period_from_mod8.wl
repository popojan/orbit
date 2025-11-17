#!/usr/bin/env wolframscript
(* EXPLORE: CF period from mod 8 theorem for PRIMES *)

Print[StringRepeat["=", 80]];
Print["CF PERIOD EXPLORATION: Using mod 8 theorem for primes"];
Print[StringRepeat["=", 80]];
Print[];

Print["HYPOTHESIS: Can we derive period(p) from p mod 8 using the theorem:"];
Print["  p ≡ 7 (mod 8) ⟺ x ≡ +1 (mod p)"];
Print["  p ≡ 1,3 (mod 8) ⟺ x ≡ -1 (mod p)"];
Print[];

(* Pell solver via CF convergents *)
PellSol[D_Integer] := Module[{cf, convs, i},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];

  cf = ContinuedFraction[Sqrt[D], 500];  (* Larger limit for big primes *)
  convs = Convergents[cf];

  For[i = 1, i <= Length[convs], i++,
    Module[{x, y},
      x = Numerator[convs[[i]]];
      y = Denominator[convs[[i]]];
      If[x^2 - D*y^2 == 1, Return[{x, y}]];
    ]
  ];

  {0, 0}
]

(* CF period length *)
CFPeriod[D_Integer] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]  (* Period is the repeating part *)
]

Print["Computing CF period, R, and mod 8 data for primes p < 1000..."];
Print[];

primes = Select[Range[3, 1000], PrimeQ];
Print["Analyzing ", Length[primes], " primes"];
Print[];

(* Collect data *)
data = Table[
  Module[{p, period, sol, x, y, R, xModP, mod8, expectedSign, match},
    p = primes[[i]];
    period = CFPeriod[p];
    sol = PellSol[p];
    {x, y} = sol;

    If[x > 1,
      R = N[Log[x + y*Sqrt[p]], 15];
      xModP = Mod[x, p];
      mod8 = Mod[p, 8];

      expectedSign = If[mod8 == 7, 1, p - 1];
      match = (xModP == expectedSign);

      {p, period, R, xModP, mod8, match, x, y},

      Nothing
    ]
  ],
  {i, Length[primes]}
];

data = DeleteCases[data, Nothing];

Print["Successfully computed ", Length[data], " primes"];
Print[];

(* Verify mod 8 theorem holds *)
violations = Select[data, !#[[6]] &];
If[Length[violations] == 0,
  Print["✓ Mod 8 theorem: ", Length[data], "/", Length[data], " confirmed"],
  Print["❌ VIOLATIONS FOUND: ", Length[violations]];
  Print[violations[[All, {1, 4, 5}]]];
];
Print[];

Print[StringRepeat["=", 80]];
Print["ANALYSIS 1: Period distribution by mod 8"];
Print[StringRepeat["-", 60]];
Print[];

(* Group by mod 8 *)
For[m = 1, m <= 7, m += 2,
  subset = Select[data, #[[5]] == m &];
  If[Length[subset] > 0,
    periods = subset[[All, 2]];
    Print["p ≡ ", m, " (mod 8): n=", Length[subset]];
    Print["  Period range: ", Min[periods], " - ", Max[periods]];
    Print["  Mean period:  ", N[Mean[periods], 4]];
    Print["  Median:       ", Median[periods]];
    Print["  Std dev:      ", N[StandardDeviation[periods], 4]];
    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["ANALYSIS 2: Period vs R correlation"];
Print[StringRepeat["-", 60]];
Print[];

periods = data[[All, 2]];
Rs = data[[All, 3]];

corrAll = Correlation[N[periods], N[Rs]];
Print["Overall correlation period ↔ R: ", N[corrAll, 4]];
Print["  (Expected from STATUS.md: r = 0.82)"];
Print[];

(* By mod class *)
For[m = 1, m <= 7, m += 2,
  subset = Select[data, #[[5]] == m &];
  If[Length[subset] >= 10,
    per = subset[[All, 2]];
    r = subset[[All, 3]];
    corr = Correlation[N[per], N[r]];
    Print["mod ", m, ": r = ", N[corr, 4], " (n=", Length[subset], ")"];
  ]
];
Print[];

Print[StringRepeat["=", 80]];
Print["ANALYSIS 3: Period vs p correlation"];
Print[StringRepeat["-", 60]];
Print[];

ps = data[[All, 1]];
corrPvsP = Correlation[N[periods], N[ps]];
Print["Correlation period ↔ p: ", N[corrPvsP, 4]];
Print[];

Print[StringRepeat["=", 80]];
Print["ANALYSIS 4: Looking for period formula"];
Print[StringRepeat["-", 60]];
Print[];

Print["Testing hypothesis: period ~ f(p mod 8, p, ...)"];
Print[];

(* Try simple models *)
(* Model 1: period = a + b*p *)
fit1 = LinearModelFit[
  Transpose[{N[ps], N[periods]}],
  {1, p},
  p
];
r2_1 = fit1["RSquared"];
Print["Model 1: period = a + b*p"];
Print["  R² = ", N[r2_1, 4]];
Print["  Formula: period ≈ ", N[fit1["BestFitParameters"][[1]], 3],
      " + ", N[fit1["BestFitParameters"][[2]], 6], "*p"];
Print[];

(* Model 2: period ~ sqrt(p) *)
sqrtPs = Sqrt[N[ps]];
fit2 = LinearModelFit[
  Transpose[{sqrtPs, N[periods]}],
  {1, s},
  s
];
r2_2 = fit2["RSquared"];
Print["Model 2: period = a + b*√p"];
Print["  R² = ", N[r2_2, 4]];
Print["  Formula: period ≈ ", N[fit2["BestFitParameters"][[1]], 3],
      " + ", N[fit2["BestFitParameters"][[2]], 4], "*√p"];
Print[];

(* Model 3: Stratified by mod 8 *)
Print["Model 3: Separate linear fits by mod 8"];
Print[];

For[m = 1, m <= 7, m += 2,
  subset = Select[data, #[[5]] == m &];
  If[Length[subset] >= 10,
    pSub = N[subset[[All, 1]]];
    perSub = N[subset[[All, 2]]];

    fit = LinearModelFit[Transpose[{pSub, perSub}], {1, p}, p];
    r2 = fit["RSquared"];

    Print["  mod ", m, ": period = ", N[fit["BestFitParameters"][[1]], 3],
          " + ", N[fit["BestFitParameters"][[2]], 6], "*p"];
    Print["         R² = ", N[r2, 4], " (n=", Length[subset], ")"];
  ]
];
Print[];

Print[StringRepeat["=", 80]];
Print["ANALYSIS 5: Period patterns by mod 8"];
Print[StringRepeat["-", 60]];
Print[];

(* Check if period mod k shows patterns *)
For[m = 1, m <= 7, m += 2,
  subset = Select[data, #[[5]] == m &];
  If[Length[subset] >= 20,
    periods = subset[[All, 2]];

    (* Test period mod 4, 8, etc *)
    mod4 = Tally[Mod[periods, 4]];
    mod8 = Tally[Mod[periods, 8]];

    Print["p ≡ ", m, " (mod 8):"];
    Print["  Period mod 4: ", mod4];
    Print["  Period mod 8: ", mod8];
    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["KEY INSIGHTS"];
Print[StringRepeat["-", 60]];
Print[];

Print["1. Period ↔ R correlation: r = ", N[corrAll, 4]];
Print["   STATUS: ", If[Abs[corrAll - 0.82] < 0.05, "✓ MATCHES", "⚠ DIFFERS"], " from expected 0.82"];
Print[];

Print["2. Best period model: ",
      If[r2_2 > r2_1, "period ~ √p", "period ~ p"],
      " (R² = ", N[Max[r2_1, r2_2], 4], ")"];
Print[];

Print["3. Mod 8 stratification improves fit: ",
      If[r2_2 > 0.9, "NO (already good)", "TESTING..."]];
Print[];

Print[StringRepeat["=", 80]];
Print["NEXT STEPS"];
Print[StringRepeat["-", 60]];
Print[];

Print["1. Theoretical derivation: Can mod 8 theorem + Pell structure → period formula?"];
Print["2. Test if period formula predicts R(p) better than dist"];
Print["3. Extend to composites (if prime formula works)"];
Print[];

Print[StringRepeat["=", 80]];
Print["COMPLETE"];
