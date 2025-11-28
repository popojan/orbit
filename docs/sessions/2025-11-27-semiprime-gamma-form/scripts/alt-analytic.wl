(* Analyticky definovana verze - pouzijeme Gamma misto Product *)
(* Product[n^2 - j^2, {j, 1, i}] = Product[(n-j)(n+j), {j, 1, i}] *)
(* = Gamma[n]/Gamma[n-i] * Gamma[n+i+1]/Gamma[n+1] pro i < n *)

(* Pro celociselne n mame: *)
f10[n_Integer] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

(* Analyticky pro spojite n: *)
(* Product[n^2 - j^2, {j,1,i}] = Pochhammer[n-i,i] * Pochhammer[n+1,i] *)
(* = Gamma[n]/Gamma[n-i] * Gamma[n+1+i]/Gamma[n+1] *)

fCont[n_] := Module[{S},
  (* Pro velke n potrebujeme orezat sumu na i < n *)
  S = Sum[Gamma[n+1]/Gamma[n-i+1] * Gamma[n+1+i]/Gamma[n+1] / (2*i + 1), 
          {i, 0, Floor[n] - 1}];
  -1/(1 - S)
]

Print["Overeni: f10[n] vs fCont[n] pro cela n:"]
Do[
  v1 = N[f10[n], 15];
  v2 = N[fCont[n], 15];
  Print["  n=", n, ": f10=", v1, ", fCont=", v2, ", match=", Abs[v1-v2] < 10^-10],
  {n, 2, 6}
]
Print[""]

(* Zkusme jiny pristup: integralova reprezentace *)
Print["Integralova reprezentace:"]
Print["  Suma (-1)^n * f[n] muze byt Mellinova/Fourierova transformace"]
Print[""]

(* Zkusme exponencialni generujici funkci *)
Print["Exponencialni generujici funkce:"]
egf = Sum[f10[n] * x^n / n!, {n, 2, 20}];
Print["  Sum[f[n]*x^n/n!, n=2..20] pri x=1:"]
Print["  = ", N[egf /. x -> 1, 15]]
Print["  pri x=-1: = ", N[egf /. x -> -1, 15]]
Print[""]

(* Obycejny generujici funkce *)
Print["Obycejny generujici funkce Sum[f[n]*x^n]:"]
vals = Table[{n, f10[n]}, {n, 2, 12}];
Print["  Koeficienty: ", vals]
Print[""]

(* Zkusme integral transformaci *)
Print["Testujeme integral Int[f(t)*cos(Pi*t), t, 2, Inf]:"]
(* To by teoreticky dalo alternujici sumu *)

(* Podivejme se na strukturu f10 pres Pochhammer *)
Print[""]
Print["Struktura pres Pochhammer:"]
Print["  Product[n^2-j^2, j=1..i] = (-1)^i * Pochhammer[1-n, i] * Pochhammer[1+n, i]"]
Do[
  prod = Product[n^2 - j^2, {j, 1, i}] /. n -> 5;
  poch = (-1)^i * Pochhammer[1 - 5, i] * Pochhammer[1 + 5, i];
  Print["  n=5, i=", i, ": Product=", prod, ", Poch=", poch, ", match=", prod == poch],
  {i, 0, 4}
]
