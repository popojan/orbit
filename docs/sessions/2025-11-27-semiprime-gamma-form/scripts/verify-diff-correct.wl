(* Správná formula: den[k] - den[k+1] = num * T[k+1]? nebo T[k]? *)

f[n_, startI_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, startI, n - 1}])
T[n_, k_] := Product[n^2 - j^2, {j, 1, k}]/(2 k + 1)

Print["==============================================================="]
Print["  HLEDAME SPRAVNOU FORMULI"]
Print["==============================================================="]
Print[""]

n = 7;
num = Numerator[f[n, 0]];
Print["n = ", n, ", num = ", num]
Print[""]

Print["T[k] hodnoty:"]
Do[Print["  T[", k, "] = ", T[n, k]], {k, 0, 6}]
Print[""]

Print["Rozdily denominatoru:"]
Do[
  dk = Denominator[f[n, k]];
  dk1 = Denominator[f[n, k + 1]];
  diff = dk - dk1;
  Print["  den[", k, "] - den[", k+1, "] = ", diff],
  {k, 0, 5}
]
Print[""]

Print["Srovnani diff vs num*T[k]:"]
Do[
  dk = Denominator[f[n, k]];
  dk1 = Denominator[f[n, k + 1]];
  diff = dk - dk1;
  tk = T[n, k];
  numTk = num * tk;
  Print["  k=", k, ": diff=", diff, ", num*T[k]=", numTk, " ratio=", diff/numTk],
  {k, 0, 5}
]
Print[""]

Print["==============================================================="]
Print["  AHA! Podivejme se na diff/num"]
Print["==============================================================="]
Print[""]

Do[
  dk = Denominator[f[n, k]];
  dk1 = Denominator[f[n, k + 1]];
  diff = dk - dk1;
  Print["  k=", k, ": diff/num = ", diff/num],
  {k, 0, 5}
]
Print[""]

Print["A ted porovnej s T:"]
Do[
  Print["  T[", k, "] = ", T[n, k]],
  {k, 1, 6}
]
