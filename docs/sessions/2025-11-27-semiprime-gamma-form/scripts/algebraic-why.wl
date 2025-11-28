(* Why do small coefficients work? - Algebraic proof *)

Print["==============================================================="]
Print["  ALGEBRAICKÝ DŮKAZ PRO MALÉ KOEFICIENTY"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["1. VZTAH MEZI d00 A d10"]
Print["==============================================================="]
Print[""]

(* Ověření vzorce d00 = n^2 * num10 + d10 * (n^2 - 1) *)
Print["Test: d00 = n^2 * num10 + d10 * (n^2 - 1)"]
Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  num10 = Numerator[f10[n]];
  predicted = n^2 * num10 + d10 * (n^2 - 1);
  Print["  n=", n, ": match=", d00 == predicted],
  {n, {3, 5, 7, 11, 13, 15, 21}}
]
Print[""]

Print["2. LINEÁRNÍ KOMBINACE -d00 + b*d10"]
Print["==============================================================="]
Print[""]

Print["Dosazením d00 = n^2*num10 + d10*(n^2-1):"]
Print["  -d00 + b*d10 = -n^2*num10 - d10*(n^2-1) + b*d10"]
Print["               = -n^2*num10 + d10*(b - n^2 + 1)"]
Print[""]

(* Pro squarefree n = pq: num10 = n *)
Print["Pro n = p*q (squarefree): num10 = n"]
Print["  -d00 + b*d10 = -n^3 + d10*(b + 1 - n^2)"]
Print[""]

Print["3. PODMÍNKA PRO FAKTOR p"]
Print["==============================================================="]
Print[""]

Print["Chceme: gcd(-n^3 + d10*(b + 1 - n^2), n) obsahuje p"]
Print[""]
Print["Modulo p (kde p | n):"]
Print["  -n^3 mod p = 0    (protože p | n)")
Print["  d10*(b + 1 - n^2) mod p = d10*(b + 1) mod p   (protože p | n^2)")
Print[""]
Print["Takže potřebujeme: d10*(b + 1) ≡ 0 (mod p)")
Print[""]

Print["4. CO JE d10 MOD p?"]
Print["==============================================================="]
Print[""]

(* d10 = Denominator[f10[n]] kde f10[n] = n / d10 pro squarefree n *)
(* Spočítáme d10 mod p pro různé n = pq *)

testCases = {{15, 3, 5}, {21, 3, 7}, {35, 5, 7}, {77, 7, 11}, {143, 11, 13}};

Do[
  {n, p, q} = tc;
  d10 = Denominator[f10[n]];
  d10modP = Mod[d10, p];
  d10modQ = Mod[d10, q];
  Print["n=", n, " = ", p, "*", q, ":"];
  Print["  d10 mod ", p, " = ", d10modP];
  Print["  d10 mod ", q, " = ", d10modQ],
  {tc, testCases}
]
Print[""]

Print["5. NAJÍT b TAK, ABY d10*(b+1) ≡ 0 (mod p)"]
Print["==============================================================="]
Print[""]

Do[
  {n, p, q} = tc;
  d10 = Denominator[f10[n]];
  d10modP = Mod[d10, p];
  d10modQ = Mod[d10, q];
  
  (* Pro faktor p: potřebujeme b+1 ≡ 0 (mod p/gcd(d10,p)) *)
  gP = GCD[d10, p];
  gQ = GCD[d10, q];
  
  Print["n=", n, " = ", p, "*", q, ":"];
  Print["  gcd(d10, p) = ", gP, ", gcd(d10, q) = ", gQ];
  
  (* Pokud gcd(d10, p) = p, pak jakékoli b funguje pro faktor p *)
  (* Pokud gcd(d10, p) = 1, pak potřebujeme b+1 ≡ 0 (mod p), tj. b = p-1 *)
  
  If[gP == p,
    Print["  p | d10, takže jakékoli b dá faktor p"],
    Print["  Potřeba: b ≡ -1 (mod ", p/gP, "), např. b = ", -1]
  ];
  
  If[gQ == q,
    Print["  q | d10, takže jakékoli b dá faktor q"],
    Print["  Potřeba: b ≡ -1 (mod ", q/gQ, "), např. b = ", -1]
  ];
  Print[""],
  {tc, testCases}
]

Print["6. VERIFIKACE"]
Print["==============================================================="]
Print[""]

Do[
  {n, p, q} = tc;
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  
  (* Test b = -1 *)
  combo = -d00 + (-1)*d10;
  gcd1 = GCD[combo, n];
  
  (* Test b = -2 *)
  combo2 = -d00 + (-2)*d10;
  gcd2 = GCD[combo2, n];
  
  Print["n=", n, ": b=-1 -> gcd=", gcd1, ", b=-2 -> gcd=", gcd2],
  {tc, testCases}
]
