#!/usr/bin/env wolframscript
(* TEST: Is h(n) computed from R(n)? *)

Print[StringRepeat["=", 80]];
Print["TEST: Does Wolfram compute h(n) from R(n)?"];
Print[StringRepeat["=", 80]];
Print[];

PellSol[D_] := Module[{sol},
  If[IntegerQ[Sqrt[D]], Return[{1, 0}]];
  sol = Solve[x^2 - D*y^2 == 1, {x, y}, PositiveIntegers] /. C[1] -> 1;
  If[sol === {}, {0, 0}, {x, y} /. First[sol]]
]

Reg[D_] := Module[{sol, x, y},
  sol = PellSol[D];
  {x, y} = sol;
  If[x > 1, N[Log[x + y*Sqrt[D]], 20], 0.0]
]

ClassNumber[n_] := Module[{factors},
  factors = FactorInteger[n];
  If[Max[factors[[All, 2]]] > 1, Return[Missing["NotSquareFree"]]];
  NumberFieldClassNumber[Sqrt[n]]
]

(* Analytical class number formula:
   h(n) * R(n) = (sqrt(n) / Pi) * L(1, chi_n)

   Where chi_n is Kronecker symbol (n/·)
*)

(* Simpler test: Check if h*R ~ sqrt(n)*L(1,chi) holds *)
(* Extract L(1,chi) from known h and R *)

ExtractL[n_, h_, R_] := (Pi * h * R) / Sqrt[n]

(* Test on examples *)
Print["Testing analytical formula vs Wolfram's NumberFieldClassNumber:"];
Print[];
Print[StringRepeat["-", 80]];
Print["n       h(Wolfram)  h(formula)  R(n)      L(1,chi)  Match?"];
Print[StringRepeat["-", 80]];

testCases = {3, 5, 7, 11, 13, 15, 17, 19, 21, 23, 29, 31, 35, 37, 41, 43, 47};

results = Table[
  If[!IntegerQ[Sqrt[n]],
    Module[{hWolfram, hFormula, R, Lval, match},
      hWolfram = ClassNumber[n];
      hFormula = ComputeHFromFormula[n];
      R = Reg[n];
      Lval = DirichletL[KroneckerSymbol[n, #] &, 1];

      If[!MissingQ[hWolfram] && !MissingQ[hFormula],
        match = Abs[hWolfram - hFormula] < 0.01;

        Print[
          StringPadRight[ToString[n], 8],
          StringPadRight[ToString[hWolfram], 12],
          StringPadRight[ToString[N[hFormula, 4]], 12],
          StringPadRight[ToString[N[R, 5]], 10],
          StringPadRight[ToString[N[Lval, 5]], 10],
          If[match, "YES", "NO"]
        ];

        {n, hWolfram, hFormula, match}
        ,
        Nothing
      ]
    ]
    ,
    Nothing
  ],
  {n, testCases}
];

results = DeleteCases[results, Nothing];

Print[];
Print[StringRepeat["=", 80]];
Print[];

(* Statistics *)
matches = Count[results, {_, _, _, True}];
total = Length[results];

Print["RESULTS:"];
Print[StringRepeat["-", 60]];
Print["Matches: ", matches, " / ", total];
Print["Accuracy: ", N[100.0 * matches / total, 3], "%"];
Print[];

If[matches == total,
  Print["CONFIRMED: Wolfram computes h(n) from R(n) via formula!"];
  Print["  h(n) = (sqrt(n)/Pi) * L(1,chi_n) / R(n)"];
  Print[];
  Print["IMPLICATION: h is NOT independent!"];
  Print["  M -> R -> h (causal chain)"];
  Print["  M <-> h correlation is INDIRECT via R"];
  ,
  Print["SURPRISING: Formula doesn't match exactly"];
  Print["  Wolfram may use different method"];
  Print["  Or numerical precision issues?"];
];

Print[];
Print[StringRepeat["=", 80]];
