#!/usr/bin/env wolframscript
(* Test recursive structure of R(n) for composites *)

Print[StringRepeat["=", 80]];
Print["RECURSIVE REGULATOR STRUCTURE TEST"];
Print[StringRepeat["=", 80]];
Print[];

(* Pell solution and regulator *)
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

(* === SEMIPRIMES: R(pq) vs R(p), R(q) === *)
Print["=== TEST 1: SEMIPRIMES R(pq) vs R(p), R(q) ==="];
Print[];

(* Generate semiprimes pq where both p,q are odd primes *)
primes = Select[Prime[Range[2, 30]], # < 50 &]; (* Skip 2, use odd primes *)
semiprimes = Flatten[Table[
  {p, q, p*q},
  {p, primes}, {q, Select[primes, # >= p &]}
], 1];

(* Compute regulators *)
semData = Table[
  {p, q, pq} = sp;
  Rp = Reg[p];
  Rq = Reg[q];
  Rpq = Reg[pq];
  If[Rp > 0 && Rq > 0 && Rpq > 0,
    {p, q, pq, Rp, Rq, Rpq},
    Nothing
  ],
  {sp, semiprimes}
];

Print["Computed ", Length[semData], " semiprimes"];
Print[];

(* Test various models *)
Print["Testing models for R(pq):"];
Print[StringRepeat["-", 80]];

(* Model 1: Additive R(pq) = R(p) + R(q) *)
diffs1 = Table[
  {p, q, pq, Rp, Rq, Rpq} = d;
  Rpq - (Rp + Rq),
  {d, semData}
];
meanErr1 = Mean[Abs /@ diffs1];
relErr1 = Mean[Table[Abs[diffs1[[i]]]/semData[[i, 6]], {i, Length[diffs1]}]];

Print["Model 1: R(pq) = R(p) + R(q)"];
Print["  Mean absolute error: ", N[meanErr1, 4]];
Print["  Mean relative error:  ", N[100*relErr1, 2], "%"];
corr1 = Correlation[semData[[All, 6]], semData[[All, 4]] + semData[[All, 5]]];
Print["  Correlation:          ", N[corr1, 4]];
Print[];

(* Model 2: Multiplicative R(pq) = R(p) * R(q) *)
diffs2 = Table[
  {p, q, pq, Rp, Rq, Rpq} = d;
  Rpq - (Rp * Rq),
  {d, semData}
];
meanErr2 = Mean[Abs /@ diffs2];
relErr2 = Mean[Table[Abs[diffs2[[i]]]/semData[[i, 6]], {i, Length[diffs2]}]];

Print["Model 2: R(pq) = R(p) * R(q)"];
Print["  Mean absolute error: ", N[meanErr2, 4]];
Print["  Mean relative error:  ", N[100*relErr2, 2], "%"];
corr2 = Correlation[semData[[All, 6]], semData[[All, 4]] * semData[[All, 5]]];
Print["  Correlation:          ", N[corr2, 4]];
Print[];

(* Model 3: Geometric mean R(pq) = sqrt(R(p) * R(q)) *)
diffs3 = Table[
  {p, q, pq, Rp, Rq, Rpq} = d;
  Rpq - Sqrt[Rp * Rq],
  {d, semData}
];
meanErr3 = Mean[Abs /@ diffs3];
relErr3 = Mean[Table[Abs[diffs3[[i]]]/semData[[i, 6]], {i, Length[diffs3]}]];

Print["Model 3: R(pq) = sqrt(R(p) * R(q))"];
Print["  Mean absolute error: ", N[meanErr3, 4]];
Print["  Mean relative error:  ", N[100*relErr3, 2], "%"];
corr3 = Correlation[semData[[All, 6]], Sqrt[semData[[All, 4]] * semData[[All, 5]]]];
Print["  Correlation:          ", N[corr3, 4]];
Print[];

(* Model 4: Weighted R(pq) = a*R(p) + b*R(q) (linear regression) *)
X = Transpose[{semData[[All, 4]], semData[[All, 5]]}];
Y = semData[[All, 6]];
fit = LinearModelFit[Transpose[{X, Y}], {x1, x2}, {x1, x2}];
params = fit["BestFitParameters"];

Print["Model 4: R(pq) = a*R(p) + b*R(q) + c (fitted)"];
Print["  a = ", N[params[[2]], 4]];
Print["  b = ", N[params[[3]], 4]];
Print["  c = ", N[params[[1]], 4]];
Print["  R² = ", N[fit["RSquared"], 4]];
corr4 = Sqrt[fit["RSquared"]];
Print["  Correlation: ", N[corr4, 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === PRIME POWERS: R(p²) vs R(p) === *)
Print["=== TEST 2: PRIME POWERS R(p²) vs R(p) ==="];
Print[];

primePowers = Table[
  p = primes[[i]];
  p2 = p^2;
  If[p2 < 2000,  (* Keep it reasonable *)
    Rp = Reg[p];
    Rp2 = Reg[p2];
    If[Rp > 0 && Rp2 > 0,
      {p, p2, Rp, Rp2},
      Nothing
    ],
    Nothing
  ],
  {i, Length[primes]}
];

primePowers = DeleteCases[primePowers, Nothing];

Print["Computed ", Length[primePowers], " prime powers"];
Print[];

(* Test R(p²) = k * R(p) *)
ratios = Table[
  {p, p2, Rp, Rp2} = d;
  Rp2 / Rp,
  {d, primePowers}
];

Print["R(p²) / R(p) ratios:"];
Print["  Mean:   ", N[Mean[ratios], 4]];
Print["  Median: ", N[Median[ratios], 4]];
Print["  Std:    ", N[StandardDeviation[ratios], 4]];
Print["  Min:    ", N[Min[ratios], 4]];
Print["  Max:    ", N[Max[ratios], 4]];
Print[];

Print["Testing R(p²) = k*R(p):"];
corr5 = Correlation[primePowers[[All, 4]], primePowers[[All, 3]]];
Print["  R(p²) ↔ R(p) correlation: ", N[corr5, 4]];
Print[];

(* Linear fit *)
fit2 = LinearModelFit[
  Table[{primePowers[[i, 3]], primePowers[[i, 4]]}, {i, Length[primePowers]}],
  x, x
];
Print["Linear fit R(p²) = k*R(p) + c:"];
Print["  k = ", N[fit2["BestFitParameters"][[2]], 4]];
Print["  c = ", N[fit2["BestFitParameters"][[1]], 4]];
Print["  R² = ", N[fit2["RSquared"], 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

(* === BEST MODEL SUMMARY === *)
Print["=== BEST MODEL SUMMARY ==="];
Print[];

bestModel = MaximalBy[
  {
    {"Additive (R(pq) = R(p) + R(q))", corr1, relErr1},
    {"Multiplicative (R(pq) = R(p) * R(q))", corr2, relErr2},
    {"Geometric mean", corr3, relErr3},
    {"Weighted linear", corr4, 0}
  },
  #[[2]] &
][[1]];

Print["Best model for semiprimes: ", bestModel[[1]]];
Print["  Correlation: ", N[bestModel[[2]], 4]];
If[bestModel[[3]] > 0,
  Print["  Relative error: ", N[100*bestModel[[3]], 2], "%"]
];
Print[];

Print["Prime powers:"];
Print["  R(p²) ≈ ", N[Mean[ratios], 3], " * R(p)"];
Print["  (varies from ", N[Min[ratios], 3], " to ", N[Max[ratios], 3], ")"];
Print[];

Print["=== ANALYSIS COMPLETE ==="];
Print[StringRepeat["=", 80]];
