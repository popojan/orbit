#!/usr/bin/env wolframscript
(* Compute sequence of numerators/denominators for OEIS *)

Print["================================================================"];
Print["OEIS SEQUENCE: F_p(3, eps=0) for primes p"];
Print["================================================================"];
Print[""];

(* Function to compute F_n at eps=0 symbolically *)
FnSymbolic[n_, alpha_, dMax_: 10, kMax_: 30] := Module[
  {terms, d, k, dist, eps},

  (* Collect all non-zero distance terms *)
  terms = Flatten[Table[
    dist = n - k*d - d^2;
    If[Abs[dist] < 100 && dist != 0,
      (dist^2 + eps)^(-alpha),
      Nothing
    ],
    {d, 2, Min[dMax, Floor[Sqrt[n]] + 5]},
    {k, 0, kMax}
  ]];

  (* Take limit eps->0 *)
  Total[Limit[#, eps -> 0] & /@ terms]
]

Print["Computing F_p(3) for first several primes..."];
Print["This will take time for larger primes"];
Print[""];

primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31};

results = Table[
  Module[{fp, num, den},
    Print["Computing p=", p, "..."];
    fp = FnSymbolic[p, 3];
    num = Numerator[fp];
    den = Denominator[fp];
    {p, fp, num, den, N[fp, 15]}
  ],
  {p, primes}
];

Print[""];
Print["RESULTS:"];
Print[""];
Print["p\tNumerator\t\t\tDenominator\t\t\tValue"];
Print[StringRepeat["-", 100]];

Do[
  Print[results[[i, 1]], "\t",
    If[results[[i, 3]] < 10^20,
      results[[i, 3]],
      ScientificForm[results[[i, 3]], 5]
    ], "\t",
    If[results[[i, 4]] < 10^20,
      results[[i, 4]],
      ScientificForm[results[[i, 4]], 5]
    ], "\t",
    results[[i, 5]]
  ],
  {i, 1, Length[results]}
];
Print[""];

(* Extract sequences *)
numerators = results[[All, 3]];
denominators = results[[All, 4]];

Print["SEQUENCE A: Numerators"];
Print[numerators];
Print[""];

Print["SEQUENCE B: Denominators"];
Print[denominators];
Print[""];

(* Look for patterns *)
Print["================================================================"];
Print["PATTERN ANALYSIS"];
Print["================================================================"];
Print[""];

Print["GCD of numerators:"];
gcdNums = GCD @@ numerators;
Print["  ", gcdNums];
Print[""];

Print["GCD of denominators:"];
gcdDens = GCD @@ denominators;
Print["  ", gcdDens];
Print[""];

Print["Factorizations of small numerators:"];
Do[
  If[results[[i, 3]] < 10^10,
    Print["  F_", results[[i, 1]], " numerator: ",
      FactorInteger[results[[i, 3]]]];
  ],
  {i, 1, Min[5, Length[results]]}
];
Print[""];

Print["Factorizations of small denominators:"];
Do[
  If[results[[i, 4]] < 10^10,
    Print["  F_", results[[i, 1]], " denominator: ",
      FactorInteger[results[[i, 4]]]];
  ],
  {i, 1, Min[5, Length[results]]}
];
Print[""];

(* Check for relationship with p *)
Print["Checking if numerator/denominator relates to p:"];
Print[""];
Print["p\tnum/p^k\t\tden/p^k"];
Print[StringRepeat["-", 50]];
Do[
  Module[{p, num, den, powNum, powDen},
    p = results[[i, 1]];
    num = results[[i, 3]];
    den = results[[i, 4]];

    (* Find highest power of p dividing num and den *)
    powNum = 0;
    While[Mod[num, p^(powNum+1)] == 0 && powNum < 20, powNum++];
    powDen = 0;
    While[Mod[den, p^(powDen+1)] == 0 && powDen < 20, powDen++];

    Print[p, "\tp^", powNum, "\t\tp^", powDen];
  ],
  {i, 1, Min[8, Length[results]]}
];
Print[""];

Print["================================================================"];
Print["FOR OEIS SUBMISSION"];
Print["================================================================"];
Print[""];

Print["Sequence A: Numerators of F_p(3, eps=0) for primes p"];
Print["  ", Take[numerators, Min[10, Length[numerators]]]];
Print[""];

Print["Sequence B: Denominators of F_p(3, eps=0) for primes p"];
Print["  ", Take[denominators, Min[10, Length[denominators]]]];
Print[""];

Print["Formula: F_p(3) = Sum over (d,k) of |p-kd-d^2|^(-6)"];
Print["         where sum excludes terms with p-kd-d^2 = 0"];
Print[""];

Print["First few values (decimal):"];
Do[
  Print["  F_", results[[i, 1]], " = ", N[results[[i, 2]], 20]],
  {i, 1, Min[8, Length[results]]}
];
Print[""];

(* Check if already in OEIS *)
Print["To check if sequence exists in OEIS:");
Print["  Visit: https://oeis.org/"];
Print["  Search: ", Take[numerators, Min[6, Length[numerators]]]];
Print[""];
