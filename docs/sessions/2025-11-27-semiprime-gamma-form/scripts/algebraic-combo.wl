(* Algebraic combinations for factorization *)

Print["==============================================================="]
Print["  ALGEBRAICKE KOMBINACE PRO FAKTORIZACI"]
Print["==============================================================="]
Print[""]

S00[n_] := Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}]
S01[n_] := Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 1, n}]
S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n-1}]
S11[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 1, n-1}]

(* Vime: S00 = n^2 * S10, S00-S01 = n^2, S10-S11 = 1 *)

Print["Vztahy:"]
Print["  S00 = n^2 * S10"]
Print["  S01 = S00 - n^2 = n^2 * S10 - n^2 = n^2 * (S10 - 1) = n^2 * S11"]
Print[""]

Print["Overeni S01 = n^2 * S11:"]
Do[
  ratio = S01[n] / S11[n];
  Print["  n=", n, ": S01/S11 = ", ratio, " vs n^2 = ", n^2],
  {n, 3, 8}
]
Print[""]

Print["==============================================================="]
Print["  DETERMINANT 2x2 MATICE?"]
Print["==============================================================="]
Print[""]

Print["Matice M = [[S00, S01], [S10, S11]]"]
Print["det(M) = S00*S11 - S01*S10 = n^2*S10*S11 - n^2*S11*S10 = 0!"]
Print[""]

Print["Overeni det = 0:"]
Do[
  det = S00[n]*S11[n] - S01[n]*S10[n];
  Print["  n=", n, ": det = ", det],
  {n, 3, 8}
]
Print[""]

Print["==============================================================="]
Print["  CO S DENOMINATORY?"]
Print["==============================================================="]
Print[""]

f00[n_] := -1/(1 - S00[n])
f01[n_] := -1/(1 - S01[n])
f10[n_] := -1/(1 - S10[n])
f11[n_] := -1/(1 - S11[n])

Print["Vztahy mezi denominatory:"]
Do[
  d00 = Denominator[f00[n]];
  d01 = Denominator[f01[n]];
  d10 = Denominator[f10[n]];
  d11 = Denominator[f11[n]];
  n00 = Numerator[f00[n]];
  n01 = Numerator[f01[n]];
  n10 = Numerator[f10[n]];
  n11 = Numerator[f11[n]];
  
  Print["n=", n, ":"];
  Print["  nums: ", {n00, n01, n10, n11}];
  Print["  d00*d11 - d01*d10 = ", d00*d11 - d01*d10];
  Print["  gcd(d00*d11 - d01*d10, n) = ", GCD[d00*d11 - d01*d10, n]],
  {n, {15, 21, 35, 77}}
]
Print[""]

Print["==============================================================="]
Print["  SUMA DENOMINATORU?"]
Print["==============================================================="]
Print[""]

Do[
  d00 = Denominator[f00[n]];
  d01 = Denominator[f01[n]];
  d10 = Denominator[f10[n]];
  d11 = Denominator[f11[n]];
  
  sumDen = d00 + d01 + d10 + d11;
  Print["n=", n, ": gcd(sum_den, n) = ", GCD[sumDen, n], " (factors: ", FactorInteger[n][[;;,1]], ")"],
  {n, {15, 21, 35, 77, 143}}
]
Print[""]

Print["==============================================================="]
Print["  LINEÁRNÍ KOMBINACE a*d00 + b*d10?"]
Print["==============================================================="]
Print[""]

(* Hledame a,b takove ze gcd(a*d00 + b*d10, n) > 1 *)
Do[
  d00 = Denominator[f00[n]];
  d10 = Denominator[f10[n]];
  factors = FactorInteger[n][[;;, 1]];
  
  Print["n=", n, " = ", factors[[1]], "*", factors[[2]], ":"];
  
  (* Zkusime male koeficienty *)
  found = False;
  For[a = -5, a <= 5 && !found, a++,
    For[b = -5, b <= 5 && !found, b++,
      If[{a, b} != {0, 0},
        combo = a*d00 + b*d10;
        g = GCD[combo, n];
        If[g > 1 && g < n,
          Print["  a=", a, ", b=", b, ": gcd = ", g, " <- FACTOR!"];
          found = True;
        ]
      ]
    ]
  ];
  If[!found, Print["  No simple combo found"]],
  {n, {15, 21, 35, 77, 143}}
]
