#!/usr/bin/env wolframscript
(*
Test Egypt.wl pattern on COMPOSITE numbers
Goal: Understand why primality is needed
*)

Print["=" <> StringRepeat["=", 69]];
Print["COMPOSITE NUMBER ANALYSIS"];
Print["=" <> StringRepeat["=", 69]];
Print[];

term[z_, k_] := 1/(ChebyshevT[Ceiling[k/2], z+1] *
  (ChebyshevU[Floor[k/2], z+1] - ChebyshevU[Floor[k/2]-1, z+1]))

partialSum[z_, k_] := 1 + Sum[term[z, j], {j, 1, k}]

TestDivisibility[n_, x_, y_, kMax_:8] := Module[{results},
  results = Table[
    Module[{totalTerms, sk, approx, num, numMod, divisible},
      totalTerms = k + 1;
      sk = partialSum[x - 1, k];
      approx = (x - 1)/y * sk;
      num = Numerator[approx];
      numMod = Mod[num, n];
      divisible = (numMod == 0);

      {k, totalTerms, EvenQ[totalTerms], numMod, divisible}
    ],
    {k, 1, kMax}
  ];
  results
];

(* Test composite numbers *)
compositeTests = {
  {6, 5, 2},      (* 6 = 2×3 *)
  {10, 19, 6},    (* 10 = 2×5 *)
  {15, 4, 1},     (* 15 = 3×5 *)
  {21, 55, 12},   (* 21 = 3×7 *)
  {22, 197, 42},  (* 22 = 2×11 *)
  {26, 51, 10},   (* 26 = 2×13 *)
  {35, 6, 1},     (* 35 = 5×7 *)
  {39, 25, 4}     (* 39 = 3×13 *)
};

Print["Testing composite numbers..."];
Print[];

Do[
  Module[{n, x, y, results, factorization},
    {n, x, y} = test;
    factorization = FactorInteger[n];

    Print["n = ", n, " = ", Times @@ (Power @@@ factorization), ", x = ", x, ", y = ", y];
    Print["Verify Pell: x^2 - n*y^2 = ", x^2 - n*y^2];
    Print["x mod n = ", Mod[x, n]];
    Print["x ≡ -1 (mod n)? ", Mod[x, n] == n - 1];
    Print[];

    results = TestDivisibility[n, x, y, 8];

    Print["k\tTotal\tEVEN?\tnum mod n\tDivisible?"];
    Print[StringRepeat["-", 60]];
    Do[
      Print[row[[1]], "\t", row[[2]], "\t", row[[3]], "\t", row[[4]], "\t\t", row[[5]]],
      {row, results}
    ];

    (* Check if EVEN total pattern holds *)
    Module[{evenTotalResults, oddTotalResults},
      evenTotalResults = Select[results, #[[3]] == True &];
      oddTotalResults = Select[results, #[[3]] == False &];

      Module[{evenDivisible, oddDivisible},
        evenDivisible = Count[evenTotalResults, {_, _, _, _, True}];
        oddDivisible = Count[oddTotalResults, {_, _, _, _, True}];

        Print[];
        Print["Pattern check:"];
        Print["  EVEN total divisible: ", evenDivisible, "/", Length[evenTotalResults]];
        Print["  ODD total divisible: ", oddDivisible, "/", Length[oddTotalResults]];

        If[evenDivisible == Length[evenTotalResults] && oddDivisible == 0,
          Print["  *** PATTERN HOLDS for n=", n, " ***"];
        ,
          Print["  *** PATTERN FAILS for n=", n, " ***"];
        ];
      ];
    ];

    Print[];
    Print[StringRepeat["-", 69]];
    Print[];
  ],
  {test, compositeTests}
];

Print[StringRepeat["=", 69]];
Print["PRIME POWERS"];
Print[StringRepeat["=", 69]];
Print[];

(* Test prime powers *)
primePowerTests = {
  {4, 2, 1},      (* 4 = 2^2 *)
  {9, 19, 6},     (* 9 = 3^2, (wait - 19^2 - 9*6^2 = 361-324 = 37 ≠ 1) *)
  {8, 3, 1},      (* 8 = 2^3 *)
  {25, 5, 1},     (* 25 = 5^2, but 5^2 - 25*1^2 = 0 ≠ 1 *)
  {27, 26, 5}     (* 27 = 3^3 *)
};

(* Let me find correct Pell solutions *)
Print["Finding fundamental Pell solutions for small composite numbers..."];
Print[];

compositeN = {6, 10, 15, 21, 22, 26, 35, 39};

Do[
  Module[{sol},
    sol = Solve[x^2 - n*y^2 == 1 && x > 0 && y > 0 && x < 10^10, {x, y}, Integers];
    If[Length[sol] > 0,
      Module[{xVal, yVal},
        {xVal, yVal} = {x, y} /. sol[[1]];
        Print["n = ", n, ": (x,y) = (", xVal, ", ", yVal, ")"];
        Print["  x mod n = ", Mod[xVal, n], ", x ≡ -1? ", Mod[xVal, n] == n - 1];
      ];
    ,
      Print["n = ", n, ": NO SOLUTION FOUND"];
    ];
  ],
  {n, compositeN}
];

Print[];
Print[StringRepeat["=", 69]];
