#!/usr/bin/env wolframscript
(*
Clean verification: Is sqrt(Denom(p - approx^2)) = Denom(S_k) * y?
*)

Print["=" <> StringRepeat["=", 69]];
Print["DENOMINATOR FORMULA VERIFICATION"];
Print["=" <> StringRepeat["=", 69]];
Print[];

term[z_, k_] := 1/(ChebyshevT[Ceiling[k/2], z+1] *
  (ChebyshevU[Floor[k/2], z+1] - ChebyshevU[Floor[k/2]-1, z+1]))

partialSum[z_, k_] := 1 + Sum[term[z, j], {j, 1, k}]

Print["HYPOTHESIS: sqrt(Denom(p - ((x-1)/y * S_k)^2)) = Denom(S_k) * y"];
Print[];
Print[StringRepeat["=", 69]];
Print["SYMBOLIC PROOF ATTEMPT"];
Print[StringRepeat["=", 69]];
Print[];

Do[
  Module[{sk, skSimp, denomSk, approx, diff, diffSimp, denomDiff, sqrtDenom,
          hypothesis, verified},
    Print["k = ", k, ":"];
    Print[];

    (* Compute S_k symbolically *)
    sk = partialSum[x, k];
    skSimp = Simplify[sk];
    denomSk = Denominator[skSimp];

    Print["  S_k = ", skSimp];
    Print["  Denom(S_k) = ", Factor[denomSk]];
    Print[];

    (* Compute p - approx^2 *)
    approx = (x-1)/y * skSimp;
    diff = p - approx^2;
    diffSimp = Simplify[diff, Assumptions -> {x^2 - p*y^2 == 1, x > 0, y > 0}];
    denomDiff = Denominator[diffSimp];

    Print["  p - approx^2 = ", diffSimp];
    Print["  Denom(p - approx^2) = ", Factor[denomDiff]];
    Print[];

    (* Test hypothesis *)
    hypothesis = (denomSk * y)^2;
    Print["  (Denom(S_k) * y)^2 = ", Factor[hypothesis]];
    Print["  Denom(p - approx^2) = ", Factor[denomDiff]];
    Print[];

    verified = Simplify[hypothesis - denomDiff,
                       Assumptions -> {x^2 - p*y^2 == 1, x > 0, y > 0}];

    If[verified == 0,
      Print["  *** VERIFIED: (Denom(S_k) * y)^2 = Denom(p - approx^2)"];
      Print["  *** Therefore: sqrt(Denom(p - approx^2)) = Denom(S_k) * y"];
      Print["  *** Denom is PERFECT SQUARE!"];
    ,
      Print["  Difference: ", Factor[verified]];
      Print["  NOT verified symbolically for general x, y, p"];

      (* But check ratio *)
      Module[{ratio},
        ratio = Simplify[denomDiff / hypothesis,
                        Assumptions -> {x^2 - p*y^2 == 1}];
        Print["  Ratio Denom(diff) / hypothesis = ", Factor[ratio]];
      ];
    ];

    Print[];
    Print[StringRepeat["-", 69]];
    Print[];
  ],
  {k, 1, 4}
];

Print[StringRepeat["=", 69]];
Print["NUMERICAL VERIFICATION WITH PELL SOLUTION"];
Print[StringRepeat["=", 69]];
Print[];

(* Test with actual Pell solution *)
n = 13;
xVal = 649;
yVal = 180;

Print["n = ", n, ", x = ", xVal, ", y = ", yVal];
Print["Verify Pell: x^2 - n*y^2 = ", xVal^2 - n*yVal^2];
Print[];

Print["k\tDenom(S_k)\tDenom(S_k)*y\tsqrt(Denom(diff))\tMatch?"];
Print[StringRepeat["-", 80]];

Do[
  Module[{sk, denomSk, hypothesis, approx, diff, denomDiff, sqrtDenom, match},
    sk = partialSum[xVal - 1, k];
    denomSk = Denominator[sk];
    hypothesis = denomSk * yVal;

    approx = (xVal - 1)/yVal * sk;
    diff = n - approx^2;
    denomDiff = Denominator[diff];
    sqrtDenom = Sqrt[denomDiff];

    match = If[IntegerQ[sqrtDenom] && sqrtDenom == hypothesis, "YES", "NO"];

    Print[k, "\t", denomSk, "\t\t", hypothesis, "\t\t",
          If[IntegerQ[sqrtDenom], sqrtDenom, "not int"], "\t", match];
  ],
  {k, 1, 8}
];

Print[];
Print[StringRepeat["=", 69]];
