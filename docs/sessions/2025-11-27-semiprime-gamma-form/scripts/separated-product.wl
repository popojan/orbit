(* Separovany produkt: P_k * harmonicka suma *)

Pk[n_, k_] := Product[n^2 - j^2, {j, 1, k}]
Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]  (* = 1 + 1/3 + 1/5 + ... + 1/(2n-1) *)

fSep[n_, k_] := -1/(1 - Pk[n, k] * Hn[n])

Print["Analyza separovaneho vzorce:"]
Print[""]

(* Pro n = 15 *)
n = 15;
Print["n = 15 = 3*5:"]
Print["  Hn[15] = ", Hn[15], " = ", N[Hn[15], 10]]
Print[""]

Print["  k | Pk[15,k] | fSep | den | gcd(den,15)"]
Print["  --|----------|------|-----|------------"]
Do[
  pk = Pk[n, k];
  f = fSep[n, k];
  If[Head[f] === Rational || IntegerQ[f],
    den = Denominator[f];
    g = GCD[den, n];
    Print["  ", k, " | ", pk, " | ... | ...", Mod[den, 10^6], " | ", g]
  ],
  {k, 1, 8}
]
Print[""]

(* Proc k=4 funguje? *)
Print["Proc k=4 funguje pro n=15?"]
Print["  Pk[15, 4] = ", Pk[15, 4]]
Print["  = (225-1)(225-4)(225-9)(225-16)"]
Print["  = 224 * 221 * 216 * 209"]
Print["  = ", 224*221*216*209]
Print["  Faktorizace: ", FactorInteger[Pk[15, 4]]]
Print[""]

(* Singularita: kdy je Pk[n,k] delitelne p? *)
Print["Kdy Pk[n,k] obsahuje faktor p?"]
Print["  n^2 - j^2 = 0 mod p kdyz j = +/-n mod p"]
Print["  Pro n = 15 = 3*5:"]
Print["    j = 15 mod 3 = 0 -> NIKDY (j >= 1)"]
Print["    j = 15 mod 5 = 0 -> NIKDY"]
Print["  Ale: n^2 - j^2 = (n-j)(n+j)")
Print["    Pro j=3: (15-3)(15+3) = 12*18 = 216, delitelne 3")
Print["    Pro j=5: (15-5)(15+5) = 10*20 = 200, delitelne 5")
Print[""]

(* Test na vice semiprime *)
Print["Test na vice semiprime:"]
semis = {15, 21, 35, 77, 143};
Do[
  n = semis[[s]];
  {p, q} = Sort[First /@ FactorInteger[n]];
  Print["n=", n, " (", p, "*", q, "):"];
  found = False;
  Do[
    f = fSep[n, k];
    If[Head[f] === Rational,
      den = Denominator[f];
      g = GCD[den, n];
      If[1 < g < n,
        Print["  k=", k, ": gcd=", g, " FAKTOR!"];
        found = True
      ]
    ],
    {k, 1, Min[15, n-1]}
  ];
  If[!found, Print["  zadny faktor pro k <= 15"]],
  {s, Length[semis]}
]
