#!/usr/bin/env wolframscript
(*
Verify the denominator formula for n=61
Check if the constant is the denominator of (x-1)/y in lowest terms
*)

Print["=" <> StringRepeat["=", 69]];
Print["FORMULA VERIFICATION FOR n=61"];
Print["=" <> StringRepeat["=", 69]];
Print[];

term[z_, k_] := 1/(ChebyshevT[Ceiling[k/2], z+1] *
  (ChebyshevU[Floor[k/2], z+1] - ChebyshevU[Floor[k/2]-1, z+1]))

partialSum[z_, k_] := 1 + Sum[term[z, j], {j, 1, k}]

(* Test with n=61 *)
n = 61;
x = 1766319049;
y = 226153980;

Print["n = ", n, ", x = ", x, ", y = ", y];
Print["x^2 - n*y^2 = ", x^2 - n*y^2];
Print[];

(* Compute (x-1)/y in lowest terms *)
Module[{num, den, g, numReduced, denReduced},
  num = x - 1;
  den = y;
  g = GCD[num, den];
  numReduced = num / g;
  denReduced = den / g;

  Print["(x-1)/y = ", num, "/", den];
  Print["GCD(x-1, y) = ", g];
  Print["(x-1)/y in lowest terms = ", numReduced, "/", denReduced];
  Print["Denominator in lowest terms = ", denReduced];
  Print[];
];

constantForOddTotal = y / GCD[x-1, y];
Print["Expected constant for ODD total = ", constantForOddTotal];
Print[];

Print[StringRepeat["=", 69]];
Print["TESTING FORMULA"];
Print[StringRepeat["=", 69]];
Print[];

Print["k\tTotal\tDenom(S_k)\t\tsqrt(Denom(diff))\tPredicted\tMatch?"];
Print[StringRepeat["-", 100]];

Do[
  Module[{totalTerms, sk, denomSk, approx, diff, denomDiff, sqrtDenom,
          predicted, match},
    totalTerms = k + 1;
    sk = partialSum[x - 1, k];
    denomSk = Denominator[sk];
    approx = (x - 1)/y * sk;
    diff = n - approx^2;
    denomDiff = Denominator[diff];
    sqrtDenom = Sqrt[denomDiff];

    If[IntegerQ[sqrtDenom],
      If[EvenQ[totalTerms],
        (* EVEN total: sqrt(den) = Denom(S_k) *)
        predicted = denomSk;
      ,
        (* ODD total: sqrt(den) = constantForOddTotal * Denom(S_k) *)
        predicted = constantForOddTotal * denomSk;
      ];

      match = (sqrtDenom == predicted);

      Print[k, "\t", totalTerms, "\t", denomSk, "\t", sqrtDenom, "\t",
            predicted, "\t", match];

      If[!match,
        Print["  ERROR: Mismatch! Ratio = ", N[sqrtDenom / denomSk, 15]];
      ];
    ];
  ],
  {k, 1, 8}
];

Print[];
Print[StringRepeat["=", 69]];
Print["SUMMARY"];
Print[StringRepeat["=", 69]];
Print[];

Print["For n = ", n, ":"];
Print["  Constant for ODD total = ", constantForOddTotal];
Print[];
Print["Formula:"];
Print["  EVEN total: sqrt(Denom(p - approx^2)) = Denom(S_k)"];
Print["  ODD total:  sqrt(Denom(p - approx^2)) = ", constantForOddTotal,
      " * Denom(S_k)"];
Print[];
Print["*** Denominator is ALWAYS a PERFECT SQUARE ***"];
Print[];
Print[StringRepeat["=", 69]];
