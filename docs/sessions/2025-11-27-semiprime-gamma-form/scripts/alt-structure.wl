f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["Struktura f10[n] = num/den:"]
Do[
  val = f10[n];
  num = Numerator[val];
  den = Denominator[val];
  Print["  n=", n, ": ", num, "/", den, " = ", N[val, 12]],
  {n, 2, 12}
]
Print[""]

(* Citatele a jmenovatele *)
nums = Table[Numerator[f10[n]], {n, 2, 12}];
dens = Table[Denominator[f10[n]], {n, 2, 12}];

Print["Citatele: ", nums]
Print["Jmenovatele: ", dens]
Print[""]

(* Hledame vzor v citatelich *)
Print["Citatele:"]
Print["  1, 3, 1, 5, 3, 7, 1, 3, 5, 11, 3, ..."]
Print["  = n pro n liche, nebo delitel n pro n sude?"]
Do[
  n = i + 1;
  num = Numerator[f10[n]];
  Print["  n=", n, ": citatel=", num, ", GCD[num,n]=", GCD[num, n]],
  {i, 2, 12}
]
Print[""]

(* OEIS lookup pro jmenovatele *)
Print["OEIS: jmenovatele = 1, 32, 221, 46624, 2029667, ..."]
Print[""]

(* Parcialni alternujici sumy *)
Print["Parcialni alternujici sumy:"]
ps = 0;
Do[
  ps += (-1)^n * f10[n];
  Print["  N=", n, ": ", N[ps, 18]],
  {n, 2, 15}
]
Print[""]

(* Zkusme zda Sum = 1 - neco *)
Print["1 - parcialni sume:"]
ps = 0;
Do[
  ps += (-1)^n * f10[n];
  diff = 1 - ps;
  Print["  N=", n, ": 1-S = ", N[diff, 15]],
  {n, 2, 12}
]
