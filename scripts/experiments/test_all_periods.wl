#!/usr/bin/env wolframscript
(* Test periods for all cases in the table *)

AlgebraicCirclePoint[k_, a_] := Module[{z},
  z = (a - I)^(4*k) / (1 + a^2)^(2*k);
  {Re[z], Im[z]}
];

testCases = {
  {3, Sqrt[3], "√3"},
  {5, Sqrt[5 + 2*Sqrt[5]], "√(5+2√5)"},
  {6, 2 + Sqrt[3], "2+√3"},
  {24, 2 + Sqrt[2] + Sqrt[3] + Sqrt[6], "2+√2+√3+√6"}
};

Print["Testing periods for different n values:"];
Print["==========================================\n"];

Do[
  {n, a, aStr} = testCase;

  Print["n = ", n, ", a = ", aStr];
  Print["Theoretical T = π/(2·ArcCot[a]) = ", N[Pi/(2*ArcCot[a])]];
  Print["Testing k values:"];

  p0 = AlgebraicCirclePoint[0, a];

  (* Test k from 1 to 2*n *)
  found = False;
  Do[
    pk = AlgebraicCirclePoint[k, a];
    dist = Norm[N[pk - p0, 20]];

    If[dist < 10^-8 && !found,
      Print["  k = ", k, ": FIRST RETURN (distance = ", dist, ")"];
      found = True;
      Break[];
    ];
  , {k, 1, 2*n}];

  (* Also check if k=n returns *)
  pn = AlgebraicCirclePoint[n, a];
  distN = Norm[N[pn - p0, 20]];
  Print["  k = n = ", n, ": distance = ", distN];

  (* Check if k=n/2 returns (if n is even) *)
  If[EvenQ[n],
    pHalf = AlgebraicCirclePoint[n/2, a];
    distHalf = Norm[N[pHalf - p0, 20]];
    Print["  k = n/2 = ", n/2, ": distance = ", distHalf];
  ];

  Print[""];
, {testCase, testCases}];

Print["\n=== FORMULA CHECK ===\n"];
Print["The construction is: z = (a-I)^(4k) / (1+a²)^(2k)"];
Print["Note the exponent is 4k, not k!"];
Print[""];
Print["If T_exp is period in exponent, then T_k = T_exp/4 is period in k"];
Print[""];

Do[
  {n, a, aStr} = testCase;

  (* What's the angle? *)
  angle = 4*Arg[(a - I)/Sqrt[1 + a^2]];
  period_exp = N[2*Pi/angle];
  period_k = N[period_exp/4];

  Print["n = ", n, ":"];
  Print["  Arg[(a-I)/√(1+a²)] = ", N[Arg[(a - I)/Sqrt[1 + a^2]]]];
  Print["  Period in exponent (4k): ", period_exp];
  Print["  Period in k: ", period_k];
  Print[""];
, {testCase, testCases}];
