Pk[n_, k_] := Product[n^2 - j^2, {j, 1, k}]
Hn[n_] := Sum[1/(2 i + 1), {i, 0, n - 1}]

n = 35;
p = 5; q = 7;

Print["Proc n=35 (5*7) nefunguje?"]
Print[""]

Print["Hn[35] = ", Hn[35]]
hnFactors = FactorInteger[Denominator[Hn[35]]];
Print["Jmenovatel Hn: ", hnFactors]
Print[""]

Print["Mocniny 5 a 7 v Pk[35, k]:"]
Do[
  pk = Pk[35, k];
  pkFactors = FactorInteger[pk];
  p5 = Cases[pkFactors, {5, e_} :> e];
  p7 = Cases[pkFactors, {7, e_} :> e];
  p5 = If[p5 === {}, 0, First[p5]];
  p7 = If[p7 === {}, 0, First[p7]];
  If[p5 > 0 || p7 > 0,
    Print["  k=", k, ": 5^", p5, ", 7^", p7]
  ],
  {k, 1, 34}
]
Print[""]

(* Porovnej s n=15 *)
Print["Pro srovnani, Hn[15]:"]
Print["  Hn[15] = ", Hn[15]]
hn15Factors = FactorInteger[Denominator[Hn[15]]];
Print["  Jmenovatel Hn[15]: ", hn15Factors]
Print[""]

(* Klicovy rozdil: jmenovatel Hn *)
Print["KLICOVY ROZDIL:"]
Print["  Hn[15] jmenovatel obsahuje 3? ", MemberQ[hn15Factors[[All, 1]], 3]]
Print["  Hn[35] jmenovatel obsahuje 5? ", MemberQ[hnFactors[[All, 1]], 5]]
Print["  Hn[35] jmenovatel obsahuje 7? ", MemberQ[hnFactors[[All, 1]], 7]]
Print[""]

(* Hn[n] = 1 + 1/3 + 1/5 + ... + 1/(2n-1) *)
(* Jmenovatel obsahuje vsechna licha cisla do 2n-1 *)
Print["Hn[n] obsahuje v jmenovateli vsechna licha prvocisla <= 2n-1"]
Print["Pro n=35: 2*35-1 = 69, takze 5, 7 jsou v jmenovateli Hn!")
Print["Pro n=15: 2*15-1 = 29, takze 3, 5 jsou v jmenovateli")
Print["  ale 5 < 15 takze je tam")
