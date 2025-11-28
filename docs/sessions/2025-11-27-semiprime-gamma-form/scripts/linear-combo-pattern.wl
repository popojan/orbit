(* Pattern in linear combination coefficients *)

Print["==============================================================="]
Print["  VZOREC PRO KOEFICIENTY LINEÁRNÍ KOMBINACE"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

(* Najdi optimální koeficienty pro každé n *)
findCoeffs[n_] := Module[{d00, d10, factors, bestA, bestB, bestG},
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  factors = FactorInteger[n][[;;, 1]];
  
  bestA = 0; bestB = 0; bestG = 1;
  
  Do[
    If[{a, b} != {0, 0},
      combo = a*d00 + b*d10;
      g = GCD[combo, n];
      If[g > 1 && g < n && (bestG == 1 || Abs[a] + Abs[b] < Abs[bestA] + Abs[bestB]),
        bestA = a; bestB = b; bestG = g;
      ]
    ],
    {a, -10, 10}, {b, -10, 10}
  ];
  
  {bestA, bestB, bestG}
]

Print["Hledám optimální (nejmenší |a|+|b|) koeficienty:"]
Print[""]

semiprimes = {15, 21, 33, 35, 55, 65, 77, 85, 91, 115, 119, 143, 187, 221};

results = {};
Do[
  {a, b, g} = findCoeffs[n];
  factors = FactorInteger[n][[;;, 1]];
  AppendTo[results, {n, factors, a, b, g}];
  Print["n=", n, " = ", factors[[1]], "*", factors[[2]], 
    ": a=", a, ", b=", b, " -> gcd=", g],
  {n, semiprimes}
]
Print[""]

Print["==============================================================="]
Print["  ANALÝZA KOEFICIENTŮ"]
Print["==============================================================="]
Print[""]

Print["Koeficient a vs faktory:"]
Do[
  {n, factors, a, b, g} = results[[i]];
  Print["  n=", n, ": a=", a, ", p=", factors[[1]], ", q=", factors[[2]], 
    ", a mod p=", Mod[a, factors[[1]]], ", a mod q=", Mod[a, factors[[2]]]],
  {i, 1, Length[results]}
]
Print[""]

Print["==============================================================="]
Print["  JE a VŽDY -5?"]
Print["==============================================================="]
Print[""]

aValues = results[[;;, 3]];
Print["Hodnoty a: ", aValues]
Print["Všechny = -5? ", AllTrue[aValues, # == -5 &]]
Print[""]

(* Pokud a = -5 vždy, jaký je vzorec pro b? *)
Print["Vztah b vs n:"]
Do[
  {n, factors, a, b, g} = results[[i]];
  p = factors[[1]];
  q = factors[[2]];
  Print["  n=", n, " (", p, "*", q, "): b=", b, 
    ", b+p=", b + p, ", b+q=", b + q,
    ", b mod 3=", Mod[b, 3]],
  {i, 1, Length[results]}
]
Print[""]

Print["==============================================================="]
Print["  ALTERNATIVA: FIXNÍ a=-1"]
Print["==============================================================="]
Print[""]

Print["Hledám b pro a=-1:"]
Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  factors = FactorInteger[n][[;;, 1]];
  
  found = False;
  Do[
    combo = -d00 + b*d10;
    g = GCD[combo, n];
    If[g > 1 && g < n && !found,
      Print["  n=", n, ": b=", b, " -> gcd=", g];
      found = True;
    ],
    {b, -20, 20}
  ];
  If[!found, Print["  n=", n, ": not found in range"]],
  {n, semiprimes[[1;;8]]}
]
