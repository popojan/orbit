Pk[n_, k_] := Product[n^2 - j^2, {j, 1, k}]
Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]
fSep[n_, k_] := -1/(1 - Pk[n, k] * Hn[n])

Print["Systematicky test: ktere k dava faktor?"]
Print[""]

semis = {15, 21, 33, 35, 55, 77, 91, 143};
Do[
  n = semis[[s]];
  {p, q} = Sort[First /@ FactorInteger[n]];
  Print["n=", n, " (", p, "*", q, "):"];
  
  factorK = {};
  Do[
    f = fSep[n, k];
    If[Head[f] === Rational,
      den = Denominator[f];
      g = GCD[den, n];
      If[1 < g < n,
        AppendTo[factorK, {k, g}]
      ]
    ],
    {k, 1, Min[20, n - 1]}
  ];
  
  If[Length[factorK] > 0,
    Print["  Faktory: ", factorK];
    (* Vztah k s faktory *)
    Do[
      {kVal, factor} = factorK[[i]];
      otherFactor = n / factor;
      Print["    k=", kVal, " -> faktor ", factor, 
            ", (p-1)/2=", (p-1)/2, ", (q-1)/2=", (q-1)/2],
      {i, Length[factorK]}
    ]
  ,
    Print["  Zadny faktor pro k <= 20"]
  ];
  Print[""],
  {s, Length[semis]}
]

(* Vzor: je k = (p-1)/2 nebo (q-1)/2? *)
Print[""]
Print["Hypoteza: k souvisi s (p-1)/2 nebo (q-1)/2?"]
