(* Puvodni vzorec z half-factorial theorem *)
(* Pro prvocislo m: *)
(* FractionalPart[Sum[(-1)^k * k!/(2k+1), k=1..(m-1)/2] * (m-1)!] = n/m *)
(* kde n = (-1)^((m+1)/2) * ((m-1)/2)! mod m *)

alt[m_] := Sum[(-1)^k * k!/(2 k + 1), {k, 1, Floor[(m - 1)/2]}]

Print["Fractional part pro prvocisla:"]
Do[
  p = Prime[k];
  fp = FractionalPart[alt[p] * (p - 1)!];
  Print["p=", p, ": FracPart[alt*fact] = ", fp],
  {k, 2, 7}
]
Print[""]

(* Pro semiprime n = p*q *)
Print["Pro semiprime (puvodni unit fraction vzorec):"]
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Do[
  n = {15, 21, 35, 77}[[k]];
  f = f10[n];
  num = Numerator[f];
  den = Denominator[f];
  Print["n=", n, ": f10 = ", num, "/", den];
  Print["       Numerator = ", num, " (= n pro squarefree semiprimes)"],
  {k, 4}
]
Print[""]

Print["'Closed form' = Numerator[f10[n]] = n bez explicitniho gcd"]
Print["Ale: redukce zlomku IMPLICITNE pouziva gcd"]
