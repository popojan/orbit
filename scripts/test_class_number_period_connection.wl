#!/usr/bin/env wolframscript
(* TEST: Period mod 4 vs Class Number h(p) *)

Print[StringRepeat["=", 80]];
Print["GENUS THEORY TEST: Period divisibility vs Class Number"];
Print[StringRepeat["=", 80]];
Print[];

Print["HYPOTHESIS: Period mod 4 correlates with h(p) mod 2 or 2-rank"];
Print[];

CFPeriod[D_] := Module[{cf},
  If[IntegerQ[Sqrt[D]], Return[0]];
  cf = ContinuedFraction[Sqrt[D]];
  Length[cf[[2]]]
]

Print["Computing data for primes p < 500..."];
Print[];

primes = Select[Range[3, 500], PrimeQ];
Print["Total primes: ", Length[primes]];
Print[];

(* Compute all data *)
data = Table[
  Module[{p, mod8, period, periodMod4, h, hMod2, hMod4, discriminant},
    p = primes[[i]];
    mod8 = Mod[p, 8];
    period = CFPeriod[p];
    periodMod4 = Mod[period, 4];

    (* Discriminant *)
    discriminant = If[Mod[p, 4] == 1, p, 4*p];

    (* Class number *)
    h = NumberFieldClassNumber[Sqrt[p]];
    hMod2 = Mod[h, 2];
    hMod4 = Mod[h, 4];

    If[period > 0,
      {p, mod8, period, periodMod4, h, hMod2, hMod4, discriminant},
      Nothing
    ]
  ],
  {i, Length[primes]}
];

data = DeleteCases[data, Nothing];
Print["Valid data: ", Length[data], " primes"];
Print[];

Print[StringRepeat["=", 80]];
Print["ANALYSIS 1: Period mod 4 vs h(p) mod 2"];
Print[StringRepeat["-", 60]];
Print[];

