#!/usr/bin/env wolframscript
(*
Test stride-2 recurrence hypothesis: a[n] = 2x * a[n-2]
Also test connection to denominator of S_k
*)

Print["=" <> StringRepeat["=", 69]];
Print["STRIDE-2 RECURRENCE TEST"];
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

(* Compute sqrt(den) sequence *)
sqrtDens = Table[
  Module[{sk, approx, diff, den, sqrtDen},
    sk = partialSum[x - 1, k];
    approx = (x - 1)/y * sk;
    diff = n - approx^2;
    den = Denominator[diff];
    sqrtDen = Sqrt[den];
    If[IntegerQ[sqrtDen], sqrtDen, Null]
  ],
  {k, 1, 10}
];

Print["sqrt(den) sequence:"];
Do[
  Print["  k=", k, ": ", sqrtDens[[k]]],
  {k, 1, Length[sqrtDens]}
];
Print[];

Print[StringRepeat["=", 69]];
Print["TESTING STRIDE-2 RECURRENCE: a[n] = C * a[n-2]"];
Print[StringRepeat["=", 69]];
Print[];

(* Test separately for even and odd k *)
Print["For EVEN k (ODD total):"];
evenK = Table[sqrtDens[[k]], {k, 2, Length[sqrtDens], 2}];
Do[
  If[i+1 <= Length[evenK],
    Module[{ratio},
      ratio = evenK[[i+1]] / evenK[[i]];
      Print["  a[", 2*i+2, "] / a[", 2*i, "] = ", ratio, " = ", N[ratio/x, 10], " * x"];
    ];
  ],
  {i, 1, Length[evenK]-1}
];
Print[];

Print["For ODD k (EVEN total):"];
oddK = Table[sqrtDens[[k]], {k, 1, Length[sqrtDens], 2}];
Do[
  If[i+1 <= Length[oddK],
    Module[{ratio},
      ratio = oddK[[i+1]] / oddK[[i]];
      Print["  a[", 2*i-1, "] / a[", 2*i+1, "] = ", ratio, " = ", N[ratio/x, 10], " * x"];
    ];
  ],
  {i, 1, Length[oddK]-1}
];
Print[];

Print[StringRepeat["=", 69]];
Print["CONNECTION TO DENOMINATOR OF S_k"];
Print[StringRepeat["=", 69]];
Print[];

Print["k\tTotal\tDenom(S_k)\t\tsqrt(den_diff)\t\tProduct"];
Print[StringRepeat["-", 80]];

Do[
  Module[{sk, denomSk, sqrtDenDiff, product},
    sk = partialSum[x - 1, k];
    denomSk = Denominator[sk];
    sqrtDenDiff = sqrtDens[[k]];
    product = denomSk * y;

    Print[k, "\t", k+1, "\t", denomSk, "\t\t", sqrtDenDiff, "\t\t", product];
    If[product == sqrtDenDiff,
      Print["  *** MATCH: Denom(S_k) * y = sqrt(den_diff)"];
    ];
  ],
  {k, 1, Min[8, Length[sqrtDens]]}
];

Print[];
Print[StringRepeat["=", 69]];
Print["SYMBOLIC VERIFICATION"];
Print[StringRepeat["=", 69]];
Print[];

(* Symbolic check for small k *)
Do[
  Module[{sk, approx, diff, diffSimp, denDiff, sqrtDenDiff, denomSk, product},
    Print["k = ", k, ":"];

    sk = partialSum[x, k];
    denomSk = Denominator[Simplify[sk]];
    Print["  Denom(S_k) = ", Factor[denomSk]];

    (* Full expression *)
    approx = (x-1)/y * sk;
    diff = p - approx^2;
    diffSimp = Simplify[diff, Assumptions -> {x^2 - p*y^2 == 1}];
    denDiff = Denominator[diffSimp];
    Print["  Denom(p - approx^2) = ", Factor[denDiff]];

    sqrtDenDiff = Sqrt[denDiff];
    Print["  Sqrt[denom] = ", Simplify[sqrtDenDiff]];

    product = Simplify[denomSk * y];
    Print["  Denom(S_k) * y = ", Factor[product]];

    If[Simplify[product^2 - denDiff] == 0,
      Print["  *** VERIFIED: (Denom(S_k) * y)^2 = Denom(p - approx^2)"];
    ];

    Print[];
  ],
  {k, 1, 4}
];

Print[StringRepeat["=", 69]];
