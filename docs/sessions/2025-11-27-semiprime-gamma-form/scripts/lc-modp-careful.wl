(* Spocteme presne, jak singularita prispiva k A mod p *)

n = 77;
p = 7; q = 11;

(* S10 = Sum[Product[n^2-j^2, j=1..i]/(2i+1), i=0..n-1] *)
(* Pro i < (p-1)/2: vsechny cleny maji jmenovatel koprime k p *)
(* Pri i = (p-1)/2: jmenovatel je p, citatel je delitelny p^2 (z n^2 = p^2*q^2) *)
(* Po i = (p-1)/2: pokracuji dalsi cleny *)

Print["Detailni analyza mod p=7 pro n=77:"]
Print[""]

(* Spocteme parcialni sumy S_k = Sum[..., i=0..k] presne *)
partials = {};
Do[
  Sk = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, k}];
  (* S10 = A/n, takze Sk * n = parcialni A *)
  Ak = Numerator[Sk * n] / Denominator[Sk * n] * n;
  (* Spise: Sk = nejakyZlomek, a Sk * n = A/1 kdyz suma konverguje *)
  SkTimesN = Sk * n;
  numSk = Numerator[SkTimesN];
  denSk = Denominator[SkTimesN];
  AppendTo[partials, {k, numSk, denSk, Mod[numSk, p], Mod[denSk, p]}],
  {k, 0, 10}
]

Print["k | Sk*n | num mod 7 | den mod 7"]
Do[
  {k, num, den, numMod, denMod} = partials[[i]];
  Print[k, " | ", num, "/", den, " | ", numMod, " | ", denMod],
  {i, Min[8, Length[partials]]}
]
Print[""]

(* Konecna suma *)
Sfull = Sum[Product[n^2 - j^2, {j, 1, i}]/(2 i + 1), {i, 0, n - 1}];
A = Numerator[Sfull];
Print["Finalni A = ", A]
Print["A mod 7 = ", Mod[A, 7]]
Print["A mod 11 = ", Mod[A, 11]]
Print[""]

(* Inverz A^-1 mod p *)
invA7 = PowerMod[A, -1, 7];
invA11 = PowerMod[A, -1, 11];
Print["A^-1 mod 7 = ", invA7, " => b = -A^-1 = ", Mod[-invA7, 7]]
Print["A^-1 mod 11 = ", invA11, " => b = -A^-1 = ", Mod[-invA11, 11]]
Print[""]

(* Overeni *)
d00 = Denominator[-1/(1 - Sum[Product[n^2 - j^2, {j, 0, i}]/(2 i + 1), {i, 0, n}])];
d10 = Denominator[-1/(1 - Sfull)];
Print["Overeni faktorizace:"]
Print["  d00 = ...", Mod[d00, 10^6]]
Print["  d10 = ...", Mod[d10, 10^6]]
b7 = Mod[-invA7, 7];
b11 = Mod[-invA11, 11];
Print["  gcd(-d00 + ", b7, "*d10, 77) = ", GCD[-d00 + b7*d10, n]]
Print["  gcd(-d00 + ", b11, "*d10, 77) = ", GCD[-d00 + b11*d10, n]]
