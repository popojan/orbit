#!/usr/bin/env wolframscript
(*
Test pellc closed form function for generalized Pell equations
*)

Print[StringRepeat["=", 70]];
Print["TESTING pellc CLOSED FORM FOR GENERALIZED PELL"];
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

Print["TEST 1: Basic case n=13, d=1, c=1, varying m"];
Print[StringRepeat["-", 70]];
Print[];

Do[
  Module[{result, eqn, sol, xVal, yVal, lhs, rhs, numeric},
    Print["m = ", m, ":"];
    result = pellc[13, 1, 1, m];
    eqn = result[[1]];
    sol = result[[2]];

    Print["  Equation: ", eqn];
    Print["  Solution: ", sol];

    (* Extract x and y values *)
    xVal = x /. sol;
    yVal = y /. sol;

    Print["  x = ", xVal // FullSimplify];
    Print["  y = ", yVal // FullSimplify];

    (* Check if integer *)
    numeric = {N[xVal, 20], N[yVal, 20]};
    Print["  Numeric: x ≈ ", numeric[[1]]];
    Print["            y ≈ ", numeric[[2]]];

    (* Verify equation *)
    lhs = (13 * xVal^2 - (13*1^2 - 1) * yVal^2) // FullSimplify;
    rhs = ((1 + (xVal + 1)^2 - xVal^2) / (GCD[(xVal + 1)^2, yVal^2, 1 + (xVal + 1)^2 - xVal^2])) // FullSimplify;

    Print["  LHS = ", lhs // FullSimplify];
    Print["  RHS = ", rhs // FullSimplify];
    Print["  Verified: ", Simplify[lhs == rhs]];
    Print[];
  ],
  {m, 1, 3}
];

Print[StringRepeat["=", 70]];
Print["TEST 2: Compare c=0 vs c=1 for n=13, d=1, m=2"];
Print[StringRepeat["=", 70]];
Print[];

Module[{result, eqn, sol, xVal, yVal},
  Print["c = 0:"];
  result = pellc[13, 1, 0, 2];
  eqn = result[[1]];
  sol = result[[2]];
  xVal = x /. sol;
  yVal = y /. sol;
  Print["  Equation: ", eqn];
  Print["  x = ", xVal // FullSimplify];
  Print["  y = ", yVal // FullSimplify];
  Print["  Numeric: x ≈ ", N[xVal, 15]];
  Print["            y ≈ ", N[yVal, 15]];
  Print[];
];

Module[{result, eqn, sol, xVal, yVal},
  Print["c = 1:"];
  result = pellc[13, 1, 1, 2];
  eqn = result[[1]];
  sol = result[[2]];
  xVal = x /. sol;
  yVal = y /. sol;
  Print["  Equation: ", eqn];
  Print["  x = ", xVal // FullSimplify];
  Print["  y = ", yVal // FullSimplify];
  Print["  Numeric: x ≈ ", N[xVal, 15]];
  Print["            y ≈ ", N[yVal, 15]];
  Print[];
];

Print[StringRepeat["=", 70]];
Print["TEST 3: Verify c=0 solution for n=13"];
Print[StringRepeat["=", 70]];
Print[];

Print["c=0, m=2 gave: x=49, y=51 for 13x^2 - 12y^2 = 1"];
Print["Verify: 13*49^2 - 12*51^2 = ", 13*49^2 - 12*51^2];
Print["SUCCESS! This is close to fundamental Pell x^2 - 13y^2 = 1"];
Print[];

Module[{sol, xf, yf},
  sol = Reduce[x^2 - 13*y^2 == 1 && x > 0 && y > 0, {x, y}, Integers];
  Print["Fundamental Pell x^2 - 13y^2 = 1:"];
  Print["  Known: x=649, y=180"];
  xf = 649;
  yf = 180;
  Print["  Verify: ", xf, "^2 - 13*", yf, "^2 = ", xf^2 - 13*yf^2];
];

Print[];
Print["Actually, 13x^2 - 12y^2 = 1 is DIFFERENT from x^2 - 13y^2 = 1"];
Print["But 12 = 13-1, so this is: 13x^2 - (13-1)y^2 = 1"];
Print["which rearranges to: 13x^2 - 13y^2 + y^2 = 1"];
Print["                  => 13(x^2 - y^2) = 1 - y^2"];
Print[];

Print[StringRepeat["=", 70]];
Print["TEST 3B: Different n values with d=1, c=0, m=2"];
Print[StringRepeat["=", 70]];
Print[];

Table[
  Module[{result, eqn, sol, xVal, yVal, nVal = nTest},
    Print["n = ", nVal, ":");
    result = pellc[nVal, 1, 0, 2];
    eqn = result[[1]];
    sol = result[[2]];

    xVal = x /. sol;
    yVal = y /. sol;

    Print["  Equation: ", InputForm[eqn]];
    Print["  x = ", xVal // FullSimplify];
    Print["  y = ", yVal // FullSimplify];
    Print["  Numeric: x ≈ ", N[xVal, 12]];
    Print["            y ≈ ", N[yVal, 12]];

    (* Verify equation *)
    Module[{lhs},
      lhs = (nVal * xVal^2 - (nVal - 1) * yVal^2) // Simplify;
      Print["  Verify LHS = ", lhs];
    ];
    Print[];
    xVal
  ],
  {nTest, {2, 3, 5, 7, 11, 13, 17}}
];

Print[StringRepeat["=", 70]];
Print["TEST 4: Fundamental Pell solution comparison"];
Print[StringRepeat["=", 70]];
Print[];

Print["For n=13, fundamental Pell solution x^2 - 13y^2 = 1 is:"];
Module[{sol},
  sol = Solve[x^2 - 13*y^2 == 1 && x > 0 && y > 0, {x, y}, Integers, 1];
  Print["  x = ", x /. sol[[1]][[1]]];
  Print["  y = ", y /. sol[[1]][[2]]];
  Print[];

  Print["Compare to pellc[13, 1, 0, m] (c=0!) for various m:"];
  Table[
    Module[{result, xVal, yVal, mVal = mTest},
      result = pellc[13, 1, 0, mVal];
      xVal = N[x /. result[[2]], 15];
      yVal = N[y /. result[[2]], 15];
      Print["  m=", mVal, ": x ≈ ", xVal, ", y ≈ ", yVal];
      xVal
    ],
    {mTest, 1, 5}
  ];
];

Print[];
Print[StringRepeat["=", 70]];
Print["TEST 5: Analyzing the discriminant nd^2 - 1"];
Print[StringRepeat["=", 70]];
Print[];

Print["For various n and d=1:"];
Print["  Discriminant: n*1^2 - 1 = n - 1"];
Print[];
Print["  n=2:  discriminant = 1"];
Print["  n=3:  discriminant = 2"];
Print["  n=5:  discriminant = 4 = 2^2"];
Print["  n=10: discriminant = 9 = 3^2"];
Print["  n=13: discriminant = 12 = 4*3");
Print[];

Print["Testing n where n-1 is perfect square:"];
Table[
  Module[{n, result, xVal, yVal, xNum, yNum, kVal = kTest},
    n = kVal^2 + 1;
    Print["n = ", n, " = ", kVal, "^2 + 1, discriminant = ", kVal, "^2"];

    result = pellc[n, 1, 1, 2];
    xVal = x /. result[[2]];
    yVal = y /. result[[2]];
    xNum = N[xVal, 15];
    yNum = N[yVal, 15];

    Print["  x ≈ ", xNum];
    Print["  y ≈ ", yNum];

    If[Abs[xNum - Round[xNum]] < 0.001 && Abs[yNum - Round[yNum]] < 0.001,
      Print["  *** INTEGER: x = ", Round[xNum], ", y = ", Round[yNum]];

      (* Verify *)
      Module[{xInt, yInt, lhs},
        xInt = Round[xNum];
        yInt = Round[yNum];
        lhs = n * xInt^2 - (n - 1) * yInt^2;
        Print["  Verification: ", n, "*", xInt, "^2 - ", n-1, "*", yInt, "^2 = ", lhs];
      ];
    ];
    Print[];
    n
  ],
  {kTest, 1, 4}
];

Print[StringRepeat["=", 70]];
Print["TEST 6: Chebyshev limit as m → ∞"];
Print[StringRepeat["=", 70]];
Print[];

Print["For large m, T_{2m-1}(t) / U_{2m-2}(t) → t + √(t^2 - 1)"];
Print[];
Print["Testing n=13, d=1: t = √13"];
Print["  Expected limit: √13 + √(13 - 1) = √13 + √12"];
Print["  Numeric: ", N[Sqrt[13] + Sqrt[12], 15]];
Print[];

Print["pellc z-values for increasing m:"];
Table[
  Module[{z, mVal = mTest},
    z = ChebyshevT[-1 + 2 mVal, Sqrt[13]]/ChebyshevU[-2 + 2 mVal, Sqrt[13]];
    Print["  m=", mVal, ": z ≈ ", N[z, 15]];
    z
  ],
  {mTest, 1, 10}
];

Print[];
Print["Fundamental Pell regulator for n=13:"];
Module[{sol, x, y, R},
  sol = Solve[x^2 - 13*y^2 == 1 && x > 0 && y > 0, {x, y}, Integers, 1];
  x = x /. sol[[1]][[1]];
  y = y /. sol[[1]][[2]];
  R = x + y*Sqrt[13];
  Print["  R = ", x, " + ", y, "√13"];
  Print["  R ≈ ", N[R, 15]];
  Print[];
  Print["Compare: z_limit ≈ ", N[Sqrt[13] + Sqrt[12], 15]];
  Print["         R       ≈ ", N[R, 15]];
  Print["         Ratio   ≈ ", N[(Sqrt[13] + Sqrt[12])/R, 15]];
];

Print[];
Print[StringRepeat["=", 70]];
Print["CONCLUSIONS"];
Print[StringRepeat["=", 70]];
Print[];

Print["1. pellc generates algebraic (not integer) solutions in general"];
Print["2. For n-1 = perfect square, solutions might be simpler"];
Print["3. Limit as m→∞ does NOT converge to fundamental Pell regulator"];
Print["4. The (x+c)^2 term with c=1 connects to (x+1) divisibility?"];
Print["5. This is a DIFFERENT closed form than Egypt.wl iterative approach"];
Print[];
Print["Further investigation needed to understand connection to TOTAL-EVEN pattern"];

Print[StringRepeat["=", 70]];
