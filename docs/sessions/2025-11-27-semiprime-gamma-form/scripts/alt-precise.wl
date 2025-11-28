f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

s = Sum[(-1)^n * f10[n], {n, 2, 150}];  (* vice clenu *)
sN = N[s, 60];

eta3 = (1 - 2^(1-3))*Zeta[3];

Print["Presnejsi vypocet (150 clenu):"]
Print["  s = ", N[s, 30]]
Print[""]

(* Rozdil od eta(3) + 1/110 *)
approx1 = N[eta3 + 1/110, 60];
diff1 = sN - approx1;
Print["s - (eta(3) + 1/110):"]
Print["  = ", N[diff1, 25]]
Print["  1/diff = ", N[1/diff1, 15]]
Print[""]

(* Mozna s = eta(3) + racionalni cislo? *)
(* Zkusme presnou racionalni aproximaci rozdilu s - eta(3) *)
d = sN - N[eta3, 60];
Print["d = s - eta(3) = ", N[d, 25]]
Print[""]

(* Continued fraction pro d *)
Print["Continued fraction pro d:"]
cfrac = ContinuedFraction[N[d, 40], 15];
Print["  ", cfrac]
Print["  Konvergenty:"]
Do[
  conv = FromContinuedFraction[Take[cfrac, k]];
  Print["    k=", k, ": ", conv, " = ", N[conv, 15], ", err = ", N[d - conv, 10]],
  {k, 1, Min[10, Length[cfrac]]}
]
Print[""]

(* Zkusime kombinaci s jinymi konstantami *)
Print["Kombinace s = eta(3) + a*Pi/b + c/d:"]
bestErr = 1;
bestParams = {};
Do[
  Do[
    val = N[eta3 + a*Pi/b + c/d, 40];
    err = Abs[sN - val];
    If[err < bestErr && err < 10^-10,
      bestErr = err;
      bestParams = {a, b, c, d, err}
    ],
    {a, -5, 5}, {b, 1, 50}
  ],
  {c, -5, 5}, {d, 1, 200}
];
If[bestParams =!= {},
  Print["  Nalezeno: a=", bestParams[[1]], ", b=", bestParams[[2]], 
        ", c=", bestParams[[3]], ", d=", bestParams[[4]], 
        ", err=", bestParams[[5]]]
,
  Print["  Zadna dobra kombinace"]
]
Print[""]

(* f10[2] = 1, takze alternujici suma od n=2 zacina s +1 *)
(* Mozna odecteme f10[2] = 1? *)
s3 = Sum[(-1)^n * f10[n], {n, 3, 150}];
Print["Alternujici suma od n=3:"]
Print["  Sum[(-1)^n * f10[n], n=3..150] = ", N[s3, 25]]
Print["  = s - 1 = ", N[sN - 1, 25]]
Print["  Vztah k eta(3): ", N[N[s3, 40]/eta3, 15]]
