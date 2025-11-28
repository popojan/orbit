(* Fermionová algebra pro dělitelské operátory *)

Print["=== FERMIONOVÁ ALGEBRA ===\n"];

(* Pomocné funkce *)
tau[n_] := DivisorSigma[0, n]
P[n_] := Floor[tau[n]/2]
divs[n_] := Divisors[n]

(* Antisymetrické páry: {d, n/d} s d < n/d *)
antiPairs[n_] := Select[divs[n], # < n/# &]

(* Báze V_n^- jako seznam párů *)
basis[n_] := Table[{d, n/d}, {d, antiPairs[n]}]

Print["=== 1. Ověření komutace [a_p†, a_q†] = 0 ===\n"];

(* Akce a_p† na pár {d, n/d} *)
(* a_p†({d, n/d}) = {d, np/d} + {dp, n/d} jako formální suma *)

creationAction[p_, pair_, n_] := Module[{d, e, np},
  {d, e} = pair; (* e = n/d *)
  np = n * p;
  (* Dva nové páry v V_{np}^- *)
  (* {d, np/d} a {dp, e} = {dp, n/d} *)
  {{Min[d, np/d], Max[d, np/d]}, {Min[d*p, e], Max[d*p, e]}}
]

Print["Test pro n = 2, p = 3, q = 5:\n"];

n = 2;
p = 3; q = 5;

Print["Báze V_2^-: ", basis[2]];
Print["Báze V_6^-: ", basis[6]];
Print["Báze V_10^-: ", basis[10]];
Print["Báze V_30^-: ", basis[30]];
Print[""];

(* Cesta 1: a_3† pak a_5† *)
Print["Cesta 1: a_3† ∘ a_5†"];
Print["  V_2^- → V_6^- → V_30^-\n"];

pair0 = {1, 2};
Print["  Začátek: ", pair0, " ∈ V_2^-"];

(* a_3† na {1,2} v V_2 dá páry v V_6 *)
pairs6 = creationAction[3, pair0, 2];
Print["  a_3†({1,2}) = ", pairs6, " ∈ V_6^-"];

(* a_5† na každý pár z V_6 *)
pairs30via6 = Flatten[Table[creationAction[5, pair, 6], {pair, pairs6}], 1];
Print["  a_5†(výše) = ", pairs30via6, " ∈ V_30^-"];

Print[""];

(* Cesta 2: a_5† pak a_3† *)
Print["Cesta 2: a_5† ∘ a_3†"];
Print["  V_2^- → V_10^- → V_30^-\n"];

(* a_5† na {1,2} v V_2 dá páry v V_10 *)
pairs10 = creationAction[5, pair0, 2];
Print["  a_5†({1,2}) = ", pairs10, " ∈ V_10^-"];

(* a_3† na každý pár z V_10 *)
pairs30via10 = Flatten[Table[creationAction[3, pair, 10], {pair, pairs10}], 1];
Print["  a_3†(výše) = ", pairs30via10, " ∈ V_30^-"];

Print["\n  Porovnání:"];
Print["    Cesta 1: ", Sort[pairs30via6]];
Print["    Cesta 2: ", Sort[pairs30via10]];
Print["    Stejné? ", Sort[pairs30via6] === Sort[pairs30via10]];

Print["\n=== 2. Obecný test komutace ===\n"];

testCommutation[n_, p_, q_] := Module[{b, path1, path2},
  b = basis[n];
  If[Length[b] == 0, Return[True]]; (* V_n^- = 0 *)

  path1 = Sort[Flatten[
    Table[creationAction[q, pair2, n*p],
      {pair1, b},
      {pair2, creationAction[p, pair1, n]}
    ], 2]];

  path2 = Sort[Flatten[
    Table[creationAction[p, pair2, n*q],
      {pair1, b},
      {pair2, creationAction[q, pair1, n]}
    ], 2]];

  path1 === path2
]

Print["Test [a_p†, a_q†] = 0 pro různá n, p, q:\n"];

testCases = {{2, 3, 5}, {2, 3, 7}, {3, 2, 5}, {6, 5, 7}, {4, 3, 5}};
Do[
  {n, p, q} = tc;
  If[!Divisible[n, p] && !Divisible[n, q] && p != q,
    result = testCommutation[n, p, q];
    Print["  [a_", p, "†, a_", q, "†] = 0 na V_", n, "^-: ",
          If[result, "✓", "✗"]];
  ];
, {tc, testCases}];

Print["\n=== 3. Antikomutační relace ===\n"];

Print["Pro fermiony: {a_p, a_q†} = δ_{pq}\n"];

Print["Problém: a_p a_q† : V_n^- → V_{nq}^- → V_{nq/p}^-"];
Print["         a_q† a_p : V_n^- → V_{n/p}^- → V_{nq/p}^-"];
Print["         (pouze pokud p|n)\n"];

Print["Pro p = q:"];
Print["  a_p a_p† : V_n^- → V_{np}^- → V_n^-"];
Print["  a_p† a_p : V_n^- → V_{n/p}^- → V_n^-  (pouze p|n)\n"];

(* Spočítejme a_p a_p† explicitně *)
Print["=== 4. Výpočet a_p a_p† ===\n"];

(* a_p† zdvojí každý pár, a_p je adjungovaný = sečte příspěvky *)

computeProductMatrix[n_, p_] := Module[{basisN, basisNP, dimN, dimNP, matA, matAdag, pair, newPairs},
  If[Divisible[n, p], Return["p|n, jiný případ"]];

  basisN = basis[n];
  basisNP = basis[n*p];
  dimN = Length[basisN];
  dimNP = Length[basisNP];

  If[dimN == 0, Return[{{}}]];

  (* Matice a_p† : V_n^- → V_{np}^- *)
  matAdag = Table[0, {i, dimNP}, {j, dimN}];
  Do[
    pair = basisN[[j]];
    newPairs = creationAction[p, pair, n];
    Do[
      pos = Position[basisNP, newPairs[[k]]][[1, 1]];
      matAdag[[pos, j]] = 1;
    , {k, 2}];
  , {j, dimN}];

  (* a_p = (a_p†)^T *)
  matA = Transpose[matAdag];

  (* a_p a_p† *)
  product = matA . matAdag;

  {matAdag, matA, product}
]

Do[
  Print["n = ", n, ", p = ", p, ":"];
  If[!Divisible[n, p],
    result = computeProductMatrix[n, p];
    If[Head[result] === List,
      {adag, a, prod} = result;
      Print["  dim V_n^- = ", Length[basis[n]]];
      Print["  dim V_{np}^- = ", Length[basis[n*p]]];
      Print["  a_p†:\n", MatrixForm[adag]];
      Print["  a_p a_p† = \n", MatrixForm[prod]];
      Print["  = ", prod[[1,1]], " · I"];
    ];
  ];
  Print[""];
, {n, {2, 6}}, {p, {3, 5}}];

Print["=== 5. Vzorec pro a_p a_p† ===\n"];

Print["Pozorování: a_p a_p† = 2·I na V_n^- (pro p∤n)\n"];

Print["Důvod: Každý pár {d, n/d} přispívá do DVOU párů v V_{np}^-,"];
Print["       a každý z nich se vrátí zpět k původnímu páru.\n"];

Print["Pro normalizované operátory:"];
Print["  ã_p† = a_p† / √2"];
Print["  ã_p = a_p / √2"];
Print["  ã_p ã_p† = I  ✓\n"];

Print["=== 6. Antikomutátor {ã_p, ã_p†} ===\n"];

Print["Na Fockově prostoru F^- = ⊕_n V_n^-:\n"];

Print["  ã_p ã_p† : V_n^- → V_n^-,  = I  (pro p∤n)"];
Print["  ã_p† ã_p : V_n^- → V_n^-,  = I  (pro p|n)"];
Print["            = 0  (pro p∤n, protože dim V_{n/p}^- nedef.)\n"];

Print["Tedy pro p∤n:"];
Print["  {ã_p, ã_p†}|_{V_n^-} = ã_p ã_p† + ã_p† ã_p = I + 0 = I  ✓\n"];

Print["Pro p|n potřebujeme spočítat ã_p† ã_p..."];

Print["\n=== 7. Výpočet a_p† a_p (pro p|n) ===\n"];

computeAdagA[n_, p_] := Module[{basisN, basisNdivP, dimN, dimNdivP, matA, matAdag, pair, origPairs},
  If[!Divisible[n, p], Return["p∤n"]];

  basisN = basis[n];
  basisNdivP = basis[n/p];
  dimN = Length[basisN];
  dimNdivP = Length[basisNdivP];

  If[dimNdivP == 0, Return[Table[0, {dimN}, {dimN}]]];

  (* a_p : V_n^- → V_{n/p}^- *)
  (* Pár {d, n/d} v V_n^- se mapuje na {d, n/(pd)} pokud p|d nebo {d/p, n/d} pokud p|d *)

  (* Toto je složitější... *)
  "Komplexní výpočet"
]

Print["Pro n = 6, p = 2:"];
Print["  V_6^- báze: ", basis[6]];
Print["  V_3^- báze: ", basis[3]];
Print[""];
Print["  a_2: V_6^- → V_3^-"];
Print["  Pár {1,6}: 2|6, ne 2|1 → ???"];
Print["  Pár {2,3}: 2|2 → {1, 3}"];

Print["\n=== 8. Přeformulování anihilace ===\n"];

Print["Pro p|n, pár {d, n/d} ∈ V_n^-:"];
Print[""];
Print["Případy:"];
Print["  1. p|d a p|(n/d): d = p·d', n/d = p·e' → {d', e'} ∈ V_{n/p²}^-"];
Print["  2. p|d a p∤(n/d): {d/p, n/d} ?∈ V_{n/p}^-"];
Print["  3. p∤d a p|(n/d): {d, n/(pd)} ?∈ V_{n/p}^-"];
Print["  4. p∤d a p∤(n/d): nemožné pokud p|n a de = n\n"];

Print["Příklad n = 6, p = 2:"];
Print["  Pár {1, 6}: 2∤1, 2|6 → případ 3 → {1, 3} ∈ V_3^-  ✓"];
Print["  Pár {2, 3}: 2|2, 2∤3 → případ 2 → {1, 3} ∈ V_3^-  ✓"];
Print[""];
Print["Oba páry se mapují na {1, 3}!");
Print["Tedy a_2: V_6^- → V_3^- má rank 1, ne 2.\n"];

(* Matice *)
Print["Matice a_2 v bázích:"];
Print["  V_6^- = span{e_{1,6}, e_{2,3}}"];
Print["  V_3^- = span{e_{1,3}}"];
Print["  a_2 = (1, 1) [matice 1×2]"];
Print["  a_2† = (1; 1) [matice 2×1]\n"];

Print["a_2† a_2 = (1; 1)(1, 1) = ((1, 1); (1, 1)) [matice 2×2]"];
Print["Vlastní hodnoty: 0, 2"];
Print[""];
Print["a_2 a_2† = (1, 1)(1; 1) = (2) [matice 1×1]"];

Print["\n=== 9. Shrnutí algebry ===\n"];

Print["Pro normalizované operátory ã_p = a_p/√2, ã_p† = a_p†/√2:\n"];

Print["  ã_p ã_p†|_{V_n^-} = I      pro p∤n"];
Print["  ã_p† ã_p|_{V_n^-} = ???    pro p|n (závisí na struktuře)\n"];

Print["Antikomutátor:"];
Print["  {ã_p, ã_p†}|_{V_n^-} = I + (něco)  - NENÍ čistě fermionová!\n"];

Print["Problém: Násobnost mapování závisí na aritmetické struktuře n.\n"];

Print["=== 10. Alternativní přístup: Fockův prostor na prvočíslech ===\n"];

Print["Místo V_n^- pracujme s:"];
Print["  |n⟩ = |p_1^{a_1} ... p_k^{a_k}⟩"];
Print[""];
Print["Kreační operátor:"];
Print["  a_p† |n⟩ = |np⟩ s nějakou amplitudou"];
Print[""];
Print["Ale potřebujeme sledovat antisymetrickou strukturu...\n"];
Print["Toto vyžaduje hlubší analýzu.");
