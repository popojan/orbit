(* Pattern: when is a=-1 enough vs a=-2 needed? *)

Print["==============================================================="]
Print["  KDY STAČÍ a=-1 VS POTŘEBA a=-2?"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

(* Pro a=-1, najdi nejmenší |b| *)
findBforA1[n_] := Module[{d00, d10, bestB, bestG},
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  
  bestB = Infinity; bestG = 1;
  Do[
    combo = -d00 + b*d10;
    g = GCD[combo, n];
    If[g > 1 && g < n && Abs[b] < Abs[bestB],
      bestB = b; bestG = g;
    ],
    {b, -50, 50}
  ];
  {bestB, bestG}
]

semiprimes = Select[Range[10, 300], 
  Length[FactorInteger[#]] == 2 && Max[FactorInteger[#][[;;,2]]] == 1 &];

Print["Pro a = -1, minimální |b|:"]
Print[""]

a1works = {};
a1fails = {};

Do[
  {b, g} = findBforA1[n];
  factors = FactorInteger[n][[;;, 1]];
  p = factors[[1]]; q = factors[[2]];
  
  If[b != Infinity && Abs[b] <= 5,
    AppendTo[a1works, {n, p, q, b, g}];
    Print["n=", n, " (", p, "*", q, "): b=", b, " -> ", g],
    (* else *)
    AppendTo[a1fails, {n, p, q, b}];
  ],
  {n, semiprimes[[1;;30]]}
]

Print[""]
Print["==============================================================="]
Print["  ANALÝZA: KDY a=-1 FUNGUJE S MALÝM b?"]
Print["==============================================================="]
Print[""]

Print["Funguje (|b| <= 5): ", Length[a1works], " případů"]
Print["Nefunguje: ", Length[a1fails], " případů"]
Print[""]

If[Length[a1fails] > 0,
  Print["Případy kde a=-1 nefunguje s malým b:"];
  Do[
    {n, p, q, b} = a1fails[[i]];
    Print["  n=", n, " = ", p, "*", q, ", min |b| = ", If[b == Infinity, "none", b]],
    {i, 1, Min[10, Length[a1fails]]}
  ]
]
Print[""]

Print["==============================================================="]
Print["  VZOREC PRO b?"]
Print["==============================================================="]
Print[""]

Print["Hledám vztah b vs (p, q):"]
Do[
  {n, p, q, b, g} = a1works[[i]];
  (* Různé kombinace *)
  Print["  n=", n, " (", p, "*", q, "): b=", b,
    ", p-q=", p - q,
    ", (p-1)/2=", (p - 1)/2,
    ", n mod 4=", Mod[n, 4]],
  {i, 1, Min[15, Length[a1works]]}
]
Print[""]

Print["==============================================================="]
Print["  ALTERNATIVA: PEVNÉ b, HLEDEJ a"]
Print["==============================================================="]
Print[""]

Print["Pro b = 1, jaké a funguje?"]
Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  factors = FactorInteger[n][[;;, 1]];
  
  found = False;
  Do[
    combo = a*d00 + d10;
    g = GCD[combo, n];
    If[g > 1 && g < n && !found,
      Print["  n=", n, ": a=", a, " -> gcd=", g];
      found = True;
    ],
    {a, -10, 10}
  ];
  If[!found, Print["  n=", n, ": not found"]],
  {n, semiprimes[[1;;10]]}
]
