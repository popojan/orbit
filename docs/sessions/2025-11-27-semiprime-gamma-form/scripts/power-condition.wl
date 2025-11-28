Pk[n_, k_] := Product[n^2 - j^2, {j, 1, k}]
Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]
fSep[n_, k_] := -1/(1 - Pk[n, k] * Hn[n])

getPower[x_, p_] := Module[{factors},
  factors = FactorInteger[x];
  Cases[factors, {p, e_} :> e, 1] /. {} -> {0} // First
]

Print["Test: mocnina p v Pk vs v Hn jmenovateli"]
Print[""]

testCases = {
  {15, 3, 5},
  {21, 3, 7},
  {35, 5, 7},
  {77, 7, 11}
};

Do[
  {n, p, q} = testCases[[t]];
  hnDen = Denominator[Hn[n]];
  pInHn = getPower[hnDen, p];
  qInHn = getPower[hnDen, q];
  
  Print["n=", n, " (", p, "*", q, "):"];
  Print["  Hn jmenovatel: ", p, "^", pInHn, ", ", q, "^", qInHn];
  Print[""];
  
  (* Najdi prvni k kde mocnina v Pk > mocnina v Hn *)
  Print["  k | Pk:", p, "^? | Pk:", q, "^? | gcd"];
  foundP = False; foundQ = False;
  Do[
    pk = Pk[n, k];
    pInPk = getPower[pk, p];
    qInPk = getPower[pk, q];
    
    f = fSep[n, k];
    If[Head[f] === Rational,
      den = Denominator[f];
      g = GCD[den, n];
      
      If[(pInPk > pInHn || qInPk > qInHn) && !foundP && !foundQ,
        Print["  ", k, " | ", pInPk, " (need>", pInHn, ") | ", qInPk, " (need>", qInHn, ") | ", g];
        If[g == p, foundP = True];
        If[g == q, foundQ = True];
        If[g > 1 && g < n, Print["    ^ FACTOR!"]];
      ];
      If[g > 1 && g < n && (foundP || foundQ),
        Print["  ", k, " | ", pInPk, " | ", qInPk, " | ", g, " FACTOR"]
      ]
    ],
    {k, 1, Min[25, n-1]}
  ];
  Print[""],
  {t, Length[testCases]}
]
