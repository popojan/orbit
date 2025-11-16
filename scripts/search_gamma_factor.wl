#!/usr/bin/env wolframscript
(*
  Search for Gamma Factor in Functional Equation

  Goal: Find γ(s) such that γ(s)·L_M(s) = γ(1-s)·L_M(1-s)

  Strategy: Test classical candidates numerically
*)

Print["================================================"];
Print["Searching for Functional Equation Factor γ(s)"];
Print["================================================\n"];

(* Closed form computation *)
TailZeta[s_?NumericQ, m_Integer] := Zeta[s] - Sum[k^(-s), {k, 1, m-1}];

ComputeLM[s_?NumericQ, nMax_Integer : 200] := Module[{},
  N[Zeta[s] * (Zeta[s] - 1) - Sum[TailZeta[s, j]/j^s, {j, 2, nMax}], 30]
];

(* Test if ratio is constant (FR holds) *)
TestFunctionalEquation[gammaFunc_, testPoints_List] := Module[{ratios, results},
  Print["Testing γ(s) = ", gammaFunc];
  Print[StringRepeat["-", 80]];

  results = Table[
    Module[{s, s1, Ls, Ls1, gammaS, gammaS1, left, right, ratio},
      s = σ + I*t;
      s1 = 1 - s;

      Ls = ComputeLM[s, 200];
      Ls1 = ComputeLM[s1, 200];

      gammaS = gammaFunc[s];
      gammaS1 = gammaFunc[s1];

      left = gammaS * Ls;
      right = gammaS1 * Ls1;

      ratio = left / right;

      {N[s, 4], N[Abs[ratio], 8], N[Arg[ratio], 8]}
    ],
    {pt, testPoints}, {σ, pt[[1]]}, {t, pt[[2]]}
  ];

  Print["s\t\t|ratio|\t\tArg(ratio)"];
  Print[StringRepeat["-", 60]];
  Do[
    Print[r[[1]], "\t", r[[2]], "\t", r[[3]]],
    {r, results}
  ];

  (* Check if ratio is constant *)
  ratioMags = results[[All, 2]];
  ratioArgs = results[[All, 3]];

  magStd = StandardDeviation[ratioMags];
  argStd = StandardDeviation[ratioArgs];

  Print["\nStatistics:"];
  Print["  |ratio| std dev: ", N[magStd, 6]];
  Print["  Arg std dev:     ", N[argStd, 6]];

  If[magStd < 0.01 && argStd < 0.1,
    Print["  ✓ CANDIDATE FOUND! (low variance)"],
    Print["  ✗ Not constant (high variance)"]
  ];

  Print["\n"];

  {magStd, argStd}
];

(* Test points *)
testPoints = {
  {1.5, 5.0},
  {1.3, 10.0},
  {2.0, 14.135},
  {1.7, 20.0}
};

Print["Test points: ", testPoints];
Print["\n"];

(* ========================================= *)
(* Candidate 1: Just Gamma factors         *)
(* ========================================= *)

gamma1[s_] := Gamma[s/2];
TestFunctionalEquation[gamma1, testPoints];

(* ========================================= *)
(* Candidate 2: Pi + Gamma (like zeta)     *)
(* ========================================= *)

gamma2[s_] := Pi^(-s/2) * Gamma[s/2];
TestFunctionalEquation[gamma2, testPoints];

(* ========================================= *)
(* Candidate 3: Double Gamma (L_M has ζ²)  *)
(* ========================================= *)

gamma3[s_] := (Pi^(-s/2) * Gamma[s/2])^2;
TestFunctionalEquation[gamma3, testPoints];

(* ========================================= *)
(* Candidate 4: Modified Gamma shift       *)
(* ========================================= *)

gamma4[s_] := Pi^(-s/2) * Gamma[(s+1)/2];
TestFunctionalEquation[gamma4, testPoints];

