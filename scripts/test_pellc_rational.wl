#!/usr/bin/env wolframscript
(*
Test pellc with rational arguments
*)

Print[StringRepeat["=", 70]];
Print["PELLC WITH RATIONAL ARGUMENTS"];
Print[StringRepeat["=", 70]];
Print[];

(* Define the pellc function *)
pellc[n_, d_, c_, m_] := Module[
  {
   z = ChebyshevT[-1 + 2 m, Sqrt[d^2 n]]/
    ChebyshevU[-2 + 2 m, Sqrt[d^2 n]],
   gcd, sol
   },
  sol = {
    x -> z/(Sqrt[n] Sqrt[1 - n d^2 + z^2]),
    y -> 1/Sqrt[1 - n d^2 + z^2]
    };
  gcd = GCD[(x + c)^2, y^2, 1 + (x + c)^2 - x^2] /. sol;
  {n x^2 - (n d^2 - 1) y^2 == ((1 + (x + c)^2 - x^2)/gcd /. sol),
   Thread[{x, y} -> ({(x + c)/Sqrt[gcd], y/Sqrt[gcd]} /. sol)]}
]

Print["TEST 1: Rational n (d=1, c=0, m=2)"];
Print[StringRepeat["-", 70]];
Print[];

testRationalN = {2, 5/2, 3, 7/2, 4, 9/2, 5, 11/2, 13/2};

