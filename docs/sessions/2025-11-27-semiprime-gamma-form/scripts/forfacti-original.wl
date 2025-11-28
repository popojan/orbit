forfacti[n_] := Module[{m = Floor[1/2 (-1 + Sqrt[n])]}, 
  Sum[Gamma[1 + i + n]/(n (1 + 2 i) Gamma[n - i]) // FractionalPart, {i, 1, m}]]

Print["Puvodni forfacti vzorec:"]
Print[""]

(* Test na prvocisla *)
Print["Prvocisla:"]
Do[
  p = Prime[k];
  result = forfacti[p];
  Print["p=", p, ": forfacti = ", result],
  {k, 2, 8}
]
Print[""]

(* Test na semiprime *)
Print["Semiprime:"]
semis = {15, 21, 33, 35, 55, 77, 91, 143, 221};
Do[
  n = semis[[k]];
  {p, q} = Sort[First /@ FactorInteger[n]];
  result = forfacti[n];
  Print["n=", n, " (", p, "*", q, "): forfacti = ", result, 
        " = ", Numerator[result], "/", Denominator[result]],
  {k, Length[semis]}
]
Print[""]

(* Struktura vysledku *)
Print["Struktura: co je v citateli/jmenovateli?"]
Do[
  n = semis[[k]];
  {p, q} = Sort[First /@ FactorInteger[n]];
  result = forfacti[n];
  num = Numerator[result];
  den = Denominator[result];
  Print["n=", n, ": num=", num, ", den=", den, 
        ", gcd(num,n)=", GCD[num, n], ", gcd(den,n)=", GCD[den, n]],
  {k, Min[6, Length[semis]]}
]
