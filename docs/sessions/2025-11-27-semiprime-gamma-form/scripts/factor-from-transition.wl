(* Factorization from transition point *)

Print["==============================================================="]
Print["  FAKTORIZACE Z PŘECHODOVÉHO BODU"]
Print["==============================================================="]
Print[""]

f[n_, startI_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, startI, n - 1}])

findTransition[n_] := Module[{k, d0, d1, g},
  d0 = Denominator[f[n, 0]];
  For[k = 1, k < n, k++,
    d1 = Denominator[f[n, k]];
    g = GCD[d0 - d1, n];
    If[g != n, Return[k - 1]];  (* Přechod nastal *)
    d0 = d1;
  ];
  Return[-1]  (* Nenalezeno *)
]

factorFromTransition[n_] := Module[{k, p},
  k = findTransition[n];
  If[k == -1, Return[{-1, -1}]];
  p = 2 k + 1;
  If[Mod[n, p] == 0 && PrimeQ[p],
    {p, n/p},
    {-1, -1}
  ]
]

Print["Testování faktorizace:"]
semiprimes = {15, 21, 33, 35, 55, 77, 91, 143, 187, 221, 323, 437};

Do[
  factors = FactorInteger[n][[;;, 1]];
  {foundP, foundQ} = factorFromTransition[n];
  Print["n=", n, " = ", factors[[1]], "*", factors[[2]], 
    " -> found: ", foundP, "*", foundQ,
    If[Sort[{foundP, foundQ}] == Sort[factors], " ✓", " ✗"]],
  {n, semiprimes}
]
Print[""]

Print["==============================================================="]
Print["  SLOŽITOST METODY"]
Print["==============================================================="]
Print[""]

Print["Pro nalezení přechodového bodu k:"]
Print["  - Počítáme d[0], d[1], ..., d[k+1]"]
Print["  - k = (min_factor - 1)/2"]
Print["  - Pro n = p*q, min_factor = min(p,q) ~ sqrt(n)"]
Print["  - Tedy k ~ O(sqrt(n))"]
Print[""]

Print["Každý d[i] vyžaduje výpočet sumy s O(n) členy..."]
Print["Ale můžeme iterovat! d[k+1] = d[k] - num*T[k+1]"]
Print[""]

Print["Iterativní přístup:"]
Print["  - d[0] vyžaduje O(n) operací"]
Print["  - d[k+1] = d[k] - (něco iterativně) ... O(1) update?"]
Print[""]

Print["==============================================================="]
Print["  MŮŽEME POČÍTAT ITERATIVNĚ?"]
Print["==============================================================="]
Print[""]

T[n_, k_] := Product[n^2 - j^2, {j, 1, k}]/(2 k + 1)

Print["T[k+1] / T[k] = (n^2 - (k+1)^2) * (2k+1) / (2k+3)"]
Print[""]

n = 143;
Print["Pro n=143:"]
prevT = T[n, 1];
Do[
  currT = T[n, k];
  ratio = currT / prevT;
  expected = (n^2 - k^2) * (2(k-1) + 1) / (2(k-1) + 3);
  Print["  T[", k, "]/T[", k-1, "] = ", ratio, " = ", expected, "? ", ratio == expected];
  prevT = currT,
  {k, 2, 6}
]
Print[""]

Print["ZÁVĚR:"]
Print["  T[k] lze počítat iterativně v O(1) na krok"]
Print["  d[k] = d[k-1] - num * T[k]"]
Print["  Celkem O(sqrt(n)) kroků, každý O(1)"]
Print["  = O(sqrt(n)) celkem!"]
Print[""]

Print["ALE: Pracujeme s obřími čísly! d[0] má O(n^2) digity"]
Print["Aritmetika s takovými čísly je O(n^2) per operace"]
Print["Celkem: O(sqrt(n) * n^2) = O(n^2.5)")
Print[""]

Print["To je horší než trial division O(sqrt(n))"]
