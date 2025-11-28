(* Kreační a anihilační operátory pro dělitelskou strukturu *)

Print["=== KREAČNÍ/ANIHILAČNÍ OPERÁTORY ===\n"];

Print["Cíl: Definovat operátory mezi V_n a V_{np} pro prvočíslo p\n"];

(* Pomocné funkce *)
divs[n_] := Divisors[n]
tau[n_] := DivisorSigma[0, n]
P[n_] := Floor[tau[n]/2]
isSquare[n_] := IntegerQ[Sqrt[n]]

(* Báze V_n *)
basis[n_] := Table[d, {d, divs[n]}]

(* Antisymetrická báze V_n^- *)
(* Pro každý pár {d, n/d} s d < n/d: e_d = δ_d - δ_{n/d} *)
antiSymBasis[n_] := Module[{ds = divs[n], pairs},
  pairs = Select[ds, # < n/# &];
  Table[{d, n/d}, {d, pairs}]
]

Print["=== Struktura dělitelů při násobení p ===\n"];

n = 6; p = 5;
Print["n = ", n, ", p = ", p, " (p∤n)"];
Print["Div(", n, ") = ", divs[n]];
Print["Div(", n*p, ") = ", divs[n*p]];
Print[""];

(* Mapování: Div(n) ↪ Div(np) *)
Print["Přirozená vnoření:"];
Print["  d ↦ d    (dělitelé n)"];
Print["  d ↦ d·p  (nové dělitelé)\n"];

embedding1 = Table[d -> d, {d, divs[n]}];
embedding2 = Table[d -> d*p, {d, divs[n]}];
Print["  Div(6) → Div(30): ", divs[n], " ↦ ", divs[n]];
Print["  Div(6)·5 → Div(30): ", divs[n], " ↦ ", divs[n]*p];

Print["\n=== Antisymetrické báze ===\n"];

Print["V_6^-:  páry = ", antiSymBasis[6]];
Print["V_30^-: páry = ", antiSymBasis[30]];

Print["\n=== Návrh 1: Extenze nulou ===\n"];

Print["a_p^†: V_n → V_{np}"];
Print["(a_p^† f)(d) = f(d) pokud d|n, jinak 0\n"];

Print["Problém: Zachovává antisymetrii?"];
Print["Pro f ∈ V_6^-, např. f = δ_1 - δ_6:"];
Print["  (a_5^† f)(1) = f(1) = 1"];
Print["  (a_5^† f)(6) = f(6) = -1"];
Print["  (a_5^† f)(5) = 0  (5 ∤ 6)"];
Print["  (a_5^† f)(30) = 0 (30 ∤ 6)"];
Print[""];
Print["Test σ_30: σ_30(1) = 30, σ_30(6) = 5"];
Print["  (σ_30 a_5^† f)(1) = (a_5^† f)(30) = 0"];
Print["  -(a_5^† f)(1) = -1"];
Print["  0 ≠ -1  →  NEFUNGUJE!\n"];

Print["=== Návrh 2: Tenzorové rozšíření ===\n"];

Print["Využijeme: Div(np) ≅ Div(n) × Div(p) pro p∤n"];
Print["          Div(p) = {1, p}"];
Print[""];
Print["V_{np} ≅ V_n ⊗ V_p"];
Print["V_p = span{δ_1, δ_p}, σ_p: δ_1 ↔ δ_p"];
Print["V_p^+ = span{δ_1 + δ_p}, V_p^- = span{δ_1 - δ_p}\n"];

Print["Tensorový rozklad:"];
Print["  V_{np}^- = (V_n^+ ⊗ V_p^-) ⊕ (V_n^- ⊗ V_p^+)"];
Print["  V_{np}^+ = (V_n^+ ⊗ V_p^+) ⊕ (V_n^- ⊗ V_p^-)\n"];

Print["Kreační operátor (fermionový):"];
Print["  a_p^†: V_n^± → V_{np}^∓  (mění paritu!)"];
Print["  a_p^† = id_n ⊗ (δ_1 - δ_p)\n"];

Print["Explicitně pro f ∈ V_n:"];
Print["  (a_p^† f)(d) = f(d) - f(d)  pokud d|n"];
Print["  ... to nedává smysl, zkusme jinak\n"];

Print["=== Návrh 3: Fermionový operátor ===\n"];

Print["Definice přes vnější součin:"];
Print["  a_p^†: V_n^- → V_{np}^-"];
Print["  a_p^†(e_{d,n/d}) = e_{d,np/d} - e_{dp,n/d}  ???\n"];

(* Konkrétní příklad *)
Print["Příklad: n = 6, p = 5"];
Print[""];
Print["Báze V_6^-:"];
Print["  e_1 = δ_1 - δ_6  (pár {1,6})"];
Print["  e_2 = δ_2 - δ_3  (pár {2,3})"];
Print[""];
Print["Báze V_30^-:"];
Print["  e_1 = δ_1 - δ_30  (pár {1,30})"];
Print["  e_2 = δ_2 - δ_15  (pár {2,15})"];
Print["  e_3 = δ_3 - δ_10  (pár {3,10})"];
Print["  e_5 = δ_5 - δ_6   (pár {5,6})"];
Print[""];
Print["Pozorování: P(30) = 4 = P(6) + 2 = 2 + 2"];

Print["\n=== Návrh 4: Správná definice ===\n"];

Print["Pro p∤n definujme:"];
Print[""];
Print["  a_p^†: V_n^- → V_{np}^-"];
Print["  a_p^†(e_{d,n/d}) = e_{d,np/d} ∧ e_{dp,n/d}"];
Print["                   = (δ_d - δ_{np/d}) ∧ (δ_{dp} - δ_{n/d})"];
Print[""];
Print["kde ∧ je antisymetrizace.\n"];

Print["Ale dimenze: dim V_6^- = 2, dim V_30^- = 4"];
Print["Potřebujeme a_p^†: ℂ^2 → ℂ^4"];
Print[""];
Print["Alternativně: a_p^† vytváří DVĚ nové báze z jedné.\n"];

Print["=== Návrh 5: Explicitní matice ===\n"];

(* Matice kreačního operátoru *)
Print["Definujme kreační operátor maticově:\n"];

(* Pro p∤n, mapujeme bázi V_n^- do V_{np}^- *)
(* Pár {d, n/d} v V_n^- se mapuje na... co? *)

(* Pozorování: Páry v V_30^- jsou:
   {1, 30} - obsahuje 1 z {1,6}
   {2, 15} - obsahuje 2 z {2,3}
   {3, 10} - obsahuje 3 z {2,3}
   {5, 6}  - obsahuje 6 z {1,6} a 5 nové
*)

Print["Pro n=6, p=5:"];
Print["  Pár {1,6} → páry obsahující 1 nebo 6:"];
Print["    {1, 30} (obsahuje 1)"];
Print["    {5, 6}  (obsahuje 6)"];
Print["  Pár {2,3} → páry obsahující 2 nebo 3:"];
Print["    {2, 15} (obsahuje 2)"];
Print["    {3, 10} (obsahuje 3)\n"];

Print["Matice a_5^†: V_6^- → V_30^-"];
Print["Báze V_6^-:  e_{1,6}, e_{2,3}"];
Print["Báze V_30^-: e_{1,30}, e_{2,15}, e_{3,10}, e_{5,6}"];
Print[""];
Print["  a_5^† e_{1,6} = e_{1,30} + e_{5,6}  ?"];
Print["  a_5^† e_{2,3} = e_{2,15} + e_{3,10} ?\n"];

(* Ověření dimenzí *)
Print["=== Dimenzionální analýza ===\n"];

Do[
  np = n*p;
  If[!Divisible[n, p],
    Print["n=", n, ", p=", p, ": P(n)=", P[n], ", P(np)=", P[np],
          ", rozdíl=", P[np] - P[n]];
  ];
, {n, {2, 3, 6, 12}}, {p, {2, 3, 5, 7}}];

Print["\n=== Vzorec pro P(np) - P(n) ===\n"];

Print["Pro p∤n:"];
Print["  P(np) = dim V_n^+ · dim V_p^- + dim V_n^- · dim V_p^+"];
Print["        = dim V_n^+ · 1 + P(n) · 1"];
Print["        = (τ(n) + χ_□(n))/2 + P(n)"];
Print["        = τ(n)/2 + χ_□(n)/2 + τ(n)/2 - χ_□(n)/2"];
Print["        = τ(n)\n"];

Print["Tedy: P(np) = τ(n) pro p∤n a p prvočíslo.\n"];

(* Ověření *)
Print["Ověření:"];
Do[
  If[PrimeQ[p] && !Divisible[n, p],
    pnp = P[n*p];
    tn = tau[n];
    ok = If[pnp == tn, "✓", "✗"];
    Print["  P(", n, "·", p, ") = P(", n*p, ") = ", pnp, " = τ(", n, ") = ", tn, " ", ok];
  ];
, {n, {2, 3, 4, 6, 12}}, {p, {2, 3, 5, 7}}];

Print["\n=== Definice kreačního operátoru ===\n"];

Print["Pro prvočíslo p∤n:\n"];

Print["  a_p^†: V_n → V_{np}"];
Print["  a_p^† = ι_1 - ι_p"];
Print[""];
Print["kde:"];
Print["  ι_1: V_n → V_{np}, (ι_1 f)(d) = f(d) pokud d|n, jinak 0"];
Print["  ι_p: V_n → V_{np}, (ι_p f)(d) = f(d/p) pokud p|d a d/p|n, jinak 0\n"];

Print["Ověření antisymetrie:"];
Print["Pro f = δ_d - δ_{n/d} ∈ V_n^-:"];
Print["  a_p^† f = (ι_1 - ι_p)(δ_d - δ_{n/d})"];
Print["         = ι_1 δ_d - ι_1 δ_{n/d} - ι_p δ_d + ι_p δ_{n/d}"];
Print["         = δ_d - δ_{n/d} - δ_{dp} + δ_{np/d}"];
Print["         = (δ_d - δ_{np/d}) - (δ_{dp} - δ_{n/d})"];
Print["         = e_{d,np/d} - e_{dp,n/d}  ?\n"];

Print["Hmm, to není v bázi V_{np}^-. Potřebujeme přeuspořádat...\n"];

Print["=== Správný tvar ===\n"];

Print["Pro p∤n a pár {d, n/d} s d < n/d:"];
Print["  a_p^†(δ_d - δ_{n/d}) = δ_d - δ_{dp} - δ_{n/d} + δ_{np/d}"];
Print[""];
Print["V V_{np} máme páry:"];
Print["  {d, np/d}, {dp, n/d}, a další...\n"];

Print["Klíč: d < n/d < dp < np/d  (pro d < n/d a p > 1)"];
Print["Tedy:"];
Print["  δ_d - δ_{np/d} ∈ V_{np}^-  (pár {d, np/d})"];
Print["  δ_{dp} - δ_{n/d} ∈ ?"];
Print[""];
Print["Problém: dp vs n/d - kdo je menší?"];
Print["  dp < n/d ⟺ dp² < n ⟺ d < √(n/p²)"];
