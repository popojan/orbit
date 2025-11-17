#!/usr/bin/env wolframscript
(*
Test correlation between M(p) and Pell solution for sqrt(p)
Research question: Does divisor structure relate to fundamental unit?
*)

Print[StringRepeat["=", 70]];
Print["M(p) ↔ PELL SOLUTION CORRELATION TEST"];
Print[StringRepeat["=", 70]];
Print[];

(* M(n) - count divisors 2 ≤ d ≤ sqrt(n) *)
M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

(* Get fundamental Pell solution *)
PellSol[p_] := Module[{sol},
  sol = Solve[x^2 - p*y^2 == 1 && x > 1 && y > 0, {x, y}, Integers];
  If[sol === {}, {0, 0}, {x, y} /. First[sol]]
]

(* Test primes *)
primes = Select[Range[3, 200], PrimeQ];

Print["Computing data for ", Length[primes], " primes..."];
Print[];

data = Table[
  Module[{p, m, pell, x, y, xModP, cf, period},
    p = prime;
    m = M[p];
    pell = PellSol[p];

    If[pell === {0, 0},
      (* Skip if no solution found *)
      Nothing,
      {x, y} = pell;
      xModP = Mod[x, p];
      cf = ContinuedFraction[Sqrt[p], 100];
      period = Length[cf] - 1; (* Period length *)

      {
        p,
        m,
        x,
        y,
        xModP,                (* ±1 mod p *)
        Mod[p, 8],            (* p mod 8 *)
        N[Log[x]],            (* Regulator proxy *)
        N[(x-1)/y],           (* Egypt.wl base *)
        period,               (* CF period *)
        N[x/Sqrt[p]],         (* Normalized x *)
        N[y*Sqrt[p]]          (* Normalized y *)
      }
    ]
  ],
  {prime, primes}
];

data = DeleteCases[data, Nothing];

Print["Collected ", Length[data], " data points"];
Print[];

(* Display sample *)
Print["Sample data (first 10 primes):"];
Print["p\tM(p)\tx\ty\tx mod p\tp mod 8\tlog(x)\t(x-1)/y\tCF period"];
Print[StringRepeat["-", 90]];
Do[
  {p, m, x, y, xModP, pMod8, logX, base, period, xNorm, yNorm} = row;
  Print[p, "\t", m, "\t", x, "\t", y, "\t", xModP, "\t", pMod8, "\t",
    N[logX, 4], "\t", N[base, 4], "\t", period],
  {row, Take[data, Min[10, Length[data]]]}
];

Print[];
Print[StringRepeat["=", 70]];
Print["CORRELATION ANALYSIS"];
Print[StringRepeat["=", 70]];
Print[];

(* Extract columns *)
pVals = data[[All, 1]];
mVals = data[[All, 2]];
xVals = data[[All, 3]];
yVals = data[[All, 4]];
xModPVals = data[[All, 5]];
pMod8Vals = data[[All, 6]];
logXVals = data[[All, 7]];
baseVals = data[[All, 8]];
periodVals = data[[All, 9]];

(* Correlations *)
Print["PEARSON CORRELATIONS WITH M(p):"];
Print[];

correlations = {
  {"log(x)", Correlation[mVals, logXVals]},
  {"(x-1)/y", Correlation[mVals, baseVals]},
  {"CF period", Correlation[mVals, periodVals]},
  {"x/√p", Correlation[mVals, data[[All, 10]]]},
  {"y√p", Correlation[mVals, data[[All, 11]]]}
};

Do[
  {name, corr} = pair;
  Print["  M(p) ↔ ", name, ": ", N[corr, 6]],
  {pair, correlations}
];

Print[];

(* Check if strongest correlation *)
strongestCorr = MaximalBy[correlations, Abs[Last[#]] &][[1]];
Print["Strongest correlation: ", strongestCorr[[1]], " (r = ", N[strongestCorr[[2]], 6], ")"];

If[Abs[strongestCorr[[2]]] > 0.3,
  Print["  → SIGNIFICANT correlation detected! ⭐"],
  Print["  → No strong correlation found"]
];

Print[];

(* Group by mod 8 *)
Print[StringRepeat["=", 70]];
Print["M(p) STATISTICS BY p mod 8"];
Print[StringRepeat["=", 70]];
Print[];

Do[
  Module[{subset, mSubset, meanM, stdM},
    subset = Select[data, #[[6]] == mod8 &];
    If[Length[subset] > 0,
      mSubset = subset[[All, 2]];
      meanM = Mean[mSubset];
      stdM = StandardDeviation[mSubset];
      Print["p ≡ ", mod8, " (mod 8): "];
      Print["  Count: ", Length[subset]];
      Print["  M(p) mean: ", N[meanM, 5]];
      Print["  M(p) std: ", N[stdM, 5]];
      Print["  x ≡ ", If[mod8 == 7, "+1", "-1"], " (mod p) [mod 8 theorem]"];
      Print[];
    ];
  ],
  {mod8, {1, 3, 7}}
];

(* M(p) vs p scatter *)
Print[StringRepeat["=", 70]];
Print["M(p) GROWTH"];
Print[StringRepeat["=", 70]];
Print[];

(* Fit M(p) ~ log(p) or sqrt(p) ? *)
logPVals = Log[N[pVals]];
sqrtPVals = Sqrt[N[pVals]];

corrLogP = Correlation[mVals, logPVals];
corrSqrtP = Correlation[mVals, sqrtPVals];

Print["M(p) correlation with:"];
Print["  log(p): ", N[corrLogP, 6]];
Print["  √p: ", N[corrSqrtP, 6]];
Print[];

If[corrSqrtP > corrLogP,
  Print["  → M(p) grows more like √p"],
  Print["  → M(p) grows more like log(p)"]
];

Print[];
Print["Expected (prime number theorem): M(p) ≈ 0 for most primes"];
Print["(Since p has only divisors 1 and p, M(p) counts 2 ≤ d ≤ √p)");
Print[];

(* Check actual M values *)
Print["M(p) distribution:"];
Print["  Min: ", Min[mVals]];
Print["  Max: ", Max[mVals]];
Print["  Mean: ", N[Mean[mVals], 5]];
Print["  Median: ", Median[mVals]];

Print[];
Print[StringRepeat["=", 70]];
Print["CONCLUSION"];
Print[StringRepeat["=", 70]];
Print[];

If[Abs[strongestCorr[[2]]] > 0.5,
  Print["🎯 STRONG CORRELATION FOUND!"];
  Print["   M(p) correlates with ", strongestCorr[[1]]];
  Print["   This suggests Egypt.wl ↔ Primal Forest connection!"];
  ,
  If[Abs[strongestCorr[[2]]] > 0.3,
    Print["⚠ MODERATE correlation: ", strongestCorr[[1]]];
    Print["   Worth investigating further");
    ,
    Print["❌ No significant correlation between M(p) and Pell solution");
    Print["   Egypt.wl and Primal Forest appear independent");
  ]
];

Print[];
Print["Analysis complete."];
Print[StringRepeat["=", 70]];
