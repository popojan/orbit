(* Shifted sequences - posun indexu *)

Print["==============================================================="]
Print["  POSUNUTÉ SEKVENCE"]
Print["==============================================================="]
Print[""]

(* Sekvence denominátorů pro různé startovací i *)
f[n_, startI_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, startI, n - 1}])

Print["1. SEKVENCE d[k] PRO n=143"]
Print["==============================================================="]
Print[""]

n = 143;
denSeq = Table[Denominator[f[n, k]], {k, 0, 10}];
Print["d[k] pro k=0..10:"]
Do[
  Print["  d[", k, "] = ", denSeq[[k + 1]]],
  {k, 0, 10}
]
Print[""]

Print["2. ROZDÍLY SOUSEDNÍCH ČLENŮ"]
Print["==============================================================="]
Print[""]

diffs = Table[denSeq[[k]] - denSeq[[k + 1]], {k, 1, 10}];
Print["d[k] - d[k+1]:"]
Do[
  Print["  d[", k-1, "] - d[", k, "] = ", diffs[[k]], "  gcd(.,n) = ", GCD[diffs[[k]], n]],
  {k, 1, 10}
]
Print[""]

Print["3. POSUNUTÉ ROZDÍLY d[k] - d[k+2]"]
Print["==============================================================="]
Print[""]

Do[
  diff2 = denSeq[[k]] - denSeq[[k + 2]];
  Print["  d[", k-1, "] - d[", k+1, "] = ", diff2, "  gcd = ", GCD[diff2, n]],
  {k, 1, 9}
]
Print[""]

Print["4. POSUNUTÉ PRODUKTY d[k] * d[k+s] mod n"]
Print["==============================================================="]
Print[""]

Do[
  Print["Shift s = ", s, ":"];
  Do[
    prod = denSeq[[k]] * denSeq[[k + s]];
    g = GCD[prod, n];
    If[g > 1 && g < n, Print["  d[", k-1, "]*d[", k-1+s, "] mod ", n, " -> gcd = ", g]],
    {k, 1, 10 - s}
  ],
  {s, 1, 3}
]
Print[""]

Print["5. GCD MEZI RŮZNÝMI n"]
Print["==============================================================="]
Print[""]

Print["gcd(d_n[0], d_m[0]) pro semiprimes:"]
semiprimes = {15, 21, 35, 77, 143};
dens = Table[Denominator[f[n, 0]], {n, semiprimes}];
Do[
  g = GCD[dens[[i]], dens[[j]]];
  If[g > 1,
    Print["  gcd(d_", semiprimes[[i]], ", d_", semiprimes[[j]], ") = ", g]
  ],
  {i, 1, Length[semiprimes]}, {j, i + 1, Length[semiprimes]}
]
Print[""]

Print["6. ROZDÍL d[n] - d[n+k] PRO RŮZNÉ n (s fixním k)"]
Print["==============================================================="]
Print[""]

Print["Fixní k=1, různé n:"]
Do[
  dn0 = Denominator[f[n, 0]];
  dn1 = Denominator[f[n, 1]];
  diff = dn0 - dn1;
  Print["  n=", n, ": d[0]-d[1] = ", diff, " = n? ", diff == n],
  {n, {3, 5, 7, 11, 13, 15, 21}}
]
Print[""]

Print["7. GENERUJÍCÍ FUNKCE ROZDÍLU?"]
Print["==============================================================="]
Print[""]

Print["Sekvence d[0] pro prvočísla:"]
primes = {3, 5, 7, 11, 13};
primeDens = Table[Denominator[f[p, 0]], {p, primes}];
Print[primeDens]
Print[""]

Print["Podíly d[p]/d[q]:"]
Do[
  ratio = primeDens[[i]]/primeDens[[j]];
  Print["  d_", primes[[i]], "/d_", primes[[j]], " = ", N[ratio, 6]],
  {i, 2, Length[primes]}, {j, 1, i - 1}
]
