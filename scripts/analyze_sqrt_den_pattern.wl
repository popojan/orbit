#!/usr/bin/env wolframscript
(*
Analyze pattern in sqrt(denominator) - is it related to Chebyshev polynomials?
*)

Print["=" <> StringRepeat["=", 69]];
Print["SQRT(DENOMINATOR) PATTERN ANALYSIS"];
Print["=" <> StringRepeat["=", 69]];
Print[];

term[z_, k_] := 1/(ChebyshevT[Ceiling[k/2], z+1] *
  (ChebyshevU[Floor[k/2], z+1] - ChebyshevU[Floor[k/2]-1, z+1]))

partialSum[z_, k_] := 1 + Sum[term[z, j], {j, 1, k}]

(* Test with n=13 *)
n = 13;
x = 649;
y = 180;

Print["n = ", n, ", x = ", x, ", y = ", y];
Print["x^2 - n*y^2 = ", x^2 - n*y^2];
Print[];

sqrtDens = {};

Print["k\tTotal\tsqrt(den)\t\tRatio to x\tRatio to prev"];
Print[StringRepeat["-", 80]];

Do[
  Module[{sk, approx, diff, den, sqrtDen, ratioToX, ratioToPrev},
    sk = partialSum[x - 1, k];
    approx = (x - 1)/y * sk;
    diff = n - approx^2;
    den = Denominator[diff];
    sqrtDen = Sqrt[den];

    If[IntegerQ[sqrtDen],
      ratioToX = N[sqrtDen / x, 15];
      ratioToPrev = If[Length[sqrtDens] > 0,
        N[sqrtDen / Last[sqrtDens], 15],
        "N/A"
      ];

      Print[k, "\t", k+1, "\t", sqrtDen, "\t", ratioToX, "\t", ratioToPrev];
      AppendTo[sqrtDens, sqrtDen];
    ];
  ],
  {k, 1, 8}
];

Print[];
Print[StringRepeat["=", 69]];
Print["TESTING CHEBYSHEV POLYNOMIAL HYPOTHESIS"];
Print[StringRepeat["=", 69]];
Print[];

(* Check if sqrt(den) matches some Chebyshev polynomial evaluated at x-1 or x+1 *)
Print["Testing if sqrt(den) = poly(x) for some polynomial..."];
Print[];

Do[
  Module[{sqrtDen, testVals},
    sqrtDen = sqrtDens[[k]];

    Print["k = ", k, ", sqrt(den) = ", sqrtDen];

    (* Test Chebyshev T at various arguments *)
    testVals = {
      {"T_k(x)", ChebyshevT[k, x]},
      {"T_k(x-1)", ChebyshevT[k, x-1]},
      {"T_k(x+1)", ChebyshevT[k, x+1]},
      {"U_k(x)", ChebyshevU[k, x]},
      {"U_k(x-1)", ChebyshevU[k, x-1]},
      {"U_k(x+1)", ChebyshevU[k, x+1]},
      {"y*T_k(x)", y * ChebyshevT[k, x]},
      {"y*U_k(x)", y * ChebyshevU[k, x]},
      {"Denom of S_k", Denominator[partialSum[x-1, k]] * y}
    };

    Do[
      Module[{name, val},
        {name, val} = testVal;
        If[val == sqrtDen,
          Print["  *** MATCH: ", name, " = ", val];
        ];
      ],
      {testVal, testVals}
    ];

    Print[];
  ],
  {k, 1, Min[5, Length[sqrtDens]]}
];

Print[StringRepeat["=", 69]];
Print["TESTING RECURRENCE RELATION"];
Print[StringRepeat["=", 69]];
Print[];

(* Check if sqrt(den) satisfies a linear recurrence *)
If[Length[sqrtDens] >= 4,
  Print["Testing linear recurrences of the form:"];
  Print["  a[n] = c1*a[n-1] + c2*a[n-2]"];
  Print[];

  Do[
    Module[{a1, a2, a3, c1, c2, predicted},
      a1 = sqrtDens[[k-2]];
      a2 = sqrtDens[[k-1]];
      a3 = sqrtDens[[k]];

      (* Try to find c1, c2 *)
      (* a3 = c1*a2 + c2*a1 *)
      (* We can solve for c1, c2 if we have enough terms *)

      If[k <= Length[sqrtDens],
        Module[{a4},
          a4 = sqrtDens[[k+1]];
          (* System: a3 = c1*a2 + c2*a1 *)
          (*         a4 = c1*a3 + c2*a2 *)

          Module[{sol},
            sol = Solve[{a3 == c1*a2 + c2*a1, a4 == c1*a3 + c2*a2}, {c1, c2}];
            If[Length[sol] > 0,
              Module[{c1Val, c2Val},
                c1Val = c1 /. sol[[1]];
                c2Val = c2 /. sol[[1]];
                Print["k=", k, ": c1 = ", N[c1Val, 10], ", c2 = ", N[c2Val, 10]];

                (* Try to relate to x, y, n *)
                Print["  c1 in terms of x? ", Simplify[c1Val - 2*x]];
                Print["  c1 = 2x? ", c1Val == 2*x];
                Print["  c2? ", c2Val];
              ];
            ];
          ];
        ];
      ];
    ],
    {k, 3, Min[5, Length[sqrtDens]-1]}
  ];
];

Print[];
Print[StringRepeat["=", 69]];
