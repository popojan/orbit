#!/usr/bin/env wolframscript
(* THEORETICAL ANALYSIS: Why are even n different? *)

Print[StringRepeat["=", 80]];
Print["THEORETICAL ANALYSIS: Even n CF Structure"];
Print[StringRepeat["=", 80]];
Print[];

(* Helper functions *)
CFStructure[n_] := Module[{cf, a0, quotients},
  If[IntegerQ[Sqrt[n]], Return[{}]];
  cf = ContinuedFraction[Sqrt[n], 50];
  a0 = First[cf];
  quotients = Rest[cf];
  {a0, quotients, Length[quotients]}
]

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

M[n_] := Length[Select[Divisors[n], 2 <= # <= Sqrt[n] &]]

(* === THEORY: sqrt(2m) vs sqrt(m) === *)
Print["THEORETICAL QUESTION: CF(sqrt(2m)) vs CF(sqrt(m))"];
Print[StringRepeat["-", 60]];
Print[];

Print["For odd m, we have n = 2m (even)"];
Print["sqrt(2m) = sqrt(2) * sqrt(m)"];
Print[];
Print["But CF(sqrt(2m)) is NOT sqrt(2) * CF(sqrt(m))"];
Print["CF is NOT multiplicative in the argument."];
Print[];

(* Test specific examples *)
Print["EXAMPLES: Compare CF(sqrt(m)) vs CF(sqrt(2m))"];
Print[StringRepeat["-", 60]];
Print[];

testOdd = {3, 5, 7, 11, 13, 17, 19, 23, 29, 31};

Do[
  m = testOdd[[i]];
  n = 2 * m;

  {a0m, quotM, perM} = CFStructure[m];
  {a0n, quotN, perN} = CFStructure[n];

  Rm = Reg[m];
  Rn = Reg[n];

  Print["m = ", m, " (odd), n = 2m = ", n, " (even)"];
  Print["  sqrt(", m, ") = [", a0m, "; ", Take[quotM, Min[8, Length[quotM]]], "...]"];
  Print["  sqrt(", n, ") = [", a0n, "; ", Take[quotN, Min[8, Length[quotN]]], "...]"];
  Print["  Period: ", perM, " -> ", perN, " (ratio: ", N[perN/perM, 3], ")"];
  Print["  R: ", N[Rm, 4], " -> ", N[Rn, 4], " (ratio: ", N[Rn/Rm, 3], ")"];
  Print[];
  ,
  {i, Min[5, Length[testOdd]]}
];

Print[StringRepeat["=", 80]];
Print[];

(* === PATTERN: n = 2m analysis === *)
Print["SYSTEMATIC: n = 2m CF transformation"];
Print[StringRepeat["-", 60]];
Print[];

data2m = Table[
  m = 2*k + 1;
  n = 2 * m;

  If[m < 100,
    {a0m, quotM, perM} = CFStructure[m];
    {a0n, quotN, perN} = CFStructure[n];
    Rm = Reg[m];
    Rn = Reg[n];
    Mm = M[m];
    Mn = M[n];

    If[Rm > 0 && Rn > 0,
      {m, n, perM, perN, Rm, Rn, Mm, Mn},
      Nothing
    ],
    Nothing
  ],
  {k, 1, 40}
];

data2m = DeleteCases[data2m, Nothing];

Print["Collected ", Length[data2m], " pairs (m odd, n=2m)"];
Print[];

(* Correlations *)
perRatios = Table[data2m[[i, 4]] / data2m[[i, 3]], {i, Length[data2m]}];
RRatios = Table[data2m[[i, 6]] / data2m[[i, 5]], {i, Length[data2m]}];

Print["Period transformation (n=2m):"];
Print["  Mean period(2m)/period(m): ", N[Mean[perRatios], 4]];
Print["  Std: ", N[StandardDeviation[perRatios], 4]];
Print[];

Print["R transformation (n=2m):"];
Print["  Mean R(2m)/R(m): ", N[Mean[RRatios], 4]];
Print["  Std: ", N[StandardDeviation[RRatios], 4]];
Print[];

(* Does sqrt(2) factor affect pattern? *)
RmVals = data2m[[All, 5]];
RnVals = data2m[[All, 6]];
MmVals = data2m[[All, 7]];
MnVals = data2m[[All, 8]];

Print["Correlations:"];
Print["  R(m) <-> R(2m): ", N[Correlation[N[RmVals], N[RnVals]], 4]];
Print["  M(m) <-> M(2m): ", N[Correlation[N[MmVals], N[MnVals]], 4]];
Print[];

Print[StringRepeat["=", 80]];
Print[];

Print["KEY OBSERVATION:");
Print["For n = 2m, sqrt(2) factor introduces INCOMMENSURATE structure"];
Print["CF(sqrt(2m)) cannot be predicted from CF(sqrt(m)) + mod 8 alone"];
Print["Need separate theory for even n!"];

Print[];
Print["ANALYSIS COMPLETE"];
