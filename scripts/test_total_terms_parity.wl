#!/usr/bin/env wolframscript
(*
Test divisibility by TOTAL number of terms (including leading 1)
*)

Print["=" * 70];
Print["TOTAL TERMS PARITY TEST"];
Print["=" * 70];
Print[];

term[x_, k_] := 1/(ChebyshevT[Ceiling[k/2], x+1] *
                    (ChebyshevU[Floor[k/2], x+1] - ChebyshevU[Floor[k/2]-1, x+1]))

(* f with k terms AFTER the 1 *)
f[x_, k_] := 1 + Sum[term[x, j], {j, 1, k}]

TestTotalTerms[n_, x_, y_] := Module[{},
  Print["n = ", n, ", x = ", x];
  Print[];

  Print["k\tTotal\tParity\tNumerator mod n\tDivisible?"];
  Print["-" * 70];

  Do[
    Module[{totalTerms, parity, fullExpr, num, modVal, divisible},
      totalTerms = k + 1;  (* k terms + leading 1 *)
      parity = If[EvenQ[totalTerms], "EVEN", "ODD"];
      fullExpr = (x - 1)/y * f[x - 1, k];

      If[Head[fullExpr] === Rational,
        num = Numerator[fullExpr];
        modVal = Mod[num, n];
        divisible = (modVal == 0);
        Print[k, "\t", totalTerms, "\t", parity, "\t", modVal, "\t\t", divisible];
      ,
        Print[k, "\t", totalTerms, "\t", parity, "\t", "?", "\t\t", "?"];
      ];
    ],
    {k, 1, 10}
  ];

  Print[];
];

Print["=" * 70];
Print["n=13"];
Print["=" * 70];
Print[];
TestTotalTerms[13, 649, 180];

Print["=" * 70];
Print["n=61"];
Print["=" * 70];
Print[];
TestTotalTerms[61, 1766319049, 226153980];

Print["=" * 70];
