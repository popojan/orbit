Pk[n_, k_] := Product[n^2 - j^2, {j, 1, k}]
Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]
fSep[n_, k_] := -1/(1 - Pk[n, k] * Hn[n])

Print["Test k = (n-1)/2:"]
Print[""]

semis = {15, 21, 33, 35, 55, 77, 91, 143, 221};

Do[
  n = semis[[s]];
  k = (n - 1)/2;
  {p, q} = Sort[First /@ FactorInteger[n]];
  
  Print["n=", n, " (", p, "*", q, "), k=", k, ":"];
  
  f = fSep[n, k];
  If[Head[f] === Rational,
    den = Denominator[f];
    g = GCD[den, n];
    Print["  gcd(den, n) = ", g, If[1 < g < n, " FACTOR!", ""]];
    
    (* Zkus take k-1 a k+1 *)
    Do[
      f2 = fSep[n, k + delta];
      If[Head[f2] === Rational,
        den2 = Denominator[f2];
        g2 = GCD[den2, n];
        If[1 < g2 < n && g2 != g,
          Print["  k=", k + delta, ": gcd = ", g2, " FACTOR!"]
        ]
      ],
      {delta, {-2, -1, 1, 2}}
    ]
  ,
    Print["  Neni racionalni"]
  ];
  Print[""],
  {s, Length[semis]}
]

(* Souvislost s (p-1)/2 a (q-1)/2 *)
Print["Souvislost k = (n-1)/2 s Wilson body:"]
Print["  (n-1)/2 = (pq-1)/2"]
Print["  (p-1)/2, (q-1)/2 jsou Wilson body pro p, q"]
Print[""]

Do[
  n = semis[[s]];
  k = (n - 1)/2;
  {p, q} = Sort[First /@ FactorInteger[n]];
  wp = (p-1)/2;
  wq = (q-1)/2;
  Print["n=", n, ": k=", k, ", (p-1)/2=", wp, ", (q-1)/2=", wq, 
        ", k - wp = ", k - wp, ", k - wq = ", k - wq],
  {s, 5}
]
