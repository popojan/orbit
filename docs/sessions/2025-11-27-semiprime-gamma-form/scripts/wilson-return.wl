Print["Wilson vs fSep navratova hodnota:"]
Print[""]
Print["n  | Wilson (n-1)! mod n | fSep Num"]
Print["---|---------------------|--------"]

fSep[n_, k_] := -1/(1 - Product[n^2 - j^2, {j, 1, k}] * (HarmonicNumber[2n - 1] - HarmonicNumber[n - 1]/2))

Do[
  wilson = Mod[(n - 1)!, n];
  fnum = Numerator[fSep[n, n - 1]];
  Print[n, "  | ", wilson, "                   | ", fnum],
  {n, 2, 15}
]
Print[""]

Print["Lze z Wilson ziskat n nebo 1?"]
Print[""]
Print["Napad: gcd((n-1)! + 1, n)"]
Do[
  g = GCD[(n - 1)! + 1, n];
  prime = If[PrimeQ[n], "P", "C"];
  Print["n=", n, " (", prime, "): gcd((n-1)!+1, n) = ", g],
  {n, 2, 15}
]
Print[""]

Print["gcd((n-1)!+1, n) = n pro prvocisla, 1 pro slozena (vetsinou)"]
