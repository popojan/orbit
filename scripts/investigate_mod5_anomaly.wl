#!/usr/bin/env wolframscript
(* INVESTIGATE MOD 5 ANOMALY: Why 8 orders of magnitude worse? *)

Print[StringRepeat["=", 80]];
Print["MOD 5 ANOMALY INVESTIGATION"];
Print[StringRepeat["=", 80]];
Print[];

(* Helper functions *)
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

DistToK2[n_] := Module[{k},
  k = Floor[Sqrt[n]];
  Min[n - k^2, (k+1)^2 - n]
]

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

(* === COLLECT DATA === *)
allData = Flatten[Table[
  If[OddQ[n] && !IntegerQ[Sqrt[n]],
    Module[{R, dist, m, mod8},
      R = Reg[n];
      dist = DistToK2[n];
      m = M[n];
      mod8 = Mod[n, 8];
      If[R > 0, {{n, R, dist, m, mod8}}, {}]
    ],
    {}
  ],
  {n, 3, 400}
], 1];

(* Split by training/test *)
trainingData = Select[allData, #[[1]] <= 100 &];
testData = Select[allData, #[[1]] > 100 &];

(* === MOD 5 ANALYSIS === *)
Print["MOD 5 ANALYSIS"];
Print[StringRepeat["-", 60]];
Print[];

mod5Train = Select[trainingData, #[[5]] == 5 &];
mod5Test = Select[testData, #[[5]] == 5 &];

Print["Training set (n <= 100): ", Length[mod5Train], " numbers"];
Print["Test set (n > 100):     ", Length[mod5Test], " numbers"];
Print[];

Print["TRAINING SET (mod 5, n <= 100):"];
Print[StringRepeat["-", 60]];
Print["n    R(n)    dist  M   Type"];
Print[StringRepeat["-", 60]];

Do[
  Module[{n, R, dist, m, isPrime},
    {n, R, dist, m} = mod5Train[[i, {1, 2, 3, 4}]];
    isPrime = PrimeQ[n];
    Print[StringPadRight[ToString[n], 5],
          StringPadRight[ToString[N[R, 4]], 8],
          StringPadRight[ToString[dist], 6],
          StringPadRight[ToString[m], 4],
          If[isPrime, "PRIME", "COMPOSITE"]];
  ],
  {i, Length[mod5Train]}
];

Print[];
Print["Training statistics (mod 5):"];
RVals = mod5Train[[All, 2]];
Print["  Mean R:   ", N[Mean[RVals], 4]];
Print["  Median R: ", N[Median[RVals], 4]];
Print["  Min R:    ", N[Min[RVals], 4]];
Print["  Max R:    ", N[Max[RVals], 4]];
Print["  Std dev:  ", N[StandardDeviation[RVals], 4]];
Print[];

(* === COMPARE WITH MOD 1 === *)
Print[StringRepeat["=", 80]];
Print[];
Print["COMPARISON: MOD 5 vs MOD 1"];
Print[StringRepeat["-", 60]];
Print[];

mod1Train = Select[trainingData, #[[5]] == 1 &];
mod1Test = Select[testData, #[[5]] == 1 &];

Print["MOD 1 training (n <= 100): ", Length[mod1Train], " numbers"];
Print["MOD 1 test (n > 100):      ", Length[mod1Test], " numbers"];
Print[];

Print["Training statistics comparison:"];
Print[StringRepeat["-", 60]];
Print["              Mod 1         Mod 5"];
Print[StringRepeat["-", 60]];

R1Vals = mod1Train[[All, 2]];
R5Vals = mod5Train[[All, 2]];

Print["Mean R:       ", StringPadRight[ToString[N[Mean[R1Vals], 4]], 12],
      "  ", N[Mean[R5Vals], 4]];
Print["Median R:     ", StringPadRight[ToString[N[Median[R1Vals], 4]], 12],
      "  ", N[Median[R5Vals], 4]];
Print["Std dev:      ", StringPadRight[ToString[N[StandardDeviation[R1Vals], 4]], 12],
      "  ", N[StandardDeviation[R5Vals], 4]];
Print["Min R:        ", StringPadRight[ToString[N[Min[R1Vals], 4]], 12],
      "  ", N[Min[R5Vals], 4]];
Print["Max R:        ", StringPadRight[ToString[N[Max[R1Vals], 4]], 12],
      "  ", N[Max[R5Vals], 4]];
Print[];

(* === TEST SET OUTLIERS === *)
Print[StringRepeat["=", 80]];
Print[];
Print["TEST SET OUTLIERS (mod 5, n > 100):"];
Print[StringRepeat["-", 60]];
Print[];

(* Use rational coefficients *)
baseline5 = Mean[mod5Train[[All, 2]]];
{alpha, beta, const} = {5/28, 33/82, 11/19};

Print["Model: R = ", N[baseline5, 4], " * (", N[const, 4], " + ",
      N[alpha, 4], "*dist - ", N[beta, 4], "*M)"];
Print[];

Print["n    R(act)  R(prd)  Error   dist  M   Type          Factorization"];
Print[StringRepeat["-", 80]];

predictions5 = Table[
  Module[{n, Rtrue, dist, m, Rpred, error, isPrime, factors},
    {n, Rtrue, dist, m} = mod5Test[[i, {1, 2, 3, 4}]];
    Rpred = baseline5 * (const + alpha*dist - beta*m);
    error = Abs[Rtrue - Rpred];
    isPrime = PrimeQ[n];
    factors = FactorInteger[n];

    {n, Rtrue, Rpred, error, dist, m, isPrime, factors}
  ],
  {i, Length[mod5Test]}
];

(* Sort by error *)
sortedPred5 = Reverse[SortBy[predictions5, #[[4]] &]];

(* Show top 15 *)
Do[
  Module[{n, Rtrue, Rpred, err, dist, m, isPrime, factors, typeStr},
    {n, Rtrue, Rpred, err, dist, m, isPrime, factors} = sortedPred5[[i]];
    typeStr = If[isPrime, "PRIME", "COMPOSITE"];

    Print[StringPadRight[ToString[n], 5],
          StringPadRight[ToString[N[Rtrue, 3]], 8],
          StringPadRight[ToString[N[Rpred, 3]], 8],
          StringPadRight[ToString[N[err, 3]], 8],
          StringPadRight[ToString[dist], 6],
          StringPadRight[ToString[m], 4],
          StringPadRight[typeStr, 14],
          ToString[factors]];
  ],
  {i, Min[15, Length[sortedPred5]]}
];

Print[];

(* === PATTERN SEARCH === *)
Print[StringRepeat["=", 80]];
Print[];
Print["PATTERN SEARCH: What makes mod 5 outliers special?"];
Print[StringRepeat["-", 60]];
Print[];

(* Top 10 outliers *)
top10 = Take[sortedPred5, Min[10, Length[sortedPred5]]];

Print["Top 10 outliers properties:"];
Print[];

(* Check if they're all primes *)
primesCount = Count[top10, {_, _, _, _, _, _, True, _}];
Print["Primes:     ", primesCount, "/10"];

(* Check dist pattern *)
distVals = top10[[All, 5]];
Print["Dist range: ", Min[distVals], " - ", Max[distVals]];
Print["Dist mean:  ", N[Mean[distVals], 3]];

(* Check M pattern *)
mVals = top10[[All, 6]];
Print["M range:    ", Min[mVals], " - ", Max[mVals]];
Print["M mean:     ", N[Mean[mVals], 3]];

Print[];

(* === HYPOTHESIS: BIFURCATION IN MOD 5? === *)
Print[StringRepeat["=", 80]];
Print[];
Print["HYPOTHESIS: Is there a BIFURCATION in mod 5 based on dist?"];
Print[StringRepeat["-", 60]];
Print[];

(* Split mod 5 test by dist *)
lowDist = Select[mod5Test, #[[3]] < 10 &];
highDist = Select[mod5Test, #[[3]] >= 10 &];

Print["Low dist (<10):  ", Length[lowDist], " numbers"];
Print["High dist (>=10): ", Length[highDist], " numbers"];
Print[];

If[Length[lowDist] > 0 && Length[highDist] > 0,
  Print["Mean R(actual):"];
  Print["  Low dist:  ", N[Mean[lowDist[[All, 2]]], 4]];
  Print["  High dist: ", N[Mean[highDist[[All, 2]]], 4]];
  Print["  Ratio:     ", N[Mean[highDist[[All, 2]]] / Mean[lowDist[[All, 2]]], 3], "x"];
  Print[];
];

(* === HYPOTHESIS: PRIMES vs COMPOSITES === *)
Print[StringRepeat["=", 80]];
Print[];
Print["HYPOTHESIS: Do primes behave differently than composites in mod 5?"];
Print[StringRepeat["-", 60]];
Print[];

primes5 = Select[mod5Test, PrimeQ[#[[1]]] &];
composites5 = Select[mod5Test, !PrimeQ[#[[1]]] &];

Print["Primes:     ", Length[primes5], " numbers"];
Print["Composites: ", Length[composites5], " numbers"];
Print[];

If[Length[primes5] > 0 && Length[composites5] > 0,
  Print["Mean R(actual):"];
  Print["  Primes:     ", N[Mean[primes5[[All, 2]]], 4]];
  Print["  Composites: ", N[Mean[composites5[[All, 2]]], 4]];
  Print["  Ratio:      ", N[Mean[primes5[[All, 2]]] / Mean[composites5[[All, 2]]], 3], "x"];
  Print[];
];

Print[StringRepeat["=", 80]];
Print["INVESTIGATION COMPLETE"];
