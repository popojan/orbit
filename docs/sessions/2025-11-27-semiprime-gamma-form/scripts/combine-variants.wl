(* Kombinace různých variant formule *)

Print["==============================================================="]
Print["  KOMBINACE VARIANT FORMULE"]
Print["==============================================================="]
Print[""]

(* Definice 4 základních variant *)
(* f[j0, i0][n] = -1/(1 - Sum[Product[n^2-j^2, {j, j0, i}]/(2i+1), {i, i0, inf}]) *)

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f01[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 1, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])
f11[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, n - 1}])

Print["1. JEDNOTLIVE VARIANTY PRO n = 3..10"]
Print["==============================================================="]
Print[""]

Print["n    f00        f01        f10        f11"]
Do[
  Print[n, "   ", 
    PaddedForm[N[f00[n], 8], {10, 6}], "   ",
    PaddedForm[N[f01[n], 8], {10, 6}], "   ",
    PaddedForm[N[f10[n], 8], {10, 6}], "   ",
    PaddedForm[N[f11[n], 8], {10, 6}]
  ],
  {n, 3, 10}
]
Print[""]

Print["2. SOUCET VSECH CTYR VARIANT"]
Print["==============================================================="]
Print[""]

Print["n    sum(all 4)"]
Do[
  s = f00[n] + f01[n] + f10[n] + f11[n];
  Print[n, "   ", s, " = ", N[s, 10]],
  {n, 3, 10}
]
Print[""]

Print["3. SOUCIN VSECH CTYR VARIANT"]
Print["==============================================================="]
Print[""]

Print["n    product(all 4)"]
Do[
  p = f00[n] * f01[n] * f10[n] * f11[n];
  Print[n, "   ", N[p, 10]],
  {n, 3, 8}
]
Print[""]

Print["4. ROZDILY VARIANT"]
Print["==============================================================="]
Print[""]

Print["n    f00-f01    f10-f11    f00-f10    f01-f11"]
Do[
  d1 = f00[n] - f01[n];
  d2 = f10[n] - f11[n];
  d3 = f00[n] - f10[n];
  d4 = f01[n] - f11[n];
  Print[n, "   ", N[d1, 6], "   ", N[d2, 6], "   ", N[d3, 6], "   ", N[d4, 6]],
  {n, 3, 8}
]
Print[""]

Print["5. POMERY VARIANT"]
Print["==============================================================="]
Print[""]

Print["n    f00/f10    f01/f11"]
Do[
  r1 = f00[n]/f10[n];
  r2 = f01[n]/f11[n];
  Print[n, "   ", N[r1, 10], "   ", N[r2, 10]],
  {n, 3, 10}
]
Print[""]

Print["6. KOMBINACE: f00*f11 - f01*f10 (Kreuzprodukt)"]
Print["==============================================================="]
Print[""]

Do[
  cross = f00[n]*f11[n] - f01[n]*f10[n];
  Print["n=", n, ": ", N[cross, 10]],
  {n, 3, 10}
]
Print[""]

Print["7. KOMBINACE: f00*f11 + f01*f10"]
Print["==============================================================="]
Print[""]

Do[
  s = f00[n]*f11[n] + f01[n]*f10[n];
  Print["n=", n, ": ", N[s, 10]],
  {n, 3, 10}
]
