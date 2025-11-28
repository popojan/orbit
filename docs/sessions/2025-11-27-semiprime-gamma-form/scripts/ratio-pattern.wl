(* Ratio pattern: f00/f10 = 1/n^2 ? *)

Print["==============================================================="]
Print["  POMER f00/f10 vs 1/n^2"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["n     f00/f10           1/n^2           ratio/(1/n^2)"]
Do[
  ratio = f00[n]/f10[n];
  expected = 1/n^2;
  Print[n, "    ", N[ratio, 12], "    ", N[expected, 12], "    ", N[ratio/expected, 12]],
  {n, 3, 15}
]
Print[""]

Print["==============================================================="]
Print["  TAK TO NENI PRESNE 1/n^2 ... ale co?"]
Print["==============================================================="]
Print[""]

Print["Podivent se na presny zlomek f00/f10:"]
Do[
  ratio = f00[n]/f10[n];
  Print["n=", n, ": ", ratio],
  {n, 3, 8}
]
Print[""]

Print["==============================================================="]
Print["  MOZNA f00 = f10 / (n^2 + epsilon)?"]
Print["==============================================================="]
Print[""]

Print["f10/f00 - n^2:"]
Do[
  invRatio = f10[n]/f00[n];
  diff = invRatio - n^2;
  Print["n=", n, ": f10/f00 = ", N[invRatio, 10], ", diff from n^2 = ", N[diff, 10]],
  {n, 3, 12}
]
Print[""]

Print["==============================================================="]
Print["  VZTAH MEZI VARIANTAMI - HLUBSI ANALYZA"]
Print["==============================================================="]
Print[""]

(* Product n^2-j^2 pro j=0..i vs j=1..i *)
(* Pro j=0..i: Product = n^2 * Product[n^2-j^2, j=1..i] *)
(* Takze Term_00[i] = n^2 * Term_10[i] *)

Print["Term porovnani:"]
Print["  Product[n^2-j^2, j=0..i] = n^2 * Product[n^2-j^2, j=1..i]"]
Print[""]

n = 5;
Print["Pro n=5:"]
Do[
  p00 = Product[n^2 - j^2, {j, 0, i}];
  p10 = Product[n^2 - j^2, {j, 1, i}];
  Print["  i=", i, ": P_00=", p00, ", P_10=", p10, ", P_00/P_10=", p00/p10, " = n^2=", n^2, "? ", p00/p10 == n^2],
  {i, 1, 4}
]
Print[""]

Print["TAKZE: Sum_00 = n^2 * Sum_10 (primo proporcionalni!)"]
Print[""]

Print["Overeni:"]
Do[
  s00 = Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}];
  s10 = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
  Print["n=", n, ": S_00/S_10 = ", s00/s10, " vs n^2 = ", n^2],
  {n, 3, 8}
]
