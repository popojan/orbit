(* Proč je první rozdíl přesně n? *)

Print["==============================================================="]
Print["  PROČ d[0] - d[1] = n?"]
Print["==============================================================="]
Print[""]

(* Rozdíl mezi sumami začínajícími od i=0 vs i=1 *)
(* je právě člen T[0] = Product[n^2-j^2, {j,1,0}]/(2*0+1) *)

Print["T[0] = Product[n^2-j^2, {j,1,0}] / 1"]
Print["     = (prázdný produkt) / 1"]
Print["     = 1"]
Print[""]

(* Takže suma od i=0 = 1 + suma od i=1 *)
(* Jak to ovlivní zlomek? *)

Print["Suma od i=0: S0 = 1 + S1"]
Print[""]

Print["f[n, 0] = -1/(1 - S0) = -1/(1 - 1 - S1) = -1/(-S1) = 1/S1"]
Print["f[n, 1] = -1/(1 - S1)"]
Print[""]

(* Tohle je klíč! Pro i=0 je jmenovatel 1/S1, pro i=1 je -1/(1-S1) *)
(* To jsou různé zlomky, ne jen rozdíl v čitateli *)

Print["Ověření numericky pro n=5:"]
S1 = Sum[Product[25 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, 4}];
Print["  S1 = ", S1]
Print["  1 - S1 = ", 1 - S1]
Print[""]

f0 = -1/(1 - (1 + S1));
f1 = -1/(1 - S1);
Print["  f[5,0] = 1/S1 = ", f0, " = ", N[f0, 6]]
Print["  f[5,1] = -1/(1-S1) = ", f1, " = ", N[f1, 6]]
Print[""]

Print["  Denominátory: ", Denominator[f0], " vs ", Denominator[f1]]
Print["  Rozdíl: ", Denominator[f0] - Denominator[f1]]
Print["  = n = 5? ", Denominator[f0] - Denominator[f1] == 5]
Print[""]

Print["==============================================================="]
Print["  HLUBŠÍ ANALÝZA: CO JE SKUTEČNÁ STRUKTURA?"]
Print["==============================================================="]
Print[""]

(* Pro prvočísla: num = n *)
(* Pro složená: num = rad(lichá část n) *)

Print["Čitatel vždy = rad(n / 2^v2(n)):"]
rad[m_] := Times @@ (First /@ FactorInteger[m])
Do[
  f0 = -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]);
  num = Numerator[f0];
  oddPart = n/2^IntegerExponent[n, 2];
  radOdd = If[oddPart == 1, 1, rad[oddPart]];
  Print["  n=", n, ": num=", num, ", rad(odd(n))=", radOdd, ", match=", num == radOdd],
  {n, 2, 20}
]
Print[""]

Print["==============================================================="]
Print["  CO KÓDUJE JMENOVATEL?"]
Print["==============================================================="]
Print[""]

(* Jmenovatel obsahuje faktorizační informaci *)
(* Pro n = pq: gcd(den ± k, n) = faktor *)

Print["Pro n=15=3×5:"]
f0 = -1/(1 - Sum[Product[225 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, 14}]);
den = Denominator[f0];
Print["  den = ", den]
Print["  Faktorizace den: ", FactorInteger[den]]
Print[""]

Print["  Hledání faktoru přes gcd(den±k, 15):"]
Do[
  g1 = GCD[den + k, 15];
  g2 = GCD[den - k, 15];
  If[g1 > 1 && g1 < 15, Print["    gcd(den+", k, ", 15) = ", g1, " <- FAKTOR!"]];
  If[g2 > 1 && g2 < 15, Print["    gcd(den-", k, ", 15) = ", g2, " <- FAKTOR!"]],
  {k, 0, 10}
]
