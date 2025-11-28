(* Transition point analysis *)

Print["==============================================================="]
Print["  PŘECHODOVÝ BOD - KDE SE GCD MĚNÍ?"]
Print["==============================================================="]
Print[""]

f[n_, startI_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, startI, n - 1}])

(* Pro různé semiprimes, najdi kde gcd přestane být n *)
semiprimes = {15, 21, 35, 55, 77, 91, 143, 187};

Do[
  factors = FactorInteger[n][[;;, 1]];
  p = factors[[1]];
  q = factors[[2]];
  wilsonP = (p - 1)/2;
  wilsonQ = (q - 1)/2;
  
  Print["n=", n, " = ", p, "*", q, ", Wilson points: ", wilsonP, ", ", wilsonQ];
  
  denSeq = Table[Denominator[f[n, k]], {k, 0, Min[15, n-1]}];
  
  transitionK = -1;
  Do[
    If[k < Length[denSeq],
      diff = denSeq[[k]] - denSeq[[k + 1]];
      g = GCD[diff, n];
      If[g != n && transitionK == -1,
        transitionK = k - 1;
        Print["  Transition at k=", transitionK, " (gcd went from ", n, " to ", g, ")"];
      ]
    ],
    {k, 1, Min[14, Length[denSeq] - 1]}
  ];
  
  If[transitionK == -1, Print["  No transition found in range"]];
  
  Print["  min(Wilson) = ", Min[wilsonP, wilsonQ], ", transition = ", transitionK];
  Print["  Match: ", transitionK == Min[wilsonP, wilsonQ]];
  Print[""],
  {n, semiprimes}
]

Print["==============================================================="]
Print["  CO SE DĚJE V PŘECHODOVÉM BODĚ?"]
Print["==============================================================="]
Print[""]

n = 143;
{p, q} = {11, 13};
Print["n=", n, " = ", p, "*", q]
Print[""]

T[n_, k_] := Product[n^2 - j^2, {j, 1, k}]/(2 k + 1)

Print["Členy T[k] mod p a mod q:"]
Do[
  tk = T[n, k];
  tkNum = Numerator[tk];
  tkDen = Denominator[tk];
  Print["  T[", k, "] = ", tkNum, "/", tkDen];
  Print["    Num mod ", p, " = ", Mod[tkNum, p], ", Num mod ", q, " = ", Mod[tkNum, q]];
  Print["    (p-1)/2 = ", (p-1)/2, ", (q-1)/2 = ", (q-1)/2],
  {k, 4, 7}
]
Print[""]

Print["==============================================================="]
Print["  PRODUKTY V OKOLÍ WILSON BODŮ"]
Print["==============================================================="]
Print[""]

Print["Product[n^2-j^2, j=1..k] mod p pro k kolem (p-1)/2:"]
Do[
  prod = Product[n^2 - j^2, {j, 1, k}];
  Print["  k=", k, ": prod mod ", p, " = ", Mod[prod, p], ", prod mod ", q, " = ", Mod[prod, q]],
  {k, 3, 8}
]
Print[""]

Print["Klíčový moment: k = (p-1)/2 = 5"]
Print["  Product[143^2-j^2, j=1..5] mod 11 = ", Mod[Product[143^2 - j^2, {j, 1, 5}], 11]]
Print["  Tohle by mělo být (p-1)! mod p = 10! mod 11 = 10 (Wilson!)"]
Print[""]

Print["Ověření Wilson:"]
Print["  10! mod 11 = ", Mod[10!, 11]]
Print["  = -1 mod 11 = 10 ✓"]
