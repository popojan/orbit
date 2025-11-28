f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

(* Vnitrni suma: *)
(* Sum[(-1)^i * Pochhammer[1-n,i] * Pochhammer[1+n,i] / (2i+1), i=0..n-1] *)

(* Prepisme: 2i+1 = Pochhammer[1,i]/Pochhammer[1/2,i] * 2^i ... ne *)
(* Nebo: 1/(2i+1) = (1/2)_i / (3/2)_i * 1/i! ... *)

Print["Analyza vnitrni sumy:"]
Print[""]

Do[
  S = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
  Print["n=", n, ": S = ", S, " = ", N[S, 10]];
  (* Zkusme hypergeometric *)
  hyp = Hypergeometric2F1[1 - n, 1 + n, 3/2, 1];
  Print["       2F1[1-n, 1+n, 3/2, 1] = ", hyp, " = ", N[hyp, 10]],
  {n, 2, 6}
]
Print[""]

(* 2F1[a,b,c,1] = Gamma[c]*Gamma[c-a-b]/(Gamma[c-a]*Gamma[c-b]) pro c-a-b > 0 *)
Print["Gauss hypergeometric identity:"]
Print["  2F1[1-n, 1+n, 3/2, 1] = Gamma[3/2]*Gamma[3/2-2]/(Gamma[3/2-1+n]*Gamma[3/2-1-n])"]
Print["  ale 3/2 - 2 = -1/2 < 0, takze neplati primo"]
Print[""]

(* Zkusme regularizovanou verzi *)
Print["Vztah k Legendre polynomum:"]
Print["  2F1[-l, l+1, 1, (1-x)/2] = P_l(x)")
Print["  2F1[1-n, 1+n, 3/2, z] souvis s P'_n nebo Q_n"]
Print[""]

Do[
  S = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
  (* Legendre P a Q pri x = 0 *)
  Pn = LegendreP[n, 0];
  Qn = LegendreQ[n, 0];
  Print["n=", n, ": S=", N[S, 8], ", P_n(0)=", N[Pn, 8], ", Q_n(0)=", N[Qn, 8]],
  {n, 2, 6}
]
Print[""]

(* Zkusme jeste jiny pristup - generating function *)
Print["Generating function pristup:"]
Print["  g(x) = Sum[f10[n] * x^n, n=2..inf]"]
Print[""]

(* Zkusme -1 *)
gm1 = Sum[f10[n] * (-1)^n, {n, 2, 100}];
Print["  g(-1) = ", N[gm1, 20]]
Print["  (to je nase alternujici suma)")
Print[""]

(* Podivejme se na strukturu citatelu a jmenovatelu *)
Print["Struktura f10[n] = num/den:"]
Do[
  val = f10[n];
  num = Numerator[val];
  den = Denominator[val];
  Print["  n=", n, ": ", num, "/", den],
  {n, 2, 10}
]
