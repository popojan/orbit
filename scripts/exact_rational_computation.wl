#!/usr/bin/env wolframscript
(* Compute EXACT rational for n=5 using Wolfram's symbolic limit *)

Print["================================================================"];
Print["EXACT RATIONAL COMPUTATION: n=5, alpha=3"];
Print["================================================================"];
Print[""];

Print["Using symbolic limit approach (epsilon -> 0)"];
Print[""];

n = 5;
alpha = 3;

Print["Collecting terms with symbolic epsilon..."];
Print[""];

(* Collect terms symbolically *)
terms = {};

Print["Range: d from 2 to ", Floor[Sqrt[n]] + 10];
Print["       k from 0 to 50"];
Print[""];

For[d = 2, d <= Floor[Sqrt[n]] + 10, d++,
  For[k = 0, k <= 50, k++,
    Module[{dist},
      dist = n - k*d - d^2;
      If[dist != 0 && Abs[dist] < 200,
        AppendTo[terms, {d, k, dist, (dist^2 + eps)^(-alpha)}];
      ];
    ];
  ];
];

Print["Collected ", Length[terms], " terms"];
Print[""];

Print["Taking limit eps -> 0 for each term..."];
Print[""];

limitedTerms = Table[
  Limit[terms[[i, 4]], eps -> 0],
  {i, 1, Length[terms]}
];

Print["Summing ", Length[limitedTerms], " rational terms..."];
Print[""];

totalSum = Total[limitedTerms];

Print["Simplifying to single fraction..."];
Print[""];

result = Together[totalSum];

Print["RESULT:"];
Print[""];
Print[result];
Print[""];

num = Numerator[result];
den = Denominator[result];

Print["Numerator:"];
Print[num];
Print[""];
Print["Denominator:"];
Print[den];
Print[""];

Print["Decimal (50 digits):"];
Print[N[result, 50]];
Print[""];

Print["================================================================"];
Print["VERIFICATION"];
Print["================================================================"];
Print[""];

knownNum = 703166705641;
knownDen = 351298031616;

Print["Known value from documentation:"];
Print["  ", knownNum, "/", knownDen];
Print["  = ", N[knownNum/knownDen, 50]];
Print[""];

If[num == knownNum && den == knownDen,
  Print["*** PERFECT MATCH! ***"];
,
  Print["Difference: ", N[result - knownNum/knownDen, 30]];
  Print[""];
  Print["Checking if values are equal numerically:"];
  If[Abs[N[result - knownNum/knownDen, 100]] < 10^(-20),
    Print["  Values match to 20+ digits"];
    Print["  Likely different reduced forms of same rational"];
    Print[""];
    Print["  GCD(num, den) = ", GCD[num, den]];
    Print["  GCD(knownNum, knownDen) = ", GCD[knownNum, knownDen]];
  ,
    Print["  Values differ significantly"];
    Print["  Need more terms or different approach"];
  ];
];

Print[""];
Print["Term count analysis:"];
Print["  Total terms collected: ", Length[terms]];
Print["  Max |dist| included: ", Max[Abs[terms[[All, 3]]]]];
Print[""];

(* Show contribution of largest |dist| terms *)
Print["Contribution of terms with largest |dist|:"];
largeDistTerms = Select[limitedTerms, # < 10^(-10) &];
If[Length[largeDistTerms] > 0,
  Print["  ", Length[largeDistTerms], " terms contribute < 10^(-10) each"];
  Print["  Their sum: ", N[Total[largeDistTerms], 20]];
,
  Print["  All terms contribute >= 10^(-10)"];
];
Print[""];