Table[
  Module[{result, eqn, sol, xVal, yVal, verify},
    Print["n = ", nrat, " (", If[IntegerQ[nrat], "integer", "rational"], "):"];
    result = pellc[nrat, 1, 0, 2];
    eqn = result[[1]];
    sol = result[[2]];
    xVal = x /. sol;
    yVal = y /. sol;

    Print["  Equation: ", InputForm[eqn]];
    Print["  x = ", xVal // FullSimplify];
    Print["  y = ", yVal // FullSimplify];

    (* Simplify to see if rational *)
    Module[{xSimp, ySimp},
      xSimp = FullSimplify[xVal];
      ySimp = FullSimplify[yVal];

      If[Head[xSimp] === Rational || IntegerQ[xSimp],
        Print["  *** x is RATIONAL: ", xSimp];
      ];

      If[Head[ySimp] === Rational || IntegerQ[ySimp],
        Print["  *** y is RATIONAL: ", ySimp];
      ];

      (* Verify equation *)
      verify = FullSimplify[nrat * xSimp^2 - (nrat - 1) * ySimp^2];
      Print["  Verify: ", nrat, "*x^2 - ", nrat-1, "*y^2 = ", verify];
    ];

    Print[];
    {nrat, xVal, yVal}
  ],
  {nrat, testRationalN}
];

Print[StringRepeat["=", 70]];
Print["TEST 2: Rational d (n=13, c=0, m=2)"];
Print[StringRepeat["-", 70]];
Print[];

testRationalD = {1/2, 1, 3/2, 2, 5/2};

Table[
  Module[{result, eqn, sol, xVal, yVal, discriminant},
    discriminant = 13 * drat^2 - 1;
    Print["d = ", drat, ", discriminant = 13*", drat, "^2 - 1 = ", discriminant];

    result = pellc[13, drat, 0, 2];
    eqn = result[[1]];
    sol = result[[2]];
    xVal = x /. sol;
    yVal = y /. sol;

    Print["  Equation: ", InputForm[eqn]];
    Print["  x = ", FullSimplify[xVal]];
    Print["  y = ", FullSimplify[yVal]];

    (* Check if solutions are rational *)
    Module[{xSimp, ySimp},
      xSimp = FullSimplify[xVal];
      ySimp = FullSimplify[yVal];

      If[Head[xSimp] === Rational || IntegerQ[xSimp],
        Print["  *** x is RATIONAL: ", xSimp];
      ];

      If[Head[ySimp] === Rational || IntegerQ[ySimp],
        Print["  *** y is RATIONAL: ", ySimp];
      ];
    ];

    Print[];
    {drat, xVal, yVal}
  ],
  {drat, testRationalD}
];

Print[StringRepeat["=", 70]];
Print["TEST 3: Rational c (n=13, d=1, m=2)"];
Print[StringRepeat["-", 70]];
Print[];

testRationalC = {0, 1/2, 1, 3/2, 2};

Table[
  Module[{result, eqn, sol, xVal, yVal},
    Print["c = ", crat, ":"];

    result = pellc[13, 1, crat, 2];
    eqn = result[[1]];
    sol = result[[2]];
    xVal = x /. sol;
    yVal = y /. sol;

    Print["  Equation: ", InputForm[eqn]];
    Print["  x = ", FullSimplify[xVal]];
    Print["  y = ", FullSimplify[yVal]];

    (* Check if integer *)
    Module[{xNum, yNum},
      xNum = N[xVal, 15];
      yNum = N[yVal, 15];

      If[Abs[xNum - Round[xNum]] < 0.0001 && Abs[yNum - Round[yNum]] < 0.0001,
        Print["  *** INTEGER: x ≈ ", Round[xNum], ", y ≈ ", Round[yNum]];
      ];
    ];

    Print[];
    {crat, xVal, yVal}
  ],
  {crat, testRationalC}
];

Print[StringRepeat["=", 70]];
Print["TEST 4: Special rational combinations"];
Print[StringRepeat["-", 70]];
Print[];

Print["Looking for cases where d^2*n results in nice discriminant..."];
Print[];

(* Try n/d^2 = integer *)
testCombos = {
  {13, 1/2, "n*d^2 = 13/4"},
  {13/4, 1, "n*d^2 = 13/4"},
  {13/9, 1, "n*d^2 = 13/9"},
  {2, Sqrt[2], "n*d^2 = 4"},
  {3, Sqrt[3], "n*d^2 = 9"}
};

Do[
  Module[{n, d, label, result, xVal, yVal},
    {n, d, label} = combo;
    Print[label, ": n=", n, ", d=", d];

    (* Check if d^2*n is rational *)
    Module[{prod},
      prod = d^2 * n;
      Print["  d^2*n = ", prod // FullSimplify];
      Print["  discriminant = ", (n * d^2 - 1) // FullSimplify];
    ];

    result = pellc[n, d, 0, 2];
    xVal = x /. result[[2]];
    yVal = y /. result[[2]];

    Print["  x = ", FullSimplify[xVal]];
    Print["  y = ", FullSimplify[yVal]];

    (* Check rationality *)
    Module[{xSimp, ySimp},
      xSimp = FullSimplify[xVal];
      ySimp = FullSimplify[yVal];

      If[(Head[xSimp] === Rational || IntegerQ[xSimp]) &&
         (Head[ySimp] === Rational || IntegerQ[ySimp]),
        Print["  *** BOTH x AND y ARE RATIONAL!"];
        Print["  x = ", xSimp, ", y = ", ySimp];
      ];
    ];

    Print[];
  ],
  {combo, testCombos}
];

Print[StringRepeat["=", 70]];
Print["TEST 5: Pattern search for rational solutions"];
Print[StringRepeat["-", 70]];
Print[];

Print["Searching n, d such that both x and y are rational..."];
Print[];

rationalSolutions = {};

Do[
  Do[
    Module[{result, xVal, yVal, xSimp, ySimp},
      result = pellc[ntest, dtest, 0, 2];
      xVal = x /. result[[2]];
      yVal = y /. result[[2]];
      xSimp = FullSimplify[xVal];
      ySimp = FullSimplify[yVal];

      If[(Head[xSimp] === Rational || IntegerQ[xSimp]) &&
         (Head[ySimp] === Rational || IntegerQ[ySimp]),
        AppendTo[rationalSolutions, {ntest, dtest, xSimp, ySimp}];
      ];
    ],
    {dtest, {1/2, 1, 3/2, 2}}
  ],
  {ntest, {2, 5/2, 3, 7/2, 4, 9/2, 5, 13/2, 13/4}}
];

If[Length[rationalSolutions] > 0,
  Print["Found ", Length[rationalSolutions], " cases with rational x and y:"];
  Print[];
  Print["n\td\tx\ty"];
  Print[StringRepeat["-", 50]];
  Do[
    Print[sol[[1]], "\t", sol[[2]], "\t", sol[[3]], "\t", sol[[4]]],
    {sol, rationalSolutions}
  ];
  Print[];
,
  Print["No rational solutions found in tested range."];
  Print[];
];

Print[StringRepeat["=", 70]];
Print["CONCLUSIONS"];
Print[StringRepeat["=", 70]];
Print[];

If[Length[rationalSolutions] > 0,
  Print["FOUND RATIONAL SOLUTIONS - this is interesting!"];
  Print["Suggests special algebraic structure for certain n, d combinations."];
,
  Print["Most solutions involve algebraic numbers (radicals)."];
  Print["Rational arguments don't seem to produce rational solutions generally."];
];

Print[];
Print[StringRepeat["=", 70]];
