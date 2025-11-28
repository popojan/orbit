(* Addressing open questions systematically *)

Print["==============================================================="]
Print["  OTÁZKA 1: OEIS LOOKUP PRO DENOMINÁTORY"]
Print["==============================================================="]
Print[""]

f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

denSeq = Table[Denominator[f10[n]], {n, 2, 12}];
numSeq = Table[Numerator[f10[n]], {n, 2, 12}];

Print["Denominátory pro n = 2..12:"]
Print[denSeq]
Print[""]

Print["Pro OEIS hledání (prvočísla, kde num = n):"]
primeDens = Table[Denominator[f10[Prime[k]]], {k, 1, 6}];
Print["Primes: ", Table[Prime[k], {k, 1, 6}]]
Print["Dens:   ", primeDens]
Print[""]

Print["Zkusme logaritmy:"]
Do[
  Print["  log10(d[", Prime[k], "]) = ", N[Log10[primeDens[[k]]], 6]],
  {k, 1, 6}
]
Print[""]

Print["==============================================================="]
Print["  OTÁZKA 2: SUMA 1.09838... - ZNÁMÁ KONSTANTA?"]
Print["==============================================================="]
Print[""]

sumLimit = Sum[f10[n], {n, 2, 100}];
Print["Sum[f10[n], n=2..100] = ", N[sumLimit, 50]]
Print[""]

(* Porovnání se známými konstantami *)
Print["Porovnání:"]
Print["  Pi/e        = ", N[Pi/E, 20]]
Print["  E/Pi        = ", N[E/Pi, 20]]
Print["  1 + 1/e^2   = ", N[1 + 1/E^2, 20]]
Print["  Sqrt[e]/Sqrt[Pi] = ", N[Sqrt[E]/Sqrt[Pi], 20]]
Print["  Naše suma   = ", N[sumLimit, 20]]
Print[""]

(* Hledání v RIES stylu *)
s = N[sumLimit, 30];
Print["s - 1 = ", N[s - 1, 20]]
Print["1/s = ", N[1/s, 20]]
Print["s^2 = ", N[s^2, 20]]
Print[""]

(* Zkusme kombinace s pi a e *)
Print["Kombinace s Pi, E:"]
Print["  s * Pi = ", N[s * Pi, 15]]
Print["  s * E = ", N[s * E, 15]]
Print["  s * Pi^2/6 = ", N[s * Pi^2/6, 15]]
Print["  (s-1) * 10 = ", N[(s - 1) * 10, 15]]
Print["  (s-1) * 12 = ", N[(s - 1) * 12, 15]]
Print[""]

Print["==============================================================="]
Print["  OTÁZKA 5: PROČ MALÉ KOEFICIENTY?"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])

Print["Algebraický vztah d00 vs d10:"]
Print[""]

(* Víme: S00 = n^2 * S10 *)
(* f00 = -1/(1 - S00) = -1/(1 - n^2 * S10) *)
(* f10 = -1/(1 - S10) *)

(* Nechť S10 = (a+1)/a pro nějaké a (tak že f10 = a/(a - a - 1) = -a) *)
(* Ne, to není správně... *)

(* f10 = num10 / d10 *)
(* 1 - S10 = -num10/d10 *)
(* S10 = 1 + num10/d10 = (d10 + num10)/d10 *)

(* 1 - n^2 * S10 = 1 - n^2 * (d10 + num10)/d10 *)
(*               = (d10 - n^2*d10 - n^2*num10) / d10 *)
(*               = (d10*(1-n^2) - n^2*num10) / d10 *)

(* f00 = -1 / ((d10*(1-n^2) - n^2*num10) / d10) *)
(*     = -d10 / (d10*(1-n^2) - n^2*num10) *)
(*     = d10 / (n^2*num10 + d10*(n^2-1)) *)

Print["Odvození:"]
Print["  S10 = (d10 + num10) / d10"]
Print["  1 - n^2*S10 = (d10*(1-n^2) - n^2*num10) / d10"]
Print["  f00 = d10 / (n^2*num10 + d10*(n^2-1))"]
Print[""]

Print["Pokud num00 = 1, num10 = n (pro squarefree odd n):"]
Print["  d00 = n^2*n + d10*(n^2-1) = n^3 + d10*(n^2-1)")
Print[""]

Print["Ověření:"]
Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  num10 = Numerator[f10[n]];
  predicted = n^2 * num10 + d10 * (n^2 - 1);
  Print["  n=", n, ": d00=", d00, ", predicted=", predicted, ", match=", d00 == predicted],
  {n, {3, 5, 7, 11}}
]
Print[""]

Print["TEDY: d00 = n^2 * num10 + d10 * (n^2 - 1)"]
Print[""]

Print["Lineární kombinace:"]
Print["  -d00 + b*d10 = -(n^2*num10 + d10*(n^2-1)) + b*d10"]
Print["               = -n^2*num10 + d10*(b - n^2 + 1)")
Print["               = -n^2*num10 + d10*(b + 1 - n^2)")
Print[""]

Print["Pro faktor p | n, chceme gcd(..., n) = p"]
Print["Potřebujeme: n^2*num10 ≡ d10*(b + 1 - n^2) (mod p)")
Print[""]

Print["Pro n = pq squarefree: num10 = n = pq"]
Print["  pq * p^2 * q^2 ≡ d10 * (b + 1 - p^2*q^2) (mod p)")
Print["  0 ≡ d10 * (b + 1) (mod p)   [protože p | p^2*q^2*pq a p | p^2*q^2]")
Print[""]

Print["Takže potřebujeme: d10 * (b + 1) ≡ 0 (mod p)"]
Print["Buď p | d10, nebo p | (b + 1)")
