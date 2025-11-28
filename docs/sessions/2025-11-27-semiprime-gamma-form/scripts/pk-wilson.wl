Pk[n_, k_] := Product[n^2 - j^2, {j, 1, k}]

Print["Rozklad Pk[n, n-1]:"]
Print[""]
Print["Product[n^2 - j^2, j=1..n-1]"]
Print["= Product[(n-j)(n+j), j=1..n-1]"]
Print["= (n-1)(n+1) * (n-2)(n+2) * ... * (1)(2n-1)"]
Print["= (n-1)! * (2n-1)!/n!"]
Print["= (2n-1)! / n"]
Print[""]

Print["Overeni:")
Do[
  pk = Pk[n, n - 1];
  formula = (2 n - 1)!/n;
  Print["n=", n, ": Pk=", pk, ", (2n-1)!/n=", formula, ", match=", pk == formula],
  {n, 2, 8}
]
Print[""]

Print["Takze fSep[n, n-1] obsahuje:"]
Print["  (2n-1)!/n * Hn"]
Print[""]
Print["Wilson: (p-1)! = -1 (mod p)")
Print["My:     (2p-1)!/p * Hn  ... jiny factorial!"]
Print[""]

Print["Porovnani slozitosti:"]
Print["  Wilson: spocitat (n-1)! mod n"]
Print["  fSep:   spocitat (2n-1)!/n * Hn a extrahovat citatel"]
Print[""]
Print["fSep je POMALEJSI nez Wilson - pouziva (2n-1)! misto (n-1)!"]
