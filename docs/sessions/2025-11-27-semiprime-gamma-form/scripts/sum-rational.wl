f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["PARCIALNI SUMY Sum[f10[n], n=3..N] RACIONALNE"]
Print["=============================================="]
Print[""]

partialSum = 0;
Do[
  partialSum += f10[n];
  num = Numerator[partialSum];
  den = Denominator[partialSum];
  Print["N=", n, ": ", num, " / ", den];
  Print["     = ", N[partialSum, 20]];
  Print["     den factors: ", FactorInteger[den]];
  Print[""],
  {n, 3, 8}
]

Print["JEDNOTLIVE CLENY f10[n]:"]
Print["========================"]
Print[""]

Do[
  val = f10[n];
  Print["f10[", n, "] = ", Numerator[val], " / ", Denominator[val]],
  {n, 2, 10}
]
