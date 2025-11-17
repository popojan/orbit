#!/usr/bin/env wolframscript
(*
Analyze algebraic structure of the denominator in p - ((x-1)/y * S_k)^2
Try to find explicit formula proving it's always a perfect square
*)

Print["=" <> StringRepeat["=", 69]];
Print["ALGEBRAIC DENOMINATOR STRUCTURE ANALYSIS"];
Print["=" <> StringRepeat["=", 69]];
Print[];

term[z_, k_] := 1/(ChebyshevT[Ceiling[k/2], z+1] *
  (ChebyshevU[Floor[k/2], z+1] - ChebyshevU[Floor[k/2]-1, z+1]))

partialSum[z_, k_] := 1 + Sum[term[z, j], {j, 1, k}]

(* Symbolic analysis *)
Print["SYMBOLIC ANALYSIS (small k)"];
Print[StringRepeat["-", 70]];
Print[];

Do[
  Module[{sk, skSimp, denom},
    Print["k = ", k, ":"];
    sk = partialSum[x, k];
    skSimp = Simplify[sk];
    denom = Denominator[skSimp];

    Print["  S_k = ", skSimp];
    Print["  Denominator of S_k = ", denom];
    Print["  Factor[denom] = ", Factor[denom]];

    (* Now compute the full expression (x-1)/y * S_k *)
    Module[{fullExpr, fullSimp, fullDenom},
      fullExpr = (x-1)/y * skSimp;
      fullSimp = Simplify[fullExpr];
      fullDenom = Denominator[fullSimp];
      Print["  Denominator of (x-1)/y * S_k = ", Factor[fullDenom]];
    ];

    (* Now p - ((x-1)/y * S_k)^2 *)
    Module[{diffExpr, diffSimp, diffDenom, factored},
      diffExpr = p - ((x-1)/y * skSimp)^2;
      diffSimp = Simplify[diffExpr, Assumptions -> {x^2 - p*y^2 == 1}];
      diffDenom = Denominator[diffSimp];
      factored = Factor[diffDenom];

      Print["  Denominator of (p - approx^2) = ", factored];

      (* Check if it's a perfect square symbolically *)
      Module[{sqrtDenom, simplified},
        sqrtDenom = Sqrt[diffDenom];
        simplified = Simplify[sqrtDenom];
        Print["  Sqrt[denom] = ", simplified];
        Print["  Is polynomial? ", PolynomialQ[simplified, {x, y}]];
      ];
    ];

    Print[];
  ],
  {k, 1, 4}
];

Print[];
Print["=" <> StringRepeat["=", 69]];
Print["NUMERICAL VERIFICATION WITH PELL CONSTRAINT"];
Print["=" <> StringRepeat["=", 69]];
Print[];

(* Test with actual Pell solutions *)
testCases = {
  {13, 649, 180},
  {61, 1766319049, 226153980}
};

Do[
  Module[{n, x, y},
    {n, x, y} = testCase;
    Print["n = ", n, ", x = ", x, ", y = ", y];
    Print["Verify Pell: x^2 - n*y^2 = ", x^2 - n*y^2];
    Print[];

    Do[
      Module[{sk, approx, diff, num, den, sqrtDen, isPerfSq},
        sk = partialSum[x - 1, k];
        approx = (x - 1)/y * sk;
        diff = n - approx^2;

        num = Numerator[diff];
        den = Denominator[diff];
        sqrtDen = Sqrt[den];
        isPerfSq = IntegerQ[sqrtDen];

        Print["  k=", k, ": den = ", den];
        Print["       sqrt(den) = ", If[isPerfSq, sqrtDen, "NOT INTEGER"]];
        Print["       Perfect square? ", isPerfSq];

        If[isPerfSq,
          Print["       sqrt(den) / y = ", N[sqrtDen / y, 10]];
        ];
        Print[];
      ],
      {k, 1, 5}
    ];

    Print[StringRepeat["-", 70]];
    Print[];
  ],
  {testCase, testCases}
];

Print["=" <> StringRepeat["=", 69]];