(* ========================================= *)
(* Candidate 5: Product of shifted Gammas  *)
(* ========================================= *)

gamma5[s_] := Gamma[s/2] * Gamma[(s+1)/2];
TestFunctionalEquation[gamma5, testPoints];

(* ========================================= *)
(* Candidate 6: Empirical - try s itself   *)
(* ========================================= *)

gamma6[s_] := s * Pi^(-s/2) * Gamma[s/2];
TestFunctionalEquation[gamma6, testPoints];

(* ========================================= *)
(* Candidate 7: ζ(s) factor (self-dual?)   *)
(* ========================================= *)

gamma7[s_] := Zeta[s] * Pi^(-s/2) * Gamma[s/2];
TestFunctionalEquation[gamma7, testPoints];

(* ========================================= *)
(* ANALYSIS: Check direct ratio pattern    *)
(* ========================================= *)

Print["================================================"];
Print["DIRECT RATIO ANALYSIS"];
Print["================================================\n"];

Print["Computing L_M(s)/L_M(1-s) to find pattern...\n"];

directRatios = Table[
  Module[{s, s1, Ls, Ls1, ratio},
    s = σ + I*t;
    s1 = 1 - s;
    Ls = ComputeLM[s, 200];
    Ls1 = ComputeLM[s1, 200];
    ratio = Ls / Ls1;
    {N[s, 4], N[ratio, 10]}
  ],
  {pt, testPoints}, {σ, pt[[1]]}, {t, pt[[2]]}
];

Print["s\t\tL_M(s)/L_M(1-s)"];
Print[StringRepeat["-", 70]];
Do[
  Print[r[[1]], "\t", r[[2]]],
  {r, directRatios}
];

Print["\n"];

(* Try to fit ratio to known functions *)
Print["Attempting to identify pattern in ratio...\n"];

(* Check if ratio matches classical xi function ratio *)
xiRatios = Table[
  Module[{s, s1, xiS, xiS1, ratio},
    s = σ + I*t;
    s1 = 1 - s;
    xiS = Pi^(-s/2) * Gamma[s/2] * Zeta[s];
    xiS1 = Pi^(-(1-s)/2) * Gamma[(1-s)/2] * Zeta[1-s];
    ratio = xiS / xiS1;
    {N[s, 4], N[ratio, 10]}
  ],
  {pt, testPoints}, {σ, pt[[1]]}, {t, pt[[2]]}
];

Print["For comparison, ξ(s)/ξ(1-s) [should be 1]:"];
Print["s\t\tξ(s)/ξ(1-s)"];
Print[StringRepeat["-", 70]];
Do[
  Print[r[[1]], "\t", r[[2]]],
  {r, xiRatios}
];

Print["\n"];

(* Check product structure *)
Print["Testing if L_M ratio = [ξ ratio]^n for some n...\n"];

productTest = Table[
  Module[{lmRat, xiRat, powerEst},
    lmRat = directRatios[[i, 2]];
    xiRat = xiRatios[[i, 2]];
    powerEst = Log[Abs[lmRat]] / Log[Abs[xiRat]];
    {directRatios[[i, 1]], N[powerEst, 6], N[Arg[lmRat]/Arg[xiRat], 6]}
  ],
  {i, 1, Length[directRatios]}
];

Print["s\t\tPower (magnitude)\tPower (argument)"];
Print[StringRepeat["-", 70]];
Do[
  Print[p[[1]], "\t", p[[2]], "\t\t", p[[3]]],
  {p, productTest}
];

Print["\n"];
Print["If power ≈ constant, then γ(s) = [π^(-s/2) Γ(s/2)]^power"];

Print["\n================================================"];
Print["NEXT STEPS"];
Print["================================================\n"];
Print["1. If candidate found → verify on more points"];
Print["2. If pattern unclear → try symbolic manipulation"];
Print["3. Check correction sum Σ H_j(s)/j^s separately"];

Print["\nSearch complete!"];
