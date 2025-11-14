#!/usr/bin/env wolframscript
(* Explore how fractional parts accumulate to (p-1)/p *)

Print["Detailed Semiprime Formula Exploration\n"];
Print[StringRepeat["=", 70]];

(* For a semiprime, show each term's contribution *)
AnalyzeSemiprime[n_] := Module[{p, q, m, terms, total},
  {p, q} = FactorInteger[n][[All, 1]];
  m = Floor[(Sqrt[n] - 1)/2];

  Print["n = ", n, " = ", p, " × ", q];
  Print["m = Floor[(√n - 1)/2] = ", m];
  Print["Expected result: (p-1)/p = ", (p-1)/p, " = ", N[(p-1)/p], "\n"];

  Print["Term by term analysis:"];
  Print["i | Poch(1-n,i)×Poch(1+n,i) | (2i+1) | Quotient | Frac Part | Running Sum"];
  Print[StringRepeat["-", 100]];

  total = 0;
  terms = Table[
    Module[{poch1, poch2, product, denom, quotient, frac, contrib},
      poch1 = Pochhammer[1-n, i];
      poch2 = Pochhammer[1+n, i];
      product = poch1 * poch2 * (-1)^i;
      denom = 2*i + 1;

      quotient = product / denom;
      frac = quotient - Floor[quotient];
      total += frac;

      Print[i, " | ", product, " | ", denom, " | ",
            quotient, " | ", frac, " | ", total];

      {i, product, denom, quotient, frac, total}
    ],
    {i, 1, m}
  ];

  Print["\nFinal sum: ", total];
  Print["Reduced: ", Numerator[total], "/", Denominator[total]];
  Print["Matches (p-1)/p? ", total == (p-1)/p];
  Print[];
];

(* Test several semiprimes *)
semiprimes = {15, 21, 35, 55, 77, 91};

Do[AnalyzeSemiprime[n], {n, semiprimes}];

Print[StringRepeat["=", 70]];
Print["PATTERN ANALYSIS\n"];
Print[StringRepeat["=", 70], "\n"];

Print["Looking for the mechanism:\n"];

(* For n=15, look at divisibility *)
n = 15;
p = 3;
m = Floor[(Sqrt[n] - 1)/2];

Print["For n=15=3×5, analyzing divisibility by p=3:\n"];

Do[
  Module[{poch1, poch2, product, v3},
    poch1 = Pochhammer[1-n, i];
    poch2 = Pochhammer[1+n, i];
    product = poch1 * poch2;

    v3 = IntegerExponent[product, 3];

    Print["i=", i, ":");
    Print["  Poch(1-15,", i, ") = ", poch1, " = ", FactorInteger[poch1]];
    Print["  Poch(1+15,", i, ") = ", poch2, " = ", FactorInteger[poch2]];
    Print["  Product = ", product];
    Print["  ν_3(product) = ", v3];
    Print["  Product/(2i+1) = ", product/(2*i+1)];
    Print["  Fractional part = ", FractionalPart[product/(2*i+1)]];
    Print[];
  ],
  {i, 1, m}
];

Print["Key question: How does ν_3 relate to the fractional accumulation?"];

Print["\nDone!"];
