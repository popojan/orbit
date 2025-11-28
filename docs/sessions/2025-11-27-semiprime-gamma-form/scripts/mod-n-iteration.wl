(* Iterativní výpočet d[k] mod n *)

Print["==============================================================="]
Print["  ITERATIVNÍ VÝPOČET d[k] MOD n"]
Print["==============================================================="]
Print[""]

Print["Problém: d[k] závisí na S[k] = Sum[T[i], i=k..n-1]"]
Print["         T[i] = Product[n^2-j^2, j=1..i] / (2i+1)"]
Print[""]
Print["Dělení (2i+1) vyžaduje modulární inverzi!"]
Print["Pro n=pq, gcd(2i+1, n) může být netriviální..."]
Print[""]

n = 143;
Print["Pro n = ", n, ":"]
Print["gcd(2i+1, n) pro různá i:"]
Do[
  g = GCD[2 i + 1, n];
  If[g > 1, Print["  i=", i, ": gcd(", 2 i + 1, ", 143) = ", g]],
  {i, 1, 20}
]
Print[""]

Print["Problém: Pro i=5: gcd(11, 143) = 11 ≠ 1"]
Print["         Pro i=6: gcd(13, 143) = 13 ≠ 1"]
Print["         Nelze počítat T[5], T[6] mod 143!"]
Print[""]

Print["==============================================================="]
Print["  ALTERNATIVA: POČÍTAT MOD p NEBO MOD q?"]
Print["==============================================================="]
Print[""]

Print["Pokud n = p*q, pak:"]
Print["  T[i] mod p je definované pro 2i+1 ≠ 0 (mod p)"]
Print["  T[i] mod q je definované pro 2i+1 ≠ 0 (mod q)"]
Print[""]

Print["Problem: Neznáme p, q - to je to co hledáme!")
Print[""]

Print["==============================================================="]
Print["  ALTERNATIVA: PRACOVAT S ČITATELEM PŘÍMO?"]
Print["==============================================================="]
Print[""]

(* Místo T[i] = Product/(2i+1), počítejme samotný produkt *)
P[n_, k_] := Product[n^2 - j^2, {j, 1, k}]

Print["P[k] = Product[n^2-j^2, j=1..k] mod n:"]
Do[
  pMod = Mod[P[n, k], n];
  Print["  P[", k, "] mod ", n, " = ", pMod],
  {k, 1, 10}
]
Print[""]

Print["Hmm, P[k] mod n = 0 pro k >= ? ..."]
Print[""]

Print["Důvod: n^2 - j^2 = (n-j)(n+j)"]
Print["       Pro j = 0: n^2 ≡ 0 (mod n)")
Print["       Pro j = p: n^2 - p^2 = (n-p)(n+p) = (q*p - p)(q*p + p) = p(q-1)*p(q+1)")
Print["                  = p^2 * (q-1)(q+1) ≡ 0 (mod p)")
Print[""]

Print["==============================================================="]
Print["  JINÝ PŘÍSTUP: FERMATŮV TEST MODIFIKACE?"]
Print["==============================================================="]
Print[""]

Print["Wilson: (p-1)! ≡ -1 (mod p)")
Print["Náš produkt při i = (p-1)/2:")
Print["  Product[n^2-j^2, j=1..(p-1)/2] = ?"]
Print[""]

Print["Pro n = 143 = 11*13, i = 5 = (11-1)/2:")
prod5 = P[143, 5];
Print["  P[5] = ", prod5]
Print["  P[5] mod 11 = ", Mod[prod5, 11]]
Print["  P[5] mod 13 = ", Mod[prod5, 13]]
Print[""]

Print["Wilson říká: P[5] mod 11 by mělo souviset s 10! mod 11..."]
Print["  10! mod 11 = ", Mod[10!, 11], " = -1 mod 11"]
Print[""]

Print["Jak souvisí P[5] s 10! ?"]
Print["  n^2 - j^2 = 143^2 - j^2 = (143-j)(143+j)")
Print["  Mod 11: (143-j)(143+j) ≡ (-j)(+j) = -j^2 (mod 11)")
Print["  Product mod 11: (-1)^5 * (1*2*3*4*5)^2 = -(5!)^2")
Print["  5!^2 mod 11 = ", Mod[5!^2, 11]]
Print["  -5!^2 mod 11 = ", Mod[-5!^2, 11]]
Print["  P[5] mod 11 = ", Mod[prod5, 11]]
Print["  Match: ", Mod[-5!^2, 11] == Mod[prod5, 11]]
