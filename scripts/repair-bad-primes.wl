(* Analýza: lze "opravit" špatná prvočísla? *)

closesQ[m_] := Module[{ord},
  If[EvenQ[m] || m == 1, Return[False]];
  ord = MultiplicativeOrder[2, m];
  EvenQ[ord] && PowerMod[2, ord/2, m] == m - 1
]

(* Pro které k platí 2^k ≡ -1 (mod m)? *)
validK[m_] := Module[{ord},
  If[!closesQ[m], Return[{}]];
  ord = MultiplicativeOrder[2, m];
  (* k = ord/2 + n*ord pro n = 0,1,2,... ale stačí základní *)
  ord/2
]

Print["=== Špatná prvočísla - nelze opravit ===\n"];

badPrimes = Select[Range[3, 50, 2], PrimeQ[#] && !closesQ[#] &];
Print["Špatná p ≤ 50: ", badPrimes];

Print["\nPro každé m dělitelné špatným p:"];
Do[
  Print["  m = 3*", p, " = ", 3*p, ": uzavírá se? ", closesQ[3*p]];
, {p, Take[badPrimes, 3]}];

Print["\n=== Dobrá prvočísla - kompatibilita ===\n"];

goodPrimes = Select[Range[3, 50, 2], PrimeQ[#] && closesQ[#] &];
Print["Dobrá p ≤ 50: ", goodPrimes];
Print["Jejich k (počet kroků): ",
  Table[{p, validK[p]}, {p, goodPrimes}]];

(* Kdy jsou dvě dobrá prvočísla kompatibilní? *)
compatibleQ[p1_, p2_] := closesQ[p1 * p2]

Print["\n=== Matice kompatibility (dobrá prvočísla ≤ 30) ===\n"];
smallGood = Select[Range[3, 30, 2], PrimeQ[#] && closesQ[#] &];
Print["Prvočísla: ", smallGood];

compatMatrix = Table[
  If[p1 == p2, "-", If[compatibleQ[p1, p2], "✓", "✗"]],
  {p1, smallGood}, {p2, smallGood}
];
Print[Grid[
  Prepend[
    MapThread[Prepend, {compatMatrix, smallGood}],
    Prepend[smallGood, ""]
  ],
  Frame -> All
]];

Print["\n=== Proč nekompatibilita? ===\n"];

(* Detailní analýza pro 3 a 5 *)
Print["p=3: ord=", MultiplicativeOrder[2, 3],
      ", k=", validK[3],
      ", 2^k mod 3 = ", PowerMod[2, validK[3], 3]];
Print["p=5: ord=", MultiplicativeOrder[2, 5],
      ", k=", validK[5],
      ", 2^k mod 5 = ", PowerMod[2, validK[5], 5]];
Print["Pro m=15: potřebujeme k liché (pro 3) AND k≡2 mod 4 (pro 5) → SPOR"];

Print["\n=== Podmínka kompatibility ===\n"];
Print["p1, p2 kompatibilní ⟺ k1 ≡ k2 (mod gcd(ord1, ord2)/2)"];

Do[
  ord1 = MultiplicativeOrder[2, p1];
  ord2 = MultiplicativeOrder[2, p2];
  k1 = ord1/2; k2 = ord2/2;
  g = GCD[ord1, ord2];
  compat = Mod[k1, g] == Mod[k2, g];
  Print[p1, " & ", p2, ": ord=", {ord1, ord2}, ", k=", {k1, k2},
        ", gcd=", g, ", k mod gcd = ", {Mod[k1,g], Mod[k2,g]},
        " → ", If[compat, "✓", "✗"]];
, {p1, {3, 5, 11}}, {p2, {3, 5, 11}}] // Flatten;

Print["\n=== Speciální body 2^n+1 ===\n"];
fermatLike = Table[2^n + 1, {n, 1, 10}];
Print["m = 2^n + 1: ", fermatLike];
Print["Uzavírá se?: ", closesQ /@ fermatLike];
Print["Jsou prvočísla?: ", PrimeQ /@ fermatLike];

Print["\n=== Jaká složená čísla se uzavírají? ===\n"];
goodComposite = Select[Range[9, 200, 2], !PrimeQ[#] && closesQ[#] &];
Print["Složená m ≤ 200 která se uzavírají: ", goodComposite];
Print["Jejich faktorizace:"];
Do[Print["  ", m, " = ", FactorInteger[m]], {m, Take[goodComposite, 15]}];
