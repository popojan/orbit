f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

s = Sum[(-1)^n * f10[n], {n, 2, 100}];

Print["Alternujici suma s = ", N[s, 30]]
Print[""]

(* Zkusime Recognize - hleda algebraicke cislo *)
Print["Algebraic number test:"]
alg = Recognize[N[s, 50], 6, x];
Print["  Recognize[s, 6, x] = ", alg]
Print[""]

(* Kombinace s racionaly *)
Print["Racionalni aproximace:"]
Print["  RootApproximant[s] = ", RootApproximant[N[s, 30]]]
Print[""]

(* Kombinace se znamymi konstantami *)
Print["Hledani vztahu:"]
constants = {Pi, E, Log[2], Sqrt[2], Sqrt[3], EulerGamma, Catalan, Zeta[2], Zeta[3]};
Do[
  c = constants[[i]];
  ratio = N[s/c, 15];
  diff = N[s - c, 15];
  inv = N[c/s, 15];
  If[Abs[ratio - Round[ratio]] < 0.01 || Abs[diff] < 0.1,
    Print["  s/", c, " = ", ratio]
  ];
  If[Abs[inv - Round[inv]] < 0.01,
    Print["  ", c, "/s = ", inv]
  ],
  {i, Length[constants]}
]
Print[""]

(* Specificke kombinace *)
Print["Specificke testy:"]
Print["  s - 1 = ", N[s - 1, 20]]
Print["  1 - s = ", N[1 - s, 20]]
Print["  1/(1-s) = ", N[1/(1 - s), 20]]
Print["  s/(1-s) = ", N[s/(1 - s), 20]]
Print[""]

(* Zkusme vztahy s Gamma/factorial *)
Print["Gamma vztahy:"]
Print["  Gamma[1/2]^2/Pi = 1, s*Pi = ", N[s*Pi, 15]]
Print["  s * Gamma[1/3] = ", N[s * Gamma[1/3], 15]]
Print["  s + Gamma[1/4]/4 = ", N[s + Gamma[1/4]/4, 15]]