(* Focus on p ≡ 3,7 (mod 8) where period rule holds *)
For[m = 3, m <= 7, m += 4,
  subset = Select[data, #[[2]] == m &];

  If[Length[subset] >= 5,
    Print["p ≡ ", m, " (mod 8): n=", Length[subset]];
    Print[];

    (* Crosstab: period mod 4 vs h mod 2 *)
    Print["  Period mod 4 distribution:"];
    periodDist = Tally[subset[[All, 4]]];
    Print["    ", periodDist];

    Print["  Class number h(p) mod 2:"];
    hMod2Dist = Tally[subset[[All, 6]]];
    Print["    ", hMod2Dist];

    (* Check correlation *)
    periods = subset[[All, 4]];
    hMods = subset[[All, 6]];

    (* Are they related? *)
    crosstab = Table[
      {per, hm, Length[Select[subset, #[[4]] == per && #[[6]] == hm &]]},
      {per, Union[periods]},
      {hm, Union[hMods]}
    ];

    Print["  Cross-tabulation (period mod 4, h mod 2, count):"];
    Do[
      Print["    ", crosstab[[i]]];
      ,
      {i, Length[crosstab]}
    ];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["ANALYSIS 2: Detailed examples"];
Print[StringRepeat["-", 60]];
Print[];

Print["First 20 primes p ≡ 3 (mod 8):"];
Print["p     period  per%4  h(p)  h%2  h%4"];
Print[StringRepeat["-", 50]];

subset3 = Select[data, #[[2]] == 3 &];
Do[
  {p, m8, per, pm4, h, hm2, hm4, disc} = subset3[[i]];
  Print[
    StringPadRight[ToString[p], 6],
    StringPadRight[ToString[per], 8],
    StringPadRight[ToString[pm4], 7],
    StringPadRight[ToString[h], 6],
    StringPadRight[ToString[hm2], 5],
    hm4
  ];
  ,
  {i, Min[20, Length[subset3]]}
];

Print[];
Print["First 20 primes p ≡ 7 (mod 8):"];
Print["p     period  per%4  h(p)  h%2  h%4"];
Print[StringRepeat["-", 50]];

subset7 = Select[data, #[[2]] == 7 &];
Do[
  {p, m8, per, pm4, h, hm2, hm4, disc} = subset7[[i]];
  Print[
    StringPadRight[ToString[p], 6],
    StringPadRight[ToString[per], 8],
    StringPadRight[ToString[pm4], 7],
    StringPadRight[ToString[h], 6],
    StringPadRight[ToString[hm2], 5],
    hm4
  ];
  ,
  {i, Min[20, Length[subset7]]}
];

Print[];
Print[StringRepeat["=", 80]];
Print["ANALYSIS 3: Correlation tests"];
Print[StringRepeat["-", 60]];
Print[];

(* Numerical correlation *)
For[m = 3, m <= 7, m += 4,
  subset = Select[data, #[[2]] == m &];

  If[Length[subset] >= 10,
    periods = N[subset[[All, 4]]];
    hMods = N[subset[[All, 6]]];

    corr = Correlation[periods, hMods];

    Print["p ≡ ", m, " (mod 8):"];
    Print["  Correlation(period mod 4, h mod 2): ", N[corr, 4]];

    (* Chi-square test for independence *)
    (* Count combinations *)
    n00 = Length[Select[subset, #[[4]] == 0 && #[[6]] == 0 &]];
    n01 = Length[Select[subset, #[[4]] == 0 && #[[6]] == 1 &]];
    n20 = Length[Select[subset, #[[4]] == 2 && #[[6]] == 0 &]];
    n21 = Length[Select[subset, #[[4]] == 2 && #[[6]] == 1 &]];

    If[m == 3,
      (* p ≡ 3: expect period ≡ 2 mod 4 *)
      Print["  Expected: ALL period ≡ 2 (mod 4)"];
      Print["  Actual: period=0:", n00+n01, ", period=2:", n20+n21];
      Print["  h even:", n00+n20, ", h odd:", n01+n21];
      ,
      (* p ≡ 7: expect period ≡ 0 mod 4 *)
      Print["  Expected: ALL period ≡ 0 (mod 4)"];
      Print["  Actual: period=0:", n00+n01, ", period=2:", n20+n21];
      Print["  h even:", n00+n20, ", h odd:", n01+n21];
    ];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["ANALYSIS 4: 2-rank investigation"];
Print[StringRepeat["-", 60]];
Print[];

(* 2-rank is the exponent k where h ≡ 0 (mod 2^k) but h ≠ 0 (mod 2^(k+1)) *)
Print["Checking if period divisibility relates to 2-divisibility of h(p)"];
Print[];

For[m = 3, m <= 7, m += 4,
  subset = Select[data, #[[2]] == m &];

  If[Length[subset] >= 5,
    Print["p ≡ ", m, " (mod 8):"];

    (* Group by h mod 4 *)
    hMod4Groups = GroupBy[subset, #[[7]] &];

    Do[
      hMod4Val = Keys[hMod4Groups][[i]];
      group = hMod4Groups[hMod4Val];

      avgPeriod = N[Mean[group[[All, 3]]], 3];
      periodMod4Dist = Tally[group[[All, 4]]];

      Print["  h ≡ ", hMod4Val, " (mod 4): n=", Length[group]];
      Print["    Mean period: ", avgPeriod];
      Print["    Period mod 4: ", periodMod4Dist];
      ,
      {i, Length[Keys[hMod4Groups]]}
    ];

    Print[];
  ]
];

Print[StringRepeat["=", 80]];
Print["CONCLUSIONS"];
Print[StringRepeat["-", 60]];
Print[];

(* Summary statistics *)
subset3 = Select[data, #[[2]] == 3 &];
subset7 = Select[data, #[[2]] == 7 &];

(* Check if period rule is violated *)
violations3 = Select[subset3, #[[4]] != 2 &];
violations7 = Select[subset7, #[[4]] != 0 &];

Print["Period divisibility rule:"];
Print["  p ≡ 3 (mod 8): ", Length[subset3] - Length[violations3], "/",
      Length[subset3], " have period ≡ 2 (mod 4)"];
Print["  p ≡ 7 (mod 8): ", Length[subset7] - Length[violations7], "/",
      Length[subset7], " have period ≡ 0 (mod 4)"];
Print[];

(* Class number parity *)
evenH3 = Length[Select[subset3, #[[6]] == 0 &]];
evenH7 = Length[Select[subset7, #[[6]] == 0 &]];

Print["Class number parity:"];
Print["  p ≡ 3 (mod 8): ", evenH3, " even h, ",
      Length[subset3] - evenH3, " odd h"];
Print["  p ≡ 7 (mod 8): ", evenH7, " even h, ",
      Length[subset7] - evenH7, " odd h"];
Print[];

Print["Key finding:"];
Print["  If h(p) parity correlates with period divisibility:");
Print["    → genus theory explains the rule"];
Print["  If NO correlation:");
Print["    → different mechanism (unit structure, Rédei symbols)"];
Print[];

Print[StringRepeat["=", 80]];
Print["TEST COMPLETE"];
