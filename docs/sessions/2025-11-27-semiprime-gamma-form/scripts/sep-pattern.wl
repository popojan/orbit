Pk[n_, k_] := Product[n^2 - j^2, {j, 1, k}]
Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]
fSep[n_, k_] := -1/(1 - Pk[n, k] * Hn[n])

(* Test n=35 s vetsim k *)
Print["n=35 (5*7), testuju k do 34:"]
n = 35;
Do[
  f = fSep[n, k];
  If[Head[f] === Rational,
    den = Denominator[f];
    g = GCD[den, n];
    If[1 < g < n,
      Print["  k=", k, " -> gcd=", g]
    ]
  ],
  {k, 1, 34}
]
Print[""]

(* Analyzuji vzor: kdy presne k funguje? *)
Print["Podrobna analyza - kdy gcd > 1:"]
Print[""]

testCases = {{15, 3, 5}, {21, 3, 7}, {77, 7, 11}};
Do[
  {n, p, q} = testCases[[t]];
  Print["n=", n, " (", p, "*", q, "):"];
  
  (* Pro kazde k spocitam gcd *)
  Do[
    f = fSep[n, k];
    If[Head[f] === Rational,
      den = Denominator[f];
      gp = GCD[den, p];
      gq = GCD[den, q];
      gn = GCD[den, n];
      If[gn > 1,
        (* Kdy Pk obsahuje mocninu p nebo q? *)
        pkFactors = FactorInteger[Pk[n, k]];
        pPow = Cases[pkFactors, {p, e_} :> e];
        qPow = Cases[pkFactors, {q, e_} :> e];
        pPow = If[pPow === {}, 0, First[pPow]];
        qPow = If[qPow === {}, 0, First[qPow]];
        Print["  k=", k, ": gcd=", gn, ", Pk has ", p, "^", pPow, " and ", q, "^", qPow]
      ]
    ],
    {k, 1, Min[25, n - 1]}
  ];
  Print[""],
  {t, Length[testCases]}
]

(* Hypoteza: souvisi s tim, kdy Pk obsahuje vyssi mocninu faktoru *)
Print["Hypoteza: gcd(den, p) > 1 kdyz Pk obsahuje p^(neco)?"]
