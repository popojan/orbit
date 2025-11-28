f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])

s = Sum[(-1)^n * f10[n], {n, 2, 100}];
sN = N[s, 50];

eta3 = (1 - 2^(1-3))*Zeta[3];  (* = 3/4 * Zeta[3] *)

Print["Vztah s eta(3):"]
Print["  s = ", N[s, 25]]
Print["  eta(3) = ", N[eta3, 25]]
Print["  eta(3) = (3/4)*Zeta(3) = (3/4)*", N[Zeta[3], 25]]
Print[""]

diff = sN - N[eta3, 50];
Print["  s - eta(3) = ", N[diff, 25]]
Print[""]

(* Hledame strukturu v rozdilu *)
Print["Struktura rozdilu d = s - eta(3):"]
Print["  d = ", N[diff, 20]]
Print["  d*100 = ", N[diff*100, 20]]
Print["  d*1000 = ", N[diff*1000, 20]]
Print["  1/d = ", N[1/diff, 15]]
Print[""]

(* PSLQ pro rozdil *)
Print["PSLQ pro d = s - eta(3):"]
dN = N[diff, 50];
v1 = FindIntegerNullVector[{dN, N[Pi, 50], 1}, 20];
Print["  {d, Pi, 1}: ", v1]
v2 = FindIntegerNullVector[{dN, N[Log[2], 50], 1}, 20];
Print["  {d, ln2, 1}: ", v2]
v3 = FindIntegerNullVector[{dN, N[1/Pi^2, 50], 1}, 20];
Print["  {d, 1/Pi^2, 1}: ", v3]
v4 = FindIntegerNullVector[{dN, N[Zeta[3], 50], 1}, 20];
Print["  {d, Zeta[3], 1}: ", v4]
Print[""]

(* Kombinace eta(3) a jednoducheho zlomku *)
Print["Je s = eta(3) + 1/n pro nejake n?"]
Do[
  approx = N[eta3 + 1/k, 20];
  If[Abs[N[s, 20] - approx] < 0.0001,
    Print["  k = ", k, ": eta(3) + 1/k = ", approx]
  ],
  {k, 1, 200}
]
Print["  (zadne presne shody)"]
Print[""]

(* Mozna s = eta(3) + a/b pro male a,b? *)
Print["Hledani s = eta(3) + a/b:"]
best = {1000, 0, 0};
Do[
  Do[
    val = N[eta3 + a/b, 30];
    err = Abs[N[s, 30] - val];
    If[err < best[[1]],
      best = {err, a, b}
    ],
    {a, -20, 20}
  ],
  {b, 1, 200}
]
Print["  Nejlepsi: a = ", best[[2]], ", b = ", best[[3]], ", chyba = ", best[[1]]]
Print["  s ~= eta(3) + ", best[[2]], "/", best[[3]], " = ", N[eta3 + best[[2]]/best[[3]], 20]]
