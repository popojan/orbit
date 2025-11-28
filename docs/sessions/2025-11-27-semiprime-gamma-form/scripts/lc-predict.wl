S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]
getA[n_] := Numerator[S10[n]]

(* Muzeme predikovat b z vlastnosti n? *)
(* A mod p kde A = Sum[(...)/(2i+1), ...] *)
(* Klicova otazka: jake jsou cleny sumy mod p? *)

Print["Analyza A mod p pres jednotlive cleny:"]
Print[""]

n = 77;  (* = 7 * 11 *)
p = 7;

Print["n = ", n, " = 7 * 11, p = 7:"]
Print[""]

(* Jednotlive cleny *)
terms = Table[
  t = Product[n^2 - j^2, {j, 1, i}]/(2 i + 1);
  {i, t, Mod[Numerator[t], p], Denominator[t], Mod[Denominator[t], p]},
  {i, 0, n - 1}
];

Print["i | clen | num mod 7 | den | den mod 7"]
Do[
  {i, t, numMod, den, denMod} = terms[[k]];
  If[k <= 10 || k > n - 3,
    Print[i, " | ", N[t, 6], " | ", numMod, " | ", den, " | ", denMod]
  ];
  If[k == 11, Print["..."]],
  {k, Length[terms]}
]
Print[""]

(* Kde je singularita? *)
Print["Singularita pri i = (p-1)/2 = 3:"]
Print["  2*3+1 = 7 = p, takze delime p"]
Print["  => tento clen diverguje mod p"]
Print[""]

(* Mozna soucet jen do singularity? *)
Print["Parcialni soucty A_k = Sum[..., i=0..k]:"]
Do[
  Ak = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, k}];
  AkNum = Numerator[Ak * n];  (* A = Ak * n pro uplnou sumu *)
  Print["  k=", k, ": A_k*n mod 7 = ", Mod[AkNum, 7]],
  {k, 0, 6}
]
Print[""]

(* Pro q = 11 *)
q = 11;
Print["Pro q = 11, singularita pri i = 5:"]
Do[
  Ak = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, k}];
  AkNum = Numerator[Ak * n];
  Print["  k=", k, ": A_k*n mod 11 = ", Mod[AkNum, q]],
  {k, 0, 10}
]
