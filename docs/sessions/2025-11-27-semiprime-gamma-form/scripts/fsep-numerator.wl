fSep[n_, k_] := -1/(1 - Product[n^2 - j^2, {j, 1, k}] * (HarmonicNumber[2n - 1] - HarmonicNumber[n - 1]/2))

Print["Test: Numerator[fSep[n, n-1]]"]
Print[""]
Print["n  | prime? | Num[fSep] | Num[f10]"]
Print["---|--------|-----------|--------"]

f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Do[
  fs = fSep[n, n - 1];
  f = f10[n];
  numSep = Numerator[fs];
  numOrig = Numerator[f];
  prime = If[PrimeQ[n], "yes", "no"];
  Print[n, "  | ", prime, "    | ", numSep, "         | ", numOrig],
  {n, 2, 15}
]
