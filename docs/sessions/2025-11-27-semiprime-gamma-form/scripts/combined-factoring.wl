(* Can combining variants help with factorization? *)

Print["==============================================================="]
Print["  KOMBINACE VARIANT PRO FAKTORIZACI"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["1. DENOMINATORY OBE VARIANT"]
Print["==============================================================="]
Print[""]

semiprimes = {15, 21, 35, 77, 143};
Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  Print["n=", n, ":"];
  Print["  den_00 = ", d00];
  Print["  den_10 = ", d10];
  Print["  gcd = ", GCD[d00, d10]];
  Print["  lcm/d00 = ", LCM[d00, d10]/d00];
  Print["  lcm/d10 = ", LCM[d00, d10]/d10];
  Print[""],
  {n, semiprimes[[1;;3]]}
]

Print["2. GCD(den_00 + k, n) vs GCD(den_10 + k, n)"]
Print["==============================================================="]
Print[""]

Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  Print["n=", n, " = ", FactorInteger[n][[;;, 1]], ":"];
  factorFound00 = False;
  factorFound10 = False;
  For[k = 0, k <= 10 && (!factorFound00 || !factorFound10), k++,
    g00p = GCD[d00 + k, n];
    g00m = GCD[d00 - k, n];
    g10p = GCD[d10 + k, n];
    g10m = GCD[d10 - k, n];
    If[g00p > 1 && g00p < n && !factorFound00, 
      Print["  d00: factor ", g00p, " at k=+", k];
      factorFound00 = True];
    If[g00m > 1 && g00m < n && !factorFound00 && k > 0, 
      Print["  d00: factor ", g00m, " at k=-", k];
      factorFound00 = True];
    If[g10p > 1 && g10p < n && !factorFound10, 
      Print["  d10: factor ", g10p, " at k=+", k];
      factorFound10 = True];
    If[g10m > 1 && g10m < n && !factorFound10 && k > 0, 
      Print["  d10: factor ", g10m, " at k=-", k];
      factorFound10 = True];
  ];
  Print[""],
  {n, semiprimes}
]

Print["3. ROZDIL DENOMINATORU"]
Print["==============================================================="]
Print[""]

Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  diff = d00 - d10;
  Print["n=", n, ": d00-d10 = ", diff];
  Print["  Factor: ", FactorInteger[diff]];
  Print["  gcd(diff, n) = ", GCD[diff, n]],
  {n, semiprimes[[1;;3]]}
]
Print[""]

Print["4. SOUCIN DENOMINATORU"]
Print["==============================================================="]
Print[""]

Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  prod = d00 * d10;
  Print["n=", n, ": gcd(d00*d10 +/- k, n)"];
  For[k = 0, k <= 5, k++,
    gp = GCD[prod + k, n];
    gm = GCD[prod - k, n];
    If[gp > 1 && gp < n, Print["  +", k, ": ", gp]];
    If[gm > 1 && gm < n && k > 0, Print["  -", k, ": ", gm]];
  ],
  {n, semiprimes[[1;;2]]}
]
Print[""]

Print["5. VZTAH d10 - n^2 * d00?"]
Print["==============================================================="]
Print[""]

(* Pokud f00 = num/d00 a f10 = num/d10, pak *)
(* f00/f10 = d10/d00 = (1-S10)/(1-n^2 S10) *)

Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  num00 = Numerator[f00[n]];
  num10 = Numerator[f10[n]];
  Print["n=", n, ":"];
  Print["  f00 = ", num00, "/", d00];
  Print["  f10 = ", num10, "/", d10];
  Print["  d10 - n^2*d00 = ", d10 - n^2*d00];
  Print["  d10/d00 = ", N[d10/d00, 10], " vs n^2 = ", n^2],
  {n, {5, 7, 11}}
]
