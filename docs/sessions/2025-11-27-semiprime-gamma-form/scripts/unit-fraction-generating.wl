(* Generující funkce a další analýzy *)

Print["==============================================================="]
Print["  GENERUJICI FUNKCE A ANALYZY"]
Print["==============================================================="]
Print[""]

f[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

Print["1. POSLOUPNOST ZLOMKU f[n] pro n = 2..20"]
Print["==============================================================="]
Print[""]

fractions = Table[f[n], {n, 2, 20}];
nums = Numerator /@ fractions;
dens = Denominator /@ fractions;

Print["n:    num     den"]
Do[
  Print[n, ":   ", nums[[n-1]], "   ", dens[[n-1]]],
  {n, 2, 12}
]
Print[""]

Print["2. SUMA ZLOMKU Sum[f[n], n=2..N]"]
Print["==============================================================="]
Print[""]

Do[
  s = Sum[f[n], {n, 2, maxN}];
  Print["Sum[f[n], n=2..", maxN, "] = ", N[s, 10]],
  {maxN, {5, 10, 15, 20}}
]
Print[""]

Print["3. GENERUJICI FUNKCE G(x) = Sum[f[n] x^n]"]
Print["==============================================================="]
Print[""]

Print["Prvnich 10 koeficientu:"]
Do[
  Print["  f[", n, "] = ", f[n], " ~ ", N[f[n], 6]],
  {n, 2, 10}
]
Print[""]

Print["G(1) = Sum[f[n]] diverguje (clenove nekonvergujou k 0)"]
Print[""]

Print["4. POSLOUPNOST JMENOVATELU"]
Print["==============================================================="]
Print[""]

denSeq = Table[Denominator[f[n]], {n, 2, 15}];
Print["Denominatory: ", denSeq]
Print[""]

Print["Logaritmy (log10):"]
Do[
  Print["  den[", n, "] ~ 10^", Floor[Log10[Denominator[f[n]]]]],
  {n, 2, 12}
]
Print[""]

(* OEIS lookup? *)
Print["OEIS lookup pro prvnich par hodnot:"]
Print["  7, 32, 46624, 524854336, ..."]
Print[""]

Print["5. DERIVACE / INTEGRACE FORMULE"]
Print["==============================================================="]
Print[""]

(* f[n] jako funkce spojiteho n? *)
Print["f[n] pro neceloucelna n?"]
Print["Problem: Suma ma konecne mnoho clenu kvuli Product[n^2-j^2]=0 pro j=n"]
Print["Pro necelociselne n by suma byla nekonecna!"]
Print[""]

(* Zkusme n -> spojity parametr *)
Print["Zkusim regularizaci pres Gamma:"]
Print["Product[n^2-j^2, j=1..k] = Pochhammer[1-n,k] * Pochhammer[1+n,k] * (-1)^k"]
Print[""]

Print["Pro n=5.5 (necelocislne):"]
n = 55/10;
(* Aproximace sumy - prvnich 20 clenu *)
approx = Sum[
  (-1)^i * Pochhammer[1 - n, i] * Pochhammer[1 + n, i]/(2 i + 1), 
  {i, 0, 20}
];
Print["  Parcialni suma (20 clenu): ", N[approx, 8]]
Print["  f ~ ", N[-1/(1 - approx), 8]]
Print[""]

Print["6. ALTERNATIVNI REPREZENTACE"]
Print["==============================================================="]
Print[""]

Print["Pochhammer[1-n,k] * Pochhammer[1+n,k] = (1-n^2)(4-n^2)...(k^2-n^2)"]
Print["                                       = Product[j^2-n^2, j=1..k]"]  
Print["                                       = (-1)^k Product[n^2-j^2, j=1..k]"]
Print[""]

Print["Tedy suma je (skoro) 2F1:"]
Print["Sum[Poch[1-n,k]*Poch[1+n,k]/Poch[3/2,k] * z^k / k!]"]
Print["~ Hypergeometric2F1[1-n, 1+n, 3/2, z] s nejakou modifikaci"]
Print[""]

(* Test *)
Print["Test hypergeom. reprezentace pro n=5:"]
n = 5;
hyperApprox = Hypergeometric2F1[1 - n, 1 + n, 3/2, -1];
Print["  2F1[1-5, 1+5, 3/2, -1] = ", hyperApprox]
Print["  = ", N[hyperApprox]]
Print[""]

directSum = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
Print["  Prima suma = ", directSum]
Print["  = ", N[directSum]]
