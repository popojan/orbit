#!/usr/bin/env wolframscript
(*
Find exact relation between Denom(S_k) and sqrt(Denom(diff))
*)

Print["=" <> StringRepeat["=", 69]];
Print["EXACT RELATION SEARCH"];
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
Print[];

Print["k\tTotal\tDenom(S_k)\t\tsqrt(Denom(diff))\tRatio\t\tRatio simplified"];
Print[StringRepeat["-", 100]];

Do[
  Module[{totalTerms, sk, denomSk, approx, diff, denomDiff, sqrtDenom, ratio, ratioSimp},
    totalTerms = k + 1;
    sk = partialSum[x - 1, k];
    denomSk = Denominator[sk];

    approx = (x - 1)/y * sk;
    diff = n - approx^2;
    denomDiff = Denominator[diff];
    sqrtDenom = Sqrt[denomDiff];

    If[IntegerQ[sqrtDenom],
      ratio = sqrtDenom / denomSk;
      ratioSimp = Simplify[ratio];

      Print[k, "\t", totalTerms, "\t", denomSk, "\t\t", sqrtDenom, "\t\t",
            N[ratio, 10], "\t", ratioSimp];
    ];
  ],
  {k, 1, 10}
];

Print[];
Print[StringRepeat["=", 69]];
Print["PATTERN ANALYSIS"];
Print[StringRepeat["=", 69]];
Print[];

(* Separate by parity *)
Print["ODD k (EVEN total):"];
Do[
  Module[{sk, denomSk, approx, diff, denomDiff, sqrtDenom, ratio},
    sk = partialSum[x - 1, k];
    denomSk = Denominator[sk];
    approx = (x - 1)/y * sk;
    diff = n - approx^2;
    denomDiff = Denominator[diff];
    sqrtDenom = Sqrt[denomDiff];

    If[IntegerQ[sqrtDenom],
      ratio = sqrtDenom / denomSk;
      Print["  k=", k, ": sqrt(den) = ", sqrtDenom, ", Denom(S_k) = ", denomSk,
            ", ratio = ", ratio];
      If[ratio == 1,
        Print["    *** EXACT MATCH: sqrt(den) = Denom(S_k)"];
      ];
    ];
  ],
  {k, 1, 10, 2}
];

Print[];
Print["EVEN k (ODD total):"];
Do[
  Module[{sk, denomSk, approx, diff, denomDiff, sqrtDenom, ratio},
    sk = partialSum[x - 1, k];
    denomSk = Denominator[sk];
    approx = (x - 1)/y * sk;
    diff = n - approx^2;
    denomDiff = Denominator[diff];
    sqrtDenom = Sqrt[denomDiff];

    If[IntegerQ[sqrtDenom],
      ratio = sqrtDenom / denomSk;
      Print["  k=", k, ": sqrt(den) = ", sqrtDenom, ", Denom(S_k) = ", denomSk,
            ", ratio = ", ratio];

      (* Check what this ratio might be *)
      Module[{checkVals},
        checkVals = {
          {"ratio", ratio},
          {"ratio / 5", ratio / 5},
          {"ratio * y", ratio * y},
          {"ratio / y", ratio / y},
          {"ratio / x", ratio / x},
          {"Floor[Sqrt[n]]", Floor[Sqrt[n]]},
          {"Floor[Sqrt[n]] + 1", Floor[Sqrt[n]] + 1}
        };
        Do[
          Module[{name, val},
            {name, val} = checkVal;
            If[val == 1 || val == Floor[Sqrt[n]] || val == Floor[Sqrt[n]] + 1,
              Print["    ", name, " = ", val];
            ];
          ],
          {checkVal, checkVals}
        ];
      ];
    ];
  ],
  {k, 2, 10, 2}
];

Print[];
Print[StringRepeat["=", 69]];
Print["TESTING FORMULA: sqrt(den) = Denom(S_k) * [parity-dependent factor]"];
Print[StringRepeat["=", 69]];
Print[];

(* Hypothesis:
   - ODD k (EVEN total): sqrt(den) = Denom(S_k)
   - EVEN k (ODD total): sqrt(den) = Denom(S_k) * (something)
*)

Print["Testing hypothesis..."];
Print[];

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
      If[OddQ[totalTerms],
        (* ODD total - predict sqrt(den) = Denom(S_k) * X *)
        Module[{factor},
          factor = sqrtDenom / denomSk;
          Print["k=", k, " (ODD total): factor = ", factor,
                " = ", N[factor, 15]];
        ];
      ,
        (* EVEN total - predict sqrt(den) = Denom(S_k) *)
        predicted = denomSk;
        match = (sqrtDenom == predicted);
        Print["k=", k, " (EVEN total): predicted = ", predicted,
              ", actual = ", sqrtDenom, ", match = ", match];
      ];
    ];
  ],
  {k, 1, 10}
];

Print[];
Print[StringRepeat["=", 69]];
