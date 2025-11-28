(* Proc je A mod p male? *)
(* A = citatel S10 = Sum[Product[n^2-j^2, j=1..i]/(2i+1), i=0..n-1] * n *)

f10[n_] := -1/(1 - Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}])
S10[n_] := Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}]

getA[n_] := Numerator[S10[n]]  (* S10 = A/n *)

Print["A mod p pro ruzne semiprime n = p*q:"]
Print[""]

semis = {15, 21, 33, 35, 55, 77, 91, 143, 187, 221, 247, 299, 323, 437};
Do[
  n = semis[[k]];
  {p, q} = Sort[First /@ FactorInteger[n]];
  A = getA[n];
  Ap = Mod[A, p];
  Aq = Mod[A, q];
  Print["n=", n, " (", p, "*", q, "): A mod ", p, " = ", Ap, ", A mod ", q, " = ", Aq,
        " => b_p = ", PowerMod[-A, -1, p], ", b_q = ", PowerMod[-A, -1, q]],
  {k, Length[semis]}
]
Print[""]

(* Statistika distribuce A mod p *)
Print["Distribuce A mod p:"]
amodp = {};
Do[
  n = semis[[k]];
  {p, q} = Sort[First /@ FactorInteger[n]];
  A = getA[n];
  AppendTo[amodp, Mod[A, p]];
  AppendTo[amodp, Mod[A, q]],
  {k, Length[semis]}
];
Print["  Vsechny hodnoty: ", amodp]
Print["  Histogram: ", Tally[amodp]]
Print["  Max: ", Max[amodp]]
Print["  Mean: ", N[Mean[amodp], 5]]
Print[""]

(* Co je A presne? *)
Print["Struktura A:"]
Do[
  n = {3, 5, 7, 11, 13}[[k]];
  A = getA[n];
  Print["  n=", n, ": A = ", A, " = ", FactorInteger[A]],
  {k, 5}
]
