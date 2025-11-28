(* B divisibility analysis *)

S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
f00[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])
f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["B = denominator of S10"]
Print["======================"]
Print[""]

semiprimes = {15, 21, 35, 55, 77, 91, 143};
Do[
  s10 = S10[n];
  B = Denominator[s10];
  A = Numerator[s10];
  Print["n=", n, ": B=", B, ", B mod n=", Mod[B, n], ", n | B? ", Mod[B, n] == 0],
  {n, semiprimes}
]
Print[""]

Print["Also for primes:"]
Do[
  s10 = S10[p];
  B = Denominator[s10];
  Print["p=", p, ": B=", B, ", B mod p=", Mod[B, p]],
  {p, {3, 5, 7, 11, 13}}
]
Print[""]

Print["WHAT IS gcd(d00, n) AND gcd(d10, n)?"]
Print["===================================="]
Print[""]

Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  Print["n=", n, ": gcd(d00,n)=", GCD[d00, n], ", gcd(d10,n)=", GCD[d10, n]],
  {n, semiprimes}
]
Print[""]

Print["SO: gcd(d00, n) and gcd(d10, n) are both 1"]
Print["The linear combo must create divisibility!"]
Print[""]

Print["REVISITING: Why does -d00 + b*d10 work?"]
Print["========================================"]
Print[""]

(* Let's look at actual values more carefully *)
n = 15;
s10 = S10[n];
A = Numerator[s10];
B = Denominator[s10];
d00 = Denominator[f00[n]];
d10 = Denominator[f10[n]];

Print["n=15: A=", A, ", B=", B]
Print["      d00=", d00, ", d10=", d10]
Print[""]

Print["Testing combinations:"]
Do[
  combo = -d00 + b*d10;
  g = GCD[combo, n];
  If[g > 1 && g < n,
    Print["  b=", b, ": -d00 + b*d10 = ", combo, ", gcd = ", g, " <- FACTOR"]
  ],
  {b, -5, 5}
]
Print[""]

Print["STRUCTURE OF d00 and d10 mod 3 and mod 5:"]
Print["d00 mod 3 = ", Mod[d00, 3], ", d00 mod 5 = ", Mod[d00, 5]]
Print["d10 mod 3 = ", Mod[d10, 3], ", d10 mod 5 = ", Mod[d10, 5]]
Print[""]

Print["For b=-1:"]
Print["  -d00 - d10 mod 3 = ", Mod[-d00 - d10, 3]]
Print["  -d00 - d10 mod 5 = ", Mod[-d00 - d10, 5]]
Print[""]

Print["FINDING THE PATTERN:"]
Print["===================="]

Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  factors = FactorInteger[n][[;;, 1]];
  p = factors[[1]];
  q = factors[[2]];
  
  Print["n=", n, " = ", p, "*", q, ":"];
  Print["  d00 mod ", p, " = ", Mod[d00, p], ", d10 mod ", p, " = ", Mod[d10, p]];
  Print["  d00 mod ", q, " = ", Mod[d00, q], ", d10 mod ", q, " = ", Mod[d10, q]];
  
  (* What b makes -d00 + b*d10 = 0 mod p? *)
  (* -d00 + b*d10 = 0 mod p *)
  (* b*d10 = d00 mod p *)
  (* b = d00/d10 mod p *)
  If[GCD[Mod[d10, p], p] == 1,
    bP = Mod[Mod[d00, p] * PowerMod[Mod[d10, p], -1, p], p];
    If[bP > p/2, bP = bP - p];
    Print["  b for factor p: ", bP]
  ];
  If[GCD[Mod[d10, q], q] == 1,
    bQ = Mod[Mod[d00, q] * PowerMod[Mod[d10, q], -1, q], q];
    If[bQ > q/2, bQ = bQ - q];
    Print["  b for factor q: ", bQ]
  ];
  Print[""],
  {n, semiprimes}
]
