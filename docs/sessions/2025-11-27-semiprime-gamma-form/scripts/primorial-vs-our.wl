(* Primorial vzorec *)
PrimorialRaw[m_] := 1/2 * Sum[(-1)^k * k!/(2 k + 1), {k, 0, Floor[(m - 1)/2]}]

(* Nase vzorce *)
S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
f10[n_] := -1/(1 - S10[n])

Print["Porovnani struktur:"]
Print[""]

(* Pro n = p prvocislo *)
Print["Pro prvocisla n:"]
Do[
  n = Prime[k];
  
  (* Primorial vzorec *)
  pr = PrimorialRaw[n];
  prDen = Denominator[pr];
  
  (* Nase S10 *)
  s = S10[n];
  sDen = Denominator[s];
  
  (* f10 *)
  f = f10[n];
  fDen = Denominator[f];
  
  Print["n=", n, ":"];
  Print["  PrimorialRaw den: ", prDen, " = Primorial(", n, ")"];
  Print["  S10 den: ", sDen];
  Print["  f10 den: ", fDen];
  Print["  Pomer fDen/prDen: ", fDen/prDen];
  Print[""],
  {k, 2, 5}
]

(* Klic: Product[n^2 - j^2] vs j! *)
Print["Klic: Product[n^2 - j^2, j=1..i] vs i!"]
Print[""]
n = 7;
Do[
  prod = Product[n^2 - j^2, {j, 1, i}];
  fact = i!;
  Print["  i=", i, ": Product = ", prod, ", i! = ", fact, ", ratio = ", prod/fact],
  {i, 1, 6}
]
Print[""]

(* Product[n^2 - j^2] = Product[(n-j)(n+j)] *)
(* = Pochhammer[n-i, i] * Pochhammer[n+1, i] *)
Print["Pochhammer forma:"]
Print["  Product[(n-j)(n+j), j=1..i] = (n-1)!/(n-i-1)! * (n+i)!/n!"]
Print["  = Pochhammer[n-i, i] * Pochhammer[n+1, i]"]
