(* Original: suma unit fractions *)
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

(* Separovany: Pk * Hn *)
Pk[n_, k_] := Product[n^2 - j^2, {j, 1, k}]
Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]
fSep[n_, k_] := -1/(1 - Pk[n, k] * Hn[n])

Print["Struktura sum:"]
Print[""]

n = 5;
Print["Original f10[", n, "]:"]
Print["  Suma = ", Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]]
Print["  Cleny:"]
Do[
  term = Product[n^2 - j^2, {j, 1, i}]/(2 i + 1);
  Print["    i=", i, ": ", term],
  {i, 0, 4}
]
Print[""]

Print["Separovany fSep[", n, ", k=2]:"]
k = 2;
Print["  Pk[5,2] = ", Pk[n, k]]
Print["  Hn[5] = ", Hn[n]]
Print["  Pk * Hn = ", Pk[n, k] * Hn[n]]
Print[""]

Print["ROZDIL:"]
Print["  Original: suma clenu 1/1 + 24/3 + 504/5 + 8064/7 + 72576/9"]
Print["           = suma ruznych zlomku (UNIT FRACTIONS pro f10)")
Print[""]
Print["  Separovany: Pk * (1/1 + 1/3 + 1/5 + 1/7 + 1/9)")
Print["           = JEDEN velky produkt * harmonicka suma")
Print["           = NENI suma unit fractions!")
