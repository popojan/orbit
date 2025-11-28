(* Can we detect transition using modular arithmetic? *)

Print["==============================================================="]
Print["  DETEKCE PŘECHODU MODULO MALÉ q"]
Print["==============================================================="]
Print[""]

(* Místo výpočtu obřích d[k], počítáme d[k] mod q pro různá q *)

T[n_, k_] := Product[n^2 - j^2, {j, 1, k}]/(2 k + 1)

(* Problém: T[k] obsahuje dělení (2k+1) *)
(* Musíme pracovat s modulární inverzí *)

Print["1. TEST: GCD(d[k] - d[k+1], n) MOD MALÉ PRVOČÍSLO?"]
Print["==============================================================="]
Print[""]

n = 143;
Print["Pro n = 143 = 11×13:"]
Print[""]

(* Přímý výpočet d[k] mod různých q *)
f[n_, startI_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, startI, n - 1}])

denSeq = Table[Denominator[f[n, k]], {k, 0, 7}];

Do[
  Print["q = ", q, ":"];
  Do[
    diff = denSeq[[k]] - denSeq[[k + 1]];
    diffModQ = Mod[diff, q];
    gcdN = GCD[diff, n];
    Print["  k=", k - 1, ": diff mod ", q, " = ", diffModQ, 
      ", gcd(diff,n) = ", gcdN,
      If[k - 1 == 5, " <- TRANSITION", ""]],
    {k, 1, 7}
  ];
  Print[""],
  {q, {7, 17, 29, 101}}
]

Print["2. ALTERNATIVA: PRACOVAT MOD n PŘÍMO"]
Print["==============================================================="]
Print[""]

Print["d[k] mod n:"]
Do[
  dModN = Mod[denSeq[[k + 1]], n];
  Print["  d[", k, "] mod ", n, " = ", dModN],
  {k, 0, 6}
]
Print[""]

Print["(d[k] - d[k+1]) mod n:"]
Do[
  diff = denSeq[[k]] - denSeq[[k + 1]];
  diffModN = Mod[diff, n];
  Print["  (d[", k - 1, "] - d[", k, "]) mod ", n, " = ", diffModN],
  {k, 1, 6}
]
Print[""]

Print["==============================================================="]
Print["  KLÍČOVÝ POSTŘEH"]
Print["==============================================================="]
Print[""]

Print["Pro k < min(Wilson):"]
Print["  gcd(d[k]-d[k+1], n) = n"]
Print["  -> (d[k]-d[k+1]) ≡ 0 (mod n)"]
Print[""]

Print["Pro k ≥ min(Wilson):"]
Print["  gcd(d[k]-d[k+1], n) ≠ n"]
Print["  -> (d[k]-d[k+1]) ≢ 0 (mod n)"]
Print[""]

Print["TAKŽE: Stačí počítat d[k] mod n!"]
Print["       Přechod nastane když d[k] ≢ d[k+1] (mod n)")
Print[""]

Print["3. MŮŽEME POČÍTAT d[k] MOD n ITERATIVNĚ?"]
Print["==============================================================="]
Print[""]

(* d[k] = num/f[k] kde f[k] = -1/(1 - S[k]) *)
(* S[k] = Sum[T[i], i=k..n-1] *)
(* d[k] = -num * (1 - S[k]) = num * (S[k] - 1) *)

(* Pro semiprimes n=pq: num = n *)
(* d[k] = n * (S[k] - 1) *)
(* d[k] mod n = 0 vždy! To je problém. *)

Print["Hmm, d[k] = n * (S[k] - 1), takže d[k] mod n = 0 vždy?"]
Print[""]

Do[
  Print["  d[", k, "] mod n = ", Mod[denSeq[[k + 1]], n]],
  {k, 0, 5}
]
Print[""]

Print["Ne! d[k] mod n ≠ 0. Proč?"]
Print["Protože num ≠ n vždy - závisí na rad(odd part)")
Print[""]

Print["Pro n = 143: num = ", Numerator[f[143, 0]]]
Print["Pro n = 15: num = ", Numerator[f[15, 0]]]
