forfacti[n_] := Module[{m = Floor[1/2 (-1 + Sqrt[n])]}, 
  Sum[Gamma[1 + i + n]/(n (1 + 2 i) Gamma[n - i]) // FractionalPart, {i, 1, m}]]

factor[n_] := 1/(1 - forfacti[n])

Print["Closed form faktorizace BEZ gcd:"]
Print[""]
Print["factor[n] = 1/(1 - forfacti[n])"]
Print[""]

semis = {15, 21, 33, 35, 55, 77, 91, 143, 221, 323, 437};
Do[
  n = semis[[k]];
  {p, q} = Sort[First /@ FactorInteger[n]];
  f = forfacti[n];
  result = 1/(1 - f);
  Print["n=", n, " (", p, "*", q, "): 1/(1-forfacti) = ", result, 
        If[result == p, "  CORRECT!", "  ???"]],
  {k, Length[semis]}
]
Print[""]

Print["Pro prvocisla:"]
Do[
  p = Prime[k];
  f = forfacti[p];
  result = If[f == 0, "undef (0)", 1/(1 - f)];
  Print["p=", p, ": forfacti=", f, ", 1/(1-f)=", result],
  {k, 2, 6}
]
Print[""]

Print["CLOSED FORM bez gcd:"]
Print["  mensi_faktor(n) = 1/(1 - Sum[FracPart[Gamma terms], i=1..sqrt(n)/2])"]
