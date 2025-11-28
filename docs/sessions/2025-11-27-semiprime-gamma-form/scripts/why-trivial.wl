(* Why gcd(d00-d01, n) = n always? *)

Print["==============================================================="]
Print["  PROC gcd(d00-d01, n) = n VZDY?"]
Print["==============================================================="]
Print[""]

Print["T_00[0] = Product[n^2-j^2, j=0..0]/1 = n^2"]
Print["T_00[i] = n^2 * Product[n^2-j^2, j=1..i]/(2i+1) pro i>=1"]
Print[""]

Print["Tedy:"]
Print["  S_00 = T_00[0] + T_00[1] + ... = n^2 * (1 + Sum[.../n^2])"]
Print["  S_01 = T_00[1] + ..."]
Print["  S_00 - S_01 = T_00[0] = n^2"]
Print[""]

Print["Podobne pro j=1:"]
Print["  T_10[0] = Product[n^2-j^2, j=1..0]/1 = 1 (prazdny produkt)"]
Print["  S_10 - S_11 = T_10[0] = 1"]
Print[""]

Print["==============================================================="]
Print["  OVERENI"]
Print["==============================================================="]
Print[""]

S00[n_] := Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}]
S01[n_] := Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 1, n}]
S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n-1}]
S11[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, n-1}]

Print["n    S00-S01    n^2    S10-S11"]
Do[
  Print[n, "    ", S00[n] - S01[n], "    ", n^2, "    ", S10[n] - S11[n]],
  {n, 3, 8}
]
Print[""]

Print["==============================================================="]
Print["  IMPLIKACE PRO DENOMINATORY"]
Print["==============================================================="]
Print[""]

Print["f_00 = -1/(1-S_00), f_01 = -1/(1-S_01)"]
Print[""]
Print["Necht 1-S_00 = -a/b (zlomek v nejnizsich termech)"]
Print["Pak 1-S_01 = 1-S_00 + n^2 = -a/b + n^2 = (n^2 b - a)/b"]
Print[""]
Print["f_00 = b/a"]
Print["f_01 = b/(n^2 b - a)"]
Print[""]

Print["Denominatory:"]
Print["  d_00 = a (pokud num_00 = b)")
Print["  d_01 = n^2 b - a = n^2 * num_00 - d_00"]
Print[""]
Print["Rozdil: d_01 - d_00 = n^2 * num_00 - 2*d_00"]
Print["Tohle je slozitejsi..."]
Print[""]

Print["Overeni numericky:"]
f00[n_] := -1/(1 - S00[n])
f01[n_] := -1/(1 - S01[n])

Do[
  num00 = Numerator[f00[n]];
  den00 = Denominator[f00[n]];
  num01 = Numerator[f01[n]];
  den01 = Denominator[f01[n]];
  Print["n=", n, ":"];
  Print["  f00 = ", num00, "/", den00];
  Print["  f01 = ", num01, "/", den01];
  Print["  d00-d01 = ", den00 - den01];
  Print["  n^2*num00 = ", n^2*num00];
  Print["  Vztah: d00-d01 = n^2*num? ", den00 - den01 == n^2*num00],
  {n, 3, 6}
]
