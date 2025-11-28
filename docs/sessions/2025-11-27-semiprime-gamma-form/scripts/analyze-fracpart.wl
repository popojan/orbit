(* Clen: Gamma[1+i+n]/(n*(1+2i)*Gamma[n-i]) *)

term[n_, i_] := Gamma[1 + i + n]/(n*(1 + 2 i)*Gamma[n - i])

Print["Analyza clenu Gamma[1+i+n]/(n*(1+2i)*Gamma[n-i]):"]
Print[""]

(* Zjednoduseni *)
Print["Gamma[1+i+n]/Gamma[n-i] = (n+i)!/(n-i-1)!"]
Print["                       = (n-i)(n-i+1)...(n+i)"]
Print["                       = Product[j, j=n-i..n+i]"]
Print["                       = (2i+1) po sobe jdoucich cisel"]
Print[""]

(* Overeni *)
n = 15; i = 1;
gamma = Gamma[1 + i + n]/Gamma[n - i];
prod = Product[j, {j, n - i, n + i}];
Print["Overeni pro n=15, i=1:"]
Print["  Gamma ratio = ", gamma]
Print["  Product = ", prod]
Print["  Match: ", gamma == prod]
Print[""]

(* Takze clen = Product[j, j=n-i..n+i] / (n*(2i+1)) *)
Print["Clen = Product[j, j=n-i..n+i] / (n*(2i+1))"]
Print[""]

(* Pro semiprime n = p*q *)
Print["Pro n = 15 = 3*5:"]
Do[
  t = term[15, i];
  intPart = Floor[t];
  fracPart = FractionalPart[t];
  prod = Product[j, {j, 15 - i, 15 + i}];
  Print["  i=", i, ": term=", t, " = ", N[t, 6], 
        ", int=", intPart, ", frac=", fracPart],
  {i, 1, Floor[(Sqrt[15] - 1)/2]}
]
Print[""]

Print["Pro n = 77 = 7*11:"]
Do[
  t = term[77, i];
  intPart = Floor[t];
  fracPart = FractionalPart[t];
  Print["  i=", i, ": frac=", fracPart, ", int=", intPart],
  {i, 1, Floor[(Sqrt[77] - 1)/2]}
]
Print[""]

(* Proc FractionalPart dava (p-1)/p v souctu? *)
Print["Proc suma FracPart = (p-1)/p?"]
Print["  Kazdy clen ma tvar: velke_cislo / (n*(2i+1))")
Print["  FracPart vybere zbytek po deleni")
Print["  Suma techto zbytku = (p-1)/p kde p | n"]
