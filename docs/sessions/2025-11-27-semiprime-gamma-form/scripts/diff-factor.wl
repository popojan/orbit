(* Does gcd(d00-d10, n) give factors? *)

Print["==============================================================="]
Print["  GCD(d00-d10, n) - DAVA FAKTORY?"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

semiprimes = Select[Range[6, 200], Length[FactorInteger[#]] == 2 && Max[FactorInteger[#][[;;,2]]] == 1 &];
Print["Testuju ", Length[semiprimes], " squarefree semiprimes od 6 do 200"]
Print[""]

successes = 0;
Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  diff = Abs[d00 - d10];
  g = GCD[diff, n];
  factors = FactorInteger[n][[;;, 1]];
  
  If[g > 1 && g < n,
    successes++;
    Print["n=", n, " = ", factors[[1]], "*", factors[[2]], ": gcd(diff, n) = ", g, " <- FACTOR!"];
  ],
  {n, semiprimes}
]

Print[""]
Print["Uspesnost: ", successes, " / ", Length[semiprimes]]
Print[""]

Print["==============================================================="]
Print["  A CO KDYZ TO NEFUNGUJE?"]
Print["==============================================================="]
Print[""]

Print["Priklady kde gcd(d00-d10, n) = 1:"]
count = 0;
Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  diff = Abs[d00 - d10];
  g = GCD[diff, n];
  
  If[g == 1 && count < 5,
    count++;
    factors = FactorInteger[n][[;;, 1]];
    Print["n=", n, " = ", factors[[1]], "*", factors[[2]], ": gcd = 1"];
    Print["  diff mod p = ", Mod[diff, factors[[1]]], ", diff mod q = ", Mod[diff, factors[[2]]]];
  ],
  {n, semiprimes}
]
Print[""]

Print["==============================================================="]
Print["  JINE KOMBINACE"]
Print["==============================================================="]
Print[""]

f01[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 1, n}])
f11[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, n - 1}])

Print["Testuju vsechny pary rozdilu:"]
testN = {15, 21, 35, 77, 143};
Do[
  d00 = Denominator[f00[n]];
  d01 = Denominator[f01[n]];
  d10 = Denominator[f10[n]];
  d11 = Denominator[f11[n]];
  
  Print["n=", n, " = ", FactorInteger[n][[;;,1]]];
  Print["  gcd(d00-d01, n) = ", GCD[Abs[d00-d01], n]];
  Print["  gcd(d00-d10, n) = ", GCD[Abs[d00-d10], n]];
  Print["  gcd(d00-d11, n) = ", GCD[Abs[d00-d11], n]];
  Print["  gcd(d01-d10, n) = ", GCD[Abs[d01-d10], n]];
  Print["  gcd(d01-d11, n) = ", GCD[Abs[d01-d11], n]];
  Print["  gcd(d10-d11, n) = ", GCD[Abs[d10-d11], n]];
  Print[""],
  {n, testN}
]
