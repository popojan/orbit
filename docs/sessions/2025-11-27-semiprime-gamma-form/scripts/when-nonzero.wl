term[n_, i_] := Gamma[1 + i + n]/(n*(1 + 2 i)*Gamma[n - i])

Print["Kdy je FractionalPart nenulovy?"]
Print[""]

semis = {15, 21, 35, 55, 77, 91, 143};
Do[
  n = semis[[k]];
  {p, q} = Sort[First /@ FactorInteger[n]];
  m = Floor[(Sqrt[n] - 1)/2];
  
  Print["n=", n, " (", p, "*", q, "), m=", m, ", (p-1)/2=", (p-1)/2, ":"];
  
  Do[
    frac = FractionalPart[term[n, i]];
    If[frac != 0,
      Print["  i=", i, " (2i+1=", 2i+1, "): frac=", frac]
    ],
    {i, 1, m}
  ];
  Print[""],
  {k, Length[semis]}
]

Print["VZOR: FracPart != 0 prave kdyz 2i+1 = p (mensi faktor)"]
Print["      tj. i = (p-1)/2"]
Print[""]
Print["      A pak FracPart = (p-1)/p"]
