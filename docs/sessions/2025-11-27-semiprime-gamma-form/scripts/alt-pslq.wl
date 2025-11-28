f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

s = Sum[(-1)^n * f10[n], {n, 2, 100}];
sN = N[s, 50];

Print["s = ", N[s, 30]]
Print[""]

(* PSLQ-like: FindIntegerNullVector *)
Print["FindIntegerNullVector testy:"]
Print[""]

(* Test: a*s + b = 0 pro racionalni s *)
v1 = FindIntegerNullVector[{sN, 1}, 20];
Print["  {s, 1}: ", v1, " => s = ", If[v1 =!= $Failed && v1[[1]] != 0, -v1[[2]]/v1[[1]], "N/A"]]

(* Test: a*s + b*Pi + c = 0 *)
v2 = FindIntegerNullVector[{sN, N[Pi, 50], 1}, 15];
Print["  {s, Pi, 1}: ", v2]

(* Test: a*s + b*Log[2] + c = 0 *)
v3 = FindIntegerNullVector[{sN, N[Log[2], 50], 1}, 15];
Print["  {s, ln2, 1}: ", v3]

(* Test: a*s + b*Catalan + c = 0 *)
v4 = FindIntegerNullVector[{sN, N[Catalan, 50], 1}, 15];
Print["  {s, Catalan, 1}: ", v4]

(* Test: a*s + b*EulerGamma + c = 0 *)
v5 = FindIntegerNullVector[{sN, N[EulerGamma, 50], 1}, 15];
Print["  {s, gamma, 1}: ", v5]

(* Test: kombinace s Pi a ln2 *)
v6 = FindIntegerNullVector[{sN, N[Pi, 50], N[Log[2], 50], 1}, 12];
Print["  {s, Pi, ln2, 1}: ", v6]

Print[""]

(* Zkusme 1-s misto s *)
t = 1 - sN;
Print["Pro t = 1 - s = ", N[t, 20], ":"]
w1 = FindIntegerNullVector[{t, N[Pi, 50], 1}, 15];
Print["  {t, Pi, 1}: ", w1]
w2 = FindIntegerNullVector[{t, N[1/Pi, 50], 1}, 15];
Print["  {t, 1/Pi, 1}: ", w2]
w3 = FindIntegerNullVector[{t, N[Log[2], 50], 1}, 15];
Print["  {t, ln2, 1}: ", w3]

Print[""]

(* Zkusme s^2 *)
Print["Pro s^2 = ", N[sN^2, 20], ":"]
u1 = FindIntegerNullVector[{sN^2, N[Pi, 50], 1}, 15];
Print["  {s^2, Pi, 1}: ", u1]
