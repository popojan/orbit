#!/usr/bin/env wolframscript
(*
Test if pattern holds for perfect squares with trivial Pell solution (1, 0)
*)

Print["=" <> StringRepeat["=", 69]];
Print["PERFECT SQUARE TEST WITH TRIVIAL SOLUTION"];
Print["=" <> StringRepeat["=", 69]];
Print[];

term[z_, k_] := 1/(ChebyshevT[Ceiling[k/2], z+1] *
  (ChebyshevU[Floor[k/2], z+1] - ChebyshevU[Floor[k/2]-1, z+1]))

partialSum[z_, k_] := 1 + Sum[term[z, j], {j, 1, k}]

(* Test perfect squares with trivial solution x=1, y=0 *)
perfectSquares = {4, 9, 16, 25, 36, 49};

Print["For perfect square n = k^2:"];
Print["  Trivial Pell solution: x = 1, y = 0"];
Print["  Check: 1^2 - k^2 * 0^2 = 1 ✓"];
Print[];

Do[
  Module[{n, k, x, y},
    n = ps;
    k = Sqrt[n];
    x = 1;
    y = 0;

    Print["n = ", n, " = ", k, "^2"];
    Print["  x = ", x, ", y = ", y];
    Print["  x - 1 = ", x - 1];
    Print["  x + 1 = ", x + 1];
    Print[];

    (* Compute terms at x-1 = 0 *)
    Print["  Computing term(0, j):"];
    Do[
      Module[{t},
        t = term[0, j];
        Print["    term(0, ", j, ") = ", t];
      ],
      {j, 1, 5}
    ];
    Print[];

    (* Compute partial sums *)
    Print["  k\tTotal\tS_k\t\tNumerator\t(x+1)|num?"];
    Print["  ", StringRepeat["-", 60]];
    Do[
      Module[{sk, num, divisible},
        sk = partialSum[0, kk];
        num = Numerator[sk];
        divisible = Divisible[num, x + 1];  (* x+1 = 2 *)

        Print["  ", kk, "\t", kk+1, "\t", sk, "\t\t", num, "\t\t", divisible];
      ],
      {kk, 1, 8}
    ];

    Print[];

    (* Check pattern *)
    Module[{results},
      results = Table[
        Module[{sk, num, totalTerms, expectedDivisible, actualDivisible},
          sk = partialSum[0, kk];
          num = Numerator[sk];
          totalTerms = kk + 1;
          expectedDivisible = EvenQ[totalTerms];
          actualDivisible = Divisible[num, 2];  (* x+1 = 2 *)

          {kk, totalTerms, expectedDivisible, actualDivisible,
           expectedDivisible == actualDivisible}
        ],
        {kk, 1, 8}
      ];

      Print["  Pattern check:"];
      Print["  k\tTotal\tExpected div?\tActual div?\tMatch?"];
      Print["  ", StringRepeat["-", 60]];
      Do[
        Print["  ", row[[1]], "\t", row[[2]], "\t", row[[3]], "\t\t",
              row[[4]], "\t\t", row[[5]]],
        {row, results}
      ];

      Module[{matches, total},
        matches = Count[results, {_, _, _, _, True}];
        total = Length[results];
        Print[];
        If[matches == total,
          Print["  *** PATTERN HOLDS for n=", n, " ***"];
        ,
          Print["  *** PATTERN FAILS for n=", n, " (", matches, "/", total, ") ***"];
        ];
      ];
    ];

    Print[];
    Print[StringRepeat["-", 69]];
    Print[];
  ],
  {ps, perfectSquares}
];

Print[StringRepeat["=", 69]];
Print["CONCLUSION"];
Print[StringRepeat["=", 69]];
Print[];

Print["For perfect squares n = k^2 with trivial solution x=1, y=0:"];
Print["  - term(0, j) evaluates to simple values"];
Print["  - Pattern may or may not hold"];
Print[];
Print["Testing whether 'non-square' condition is NECESSARY...");
Print[];

Print[StringRepeat["=", 69]];
