(* Exact relationship between f00 and f10 *)

Print["==============================================================="]
Print["  PRESNY VZTAH MEZI f00 A f10"]
Print["==============================================================="]
Print[""]

Print["Vime: S_00 = n^2 * S_10"]
Print[""]

Print["Definice:"]
Print["  f_00 = -1/(1 - S_00) = -1/(1 - n^2 * S_10)"]
Print["  f_10 = -1/(1 - S_10)"]
Print[""]

Print["Pomer:"]
Print["  f_00/f_10 = (1 - S_10) / (1 - n^2 * S_10)"]
Print[""]

Print["Necht x = S_10, pak:"]
Print["  f_00/f_10 = (1-x) / (1-n^2 x)"]
Print[""]

Print["Pro velke n a male x (coz je nas pripad pro velke n):"]
Print["  ~ (1-x) / (-n^2 x)    [1 << n^2 x]"]
Print["  ~ -(1-x) / (n^2 x)"]
Print["  ~ -1/(n^2 x) + 1/n^2"]
Print[""]

Print["Ale x = S_10 ~ f_10 / (1 - f_10) = ...tady to komplikovane"]
Print[""]

Print["==============================================================="]
Print["  OVERENI PRESNEHO VZORCE"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])
S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]

Print["Overeni (1-S10)/(1-n^2*S10) = f00/f10:"]
Do[
  s = S10[n];
  ratio1 = (1 - s)/(1 - n^2*s);
  ratio2 = f00[n]/f10[n];
  Print["n=", n, ": formula = ", N[ratio1, 12], ", direct = ", N[ratio2, 12], ", match: ", Chop[ratio1 - ratio2] == 0],
  {n, 3, 8}
]
Print[""]

Print["==============================================================="]
Print["  CO JE S_10?"]
Print["==============================================================="]
Print[""]

Print["S_10 = Sum[Product[n^2-j^2, j=1..i]/(2i+1), i=0..n-1]"]
Print["     = 1 + T[1] + T[2] + ... + T[n-1]"]
Print[""]

Print["Hodnoty S_10:"]
Do[
  s = S10[n];
  Print["n=", n, ": S_10 = ", s],
  {n, 3, 8}
]
Print[""]

Print["Vsimnete si: f_10 = -1/(1 - S_10)"]
Print["            = -1/(1 - S_10)"]
Print[""]
Print["Pro prvocisla: f_10 = p / den, kde den je velke cislo"]
Print["             S_10 = 1 - 1/f_10 = 1 + den/p"]
Print[""]

Print["==============================================================="]
Print["  ALTERNATIVNI: VYJADRENI PRES DENOMINATORY"]
Print["==============================================================="]
Print[""]

Print["f_10[n] = num/den kde num = rad(licha cast n)"]
Print["S_10[n] = 1 - num/den = (den - num)/den"]
Print[""]

Do[
  fn = f10[n];
  num = Numerator[fn];
  den = Denominator[fn];
  s = S10[n];
  sFromF = 1 + 1/fn;
  Print["n=", n, ": S_10 = ", s, ", 1 + 1/f = ", sFromF, ", match: ", s == sFromF],
  {n, 3, 8}
]
