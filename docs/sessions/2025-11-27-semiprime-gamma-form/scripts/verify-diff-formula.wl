(* Verify: den[k] - den[k+1] = num * T[k+1] *)

f[n_, startI_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, startI, n - 1}])
T[n_, k_] := Product[n^2 - j^2, {j, 1, k}]/(2 k + 1)

Print["==============================================================="]
Print["  VZOREC: den[k] - den[k+1] = num * T[k+1]"]
Print["==============================================================="]
Print[""]

Do[
  f0 = f[n, 0];
  num = Numerator[f0];
  Print["n = ", n, " (num = ", num, "):"];
  
  Do[
    dk = Denominator[f[n, k]];
    dk1 = Denominator[f[n, k + 1]];
    diff = dk - dk1;
    tk1 = T[n, k + 1];
    predicted = num * tk1;
    match = diff == predicted;
    Print["  k=", k, ": diff=", diff, ", num*T[", k+1, "]=", predicted, " ", If[match, "OK", "FAIL"]],
    {k, 0, Min[5, n - 2]}
  ];
  Print[""],
  {n, {5, 7, 11}}
]

Print["==============================================================="]
Print["  IMPLIKACE"]
Print["==============================================================="]
Print[""]

Print["den[0] = den[m] + num * Sum[T[k], k=1..m]"]
Print["       = den[m] + num * S_1..m"]
Print[""]
Print["Pro m = n-1 (poslední nenulovy clen):"]
Print["  den[n-1] je maly (relativne)"]
Print["  den[0] ~ num * S_celkova"]
Print[""]

Print["Takze jmenovatel koduje celou strukturu sumy!"]
