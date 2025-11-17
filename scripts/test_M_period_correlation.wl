#!/usr/bin/env wolframscript
(* TEST: M(D) vs CF period correlation *)

Print[StringRepeat["=", 80]];
Print["PRIMAL FOREST × SB TREE: M(D) vs Period Correlation"];
Print[StringRepeat["=", 80]];
Print[];

(* M(n) definition *)
M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

(* Test on D ≤ 200 (primes and composites) *)
Print["Computing M(D) and period(√D) for D ≤ 200..."];
Print[];

data = Table[
  Module[{m, period},
    If[!IntegerQ[Sqrt[n]],
      m = M[n];
      period = CFPeriod[n];
      {n, m, period, If[PrimeQ[n], "prime", "composite"]},
      Nothing
    ]
  ],
  {n, 2, 200}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " non-square numbers"];
Print[];

(* Separate by type *)
primeData = Select[data, #[[4]] == "prime" &];
compositeData = Select[data, #[[4]] == "composite" &];

Print["Primes: ", Length[primeData]];
Print["Composites: ", Length[compositeData]];
Print[];

Print[StringRepeat["=", 80]];
Print["CORRELATION ANALYSIS"];
Print[StringRepeat["=", 80]];
Print[];

(* Overall correlation *)
mValues = data[[All, 2]];
periods = data[[All, 3]];

correlation = Correlation[mValues, periods];
Print["Overall M(D) vs period correlation: r = ", N[correlation, 4]];
Print[];

(* By type *)
If[Length[primeData] > 0,
  mPrime = primeData[[All, 2]];
  periodPrime = primeData[[All, 3]];
  Print["Primes only: all M=0, periods vary"];
  Print["  Period range: ", Min[periodPrime], " to ", Max[periodPrime]];
  Print["  Mean period: ", N[Mean[periodPrime], 4]];
  Print[];
];

If[Length[compositeData] > 2,
  mComp = compositeData[[All, 2]];
  periodComp = compositeData[[All, 3]];
  corrComp = Correlation[mComp, periodComp];
  Print["Composites only: r = ", N[corrComp, 4]];
  Print["  M range: ", Min[mComp], " to ", Max[mComp]];
  Print["  Period range: ", Min[periodComp], " to ", Max[periodComp]];
  Print[];
];

Print[StringRepeat["=", 80]];
Print["STRATIFIED ANALYSIS: M(D) groups"];
Print[StringRepeat["=", 80]];
Print[];

(* Group by M value *)
For[m = 0, m <= 5, m++,
  subset = Select[data, #[[2]] == m &];

  If[Length[subset] > 0,
    periods = subset[[All, 3]];
    Print["M(D) = ", m, ": n=", Length[subset]];
    Print["  Period: mean=", N[Mean[periods], 4],
          ", median=", Median[periods],
          ", range=[", Min[periods], ",", Max[periods], "]"];
    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["EXAMPLES: High M vs Low M"];
Print[StringRepeat["=", 80]];
Print[];

Print["High M(D) (many divisors, should have short periods):"];
highM = Select[compositeData, #[[2]] >= 3 &];
If[Length[highM] > 0,
  Do[
    {d, m, per, _} = highM[[i]];
    Print["  D=", d, ", M=", m, ", period=", per];
    ,
    {i, Min[10, Length[highM]]}
  ];
  ,
  Print["  (none in this range)"];
];

Print[];
Print["Low M(D) (few divisors, should have longer periods):"];
lowM = Select[compositeData, #[[2]] <= 1 &];
If[Length[lowM] > 0,
  Do[
    {d, m, per, _} = lowM[[i]];
    Print["  D=", d, ", M=", m, ", period=", per];
    ,
    {i, Min[10, Length[lowM]]}
  ];
];

Print[];
Print[StringRepeat["=", 80]];
Print["HYPOTHESIS TEST"];
Print[StringRepeat["=", 80]];
Print[];

Print["H0: M(D) and period are uncorrelated (r ≈ 0)"];
Print["H1: M(D) and period are anti-correlated (r < 0)"];
Print[];
Print["Result: r = ", N[correlation, 4]];

If[correlation < -0.2,
  Print["✓ MODERATE negative correlation → hypothesis supported"];
  Print["  More divisors → shorter period (trend)"];
  ,
  If[correlation < 0,
    Print["⚠ WEAK negative correlation → hypothesis partially supported"];
    ,
    Print["✗ No negative correlation → hypothesis NOT supported"];
  ]
];

Print[];
Print["Note: Primes (M=0) dominate sample, may mask composite pattern"];
Print["Composite-only correlation: ",
  If[Length[compositeData] > 2, N[corrComp, 4], "N/A"]];

Print[];
Print["TEST COMPLETE"];
