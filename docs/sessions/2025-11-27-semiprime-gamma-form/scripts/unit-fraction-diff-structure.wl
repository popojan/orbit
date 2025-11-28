(* Struktura rozdílů pro vyšší i *)

Print["==============================================================="]
Print["  STRUKTURA ROZDÍLŮ d[k] - d[k+1]"]
Print["==============================================================="]
Print[""]

f[n_, startI_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, startI, n - 1}])

(* Explicitní výpočet: co je d[k] - d[k+1]? *)
(* Suma od k vs suma od k+1 se liší o člen T[k] *)

T[n_, k_] := Product[n^2 - j^2, {j, 1, k}]/(2 k + 1)

Print["1. ČLENY SUMY T[k]"]
Print["==============================================================="]
Print[""]

Do[
  Print["n = ", n, ":"];
  Do[
    tk = T[n, k];
    Print["  T[", k, "] = ", tk],
    {k, 0, Min[n, 6]}
  ];
  Print[""],
  {n, {5, 7, 11}}
]

Print["2. PROČ ROZDÍLY NEODPOVÍDAJÍ PŘÍMO T[k]?"]
Print["==============================================================="]
Print[""]

Print["Protože f = -1/(1-S), ne přímo S!"]
Print[""]
Print["Nechť S_k = Sum od i=k do n-1"]
Print["     f_k = -1/(1 - S_k)"]
Print[""]
Print["Pak: f_k - f_{k+1} = -1/(1-S_k) + 1/(1-S_{k+1})"]
Print["                   = (-1 + (1-S_k)/(1-S_{k+1})) / (1-S_k)"]
Print[""]

(* Numerické ověření *)
n = 7;
Print["Pro n = 7:"];
Do[
  Sk = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, k, n - 1}];
  Sk1 = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, k + 1, n - 1}];
  fk = -1/(1 - Sk);
  fk1 = -1/(1 - Sk1);
  tk = T[n, k];
  Print["  k=", k, ":"];
  Print["    S_k = ", Sk];
  Print["    S_{k+1} = ", Sk1];
  Print["    T[k] = S_k - S_{k+1} = ", Sk - Sk1, " = ", tk, "? ", Sk - Sk1 == tk];
  Print["    f_k = ", fk, ", f_{k+1} = ", fk1];
  Print["    Rozdíl denom: ", Denominator[fk] - Denominator[fk1]];
  Print[""],
  {k, 0, 3}
]

Print["3. VZTAH MEZI den[k] - den[k+1] A T[k]"]
Print["==============================================================="]
Print[""]

(* Pokud num je konstantní, pak: *)
(* f_k = num/den_k, f_{k+1} = num/den_{k+1} *)
(* den_k - den_{k+1} = num * (1/f_k - 1/f_{k+1}) = num * (f_{k+1} - f_k)/(f_k * f_{k+1}) *)

Print["Odvození:"]
Print["  f_k = num/den_k"]
Print["  den_k = num/f_k = num * (S_k - 1)")
Print["  den_k - den_{k+1} = num * (S_k - S_{k+1}) = num * T[k]"]
Print[""]

n = 7;
f0 = f[n, 0];
num = Numerator[f0];
Print["Pro n = ", n, ", num = ", num, ":"]
Do[
  dk = Denominator[f[n, k]];
  dk1 = Denominator[f[n, k + 1]];
  diff = dk - dk1;
  tk = T[n, k + 1];
  predicted = num * tk;
  Print["  den[", k, "] - den[", k + 1, "] = ", diff];
  Print["    num * T[", k + 1, "] = ", num, " * ", tk, " = ", predicted];
  Print["    Match: ", diff == predicted],
  {k, 0, 4}
]
Print[""]

Print["4. TEDY: den[k] - den[k+1] = num * T[k+1]"]
Print["==============================================================="]
Print[""]

Print["Ověření pro více n:"]
Do[
  f0 = f[n, 0];
  num = Numerator[f0];
  Print["n = ", n, " (num = ", num, "):"];
  allMatch = True;
  Do[
    dk = Denominator[f[n, k]];
    dk1 = Denominator[f[n, k + 1]];
    diff = dk - dk1;
    tk1 = T[n, k + 1];
    predicted = num * tk1;
    If[diff != predicted, allMatch = False; Print["  FAIL at k=", k]],
    {k, 0, n - 2}
  ];
  Print["  All differences = num * T[k+1]: ", allMatch],
  {n, {3, 5, 7, 11, 13}}
]
